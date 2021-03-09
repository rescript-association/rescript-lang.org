// NOTE: This file will later be important to document our
//       design tokens etc.

module ColorSquare = {
  @react.component
  let make = (~className="") => {
    <div className={"w-6 h-6 " ++ className} />
  }
}

@react.component
let default = () => {
  let fireColorSquares = [
    "bg-fire-90",
    "bg-fire-70",
    "bg-fire-50",
    "bg-fire-30",
    "bg-fire-10",
  ]->Js.Array2.map(bgColorClass => {
    <ColorSquare className=bgColorClass />
  })

  <div>
    <h1> {React.string("Main Palette")} </h1>
    <div className="flex"> {React.array(fireColorSquares)} </div>
  </div>
}
