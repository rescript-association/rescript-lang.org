module Options: {
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

let make: (array<'data>, Options.t) => t<'a>

let search: (t<'data>, string) => array<match<'data>>
