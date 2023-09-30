module Schema = {
  type fieldDoc = {
    fieldName: string,
    docstrings: array<string>,
    signature: string,
    optional: bool,
    deprecated: option<string>,
  }

  type constructorDoc = {
    constructorName: string,
    docstrings: array<string>,
    signature: string,
    deprecated: option<string>,
  }

  type docsForModuleAlias = {
    id: string,
    docstring: array<string>,
    name: string,
    signature: string,
  }

  type docItemDetail =
    | Record(array<fieldDoc>)
    | Variant(array<constructorDoc>)

  type rec docItem =
    | Value({
        id: string,
        docstring: array<string>,
        signature: string,
        name: string,
        deprecated: option<string>,
      })
    | Type({
        id: string,
        docstring: array<string>,
        signature: string,
        name: string,
        deprecated: option<string>,
        /** Additional documentation for constructors and record fields, if available. */
        detail: option<docItemDetail>,
      })
    | Module(docsForModule)
    | ModuleAlias(docsForModuleAlias)
  and docsForModule = {
    id: string,
    docstring: array<string>,
    deprecated: option<string>,
    name: string,
    items: array<docItem>,
  }
}

let decodeDocstring = item => {
  open Js.Json
  switch item->Js.Dict.get("docstrings") {
  | Some(j) =>
    switch classify(j) {
    | JSONArray(arr) =>
      arr->Js.Array2.map(s =>
        switch classify(s) {
        | JSONString(s) => s
        | _ => assert false
        }
      )
    | _ => assert false
    }
  | None => []
  }
}

let decodeStringByField = (item, field) => {
  open Js.Json
  switch item->Js.Dict.get(field) {
  | Some(j) =>
    switch classify(j) {
    | JSONString(s) => s
    | _ => assert false
    }
  | None => {
      Js.Console.error(item)
      failwith(`Not found field: ${field}`)
    }
  }
}

let decodeDepreacted = item => {
  open Js.Json
  switch item->Js.Dict.get("deprecated") {
  | Some(j) =>
    switch classify(j) {
    | JSONString(j) => Some(j)
    | _ => assert false
    }

  | None => None
  }
}

let decodeRecordFields = (fields: array<Js.Json.t>) => {
  open Js.Json
  let fields = fields->Js.Array2.map(field => {
    switch classify(field) {
    | JSONObject(doc) => {
        let fieldName = doc->decodeStringByField("name")
        let docstrings = doc->decodeDocstring
        let signature = doc->decodeStringByField("signature")
        let deprecated = doc->decodeDepreacted
        let optional = switch Js.Dict.get(doc, "optional") {
        | Some(value) =>
          switch classify(value) {
          | JSONTrue => true
          | JSONFalse => false
          | _ => assert false
          }
        | None => assert false
        }

        {Schema.fieldName, docstrings, signature, optional, deprecated}
      }

    | _ => assert false
    }
  })
  Schema.Record(fields)
}

let decodeConstructorFields = (fields: array<Js.Json.t>) => {
  open Js.Json
  let fields = fields->Js.Array2.map(field => {
    switch classify(field) {
    | JSONObject(doc) => {
        let constructorName = doc->decodeStringByField("name")
        let docstrings = doc->decodeDocstring
        let signature = doc->decodeStringByField("signature")
        let deprecated = doc->decodeDepreacted

        {Schema.constructorName, docstrings, signature, deprecated}
      }

    | _ => assert false
    }
  })
  Schema.Variant(fields)
}

let decodeDetail = detail => {
  open Js.Json

  switch classify(detail) {
  | JSONObject(detail) =>
    switch (detail->Js.Dict.get("kind"), detail->Js.Dict.get("items")) {
    | (Some(kind), Some(items)) =>
      switch (classify(kind), classify(items)) {
      | (JSONString(kind), JSONArray(items)) =>
        switch kind {
        | "record" => decodeRecordFields(items)
        | "variant" => decodeConstructorFields(items)
        | _ => assert false
        }

      | _ => assert false
      }
    | _ => assert false
    }

  | _ => assert false
  }
}

let rec decodeValue = (item: Js_dict.t<Js.Json.t>) => {
  let id = item->decodeStringByField("id")
  let signature = item->decodeStringByField("signature")
  let name = item->decodeStringByField("name")
  let deprecated = item->decodeDepreacted
  let docstring = item->decodeDocstring
  Schema.Value({id, docstring, signature, name, deprecated})
}
and decodeType = (item: Js_dict.t<Js.Json.t>) => {
  let id = item->decodeStringByField("id")
  let signature = item->decodeStringByField("signature")
  let name = item->decodeStringByField("name")
  let deprecated = item->decodeDepreacted
  let docstring = item->decodeDocstring
  let detail = switch item->Js_dict.get("detail") {
  | Some(field) => decodeDetail(field)->Some
  | None => None
  }
  Schema.Type({id, docstring, signature, name, deprecated, detail})
}
and decodeModuleAlias = (item: Js.Dict.t<Js.Json.t>) => {
  // let id = item->decode_string_by_field("id")
  // let signature = item->decode_string_by_field("signature")
  // let name = item->decode_string_by_field("name")
  // let docstring = item->decode_docstring
  // Schema.ModuleAlias({id, signature, name, docstring})
  decodeModule(item)
}
and decodeModule = (item: Js.Dict.t<Js.Json.t>) => {
  open Js.Json
  let id = item->decodeStringByField("id")
  let name = item->decodeStringByField("name")
  let deprecated = item->decodeDepreacted
  let docstring = item->decodeDocstring
  let items = switch Js.Dict.get(item, "items") {
  | Some(items) =>
    switch classify(items) {
    | JSONArray(arr) => arr->Js.Array2.map(i => decodeItem(i))
    | _ => assert false
    }
  | None => assert false
  }
  Schema.Module({id, name, docstring, deprecated, items})
}
and decodeItem = (item: Js.Json.t) => {
  open Js.Json
  switch classify(item) {
  | JSONObject(value) =>
    switch Js.Dict.get(value, "kind") {
    | Some(kind) =>
      switch classify(kind) {
      | JSONString(type_) =>
        switch type_ {
        | "type" => decodeType(value)
        | "value" => decodeValue(value)
        | "module" => decodeModule(value)
        | "moduleAlias" => decodeModuleAlias(value)
        | _ => failwith(`Not implemented ${type_}`)
        }

      | _ => failwith("Expected string field for `kind`")
      }

    | None => failwith("Cannot found `kind` field")
    }

  | _ => assert false
  }
}

type doc = {
  name: string,
  deprecated: option<string>,
  docstring: array<string>,
  items: array<Schema.docItem>,
}
let decodeFromJson = (json: Js.Json.t) => {
  open Js.Json

  switch classify(json) {
  | JSONObject(mod) => {
      let name = mod->decodeStringByField("name")
      let deprecated = mod->decodeDepreacted
      let docstring = mod->decodeDocstring
      let items = switch Js.Dict.get(mod, "items") {
      | Some(items) =>
        switch classify(items) {
        | JSONArray(arr) => arr->Js.Array2.map(i => decodeItem(i))
        | _ => assert false
        }

      | None => assert false
      }

      {name, deprecated, docstring, items}
    }

  | _ => assert false
  }
}
