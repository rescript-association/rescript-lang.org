module Req: {
  type req
}
module Res: {
  type res
}
@val external process: 'a = "process"
let handler: (Req.req, Res.res) => promise<Res.res>
