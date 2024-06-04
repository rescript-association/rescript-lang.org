module Req = {
  type req = {query: Dict.t<string>}
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

let handler = async (req: Req.req, res: Res.res) => {
  switch req.query->Dict.get("secret") {
  | Some(secret) =>
    switch Node.Process.env->Dict.get("NEXT_REVALIDATE_SECRET_TOKEN") {
    | Some(token) =>
      if secret !== token {
        res->Res.Status.make(401)->Res.Status.json({"message": "Invalid secret"})
      } else {
        try {
          let () = await res->Res.revalidate("/try")
          res->Res.json({"revalidated": true})
        } catch {
        | Exn.Error(_) => res->Res.Status.make(500)->Res.Status.send("Error revalidating")
        }
      }
    | None =>
      res
      ->Res.Status.make(500)
      ->Res.Status.send("Error revalidating, `NEXT_REVALIDATE_SECRET_TOKEN` not found")
    }
  | None =>
    res->Res.Status.make(500)->Res.Status.send("Error revalidating, param `secret` not found")
  }
}
