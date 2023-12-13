/*
    This module is intended to manage following things:
    - Loading available versions of bs-platform-js releases
    - Loading actual bs-platform-js bundles on demand
    - Loading third-party libraries together with the compiler bundle
    - Sending data back and forth between consumer and compiler

    The interface is defined with a finite state and action dispatcher.
 */

open RescriptCompilerApi

module LoadScript = {
  type err

  @module("../ffi/loadScript")
  external loadScript: (
    ~src: string,
    ~onSuccess: unit => unit,
    ~onError: err => unit,
  ) => unit => unit = "default"

  @module("../ffi/loadScript")
  external removeScript: (~src: string) => unit = "removeScript"

  let loadScriptPromise = (url: string) => {
    Js.Promise2.make((~resolve, ~reject as _) => {
      loadScript(
        ~src=url,
        ~onSuccess=() => resolve(Ok()),
        ~onError=_err => resolve(Error(`Could not load script: ${url}`)),
      )->ignore
    })
  }
}

module Semver = {
  type preRelease = Alpha(int) | Beta(int) | Dev(int) | Rc(int)

  type t = {major: int, minor: int, patch: int, preRelease: option<preRelease>}

  /**
  Takes a `version` string starting with a "v" and ending in major.minor.patch or
  major.minor.patch-prerelease.identifier (e.g. "v10.1.0" or "v10.1.0-alpha.2")
  */
  let parse = (versionStr: string) => {
    let parsePreRelease = str => {
      switch str->Js.String2.split("-") {
      | [_, identifier] =>
        switch identifier->Js.String2.split(".") {
        | [name, number] =>
          switch Belt.Int.fromString(number) {
          | None => None
          | Some(buildIdentifier) =>
            switch name {
            | "dev" => buildIdentifier->Dev->Some
            | "beta" => buildIdentifier->Beta->Some
            | "alpha" => buildIdentifier->Alpha->Some
            | "rc" => buildIdentifier->Rc->Some
            | _ => None
            }
          }
        | _ => None
        }
      | _ => None
      }
    }

    // Some version contain a suffix. Example: v11.0.0-alpha.5, v11.0.0-beta.1
    let isPrerelease = versionStr->Js.String2.search(%re("/-/")) != -1

    // Get the first part i.e vX.Y.Z
    let versionNumber =
      versionStr->Js.String2.split("-")->Belt.Array.get(0)->Belt.Option.getWithDefault(versionStr)

    switch versionNumber->Js.String2.replace("v", "")->Js.String2.split(".") {
    | [major, minor, patch] =>
      switch (major->Belt.Int.fromString, minor->Belt.Int.fromString, patch->Belt.Int.fromString) {
      | (Some(major), Some(minor), Some(patch)) =>
        let preReleaseIdentifier = if isPrerelease {
          parsePreRelease(versionStr)
        } else {
          None
        }
        Some({major, minor, patch, preRelease: preReleaseIdentifier})
      | _ => None
      }
    | _ => None
    }
  }

  let toString = ({major, minor, patch, preRelease}) => {
    let mainVersion = `v${major->Belt.Int.toString}.${minor->Belt.Int.toString}.${patch->Belt.Int.toString}`

    switch preRelease {
    | None => mainVersion
    | Some(identifier) =>
      let identifier = switch identifier {
      | Dev(number) => `dev.${number->Belt.Int.toString}`
      | Alpha(number) => `alpha.${number->Belt.Int.toString}`
      | Beta(number) => `beta.${number->Belt.Int.toString}`
      | Rc(number) => `rc.${number->Belt.Int.toString}`
      }

      `${mainVersion}-${identifier}`
    }
  }
}

module CdnMeta = {
  let getCompilerUrl = (version): string =>
    `https://cdn.rescript-lang.org/${Semver.toString(version)}/compiler.js`

  let getLibraryCmijUrl = (version, libraryName: string): string =>
    `https://cdn.rescript-lang.org/${Semver.toString(version)}/${libraryName}/cmij.js`
}

module FinalResult = {
  /* A final result is the last operation the compiler has done, right now this includes... */
  type t =
    | Conv(ConversionResult.t)
    | Comp(CompilationResult.t)
    | Nothing
}

