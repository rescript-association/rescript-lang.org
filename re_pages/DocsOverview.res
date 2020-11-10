open Util.ReactStuff
module Link = Next.Link

module Card = {
  @react.component
  let make = (~title: string, ~hrefs: array<(string, string)>) => {
    let style = ReactDOMRe.Style.make(~maxWidth="21rem", ())
    <div style className="border border-snow-dark bg-snow-light px-5 py-8 rounded-lg">
      <h2 className="font-bold text-21 mb-4"> {title->s} </h2>
      <ul>
        {Belt.Array.map(hrefs, ((text, href)) =>
          <li key=text className="text-16 mb-1 last:mb-0">
            <Markdown.A href> {text->s} </Markdown.A>
          </li>
        )->ate}
      </ul>
    </div>
  }
}

@react.component
let default = (~showVersionSelect=true) => {
  let router = Next.Router.useRouter()
  let url = router.route->Url.parse

  let version = switch url.version {
  | Url.Latest => "latest"
  | NoVersion => "latest"
  | Version(version) => version
  }

  let languageManual = [
    ("Overview", j` /docs/manual/$version/introduction`),
    ("Language Features", j`/docs/manual/$version/overview`),
    ("JS Interop", j`/docs/manual/$version/embed-raw-javascript`),
    ("Build System", j`/docs/manual/$version/build-overview`),
  ]

  let ecosystem = [
    ("GenType", "/docs/gentype/latest/introduction"),
    ("ReasonReact", "https://reasonml.github.io/reason-react"),
    ("Reanalyze", "https://github.com/reason-association/reanalyze"),
  ]

  let versionSelect = if showVersionSelect {
    let onChange = evt => {
      open Url
      ReactEvent.Form.preventDefault(evt)
      let version = (evt->ReactEvent.Form.target)["value"]
      let url = Url.parse(router.route)

      let targetUrl =
        "/" ++
        (Js.Array2.joinWith(url.base, "/") ++
        ("/" ++ (version ++ ("/" ++ Js.Array2.joinWith(url.pagepath, "/")))))
      router->Next.Router.push(targetUrl)
    }
    <div className="text-fire">
      <VersionSelect
        availableVersions=ManualDocsLayout.allManualVersions
        latestVersionLabel=ManualDocsLayout.latestVersionLabel
        onChange
        version
      />
    </div>
  } else {
    React.null
  }

  <>
    <Meta title="Overview | ReScript Documentation" />
    <div> versionSelect <div className="mb-6" /> <Markdown.H1> {"Docs"->s} </Markdown.H1> </div>
    <div className="grid grid-cols-1 xs:grid-cols-2 gap-8">
      <Card title="Language Manual" hrefs=languageManual />
      <Card title="Ecosystem" hrefs=ecosystem />
    </div>
  </>
}
