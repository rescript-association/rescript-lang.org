// https://docsearch.algolia.com/docs/api
type contentType =
  | Content
  | Lvl0
  | Lvl1
  | Lvl2
  | Lvl3
  | Lvl4
  | Lvl5
  | Lvl6

type hierarchy = {
  lvl0: string,
  lvl1: string,
  lvl2: option<string>,
  lvl3: option<string>,
  lvl4: option<string>,
  lvl5: option<string>,
  lvl6: option<string>,
}

type docSearchHit = {
  objectID: string,
  content: option<string>,
  url: string,
  url_without_anchor: string,
  @as("type") type_: contentType,
  anchor: option<string>,
  hierarchy: hierarchy,
}
type transformItems = array<docSearchHit>

type hitComponent = {
  hit: docSearchHit,
  children: React.element
}

type item = {
  itemUrl: string
}

type navigator = {
  navigate: item => unit
}

type searchParameters = {
  facetFilters: array<string>
}

@module("@docsearch/react") @react.component
external make: (
  ~appId: string,
  ~indexName: string,
  ~apiKey: string,
  ~transformItems: transformItems => transformItems=?,
  ~hitComponent: hitComponent => React.element=?,
  ~navigator: navigator=?,
  ~searchParameters: searchParameters=?
) => React.element = "DocSearch"
