type field = {
  name: string,
  docstrings: array<string>,
  signature: string,
  optional: bool,
  deprecated: option<string>,
}

type constructor = {
  name: string,
  docstrings: array<string>,
  signature: string,
  deprecated: option<string>,
}

type detail =
  | Record(array<field>)
  | Variant(array<constructor>)

type rec item =
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
      detail: option<detail>,
    })
  | Module(docsForModule)
  | ModuleAlias({id: string, docstring: array<string>, name: string, items: array<item>})
and docsForModule = {
  id: string,
  docstring: array<string>,
  deprecated: option<string>,
  name: string,
  items: array<item>,
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
        let name = doc->decodeStringByField("name")
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

        {name, docstrings, signature, optional, deprecated}
      }

    | _ => assert false
    }
  })
  Record(fields)
}

let decodeConstructorFields = (fields: array<Js.Json.t>) => {
  open Js.Json
  let fields = fields->Js.Array2.map(field => {
    switch classify(field) {
    | JSONObject(doc) => {
        let name = doc->decodeStringByField("name")
        let docstrings = doc->decodeDocstring
        let signature = doc->decodeStringByField("signature")
        let deprecated = doc->decodeDepreacted

        {name, docstrings, signature, deprecated}
      }

    | _ => assert false
    }
  })
  Variant(fields)
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
  Value({id, docstring, signature, name, deprecated})
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
  Type({id, docstring, signature, name, deprecated, detail})
}
and decodeModuleAlias = (item: Js.Dict.t<Js.Json.t>) => {
  open Js.Json
  let id = item->decodeStringByField("id")
  let name = item->decodeStringByField("name")
  let docstring = item->decodeDocstring
  let items = switch Js.Dict.get(item, "items") {
  | Some(items) =>
    switch classify(items) {
    | JSONArray(arr) => arr->Js.Array2.map(i => decodeItem(i))
    | _ => assert false
    }
  | None => assert false
  }
  ModuleAlias({id, items, name, docstring})
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
  Module({id, name, docstring, deprecated, items})
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
  items: array<item>,
}
let decodeFromJson = json => {
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
