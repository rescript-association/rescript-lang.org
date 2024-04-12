type t = {
  title: string,
  metaTitle: Js.null<string>,
  description: Js.null<string>,
  canonical: Js.null<string>,
}

let decode = json => {
  open! Json.Decode
  try Some({
    title: field("title", string, json),
    metaTitle: optional(field("metaTitle", string, ...), json)->Js.Null.fromOption,
    description: optional(field("description", string, ...), json)->Js.Null.fromOption,
    canonical: optional(field("canonical", string, ...), json)->Js.Null.fromOption,
  }) catch {
  | DecodeError(_errMsg) => None
  }
}
