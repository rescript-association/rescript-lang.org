type author = {
  username: string,
  fullname: string,
  role: string,
  imgUrl: string,
  twitter: string,
}

let authors = [
  {
    username: "hongbo",
    fullname: "Hongbo Zhang",
    role: "Compiler & Build System",
    imgUrl: "https://pbs.twimg.com/profile_images/1369548222314598400/E2y46vrB_400x400.jpg",
    twitter: "bobzhang1988",
  },
  {
    username: "chenglou",
    fullname: "Cheng Lou",
    role: "Syntax & Tools",
    imgUrl: "https://pbs.twimg.com/profile_images/554199709909131265/Y5qUDaCB_400x400.jpeg",
    twitter: "_chenglou",
  },
  {
    username: "maxim",
    fullname: "Maxim Valcke",
    role: "Syntax Lead",
    imgUrl: "https://pbs.twimg.com/profile_images/970271048812974080/Xrr8Ob6J_400x400.jpg",
    twitter: "_binary_search",
  },
  {
    username: "ryyppy",
    fullname: "Patrick Ecker",
    role: "Documentation",
    imgUrl: "https://pbs.twimg.com/profile_images/1388426717006544897/B_a7D4GF_400x400.jpg",
    twitter: "ryyppy",
  },
  {
    username: "rickyvetter",
    fullname: "Ricky Vetter",
    role: "ReScript & React",
    imgUrl: "https://pbs.twimg.com/profile_images/541111032207273984/DGsZmmfr_400x400.jpeg",
    twitter: "rickyvetter",
  },
  {
    username: "made_by_betty",
    fullname: "Bettina Steinbrecher",
    role: "Brand / UI / UX",
    imgUrl: "https://pbs.twimg.com/profile_images/1366785342704136195/3IGyRhV1_400x400.jpg",
    twitter: "made_by_betty",
  },
  {
    username: "rescript-team",
    fullname: "ReScript Team",
    role: "Core Development",
    imgUrl: "https://pbs.twimg.com/profile_images/1358354824660541440/YMKNWE1V_400x400.png",
    twitter: "rescriptlang",
  },
  {
    username: "rescript-association",
    fullname: "ReScript Association",
    role: "Foundation",
    imgUrl: "https://pbs.twimg.com/profile_images/1045362176117100545/MioTQoTp_400x400.jpg",
    twitter: "ReScriptAssoc",
  },
]

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
  author: author,
  co_authors: array<author>,
  date: DateStr.t,
  previewImg: Js.null<string>,
  articleImg: Js.null<string>,
  title: string,
  badge: Js.null<Badge.t>,
  description: Js.null<string>,
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

let decodeAuthor = (~fieldName: string, ~authors, username) =>
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

let decode = (json: Js.Json.t): result<t, string> => {
  open Json.Decode
  switch {
    author: json->field("author", string, _)->decodeAuthor(~fieldName="author", ~authors),
    co_authors: json
    ->optional(field("co-authors", authorDecoder(~fieldName="co-authors", ~authors)), _)
    ->Belt.Option.getWithDefault([]),
    date: json->field("date", string, _)->DateStr.fromString,
    badge: json->optional(j => field("badge", string, j)->decodeBadge, _)->Js.Null.fromOption,
    previewImg: json->optional(field("previewImg", string), _)->Js.Null.fromOption,
    articleImg: json->optional(field("articleImg", string), _)->Js.Null.fromOption,
    title: json->field("title", string, _),
    description: json->nullable(field("description", string), _),
  } {
  | fm => Ok(fm)
  | exception DecodeError(str) => Error(str)
  | exception AuthorNotFound(str) => Error(str)
  }
}
