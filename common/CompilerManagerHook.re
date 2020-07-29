/*
    This module is intended to manage following things:
    - Loading available versions of bs-platform-js releases
    - Loading actual bs-platform-js bundles on demand
    - Loading third-party libraries together with the compiler bundle
    - Sending data back and forth between consumer and compiler

    The interface is defined with a finite state and action dispatcher.
 */


open Bs_platform_api;

module LoadScript = {
  type err;

  [@bs.module "../ffi/loadScript"]
  external loadScript:
    (~src: string, ~onSuccess: unit => unit, ~onError: err => unit) =>
    (. unit) => unit =
    "default";

  [@bs.module "../ffi/loadScript"]
  external removeScript: (~src: string) => unit = "removeScript";

  let loadScriptPromise = (url: string): Promise.t(result(unit, string)) => {
    let (p, resolve) = Promise.pending();
    loadScript(
      ~src=url,
      ~onSuccess=() => {resolve(Ok())},
      ~onError=_err => {resolve(Error({j|Could not load script: $url|j}))},
    )
    ->ignore;
    p;
  };
};

module CdnMeta = {
  // Splits and sanitizes the content of the VERSIONS file
  let parseVersions = (versions: string) => {
    Js.String2.split(versions, "\n")->Js.Array2.filter(v => v !== "");
  };

