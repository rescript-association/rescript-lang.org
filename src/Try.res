type props = {versions: array<string>}

let default = props => {
  let overlayState = React.useState(() => false)

  let lazyPlayground = Next.Dynamic.dynamic(
    async () => await Js.import(Playground.make),
    {
      ssr: false,
      loading: () => <span> {React.string("Loading...")} </span>,
    },
  )

  let playground = React.createElement(lazyPlayground, {versions: props.versions})

  <>
    <Meta title="ReScript Playground" description="Try ReScript in the browser" />
    <Next.Head>
      <style> {React.string(`body { background-color: #010427; }`)} </style>
    </Next.Head>
    <div className="text-16">
      <div className="text-gray-40 text-14">
        <Navigation fixed=false overlayState />
        playground
      </div>
    </div>
  </>
}

let getStaticProps: Next.GetStaticProps.t<props, _> = async _ => {
  let versions = {
    let response = await Webapi.Fetch.fetch("https://cdn.rescript-lang.org/")
    let text = await Webapi.Fetch.Response.text(response)
    text
    ->Js.String2.split("\n")
    ->Belt.Array.keepMap(line => {
      switch line->Js.String2.startsWith("<a href") {
      | true =>
        // Adapted from https://semver.org/
        let semverRe = %re(
          "/v(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?/"
        )
        switch Js.Re.exec_(semverRe, line) {
        | Some(result) =>
          switch Js.Re.captures(result)->Belt.Array.get(0) {
          | Some(str) => Js.Nullable.toOption(str)
          | None => None
          }
        | None => None
        }
      | false => None
      }
    })
  }

  {"props": {versions: versions}}
}
