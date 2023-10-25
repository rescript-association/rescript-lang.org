module Req: {
  type req
}
module Res: {
  type res
}
let handler: (Req.req, Res.res) => promise<Res.res>