// This will a given list of libraries to a specific target version of the compiler.
// E.g. starting from v9, @rescript/react instead of reason-react is used.
// If the version can't be parsed, an empty array will be returned.
let getLibrariesForVersion = (~version: Semver.t): array<string> => {
  let libraries = if version.major >= 9 {
    ["@rescript/react"]
  } else if version.major < 9 {
    ["reason-react"]
  } else {
    []
  }

  // Since version 11, we ship the compiler-builtins as a separate file, and
  // we also added @rescript/core as a pre-vendored package
  if version.major >= 11 {
    libraries->Js.Array2.push("@rescript/core")->ignore
    libraries->Js.Array2.push("compiler-builtins")->ignore
  }

  libraries
}

let getOpenModules = (~apiVersion: Version.t, ~libraries: array<string>): option<array<string>> =>
  switch apiVersion {
  | V1 | V2 | V3 | UnknownVersion(_) => None
  | V4 => libraries->Belt.Array.some(el => el === "@rescript/core") ? Some(["RescriptCore"]) : None
  }

/*
    This function loads the compiler, plus a defined set of libraries that are available
    on our bs-platform-js-releases channel.

    Due to JSOO specifics, even if we already loaded a compiler before, we need to make sure
    to load the compiler bundle first, and then load the library cmij files right after that.

    If you don't respect the loading order, then the loaded cmij files will not hook into the
    jsoo filesystem and the compiler won't be able to find the cmij content.

    We coupled the compiler / library loading to prevent ppl to try loading compiler / cmij files
    separately and cause all kinds of race conditions.
 */
let attachCompilerAndLibraries = async (~version, ~libraries: array<string>, ()): result<
  unit,
  array<string>,
> => {
  let compilerUrl = CdnMeta.getCompilerUrl(version)

  // Useful for debugging our local build
  /* let compilerUrl = "/static/linked-bs-bundle.js"; */

  switch await LoadScript.loadScriptPromise(compilerUrl) {
  | Error(_) => Error([`Could not load compiler from url ${compilerUrl}`])
  | Ok(_) =>
    let promises = Belt.Array.map(libraries, async lib => {
      let cmijUrl = CdnMeta.getLibraryCmijUrl(version, lib)
      switch await LoadScript.loadScriptPromise(cmijUrl) {
      | Error(_) => Error(`Could not load cmij from url ${cmijUrl}`)
      | r => r
      }
    })

    let all = await Js.Promise2.all(promises)

    let errors = Belt.Array.keepMap(all, r => {
      switch r {
      | Error(msg) => Some(msg)
      | _ => None
      }
    })

    switch errors {
    | [] => Ok()
    | errs => Error(errs)
    }
  }
}

type error =
  | SetupError(string)
  | CompilerLoadingError(string)

type selected = {
  id: Semver.t, // The id used for loading the compiler bundle (ideally should be the same as compilerVersion)
  apiVersion: Version.t, // The playground API version in use
  compilerVersion: string,
  ocamlVersion: string,
  libraries: array<string>,
  config: Config.t,
  instance: Compiler.t,
}

type ready = {
  versions: array<Semver.t>,
  selected: selected,
  targetLang: Lang.t,
  errors: array<string>, // For major errors like bundle loading
  result: FinalResult.t,
}

type state =
  | Init
  | SetupFailed(string)
  | SwitchingCompiler(ready, Semver.t) // (ready, targetId, libraries)
  | Ready(ready)
  | Compiling(ready, (Lang.t, string))

type action =
  | SwitchToCompiler(Semver.t) // id
  | SwitchLanguage({lang: Lang.t, code: string})
  | Format(string)
  | CompileCode(Lang.t, string)
  | UpdateConfig(Config.t)

// ~initialLang:
// The target language the compiler should be set to during
// playground initialization.  If the compiler doesn't support the language, it
// will default to ReScript syntax

