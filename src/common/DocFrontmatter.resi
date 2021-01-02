type t = {
  title: string,
  description: Js.null<string>,
  canonical: Js.null<string>,
  ghEditHref: string,
}

let decode: Js.Json.t => result<t, string>
