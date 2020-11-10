open Util.ReactStuff

// This component is representing a embedded image, mainly used for markdown content

@react.component
let default = (~src: string, ~withShadow=false, ~caption: option<string>=?) => {
  let shadow = if withShadow {
    "shadow-md"
  } else {
    ""
  }
  <div className="mt-8 mb-12 md:-mx-16">
    <a href=src target="_blank" rel="noopener noreferrer">
      <img className={"w-full " ++ shadow} src />
    </a>
    {switch caption {
    | None => React.null
    | Some(caption) => <div className="mt-4 text-14 text-night-light md:ml-16"> {caption->s} </div>
    }}
  </div>
}