// ~onAction:
//  This function is especially useful if you want to maintain state that
//  depends on any action happening in the compiler, no matter if a state
//  transition happened, or not.  We need that for a ActivityIndicator
//  component to give feedback to the user that an action happened (useful in
//  cases where the output didn't visually change)
let useCompilerManager = (
  ~initialVersion: option<Semver.t>=?,
  ~initialLang: Lang.t=Res,
  ~onAction: option<action => unit>=?,
  ~versions: array<Semver.t>,
  (),
) => {
  let (state, setState) = React.useState(_ => Init)

  // Dispatch method for the public interface
  let dispatch = (action: action): unit => {
    Belt.Option.forEach(onAction, cb => cb(action))
    switch action {
    | SwitchToCompiler(id) =>
      switch state {
      | Ready(ready) =>
        // TODO: Check if libraries have changed as well
        if ready.selected.id !== id {
          setState(_ => SwitchingCompiler(ready, id))
        } else {
          ()
        }
      | _ => ()
      }
    | UpdateConfig(config) =>
      switch state {
      | Ready(ready) =>
        ready.selected.instance->Compiler.setConfig(config)
        setState(_ => {
          let selected = {...ready.selected, config}
          Ready({...ready, selected})
        })
      | _ => ()
      }
    | CompileCode(lang, code) =>
      switch state {
      | Ready(ready) => setState(_ => Compiling(ready, (lang, code)))
      | _ => ()
      }
    | SwitchLanguage({lang, code}) =>
      switch state {
      | Ready(ready) =>
        let instance = ready.selected.instance
        let availableTargetLangs = Version.availableLanguages(ready.selected.apiVersion)

        let currentLang = ready.targetLang

        Js.Array2.find(availableTargetLangs, l => l === lang)->Belt.Option.forEach(lang => {
          // Try to automatically transform code
          let (result, targetLang) = switch ready.selected.apiVersion {
          | V1 =>
            let convResult = switch (currentLang, lang) {
            | (Reason, Res) =>
              instance->Compiler.convertSyntax(~fromLang=Reason, ~toLang=Res, ~code)->Some
            | (Res, Reason) =>
              instance->Compiler.convertSyntax(~fromLang=Res, ~toLang=Reason, ~code)->Some
            | _ => None
            }

            /*
                    Syntax convertion works the following way:
                    If currentLang -> otherLang is not valid, try to pretty print the code
                    with the otherLang, in case we e.g. want to copy paste or otherLang code
                    in the editor and quickly switch to it
 */
            switch convResult {
            | Some(result) =>
              switch result {
              | ConversionResult.Fail(_)
              | Unknown(_, _)
              | UnexpectedError(_) =>
                let secondTry =
                  instance->Compiler.convertSyntax(~fromLang=lang, ~toLang=lang, ~code)
                switch secondTry {
                | ConversionResult.Fail(_)
                | Unknown(_, _)
                | UnexpectedError(_) => (FinalResult.Conv(secondTry), lang)
                | Success(_) => (Conv(secondTry), lang)
                }
              | ConversionResult.Success(_) => (Conv(result), lang)
              }
            | None => (Nothing, lang)
            }
          | _ => (Nothing, lang)
          }

          setState(_ => Ready({...ready, result, errors: [], targetLang}))
        })
      | _ => ()
      }
    | Format(code) =>
      switch state {
      | Ready(ready) =>
        let instance = ready.selected.instance
        let convResult = switch ready.targetLang {
        | Res => instance->Compiler.resFormat(code)->Some
        | Reason => instance->Compiler.reasonFormat(code)->Some
        | _ => None
        }

        let result = switch convResult {
        | Some(result) =>
          switch result {
          | ConversionResult.Success(success) =>
            // We will only change the result to a ConversionResult
            // in case the reformatting has actually changed code
            // otherwise we'd loose previous compilationResults, although
            // the result should be the same anyways
            if code !== success.code {
              FinalResult.Conv(result)
            } else {
              ready.result
            }
          | ConversionResult.Fail(_)
          | Unknown(_, _)
          | UnexpectedError(_) =>
            FinalResult.Conv(result)
          }
        | None => ready.result
        }

        setState(_ => Ready({...ready, result, errors: []}))
      | _ => ()
      }
    }
  }

  let dispatchError = (err: error) =>
    setState(prev => {
      let msg = switch err {
      | SetupError(msg) => msg
      | CompilerLoadingError(msg) => msg
      }
      switch prev {
      | Ready(ready) => Ready({...ready, errors: Js.Array2.concat(ready.errors, [msg])})
      | _ => SetupFailed(msg)
      }
    })

  React.useEffect(() => {
    let updateState = async () => {
      switch state {
      | Init =>
        switch versions {
        | [] => dispatchError(SetupError("No compiler versions found"))
        | versions =>
          switch initialVersion {
          | Some(version) =>
            // Latest version is already running on @rescript/react
            let libraries = getLibrariesForVersion(~version)

            switch await attachCompilerAndLibraries(~version, ~libraries, ()) {
            | Ok() =>
              let instance = Compiler.make()
              let apiVersion = apiVersion->Version.fromString
              let open_modules = getOpenModules(~apiVersion, ~libraries)

              // Note: The compiler bundle currently defaults to
              // commonjs when initiating the compiler, but our playground
              // should default to ES6. So we override the config
              // and use the `setConfig` function to sync up the
              // internal compiler state with our playground state.
              let config = {
                ...instance->Compiler.getConfig,
                module_system: "es6",
                ?open_modules,
              }
              instance->Compiler.setConfig(config)

              let selected = {
                id: version,
                apiVersion,
                compilerVersion: instance->Compiler.version,
                ocamlVersion: instance->Compiler.ocamlVersion,
                config,
                libraries,
                instance,
              }

              let targetLang =
                Version.availableLanguages(apiVersion)
                ->Js.Array2.find(l => l === initialLang)
                ->Belt.Option.getWithDefault(Version.defaultTargetLang)

              setState(_ => Ready({
                selected,
                targetLang,
                versions,
                errors: [],
                result: FinalResult.Nothing,
              }))
            | Error(errs) =>
              let msg = Js.Array2.joinWith(errs, "; ")

              dispatchError(CompilerLoadingError(msg))
            }
          | None => dispatchError(CompilerLoadingError("Cant not found the initial version"))
          }
        }
      | SwitchingCompiler(ready, version) =>
        let libraries = getLibrariesForVersion(~version)

        switch await attachCompilerAndLibraries(~version, ~libraries, ()) {
        | Ok() =>
          // Make sure to remove the previous script from the DOM as well
          LoadScript.removeScript(~src=CdnMeta.getCompilerUrl(ready.selected.id))

          // We are removing the previous libraries, therefore we use ready.selected here
          Belt.Array.forEach(ready.selected.libraries, lib =>
            LoadScript.removeScript(~src=CdnMeta.getLibraryCmijUrl(ready.selected.id, lib))
          )

          let instance = Compiler.make()
          let apiVersion = apiVersion->Version.fromString
          let open_modules = getOpenModules(~apiVersion, ~libraries)

          let config = {...instance->Compiler.getConfig, ?open_modules}
          instance->Compiler.setConfig(config)

          let selected = {
            id: version,
            apiVersion,
            compilerVersion: instance->Compiler.version,
            ocamlVersion: instance->Compiler.ocamlVersion,
            config,
            libraries,
            instance,
          }

          setState(_ => Ready({
            selected,
            targetLang: Version.defaultTargetLang,
            versions: ready.versions,
            errors: [],
            result: FinalResult.Nothing,
          }))
        | Error(errs) =>
          let msg = Js.Array2.joinWith(errs, "; ")

          dispatchError(CompilerLoadingError(msg))
        }
      | Compiling(ready, (lang, code)) =>
        let apiVersion = ready.selected.apiVersion
        let instance = ready.selected.instance

        let compResult = switch apiVersion {
        | V1 =>
          switch lang {
          | Lang.OCaml => instance->Compiler.ocamlCompile(code)
          | Lang.Reason => instance->Compiler.reasonCompile(code)
          | Lang.Res => instance->Compiler.resCompile(code)
          }
        | V2 | V3 | V4 =>
          switch lang {
          | Lang.OCaml => instance->Compiler.ocamlCompile(code)
          | Lang.Reason =>
            CompilationResult.UnexpectedError(
              `Reason not supported with API version "${apiVersion->RescriptCompilerApi.Version.toString}"`,
            )
          | Lang.Res => instance->Compiler.resCompile(code)
          }
        | UnknownVersion(version) =>
          CompilationResult.UnexpectedError(
            `Can't handle result of compiler API version "${version}"`,
          )
        }

        setState(_ => Ready({...ready, result: FinalResult.Comp(compResult)}))
      | SetupFailed(_)
      | Ready(_) => ()
      }
    }

    updateState()->ignore
    None
  }, [state])

  (state, dispatch)
}
