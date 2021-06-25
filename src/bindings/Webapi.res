module Document = {
  @scope("document") @val external createElement: string => Dom.element = "createElement"
  @scope("document") @val external createTextNode: string => Dom.element = "createTextNode"
}

module ClassList = {
  type t;
  @send external toggle: (t, string) => unit = "toggle"
}

module Element = {
  @send external appendChild: (Dom.element, Dom.element) => unit = "appendChild"
  @send external removeChild: (Dom.element, Dom.element) => unit = "removeChild"
  @set external setClassName: (Dom.element, string) => unit = "className"
  @get external classList: Dom.element => ClassList.t = "classList"
}


type animationFrameId

@scope("window") @val
external requestAnimationFrame: (unit => unit) => animationFrameId = "requestAnimationFrame"

@scope("window") @val
external cancelAnimationFrame: animationFrameId => unit = "cancelAnimationFrame"
