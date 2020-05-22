type t = XmlHttpRequest.t;

type contentType =
  | Json
  | Plain;

type method =
  | Get
  | Post;

let make =
    (
      ~onSuccess: string => unit,
      ~onError as onErrorCb: 'error => unit,
      ~method=Get,
      ~contentType=Json,
      url: string,
    )
    : t => {
  open XmlHttpRequest;
  let xhr = make();

  let method =
    switch (method) {
    | Post => "POST"
    | Get => "GET"
    };

  xhr->onLoad(_ => {
    onSuccess(
      xhr->responseText->Js.Nullable.toOption->Belt.Option.getWithDefault(""),
    )
  });
  xhr->onError(onErrorCb);
  xhr->open_(~method, ~url);

  switch (contentType) {
  | Json => xhr->setRequestHeader("Content-Type", "application/json")
  | Plain => xhr->setRequestHeader("Content-Type", "text/plain")
  };

  xhr;
};

let send = (req: t) => req->XmlHttpRequest.send;
let abort = (req: t) => req->XmlHttpRequest.abort;
