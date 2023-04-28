open RescriptCompilerApi

module FinalResult: {
  /* A final result is the last operation the compiler has done, right now this includes... */
  type t =
    | Conv(ConversionResult.t)
    | Comp(CompilationResult.t)
    | Nothing
}

module CdnMeta: {
  /** All available versions on the CDN */
  let versions: array<string>
}

type selected = {
  id: string, // The id used for loading the compiler bundle (ideally should be the same as compilerVersion)
  apiVersion: Version.t, // The playground API version in use
  compilerVersion: string,
  ocamlVersion: string,
  libraries: array<string>,
  config: Config.t,
  instance: Compiler.t,
}

type ready = {
  versions: array<string>,
  experimentalVersions: array<string>,
  selected: selected,
  targetLang: Lang.t,
  errors: array<string>, // For major errors like bundle loading
  result: FinalResult.t,
}

type state =
  | Init
  | SetupFailed(string)
  | SwitchingCompiler(ready, string) // (ready, targetId, libraries)
  | Ready(ready)
  | Compiling(ready, (Lang.t, string))

type action =
  | SwitchToCompiler(string) // id
  | SwitchLanguage({lang: Lang.t, code: string})
  | Format(string)
  | CompileCode(Lang.t, string)
  | UpdateConfig(Config.t)

let useCompilerManager: (
  ~initialVersion: string=?,
  ~initialLang: Lang.t=?,
  ~onAction: action => unit=?,
  unit,
) => (state, action => unit)
