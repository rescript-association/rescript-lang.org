module Req = {
  type query = {secret: string}

  type req = {query: query}
}

module Res = {
  type res

  @send external revalidate: (res, string) => promise<unit> = "revalidate"
  @send external json: (res, {..}) => res = "json"

  module Status = {
    type t
    @send external make: (res, int) => t = "status"
    @send external send: (t, string) => res = "send"
    @send external json: (t, {..}) => res = "json"
  }
}

@val external process: 'a = "process"

let handler = async (req: Req.req, res: Res.res) => {
  if req.query.secret !== process["env"]["NEXT_REVALIDATE_SECRET_TOKEN"] {
    res->Res.Status.make(401)->Res.Status.json({"message": "Invalid secret"})
  } else {
    try {
      let () = await res->Res.revalidate("/try")
      res->Res.json({"revalidated": true})
    } catch {
    | Js.Exn.Error(_) => res->Res.Status.make(500)->Res.Status.send("Error revalidating")
    }
  }
}
