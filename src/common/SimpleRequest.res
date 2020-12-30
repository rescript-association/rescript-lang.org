type t = XmlHttpRequest.t

type contentType =
  | Json
  | Plain

type method_ =
  | Get
  | Post

type response = {
  status: int,
  text: string,
}

let make = (
  ~completed: result<response, response> => unit,
  ~method as method_=Get,
  ~contentType=Json,
  url: string,
): t => {
  open XmlHttpRequest
  let xhr = make()

  let method_ = switch method_ {
  | Post => "POST"
  | Get => "GET"
  }

  xhr->onLoad(_ => {
    let status = xhr->status

    let text = xhr->responseText->Js.Nullable.toOption->Belt.Option.getWithDefault("")

    if status === 200 {
      completed(Ok({status: status, text: text}))
    } else {
      completed(Error({status: status, text: text}))
    }
  })

  xhr->onError(_ => completed(Error({status: xhr->status, text: "Connection error"})))

  xhr->open_(~method=method_, ~url)

  switch contentType {
  | Json => xhr->setRequestHeader("Content-Type", "application/json")
  | Plain => xhr->setRequestHeader("Content-Type", "text/plain")
  }

  xhr
}

let send = (req: t) => req->XmlHttpRequest.send
let abort = (req: t) => req->XmlHttpRequest.abort