  let getCompilerUrl = (version: string): string => {
    {j|https://cdn.jsdelivr.net/gh/ryyppy/bs-platform-js-releases@master/$version/compiler.js|j};
  };

  let getLibraryCmijUrl = (version: string, libraryName: string): string => {
    {j|https://cdn.jsdelivr.net/gh/ryyppy/bs-platform-js-releases@master/$version/$libraryName/cmij.js|j};
  };
};

module FinalResult = {
  /* A final result is the last operation the compiler has done, right now this includes... */
  type t =
    | Conv(ConversionResult.t)
    | Comp(CompilationResult.t)
    | Nothing;
};

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
let attachCompilerAndLibraries =
    (~version: string, ~libraries: array(string), ())
    : Promise.t(result(unit, array(string))) => {
  let compilerUrl = CdnMeta.getCompilerUrl(version);

  // Useful for debugging our local build
  /*let compilerUrl = "/static/linked-bs-bundle.js";*/

  LoadScript.loadScriptPromise(compilerUrl)
  ->Promise.mapError(_msg =>
      {j|Could not load compiler from url $compilerUrl|j}
    )
  ->Promise.map(r => {
      switch (r) {
      | Ok () =>
        Belt.Array.map(
          libraries,
          lib => {
            let cmijUrl = CdnMeta.getLibraryCmijUrl(version, lib);
            LoadScript.loadScriptPromise(cmijUrl)
            ->Promise.mapError(_msg =>
                {j|Could not load cmij from url $cmijUrl|j}
              );
          },
        )
      | Error(msg) => [|Promise.resolved(Error(msg))|]
      }
    })
  ->Promise.flatMap(Promise.allArray)
  ->Promise.map(all => {
      // all: array(Promise.result(unit, string))
      let errors =
        Belt.Array.reduce(all, [||], (acc, r) =>
          switch (r) {
          | Error(msg) => Js.Array2.concat(acc, [|msg|])
          | _ => acc
          }
        );

      switch (errors) {
      | [||] => Ok()
      | errs => Error(errs)
      };
    });
};

type error =
  | SetupError(string)
  | CompilerLoadingError(string);

type selected = {
  id: string, // The id used for loading the compiler bundle (ideally should be the same as compilerVersion)
  apiVersion: Version.t, // The playground API version in use
  compilerVersion: string,
  ocamlVersion: string,
  reasonVersion: string,
  libraries: array(string),
  instance: Compiler.t,
};

type ready = {
  versions: array(string),
  selected,
  targetLang: Lang.t,
  errors: array(string), // For major errors like bundle loading
  result: FinalResult.t,
};

type state =
  | Init
  | SetupFailed(string)
  | SwitchingCompiler(ready, string, array(string))
  | Ready(ready)
  | Compiling(ready, (Lang.t, string));

type action =
  | SwitchToCompiler({
      id: string,
      libraries: array(string),
    })
  | SwitchLanguage({
      lang: Lang.t,
      code: string,
    })
  | Format(string)
  | CompileCode(Lang.t, string);

let useCompilerManager = () => {
  let (state, setState) = React.useState(_ => Init);

  // Dispatch method for the public interface
  let dispatch = (action: action): unit => {
    switch (action) {
    | SwitchToCompiler({id, libraries}) =>
      switch (state) {
      | Ready(ready) =>
        // TODO: Check if libraries have changed as well
        if (ready.selected.id !== id) {
          setState(_ => SwitchingCompiler(ready, id, libraries));
        } else {
          ();
        }
      | _ => ()
      }
    | CompileCode(lang, code) =>
      switch (state) {
      | Ready(ready) => setState(_ => Compiling(ready, (lang, code)))
      | _ => ()
      }
    | SwitchLanguage({lang, code}) =>
      switch (state) {
      | Ready(ready) =>
        let instance = ready.selected.instance;
        let availableTargetLangs =
          Version.availableLanguages(ready.selected.apiVersion);

        let currentLang = ready.targetLang;

        Js.Array2.find(availableTargetLangs, l => l === lang)
        ->Belt.Option.forEach(l => {
            // Try to automatically transform code
            let (result, targetLang) =
              switch (ready.selected.apiVersion) {
              | V1 =>
                let convResult =
                  switch (currentLang, lang) {
                  | (Reason, Res) =>
                    instance
                    ->Compiler.convertSyntax(
                        ~fromLang=Reason,
                        ~toLang=Res,
                        ~code,
                      )
                    ->Some
                  | (Res, Reason) =>
                    instance
                    ->Compiler.convertSyntax(
                        ~fromLang=Res,
                        ~toLang=Reason,
                        ~code,
                      )
                    ->Some
                  | _ => None
                  };

                // In case of an error, keep the current lang
                switch (convResult) {
                | Some(result) =>
                  switch (result) {
                  | ConversionResult.Fail(_)
                  | Unknown(_, _)
                  | UnexpectedError(_) => (
                      FinalResult.Conv(result),
                      currentLang,
                    )
                  | ConversionResult.Success(_) => (Conv(result), l)
                  }
                | None => (Nothing, l)
                };
              | _ => (Nothing, l)
              };

            setState(_ =>
              Ready({...ready, result, errors: [||], targetLang})
            );
          });
      | _ => ()
      }
    | Format(code) =>
      switch (state) {
      | Ready(ready) =>
        let instance = ready.selected.instance;
        let convResult =
          switch (ready.targetLang) {
          | Res => instance->Compiler.resFormat(code)->Some
          | Reason => instance->Compiler.reasonFormat(code)->Some
          | _ => None
          };

        let result =
          switch (convResult) {
          | Some(result) =>
            switch (result) {
            | ConversionResult.Success(success) =>
              // We will only change the result to a ConversionResult
              // in case the reformatting has actually changed code
              // otherwise we'd loose previous compilationResults, although
              // the result should be the same anyways
              if (code !== success.code) {
                FinalResult.Conv(result);
              } else {
                ready.result;
              }
            | ConversionResult.Fail(_)
            | Unknown(_, _)
            | UnexpectedError(_) => FinalResult.Conv(result)
            }
          | None => ready.result
          };

        setState(_ => Ready({...ready, result, errors: [||]}));
      | _ => ()
      }
    };
  };

  let dispatchError = (err: error) => {
    setState(prev => {
      let msg =
        switch (err) {
        | SetupError(msg) => msg
        | CompilerLoadingError(msg) => msg
        };
      switch (prev) {
      | Ready(ready) =>
        Ready({...ready, errors: Js.Array2.concat(ready.errors, [|msg|])})
      | _ => SetupFailed(msg)
      };
    });
  };

  React.useEffect1(
    () => {
      switch (state) {
      | Init =>
        let libraries = [|"reason-react"|];

        let completed = res => {
          open SimpleRequest;
          switch (res) {
          | Ok({text}) =>
            switch (CdnMeta.parseVersions(text)) {
            | [||] =>
              dispatchError(SetupError({j|No compiler versions found|j}))
            | versions =>
              // Fetching the initial compiler is different, since we
              // don't have any running version downloaded yet

              let latest = versions[0];

              attachCompilerAndLibraries(~version=latest, ~libraries, ())
              ->Promise.get(result => {
                  switch (result) {
                  | Ok () =>
                    let instance = Compiler.make();
                    let apiVersion = apiVersion->Version.fromString;

                    let selected = {
                      id: latest,
                      apiVersion,
                      compilerVersion: instance->Compiler.version,
                      ocamlVersion: instance->Compiler.ocamlVersion,
                      reasonVersion: instance->Compiler.reasonVersion,
                      libraries,
                      instance,
                    };

                    setState(_ => {
                      Ready({
                        selected,
                        targetLang: Version.defaultTargetLang(apiVersion),
                        versions,
                        errors: [||],
                        result: FinalResult.Nothing,
                      })
                    });
                  | Error(errs) =>
                    let msg = Js.Array2.joinWith(errs, "; ");

                    dispatchError(CompilerLoadingError(msg));
                  }
                });
            }
          | Error({text, status}) =>
            dispatchError(
              SetupError({j|Error occurred: $text (status-code: $status)|j}),
            )
          };
          ();
        };

        SimpleRequest.(
          make(
            ~contentType=Plain,
            ~completed,
            "https://cdn.jsdelivr.net/gh/ryyppy/bs-platform-js-releases@latest/VERSIONS",
          )
          ->send
        );
      | SwitchingCompiler(ready, version, libraries) =>
        attachCompilerAndLibraries(~version, ~libraries, ())
        ->Promise.get(result => {
            switch (result) {
            | Ok () =>
              // Make sure to remove the previous script from the DOM as well
              LoadScript.removeScript(
                ~src=CdnMeta.getCompilerUrl(ready.selected.id),
              );

              Belt.Array.forEach(ready.selected.libraries, lib => {
                LoadScript.removeScript(
                  ~src=CdnMeta.getLibraryCmijUrl(ready.selected.id, lib),
                )
              });

              let instance = Compiler.make();
              let apiVersion = apiVersion->Version.fromString;

              let selected = {
                id: version,
                apiVersion,
                compilerVersion: instance->Compiler.version,
                ocamlVersion: instance->Compiler.ocamlVersion,
                reasonVersion: instance->Compiler.reasonVersion,
                libraries,
                instance,
              };

              setState(_ => {
                Ready({
                  selected,
                  targetLang: Version.defaultTargetLang(apiVersion),
                  versions: ready.versions,
                  errors: [||],
                  result: FinalResult.Nothing,
                })
              });
            | Error(errs) =>
              let msg = Js.Array2.joinWith(errs, "; ");

              dispatchError(CompilerLoadingError(msg));
            }
          })
      | Compiling(ready, (lang, code)) =>
        let apiVersion = ready.selected.apiVersion;
        let instance = ready.selected.instance;

        let compResult =
          switch (apiVersion) {
          | Version.V1 =>
            switch (lang) {
            | Lang.OCaml => instance->Compiler.ocamlCompile(code)
            | Lang.Reason => instance->Compiler.reasonCompile(code)
            | Lang.Res => instance->Compiler.resCompile(code)
            }
          | UnknownVersion(apiVersion) =>
            CompilationResult.UnexpectedError(
              {j|Can't handle result of compiler API version "$apiVersion"|j},
            )
          };

        setState(_ => {
          Ready({...ready, result: FinalResult.Comp(compResult)})
        });
      | SetupFailed(_)
      | Ready(_) => ()
      };
      None;
    },
    [|state|],
  );

  (state, dispatch);
};
