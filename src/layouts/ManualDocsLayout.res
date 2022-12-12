module EnLayouts = {
  module LatestLayout = DocsLayout.Make({
    // Structure defined by `scripts/extract-tocs.js`
    let tocData: SidebarLayout.Toc.raw = %raw("require('index_data/manual_latest_toc.json')")
  })

  module V800Layout = DocsLayout.Make({
    // Structure defined by `scripts/extract-tocs.js`
    let tocData: SidebarLayout.Toc.raw = %raw("require('index_data/manual_v800_toc.json')")
  })

  module V900Layout = DocsLayout.Make({
    // Structure defined by `scripts/extract-tocs.js`
    let tocData: SidebarLayout.Toc.raw = %raw("require('index_data/manual_v900_toc.json')")
  })
}

module CnLayouts = {
  module LatestLayout = DocsLayout.Make({
    // Structure defined by `scripts/extract-tocs.js`
    let tocData: SidebarLayout.Toc.raw = %raw("require('index_data/manual_latest_toc_cn.json')")
  })
}

module Latest = {
  @react.component
  let make = (~frontmatter=?, ~components=Markdown.default, ~children) => {
    let router = Next.Router.useRouter()
    let route = router.route

    let url = route->Url.parse

    let version = switch url.version {
    | Version(version) => version
    | NoVersion => "latest"
    | Latest => "latest"
    }

    let lang = url.lang

    let breadcrumbs = list{
      {
        open Url
        {name: "Docs", href: langPrefix(lang) ++ "/docs/" ++ version}
      },
      {
        open Url
        {
          name: "Language Manual",
          href: langPrefix(lang) ++ "/docs/manual/" ++ (version ++ "/introduction"),
        }
      },
    }

    let title = "Language Manual"
    let version = "latest"
    
    switch lang {
    | Default =>
      <EnLayouts.LatestLayout
        theme=#Reason
        components
        version
        title
        metaTitleCategory="ReScript Language Manual"
        availableVersions=Constants.allManualVersions
        ?frontmatter
        breadcrumbs>
        children
      </EnLayouts.LatestLayout>
    | Chinese =>
      <CnLayouts.LatestLayout
        theme=#Reason
        components
        version
        title
        metaTitleCategory="ReScript 语言手册"
        availableVersions=Constants.allManualVersions
        ?frontmatter
        breadcrumbs>
        children
      </CnLayouts.LatestLayout>
    }
  }
}

module V900 = {
  @react.component
  let make = (~frontmatter: option<Js.Json.t>=?, ~components=Markdown.default, ~children) => {
    let router = Next.Router.useRouter()
    let route = router.route

    let url = route->Url.parse

    let version = switch url.version {
    | Version(version) => version
    | NoVersion => "latest"
    | Latest => "latest"
    }

    let breadcrumbs = list{
      {
        open Url
        {name: "Docs", href: "/docs/" ++ version}
      },
      {
        open Url
        {
          name: "Language Manual",
          href: "/docs/manual/" ++ (version ++ "/introduction"),
        }
      },
    }

    let title = "Language Manual"

    <EnLayouts.V900Layout
      theme=#Reason
      components
      version
      title
      metaTitleCategory="ReScript Language Manual"
      availableVersions=Constants.allManualVersions
      ?frontmatter
      breadcrumbs>
      children
    </EnLayouts.V900Layout>
  }
}

module V800 = {
  @react.component
  let make = (~frontmatter=?, ~components=Markdown.default, ~children) => {
    let router = Next.Router.useRouter()
    let route = router.route

    let url = route->Url.parse

    let version = switch url.version {
    | Version(version) => version
    | NoVersion => "latest"
    | Latest => "latest"
    }

    let breadcrumbs = list{
      {
        open Url
        {name: "Docs", href: "/docs/" ++ version}
      },
      {
        open Url
        {
          name: "Language Manual",
          href: "/docs/manual/" ++ (version ++ "/introduction"),
        }
      },
    }

    let title = "Language Manual"
    let version = "v8.0.0"

    let warnBanner = {
      open Markdown

      let latestUrl =
        "/" ++
        (Js.Array2.joinWith(url.base, "/") ++
        ("/latest/" ++ Js.Array2.joinWith(url.pagepath, "/")))

      let label = switch Js.Array2.find(Constants.allManualVersions, ((v, _)) => {
        v === version
      }) {
      | Some((_, label)) => label
      | None => version
      }

      let additionalText = switch version {
      | "v8.0.0" => "(These docs are equivalent to the old BuckleScript docs before the ReScript rebrand)"
      | _ => ""
      }

      <div className="mb-10">
        <Info>
          <P>
            {React.string(
              "You are currently looking at the " ++
              (label ++
              " docs (Reason v3.6 syntax edition). You can find the latest manual page "),
            )}
            <A href=latestUrl> {React.string("here")} </A>
            {React.string(".")}
            <p className="text-14 mt-2"> {React.string(additionalText)} </p>
          </P>
        </Info>
      </div>
    }

    <EnLayouts.V800Layout
      theme=#Reason
      components
      version
      title
      metaTitleCategory="ReScript Language Manual"
      availableVersions=Constants.allManualVersions
      ?frontmatter
      breadcrumbs>
      warnBanner
      children
    </EnLayouts.V800Layout>
  }
}
