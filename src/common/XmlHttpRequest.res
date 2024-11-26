// FULL XMLHttpRequest SPEC
// https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/Using_XMLHttpRequest

// ORIGINAL SOURCE OF THIS MODIFIED MODULE:
// https://github.com/stefanduberg/bs-xmlhttprequest/blob/master/src/XmlHttpRequest.re

module Upload = {
  type t

  @set
  external onAbort: (t, Dom.progressEvent => unit) => unit = "onabort"

  @set
  external onError: (t, Dom.progressEvent => unit) => unit = "onerror"

  @set external onLoad: (t, Dom.progressEvent => unit) => unit = "onload"

  @set
  external onLoadEnd: (t, Dom.progressEvent => unit) => unit = "onloadend"

  @set
  external onLoadStart: (t, Dom.progressEvent => unit) => unit = "onloadstart"

  @set
  external onProgress: (t, Dom.progressEvent => unit) => unit = "onprogress"

  @set
  external onTimeout: (t, Dom.progressEvent => unit) => unit = "ontimeout"

  @send
  external addEventListener: (
    t,
    @string
    [
      | #abort(Dom.progressEvent => unit)
      | #error(Dom.progressEvent => unit)
      | #load(Dom.progressEvent => unit)
      | @as("loadend") #loadEnd(Dom.progressEvent => unit)
      | @as("loadstart") #loadStart(Dom.progressEvent => unit)
      | #progress(Dom.progressEvent => unit)
      | #timeout(Dom.progressEvent => unit)
    ],
  ) => unit = "addEventListener"

  @send
  external addEventListenerWithOptions: (
    t,
    @string
    [
      | #abort(Dom.progressEvent => unit)
      | #error(Dom.progressEvent => unit)
      | #load(Dom.progressEvent => unit)
      | @as("loadend") #loadEnd(Dom.progressEvent => unit)
      | @as("loadstart") #loadStart(Dom.progressEvent => unit)
      | #progress(Dom.progressEvent => unit)
      | #timeout(Dom.progressEvent => unit)
    ],
    {"capture": bool, "once": bool, "passive": bool},
  ) => unit = "addEventListener"

  @send
  external removeEventListener: (
    t,
    @string
    [
      | #abort(Dom.progressEvent => unit)
      | #error(Dom.progressEvent => unit)
      | #load(Dom.progressEvent => unit)
      | @as("loadend") #loadEnd(Dom.progressEvent => unit)
      | @as("loadstart") #loadStart(Dom.progressEvent => unit)
      | #progress(Dom.progressEvent => unit)
      | #timeout(Dom.progressEvent => unit)
    ],
  ) => unit = "removeEventListener"

  @send
  external removeEventListenerWithOptions: (
    t,
    @string
    [
      | #abort(Dom.progressEvent => unit)
      | #error(Dom.progressEvent => unit)
      | #load(Dom.progressEvent => unit)
      | @as("loadend") #loadEnd(Dom.progressEvent => unit)
      | @as("loadstart") #loadStart(Dom.progressEvent => unit)
      | #progress(Dom.progressEvent => unit)
      | #timeout(Dom.progressEvent => unit)
    ],
    {"capture": bool, "passive": bool},
  ) => unit = "removeEventListener"
}

type t

type readyState =
  | Unsent
  | Opened
  | HeadersReceived
  | Loading
  | Done
  | Unknown

let decodeReadyState = x =>
  switch x {
  | 0 => Unsent
  | 1 => Opened
  | 2 => HeadersReceived
  | 3 => Loading
  | 4 => Done
  | _ => Unknown
  }

@new external make: unit => t = "XMLHttpRequest"

// The original readyState representation
@get external readyStateNum: t => int = "readyState"

let readyState = (xhr: t) => decodeReadyState(readyStateNum(xhr))

@get
external responseArrayBuffer: t => Nullable.t<ArrayBuffer.t> = "response"

// Response property with different encodings
@get
external responseDocument: t => Nullable.t<Dom.document> = "response"
@get external responseJson: t => Nullable.t<JSON.t> = "response"
@get external responseText: t => Nullable.t<string> = "responseText"
@get external responseType: t => string = "responseType"
@get external responseUrl: t => Nullable.t<string> = "responseUrl"
@get
external responseXml: t => Nullable.t<Dom.xmlDocument> = "responseXml"

