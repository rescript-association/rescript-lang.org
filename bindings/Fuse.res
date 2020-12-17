module Options = {
  @bs.deriving(abstract)
  type t = {
    @bs.optional
    shouldSort: bool,
    @bs.optional
    includeScore: bool,
    @bs.optional
    threshold: float,
    @bs.optional
    location: int,
    @bs.optional
    distance: int,
    @bs.optional
    minMatchCharLength: int,
    @bs.optional
    keys: array<string>,
  }
}

type t<'data>

type match<'data> = {"item": 'data, "score": float}

@bs.new @bs.module("fuse.js")
external make: (array<'data>, Options.t) => t<'a> = "default"


@bs.send external search: (t<'data>, string) => array<match<'data>> = "search"
