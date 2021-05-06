type worker

let make: string => worker

module type Config = {
  type fromApp
  type fromWorker
  let make: unit => worker
}

module Make: (Config: Config) =>
{
  include Config

  module App: {
    let postMessage: (worker, fromApp) => unit
    let onMessage: (worker, {"data": fromWorker} => unit) => unit
    let onError: (worker, 'a => unit) => unit
    let terminate: worker => unit
  }

  module Worker: {
    type self
    let postMessage: fromWorker => unit
    let onMessage: (self, {"data": fromApp} => unit) => unit
    let self: self
    let importScripts: string => unit
  }
}
