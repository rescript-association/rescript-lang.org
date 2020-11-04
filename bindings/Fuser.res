// This file was automatically converted to ReScript from 'Fuser.re'
// Check the output and make sure to delete the original file
module Options = {
  @bs.deriving(abstract)
  type t = {
    @bs.optional
    id: string,
    @bs.optional
    shouldSort: bool,
    @bs.optional
    matchAllTokens: bool,
    @bs.optional
    includeScore: bool,
    @bs.optional
    threshold: float,
    @bs.optional
    location: int,
    @bs.optional
    distance: int,
    @bs.optional
    maxPatternLength: int,
    @bs.optional
    minMatchCharLength: int,
    @bs.optional
    keys: array<string>,
  }
}

type t<'data>

type result<'data> = {"item": 'data, "score": float}

@bs.new @bs.module("fuse.js")
external make: (array<'data>, Options.t) => t<'a> = "default"


@bs.send external search: (t<'data>, string) => array<result<'data>> = "search"
