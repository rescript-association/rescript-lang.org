open Util.ReactStuff

// This component is representing a embedded video, mainly used for markdown content

@react.component
let default = (~src: string, ~withShadow=false, ~caption: option<string>=?) => {
  let shadow = if withShadow {
    "shadow-lg"
  } else {
    ""
  }
  <div className="mt-8 mb-12 md:-mx-16">
    <div className={"flex w-full justify-center"}>
      <div
        className="relative w-full h-full"
        style={Style.make(~width="640px", ~paddingTop="56.25%", ())}>
        <iframe className={"absolute top-0 left-0 w-full h-full"} src allowFullScreen={true} />
      </div>
    </div>
    {switch caption {
    | None => React.null
    | Some(caption) => <div className="mt-4 text-14 text-night-light md:ml-16"> {caption->s} </div>
    }}
  </div>
}
