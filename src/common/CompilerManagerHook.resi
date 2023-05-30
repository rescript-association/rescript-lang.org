open RescriptCompilerApi

module FinalResult: {
  /* A final result is the last operation the compiler has done, right now this includes... */
  type t =
    | Conv(ConversionResult.t)
    | Comp(CompilationResult.t)
    | Nothing
}

type selected = {
  id: Util.Semver.t, // The id used for loading the compiler bundle (ideally should be the same as compilerVersion)
  apiVersion: Version.t, // The playground API version in use
  compilerVersion: string,
  ocamlVersion: string,
  libraries: array<string>,
  config: Config.t,
  instance: Compiler.t,
}

type ready = {
  versions: array<Util.Semver.t>,
  selected: selected,
  targetLang: Lang.t,
  errors: array<string>, // For major errors like bundle loading
  result: FinalResult.t,
}

type state =
  | Init
  | SetupFailed(string)
  | SwitchingCompiler(ready, Util.Semver.t) // (ready, targetId, libraries)
  | Ready(ready)
  | Compiling(ready, (Lang.t, string))

type action =
  | SwitchToCompiler(Util.Semver.t) // id
  | SwitchLanguage({lang: Lang.t, code: string})
  | Format(string)
  | CompileCode(Lang.t, string)
  | UpdateConfig(Config.t)

let useCompilerManager: (
  ~initialVersion: Util.Semver.t=?,
  ~initialLang: Lang.t=?,
  ~onAction: action => unit=?,
  ~versions: array<Util.Semver.t>,
  unit,
) => (state, action => unit)
