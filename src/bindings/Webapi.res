module Document = {
  @scope("document") @val external createElement: string => Dom.element = "createElement"
  @scope("document") @val external createTextNode: string => Dom.element = "createTextNode"
  @scope("document") @val
  external addEventListener: (string, 'a => unit) => unit = "addEventListener"
  @scope("document") @val
  external removeEventListener: (string, 'a => unit) => unit = "removeEventListener"
}

module ClassList = {
  type t
  @send external toggle: (t, string) => unit = "toggle"
}

module Element = {
  @send external appendChild: (Dom.element, Dom.element) => unit = "appendChild"
  @send external removeChild: (Dom.element, Dom.element) => unit = "removeChild"
  @set external setClassName: (Dom.element, string) => unit = "className"
  @get external classList: Dom.element => ClassList.t = "classList"
  @get external offsetWidth: Dom.element => float = "offsetWidth"
  @get external offsetHeight: Dom.element => float = "offsetHeight"
  @send external getBoundingClientRect: Dom.element => {..} = "getBoundingClientRect"

  module Style = {
    @scope("style") @set external width: (Dom.element, string) => unit = "width"
    @scope("style") @set external height: (Dom.element, string) => unit = "height"
  }
}

type animationFrameId

@scope("window") @val
external requestAnimationFrame: (unit => unit) => animationFrameId = "requestAnimationFrame"

@scope("window") @val
external cancelAnimationFrame: animationFrameId => unit = "cancelAnimationFrame"

module Window = {
  @scope("window") @val external addEventListener: (string, 'a => unit) => unit = "addEventListener"
  @scope("window") @val
  external removeEventListener: (string, 'a => unit) => unit = "removeEventListener"
  @scope("window") @val external innerWidth: int = "innerWidth"
  @scope("window") @val external innerHeight: int = "innerHeight"
}
