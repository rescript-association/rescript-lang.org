type t = {
  title: string,
  metaTitle: Js.null<string>,
  description: Js.null<string>,
  canonical: Js.null<string>,
}

let decode = (json: Js.Json.t) => {
  switch json {
  | Object(dict) =>
    switch (
      dict->Js.Dict.get("title"),
      dict->Js.Dict.get("metaTitle"),
      dict->Js.Dict.get("description"),
      dict->Js.Dict.get("canonical"),
    ) {
    | (Some(String(title)), metaTitle, description, canonical) =>
      Some({
        title,
        metaTitle: switch metaTitle {
        | Some(String(s)) => s->Js.Null.return
        | _ => Js.null
        },
        description: switch description {
        | Some(String(s)) => s->Js.Null.return
        | _ => Js.null
        },
        canonical: switch canonical {
        | Some(String(s)) => s->Js.Null.return
        | _ => Js.null
        },
      })
    | _ => None
    }
  | _ => None
  }
}
