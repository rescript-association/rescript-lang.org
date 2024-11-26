type t = {
  title: string,
  metaTitle: Null.t<string>,
  description: Null.t<string>,
  canonical: Null.t<string>,
}

let decode = json => {
  open! Json.Decode
  try Some({
    title: field("title", string, json),
    metaTitle: optional(field("metaTitle", string, ...), json)->Null.fromOption,
    description: optional(field("description", string, ...), json)->Null.fromOption,
    canonical: optional(field("canonical", string, ...), json)->Null.fromOption,
  }) catch {
  | DecodeError(_errMsg) => None
  }
}
