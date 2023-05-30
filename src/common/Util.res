/**
module Debounce = {
  // See: https://davidwalsh.name/javascript-debounce-function
  let debounce = (~wait, fn) => {
    let timeout = ref(None)

    () => {
      let unset = () => timeout := None

      switch timeout.contents {
      | Some(id) => Js.Global.clearTimeout(id)
      | None => fn()
      }
      timeout := Some(Js.Global.setTimeout(unset, wait))
    }
  }

  let debounce3 = (~wait, ~immediate=false, fn) => {
    let timeout = ref(None)

    (a1, a2, a3) => {
      let unset = () => {
        timeout := None
        immediate ? fn(a1, a2, a3) : ()
      }

      switch timeout.contents {
      | Some(id) => Js.Global.clearTimeout(id)
      | None => fn(a1, a2, a3)
      }
      timeout := Some(Js.Global.setTimeout(unset, wait))

      if immediate && timeout.contents === None {
        fn(a1, a2, a3)
      } else {
        ()
      }
    }
  }
}
**/
module Unsafe = {
  external elementAsString: React.element => string = "%identity"
}

module String = {
  let camelCase: string => string = %raw("str => {
     return str.replace(/-([a-z])/g, function (g) { return g[1].toUpperCase(); });
    }")

  let capitalize: string => string = %raw("str => {
      return str && str.charAt(0).toUpperCase() + str.substring(1);
    }")
}

module Json = {
  @val @scope("JSON")
  external prettyStringify: (Js.Json.t, @as(json`null`) _, @as(4) _) => string = "stringify"
}

module Url = {
  let isAbsolute: string => bool = %raw(`
    function(str) {
      var r = new RegExp('^(?:[a-z]+:)?//', 'i');
      if (r.test(str))
      {
        return true
      }
      return false;
    }
  `) //', 'i');
}

module Date = {
  type intl

  @new @scope("Intl")
  external dateTimeFormat: (string, {"month": string, "day": string, "year": string}) => intl =
    "DateTimeFormat"

  @send external format: (intl, Js.Date.t) => string = "format"

  let toDayMonthYear = (date: Js.Date.t) => {
    dateTimeFormat("en-US", {"month": "short", "day": "numeric", "year": "numeric"})->format(date)
  }
}

/**
Takes a `version` string starting with a "v" and ending in major.minor.patch or
major.minor.patch-prereleader.identider (e.g. "v10.1.0" or "v10.1.0-alpha.2")
*/
module Semver = {
  type preRelease = Alpha(int) | Beta(int) | Dev(int)

  type t = {major: int, minor: int, patch: int, preRelease: option<preRelease>}

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
      }

      `${mainVersion}-${identifier}`
    }
  }
}
