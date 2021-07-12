type worker

@new external make: string => worker = "Worker"

module type Config = {
  type fromApp
  type fromWorker
  let make: unit => worker
}

module Make = (Config: Config) => {
  include Config

  module App = {
    @send external postMessage: (worker, fromApp) => unit = "postMessage"
    @set
    external onMessage: (worker, {"data": fromWorker} => unit) => unit = "onmessage"
    @set
    external onError: (worker, 'a => unit) => unit = "onerror"
    @send external terminate: worker => unit = "terminate"
  }

  module Worker = {
    type self
    @val external postMessage: fromWorker => unit = "postMessage"
    @set
    external onMessage: (self, {"data": fromApp} => unit) => unit = "onmessage"
    @val external self: self = "self"
    @val external importScripts: string => unit = "importScripts"
  }
}
