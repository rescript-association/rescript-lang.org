let args = Node.Process.argv

let args_len = args->Js.Array2.length

let analysis_path = args->Js.Array2.unsafe_get(args_len - 2)
let compiler_path = args->Js.Array2.unsafe_get(args_len - 1)
let lib_path = Node.Path.join([compiler_path, "lib", "ocaml"])

type mod = {
  name: string,
  files: array<string>,
}

let public_api_modules = [
  {
    name: "Belt",
    files: [
      "belt.res",
      "belt_Array.resi",
      "belt_Float.resi",
      "belt_HashMap.resi",
      "belt_HashMapInt.resi",
      "belt_HashMapString.resi",
      "belt_HashSet.resi",
      "belt_HashSetInt.resi",
      "belt_HashSetString.resi",
      "belt_Id.resi",
      "belt_Int.resi",
      "belt_List.resi",
      "belt_Map.resi",
      "belt_MapDict.resi",
      "belt_MapInt.resi",
      "belt_MapString.resi",
      "belt_MutableMap.resi",
      "belt_MutableMapInt.resi",
      "belt_MutableMapString.resi",
      "belt_MutableQueue.resi",
      "belt_MutableSet.resi",
      "belt_MutableSetInt.resi",
      "belt_MutableSetString.resi",
      "belt_MutableStack.resi",
      "belt_Option.resi",
      "belt_Range.resi",
      "belt_Result.resi",
      "belt_Set.resi",
      "belt_SetDict.resi",
      "belt_SetInt.resi",
      "belt_SetString.resi",
      "belt_SortArray.resi",
      "belt_SortArrayInt.resi",
      "belt_SortArrayString.resi",
    ],
  },
  {
    name: "DOM",
    files: ["dom.res", "dom_storage.res", "dom_storage2.res"],
  },
  {
    name: "JS",
    files: [
      "js.ml",
      "js_array.res",
      "js_array2.res",
      "js_bigint.res",
      "js_blob.res",
      "js_console.res",
      "js_date.res",
      "js_dict.mli",
      "js_exn.resi",
      "js_file.res",
      "js_float.res",
      "js_global.res",
      "js_int.res",
      "js_json.resi",
      "js_list.resi",
      "js_mapperRt.resi",
      "js_math.ml",
      "js_null.resi",
      "js_null_undefined.resi",
      "js_obj.res",
      "js_option.resi",
      "js_promise.res",
      "js_promise2.res",
      "js_re.res",
      "js_result.resi",
      "js_set.res",
      "js_string.ml",
      "js_string2.res",
      "js_typed_array.res",
      "js_typed_array2.res",
      "js_types.resi",
      "js_undefined.resi",
      "js_vector.resi",
      "js_weakset.res",
      "js_map.res",
      "js_weakmap.res",
    ],
  },
]

external asBuffer: string => Node.Buffer.t = "%identity"

let extractDoc = file => {
  let full_path = Node.Path.join2(lib_path, file)

  let cmd = `${analysis_path} extractDocs ${full_path}`

  let output = Node.Child_process.execSync(cmd, Node.Child_process.option())->asBuffer

  try output->Node.Buffer.toString->Js.Json.parseExn catch {
  | _ => failwith("Failed to extract docs from: " ++ file)
  }
}

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
    | Record({fieldDocs: array<fieldDoc>})
    | Variant({constructorDocs: array<constructorDoc>})

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

