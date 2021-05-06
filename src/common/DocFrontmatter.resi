type t = {
  title: string,
  metaTitle: Js.null<string>, // If there's no metaTitle, we will take title instead
  description: Js.null<string>,
  canonical: Js.null<string>,
  ghEditHref: string,
}

let decode: Js.Json.t => option<t>
