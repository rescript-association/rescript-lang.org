module Schema: {
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
  type docsForModuleAlias = {id: string, docstring: array<string>, name: string, signature: string}
  type docItemDetail = Record(array<fieldDoc>) | Variant(array<constructorDoc>)
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
        detail: option<docItemDetail>,
      })
    | Module(docsForModule)
    | ModuleAlias({id: string, docstring: array<string>, name: string, items: array<docItem>})
  and docsForModule = {
    id: string,
    docstring: array<string>,
    deprecated: option<string>,
    name: string,
    items: array<docItem>,
  }
}
// let decodeDocstring: Js.Dict.t<Js.Json.t> => Js.Array2.t<string>
// let decodeStringByField: (Js.Dict.t<Js.Json.t>, Js.Dict.key) => string
// let decodeDepreacted: Js.Dict.t<Js.Json.t> => option<string>
// let decodeRecordFields: array<Js.Json.t> => Schema.docItemDetail
// let decodeConstructorFields: array<Js.Json.t> => Schema.docItemDetail
// let decodeDetail: Js.Json.t => Schema.docItemDetail
// let decodeValue: Js_dict.t<Js.Json.t> => Schema.docItem
// let decodeType: Js_dict.t<Js.Json.t> => Schema.docItem
// let decodeModuleAlias: Js.Dict.t<Js.Json.t> => Schema.docItem
// let decodeModule: Js.Dict.t<Js.Json.t> => Schema.docItem
// let decodeItem: Js.Json.t => Schema.docItem
type doc = {
  name: string,
  deprecated: option<string>,
  docstring: array<string>,
  items: array<Schema.docItem>,
}
let decodeFromJson: Js.Json.t => doc
