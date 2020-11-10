// Note: Every optional value in here must be encoded
// as Js.Null.t, since it will be used for JSON serialization
// within Next's static generation

module Author = {
  type t = {
    username: string,
    fullname: Js.null<string>,
    role: string,
    imgUrl: Js.null<string>,
    twitter: Js.null<string>,
  }

  // We could *theoratically* query most of the
  // author data from different sources, like twitter
  // or github, but decided against it for simplicity
  // reasons for now
  let rawAuthors: Js.Json.t = %raw("require('../index_data/blog_authors.json')")

  let getDisplayName = (author: t): string =>
    switch author.fullname->Js.Null.toOption {
    | Some(fullname) => fullname
    | None => "@" ++ author.username
    }

  let decode = (json: Js.Json.t) => {
    open Json.Decode
    {
      username: json->field("username", string, _),
      fullname: json->optional(field("fullname", string), _)->Js.Null.fromOption,
      role: json->field("role", string, _),
      imgUrl: json->optional(field("img_url", string), _)->Js.Null.fromOption,
      twitter: json->optional(field("twitter", string), _)->Js.Null.fromOption,
    }
  }

  let getAllAuthors = (): array<t> => rawAuthors->Json.Decode.array(decode, _)
}

module Category = {
  type t =
    | Compiler
    | Syntax
    | Ecosystem
    | Docs
    | Community

  let toString = (c: t): string =>
    switch c {
    | Compiler => "Compiler"
    | Syntax => "Syntax"
    | Ecosystem => "Ecosystem"
    | Docs => "Docs"
    | Community => "Community"
    }
}

module Badge = {
  type t =
    | Release
    | Testing
    | Preview
    | Roadmap

  let toString = (c: t): string =>
    switch c {
    | Release => "Release"
    | Testing => "Testing"
    | Preview => "Preview"
    | Roadmap => "Roadmap"
    }
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

let decodeCategory = (str: string): Category.t =>
  switch Js.String2.toLowerCase(str) {
  | "compiler" => Compiler
  | "syntax" => Syntax
  | "ecosystem" => Ecosystem
  | "docs" => Docs
  | "community" => Community
  | str => raise(Json.Decode.DecodeError(j`Unknown category "$str"`))
  }

let decodeBadge = (str: string): Badge.t =>
  switch Js.String2.toLowerCase(str) {
  | "release" => Release
  | "testing" => Testing
  | "preview" => Preview
  | "roadmap" => Roadmap
  | str => raise(Json.Decode.DecodeError(j`Unknown category "$str"`))
  }

exception AuthorNotFound(string)

let decodeAuthor = (~fieldName: string, ~authors: array<Author.t>, username) =>
  switch Js.Array2.find(authors, a => a.username === username) {
  | Some(author) => author
  | None => raise(AuthorNotFound(j`Couldn't find author "$username" in field $fieldName`))
  }

let authorDecoder = (~fieldName: string, ~authors, json) => {
  open Json.Decode

  let multiple = j => array(string, j)->Belt.Array.map(decodeAuthor(~fieldName, ~authors))

  let single = j => [string(j)->decodeAuthor(~fieldName, ~authors)]

  either(single, multiple, json)
}

let decode = (~authors: array<Author.t>, json: Js.Json.t): result<t, string> => {
  open Json.Decode
  switch {
    author: json->field("author", string, _)->decodeAuthor(~fieldName="author", ~authors),
    co_authors: json
    ->optional(field("co-authors", authorDecoder(~fieldName="co-authors", ~authors)), _)
    ->Belt.Option.getWithDefault([]),
    date: json->field("date", string, _)->DateStr.fromString,
    category: json
    ->optional(j => field("category", string, j)->decodeCategory, _)
    ->Js.Null.fromOption,
    badge: json->optional(j => field("badge", string, j)->decodeBadge, _)->Js.Null.fromOption,
    previewImg: json->optional(field("previewImg", string), _)->Js.Null.fromOption,
    articleImg: json->optional(field("articleImg", string), _)->Js.Null.fromOption,
    title: json->field("title", string, _),
    description: json->nullable(field("description", string), _),
    canonical: json->optional(field("canonical", string), _)->Js.Null.fromOption,
  } {
  | fm => Ok(fm)
  | exception DecodeError(str) => Error(str)
  | exception AuthorNotFound(str) => Error(str)
  }
}
