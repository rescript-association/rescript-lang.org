// This module is used for accessing meta data from MDX frontmatter
// It's mostly used in conjunction with the <Meta /> component

// Note: Every optional value in here must be encoded
// as Js.Null.t, since it will be used for JSON serialization
// within Next's static generation

type t

let decode = (json: Js.Json.t): result<t, string> => Error("Not implemented")
