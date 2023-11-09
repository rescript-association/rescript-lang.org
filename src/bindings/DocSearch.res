// API: https://github.com/algolia/docsearch/tree/v3.3.0/packages/docsearch-react/src/types
type contentType = [
  | #content
  | #lvl0
  | #lvl1
  | #lvl2
  | #lvl3
  | #lvl4
  | #lvl5
  | #lvl6
]

type hierarchy = {
  lvl0: string,
  lvl1: string,
  lvl2: Js.Nullable.t<string>,
  lvl3: Js.Nullable.t<string>,
  lvl4: Js.Nullable.t<string>,
  lvl5: Js.Nullable.t<string>,
  lvl6: Js.Nullable.t<string>,
}

type docSearchHit = {
  objectID: string,
  content: Js.Nullable.t<string>,
  url: string,
  url_without_anchor: string,
  @as("type") type_: contentType,
  anchor: Js.Nullable.t<string>,
  hierarchy: hierarchy,
}
type transformItems = array<docSearchHit>

type hitComponent = {
  hit: docSearchHit,
  children: React.element,
}

type item = {itemUrl: string}

type navigator = {navigate: item => unit}

type searchParameters = {facetFilters: array<string>}

@module("@docsearch/react") @react.component
external make: (
  ~appId: string,
  ~indexName: string,
  ~apiKey: string,
  ~transformItems: transformItems => transformItems=?,
  ~hitComponent: hitComponent => React.element=?,
  ~navigator: navigator=?,
  ~onClose: unit => unit=?,
  ~searchParameters: searchParameters=?,
  ~initialScrollY: int=?,
) => React.element = "DocSearchModal"