@set
external setResponseType: (
  t,
  @string [@as("arraybuffer") #arrayBuffer | #document | #json | #text],
) => string = "responseType"

@get external status: t => int = "status"

@get external statusText: t => string = "statusText"

@get external timeout: t => int = "timeout"

@get external upload: t => Upload.t = "upload"

@set external setTimeout: (t, int) => int = "timeout"

@get external withCredentials: t => bool = "withCredentials"

@set external setWithCredentials: (t, bool) => bool = "withCredentials"

@send external abort: t => unit = "abort"

@send
external getAllResponseHeaders: t => Nullable.t<string> = "getAllResponseHeaders"

@send
external getResponseHeader: (t, string) => Nullable.t<string> = "getResponseHeader"

@send external open_: (t, ~method: string, ~url: string) => unit = "open"

@send external overrideMimeType: (t, string) => unit = "overrideMimeType"

@send external send: t => unit = "send"

@send
external sendArrayBuffer: (t, ArrayBuffer.t) => unit = "send"

@send external sendDocument: (t, Dom.document) => unit = "send"

@send external sendString: (t, string) => unit = "send"

@send
external setRequestHeader: (t, string, string) => unit = "setRequestHeader"

@set
external onReadyStateChange: (t, Dom.event => unit) => unit = "onreadystatechange"

@set external onAbort: (t, Dom.progressEvent => unit) => unit = "onabort"
@set external onError: (t, Dom.progressEvent => unit) => unit = "onerror"
@set external onLoad: (t, Dom.progressEvent => unit) => unit = "onload"

@set
external onLoadEnd: (t, Dom.progressEvent => unit) => unit = "onloadend"

@set
external onLoadStart: (t, Dom.progressEvent => unit) => unit = "onloadstart"

@set
external onProgress: (t, Dom.progressEvent => unit) => unit = "onprogress"

@set
external onTimeout: (t, Dom.progressEvent => unit) => unit = "ontimeout"

@send
external addEventListener: (
  t,
  @string
  [
    | #abort(Dom.progressEvent => unit)
    | #error(Dom.progressEvent => unit)
    | #load(Dom.progressEvent => unit)
    | @as("loadend") #loadEnd(Dom.progressEvent => unit)
    | @as("loadstart") #loadStart(Dom.progressEvent => unit)
    | #progress(Dom.progressEvent => unit)
    | @as("readystatechange") #readyStateChange(Dom.event => unit)
    | #timeout(Dom.progressEvent => unit)
  ],
) => unit = "addEventListener"

@send
external addEventListenerWithOptions: (
  t,
  @string
  [
    | #abort(Dom.progressEvent => unit)
    | #error(Dom.progressEvent => unit)
    | #load(Dom.progressEvent => unit)
    | @as("loadend") #loadEnd(Dom.progressEvent => unit)
    | @as("loadstart") #loadStart(Dom.progressEvent => unit)
    | #progress(Dom.progressEvent => unit)
    | @as("readystatechange") #readyStateChange(Dom.event => unit)
    | #timeout(Dom.progressEvent => unit)
  ],
  {"capture": bool, "once": bool, "passive": bool},
) => unit = "addEventListener"

@send
external removeEventListener: (
  t,
  @string
  [
    | #abort(Dom.progressEvent => unit)
    | #error(Dom.progressEvent => unit)
    | #load(Dom.progressEvent => unit)
    | @as("loadend") #loadEnd(Dom.progressEvent => unit)
    | @as("loadstart") #loadStart(Dom.progressEvent => unit)
    | #progress(Dom.progressEvent => unit)
    | @as("readystatechange") #readyStateChange(Dom.event => unit)
    | #timeout(Dom.progressEvent => unit)
  ],
) => unit = "removeEventListener"

@send
external removeEventListenerWithOptions: (
  t,
  @string
  [
    | #abort(Dom.progressEvent => unit)
    | #error(Dom.progressEvent => unit)
    | #load(Dom.progressEvent => unit)
    | @as("loadend") #loadEnd(Dom.progressEvent => unit)
    | @as("loadstart") #loadStart(Dom.progressEvent => unit)
    | #progress(Dom.progressEvent => unit)
    | @as("readystatechange") #readyStateChange(Dom.event => unit)
    | #timeout(Dom.progressEvent => unit)
  ],
  {"capture": bool, "passive": bool},
) => unit = "removeEventListener"
