@react.component
let default = (~src: string, ~withShadow=false, ~caption: option<string>=?) => {
  <Markdown.Image src withShadow ?caption />
}
