type version =
  | Latest
  | NoVersion
  | Version(string)

type lang =
  | Default
  | Chinese

type t = {
  fullpath: array<string>,
  lang: lang,
  base: array<string>,
  version: version,
  pagepath: array<string>,
}
// Moved here from original SidebarLayout.UrlPath
type breadcrumb = {
  name: string,
  href: string,
}

let parse: string => t

let prettyString: string => string

let langPrefix: lang => string
