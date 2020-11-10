type worker

@bs.new external make: string => worker = "Worker"

module type Config = {
  type fromApp
  type fromWorker
  let make: unit => worker
}

module Make = (Config: Config) => {
  include Config

  module App = {
    @bs.send external postMessage: (worker, fromApp) => unit = "postMessage"
    @bs.set
    external onMessage: (worker, {"data": fromWorker} => unit) => unit = "onmessage"
    @bs.set
    external onError: (worker, Js.t<'a> => unit) => unit = "onerror"
    @bs.send external terminate: worker => unit = "terminate"
  }

  module Worker = {
    type self
    @bs.val external postMessage: fromWorker => unit = "postMessage"
    @bs.set
    external onMessage: (self, {"data": fromApp} => unit) => unit = "onmessage"
    @bs.val external self: self = "self"
    @bs.val external importScripts: string => unit = ""
  }
}
