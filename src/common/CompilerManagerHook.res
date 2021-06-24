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
    . unit,
  ) => unit = "default"

  @module("../ffi/loadScript")
  external removeScript: (~src: string) => unit = "removeScript"

  let loadScriptPromise = (url: string): Promise.t<result<unit, string>> => {
    Promise.make((resolve, _reject) => {
      loadScript(
        ~src=url,
        ~onSuccess=() => resolve(. Ok()),
        ~onError=_err => resolve(. Error(j`Could not load script: $url`)),
      )->ignore
    })
  }
}

module CdnMeta = {
  // Make sure versions exist on https://cdn.rescript-lang.org
  // [0] = latest
  let versions = ["v9.1.2", "v9.0.2", "v9.0.1", "v9.0.0", "v8.4.2", "v8.3.0-dev.2"]

  let getCompilerUrl = (version: string): string =>
    j`https://cdn.rescript-lang.org/$version/compiler.js`

  let getLibraryCmijUrl = (version: string, libraryName: string): string =>
    j`https://cdn.rescript-lang.org/$version/$libraryName/cmij.js`
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
let migrateLibraries = (~version: string, libraries: array<string>): array<string> => {
  switch Js.String2.split(version, ".")->Belt.List.fromArray {
  | list{major, ..._rest} =>
    let version =
      Js.String2.replace(major, "v", "")->Belt.Int.fromString->Belt.Option.getWithDefault(0)

    Belt.Array.map(libraries, library => {
      if version >= 9 {
        switch library {
        | "reason-react" => "@rescript/react"
        | _ => library
        }
      } else {
        switch library {
        | "@rescript/react" => "reason-react"
        | _ => library
        }
      }
    })
  | _ => libraries
  }
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
let attachCompilerAndLibraries = (~version: string, ~libraries: array<string>, ()): Promise.t<
  result<unit, array<string>>,
> => {
  let compilerUrl = CdnMeta.getCompilerUrl(version)

  // Useful for debugging our local build
  /* let compilerUrl = "/static/linked-bs-bundle.js"; */

  LoadScript.loadScriptPromise(compilerUrl)
  ->Promise.thenResolve(r => {
    switch r {
    | Error(_) => Error(j`Could not load compiler from url $compilerUrl`)
    | _ => r
    }
  })
  ->Promise.then(r => {
    let promises = switch r {
    | Ok() =>
      Belt.Array.map(libraries, lib => {
        let cmijUrl = CdnMeta.getLibraryCmijUrl(version, lib)
        LoadScript.loadScriptPromise(cmijUrl)->Promise.thenResolve(r =>
          switch r {
          | Error(_) => Error(j`Could not load cmij from url $cmijUrl`)
          | _ => r
          }
        )
      })
    | Error(msg) => [Promise.resolve(Error(msg))]
    }

    Promise.all(promises)
  })
  ->Promise.thenResolve(all => {
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
  })
}

type error =
  | SetupError(string)
  | CompilerLoadingError(string)

type selected = {
  id: string, // The id used for loading the compiler bundle (ideally should be the same as compilerVersion)
  apiVersion: Version.t, // The playground API version in use
  compilerVersion: string,
  ocamlVersion: string,
  reasonVersion: string,
  libraries: array<string>,
  config: Config.t,
  instance: Compiler.t,
}

type ready = {
  versions: array<string>,
  selected: selected,
  targetLang: Lang.t,
  errors: array<string>, // For major errors like bundle loading
  result: FinalResult.t,
}

type state =
  | Init
  | SetupFailed(string)
  | SwitchingCompiler(ready, string, array<string>) // (ready, targetId, libraries)
  | Ready(ready)
  | Compiling(ready, (Lang.t, string))

type action =
  | SwitchToCompiler({id: string, libraries: array<string>})
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
let useCompilerManager = (~initialLang: Lang.t=Res, ~onAction: option<action => unit>=?, ()) => {
  let (state, setState) = React.useState(_ => Init)

  // Dispatch method for the public interface
  let dispatch = (action: action): unit => {
    Belt.Option.forEach(onAction, cb => cb(action))
    switch action {
    | SwitchToCompiler({id, libraries}) =>
      switch state {
      | Ready(ready) =>
        // TODO: Check if libraries have changed as well
        if ready.selected.id !== id {
          setState(_ => SwitchingCompiler(ready, id, libraries))
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
          let selected = {...ready.selected, config: config}
          Ready({...ready, selected: selected})
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

          setState(_ => Ready({...ready, result: result, errors: [], targetLang: targetLang}))
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

        setState(_ => Ready({...ready, result: result, errors: []}))
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

  React.useEffect1(() => {
    switch state {
    | Init =>
      switch CdnMeta.versions {
      | [] => dispatchError(SetupError(j`No compiler versions found`))
      | versions =>
        let latest = versions[0]

        // Latest version is already running on @rescript/react
        let libraries = ["@rescript/react"]

        attachCompilerAndLibraries(~version=latest, ~libraries, ())
        ->Promise.thenResolve(result =>
          switch result {
          | Ok() =>
            let instance = Compiler.make()
            let apiVersion = apiVersion->Version.fromString
            let config = instance->Compiler.getConfig

            let selected = {
              id: latest,
              apiVersion: apiVersion,
              compilerVersion: instance->Compiler.version,
              ocamlVersion: instance->Compiler.ocamlVersion,
              reasonVersion: instance->Compiler.reasonVersion,
              config: config,
              libraries: libraries,
              instance: instance,
            }

            let targetLang =
              Version.availableLanguages(apiVersion)
              ->Js.Array2.find(l => l === initialLang)
              ->Belt.Option.getWithDefault(Version.defaultTargetLang(apiVersion))

            setState(_ => Ready({
              selected: selected,
              targetLang: targetLang,
              versions: versions,
              errors: [],
              result: FinalResult.Nothing,
            }))
          | Error(errs) =>
            let msg = Js.Array2.joinWith(errs, "; ")

            dispatchError(CompilerLoadingError(msg))
          }
        )
        ->ignore
      }
    | SwitchingCompiler(ready, version, libraries) =>
      let migratedLibraries = libraries->migrateLibraries(~version)

      attachCompilerAndLibraries(~version, ~libraries=migratedLibraries, ())
      ->Promise.thenResolve(result =>
        switch result {
        | Ok() =>
          // Make sure to remove the previous script from the DOM as well
          LoadScript.removeScript(~src=CdnMeta.getCompilerUrl(ready.selected.id))

          // We are removing the previous libraries, therefore we use ready.selected here
          Belt.Array.forEach(ready.selected.libraries, lib =>
            LoadScript.removeScript(~src=CdnMeta.getLibraryCmijUrl(ready.selected.id, lib))
          )

          let instance = Compiler.make()
          let apiVersion = apiVersion->Version.fromString
          let config = instance->Compiler.getConfig

          let selected = {
            id: version,
            apiVersion: apiVersion,
            compilerVersion: instance->Compiler.version,
            ocamlVersion: instance->Compiler.ocamlVersion,
            reasonVersion: instance->Compiler.reasonVersion,
            config: config,
            libraries: migratedLibraries,
            instance: instance,
          }

          setState(_ => Ready({
            selected: selected,
            targetLang: Version.defaultTargetLang(apiVersion),
            versions: ready.versions,
            errors: [],
            result: FinalResult.Nothing,
          }))
        | Error(errs) =>
          let msg = Js.Array2.joinWith(errs, "; ")

          dispatchError(CompilerLoadingError(msg))
        }
      )
      ->ignore
    | Compiling(ready, (lang, code)) =>
      let apiVersion = ready.selected.apiVersion
      let instance = ready.selected.instance

      let compResult = switch apiVersion {
      | Version.V1 =>
        switch lang {
        | Lang.OCaml => instance->Compiler.ocamlCompile(code)
        | Lang.Reason => instance->Compiler.reasonCompile(code)
        | Lang.Res => instance->Compiler.resCompile(code)
        }
      | UnknownVersion(apiVersion) =>
        CompilationResult.UnexpectedError(j`Can't handle result of compiler API version "$apiVersion"`)
      }

      setState(_ => Ready({...ready, result: FinalResult.Comp(compResult)}))
    | SetupFailed(_)
    | Ready(_) => ()
    }
    None
  }, [state])

  (state, dispatch)
}