let decode_docstring = item => {
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

let decode_string_by_field = (item, field) => {
  open Js.Json
  switch item->Js.Dict.get(field) {
  | Some(j) =>
    switch classify(j) {
    | JSONString(s) => s
    | _ => assert false
    }
  | None => {
      Js.log(item)
      failwith(`Not found field: ${field}`)
    }
  }
}

let decode_depreacted = item => {
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

let decode_record_fields = (fields: array<Js.Json.t>) => {
  open Js.Json
  let fields = fields->Js.Array2.map(field => {
    switch classify(field) {
    | JSONObject(doc) => {
        let fieldName = doc->decode_string_by_field("fieldName")
        let docstrings = doc->decode_docstring
        let signature = doc->decode_string_by_field("signature")
        let deprecated = doc->decode_depreacted
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
  Schema.Record({fieldDocs: fields})
}

let decode_constructor_fields = (fields: array<Js.Json.t>) => {
  open Js.Json
  let fields = fields->Js.Array2.map(field => {
    switch classify(field) {
    | JSONObject(doc) => {
        let constructorName = doc->decode_string_by_field("constructorName")
        let docstrings = doc->decode_docstring
        let signature = doc->decode_string_by_field("signature")
        let deprecated = doc->decode_depreacted

        {Schema.constructorName, docstrings, signature, deprecated}
      }

    | _ => assert false
    }
  })
  Schema.Variant({constructorDocs: fields})
}

let decode_detail = detail => {
  open Js.Json

  switch classify(detail) {
  | JSONObject(detail) =>
    switch detail->Js.Dict.get("kind") {
    | Some(field) =>
      switch classify(field) {
      | JSONString(kind) =>
        switch kind {
        | "record" =>
          switch Js.Dict.get(detail, "fieldDocs") {
          | Some(field) =>
            switch classify(field) {
            | JSONArray(arr) => decode_record_fields(arr)
            | _ => assert false
            }
          | None => assert false
          }

        | "variant" =>
          switch Js.Dict.get(detail, "constructorDocs") {
          | Some(field) =>
            switch classify(field) {
            | JSONArray(arr) => decode_constructor_fields(arr)
            | _ => assert false
            }
          | None => assert false
          }
        | _ => assert false
        }

      | _ => assert false
      }
    | None => assert false
    }

  | _ => assert false
  }
}

let rec decodeValue = (item: Js_dict.t<Js.Json.t>) => {
  let id = item->decode_string_by_field("id")
  let signature = item->decode_string_by_field("signature")
  let name = item->decode_string_by_field("name")
  let deprecated = item->decode_depreacted
  let docstring = item->decode_docstring
  Schema.Value({id, docstring, signature, name, deprecated})
}
and decodeType = (item: Js_dict.t<Js.Json.t>) => {
  let id = item->decode_string_by_field("id")
  let signature = item->decode_string_by_field("signature")
  let name = item->decode_string_by_field("name")
  let deprecated = item->decode_depreacted
  let docstring = item->decode_docstring
  let detail = switch item->Js_dict.get("detail") {
  | Some(field) => decode_detail(field)->Some
  | None => None
  }
  Schema.Type({id, docstring, signature, name, deprecated, detail})
}
and decodeModuleAlias = (item: Js.Dict.t<Js.Json.t>) => {
  let id = item->decode_string_by_field("id")
  let signature = item->decode_string_by_field("signature")
  let name = item->decode_string_by_field("name")
  let docstring = item->decode_docstring
  Schema.ModuleAlias({id, signature, name, docstring})
}
and decodeModule = (item: Js.Dict.t<Js.Json.t>) => {
  open Js.Json
  let id = item->decode_string_by_field("id")
  let name = item->decode_string_by_field("name")
  let deprecated = item->decode_depreacted
  let docstring = item->decode_docstring
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
  switch Js.Json.classify(item) {
  | Js.Json.JSONObject(value) =>
    switch Js.Dict.get(value, "kind") {
    | Some(kind) =>
      switch Js.Json.classify(kind) {
      | Js.Json.JSONString(type_) =>
        switch type_ {
        | "type" => decodeType(value)
        | "value" => decodeValue(value)
        | "module" => decodeModule(value)
        | "moduleAlias" => decodeModuleAlias(value)
        | _ => failwith(`Not implemented ${type_}`)
        }

      | _ => failwith("Expected `kind` field")
      }

    | None => failwith("Cannot found `kind` field")
    }

  | _ => assert false
  }
}

type document = {
  name: string,
  deprecated: option<string>,
  docstring: array<string>,
  items: array<Schema.docItem>,
}
let topLevelModule = (json: Js.Json.t) => {
  open Js.Json

  switch classify(json) {
  | JSONObject(mod) => {
      let name = mod->decode_string_by_field("name")
      let deprecated = mod->decode_depreacted
      let docstring = mod->decode_docstring
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

// let json = Node.Fs.readFileSync(
//   "/tmp/js_json.json",
//   #utf8,
// )

// let r = Js.Json.parseExn(json)->topLevelModule

// Js.log(r)
