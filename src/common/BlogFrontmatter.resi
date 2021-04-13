exception AuthorNotFound(string)

module Author: {
  type t = {
    username: string,
    fullname: Js.null<string>,
    role: string,
    imgUrl: Js.null<string>,
    twitter: Js.null<string>,
  }

  let getAllAuthors: unit => array<t>
  let getDisplayName: t => string
}

module Category: {
  type t =
    | Compiler
    | Syntax
    | Ecosystem
    | Docs
    | Community

  let toString: t => string
}

module Badge: {
  type t =
    | Release
    | Testing
    | Preview
    | Roadmap

  let toString: t => string
}

type t = {
  author: Author.t,
  co_authors: array<Author.t>,
  date: DateStr.t,
  previewImg: Js.null<string>,
  articleImg: Js.null<string>,
  title: string,
  category: Js.null<Category.t>,
  badge: Js.null<Badge.t>,
  description: Js.null<string>,
  canonical: Js.null<string>,
}

let decode: (~authors: array<Author.t>, Js.Json.t) => result<t, string>
