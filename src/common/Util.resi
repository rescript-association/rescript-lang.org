module Url: {
  type t = {
    hash: string,
    host: string,
    hostname: string,
    href: string,
    origin: string,
    pathname: string
  }
  let isAbsolute: string => bool
  let make: string => t
}

module Unsafe: {
  let elementAsString: React.element => string
}

module String: {
  let camelCase: string => string
  let capitalize: string => string
}

module Date: {
  let toDayMonthYear: Js.Date.t => string
}

module Json: {
  let prettyStringify: Js.Json.t => string
}
