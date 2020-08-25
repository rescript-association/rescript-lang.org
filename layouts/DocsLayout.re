// This module is used for all plain prose text related
// Docs, mostly /docs/manual/latest and similar sections

open Util.ReactStuff;
module Link = Next.Link;

module Sidebar = SidebarLayout.Sidebar;

module UrlPath = SidebarLayout.UrlPath;
module NavItem = Sidebar.NavItem;
module Category = Sidebar.Category;

[@react.component]
let make =
    (
      ~breadcrumbs: option(list(UrlPath.breadcrumb))=?,
      ~title: string,
      ~frontmatter: option(Js.Json.t)=?,
      ~version: option(string)=?,
      ~availableVersions: option(array(string))=?,
      ~latestVersionLabel: string="latest",
      ~activeToc: option(SidebarLayout.Toc.t)=?,
      ~categories: array(Category.t),
      ~components=Markdown.default,
      ~theme=`Reason,
      ~children,
    ) => {
  let router = Next.Router.useRouter();
  let route = router.route;

  let (isSidebarOpen, setSidebarOpen) = React.useState(_ => false);
  let toggleSidebar = () => setSidebarOpen(prev => !prev);

  React.useEffect1(
    () => {
      open Next.Router.Events;
      let {Next.Router.events} = router;

      let onChangeComplete = _url => {
        setSidebarOpen(_ => false);
      };

      events->on(`routeChangeComplete(onChangeComplete));
      events->on(`hashChangeComplete(onChangeComplete));

      Some(
        () => {
          events->off(`routeChangeComplete(onChangeComplete));
          events->off(`hashChangeComplete(onChangeComplete));
        },
      );
    },
    [||],
  );

  let preludeSection =
    <div
      className="flex justify-between text-primary font-medium items-baseline">
      title->s
      {switch (version) {
       | Some(version) =>
         switch (availableVersions) {
         | Some(availableVersions) =>
           let onChange = evt => {
             open Url;
             ReactEvent.Form.preventDefault(evt);
             let version = evt->ReactEvent.Form.target##value;
             let url = Url.parse(route);

             let targetUrl =
               "/"
               ++ Js.Array2.joinWith(url.base, "/")
               ++ "/"
               ++ version
               ++ "/"
               ++ Js.Array2.joinWith(url.pagepath, "/");
             router->Next.Router.push(targetUrl);
           };
           <VersionSelect
             latestVersionLabel
             onChange
             version
             availableVersions
           />;
         | None => <span className="font-mono text-sm"> version->s </span>
         }
       | None => React.null
       }}
    </div>;

  let sidebar =
    <Sidebar
      isOpen=isSidebarOpen
      toggle=toggleSidebar
      preludeSection
      title
      ?activeToc
      categories
      route
    />;

  let metaTitle = title ++ " | ReScript Documentation";

  let metaElement =
    switch (frontmatter) {
    | Some(frontmatter) =>
      switch (DocFrontmatter.decode(frontmatter)) {
      | Ok(fm) =>
        let canonical = Js.Null.toOption(fm.canonical);
        let description = Js.Null.toOption(fm.description);
        let title = fm.title ++ " | ReScript Language Manual";
        <Meta title ?description ?canonical />;
      | Error(_) => React.null
      }
    | None => React.null
    };

  <SidebarLayout
    metaTitle
    theme
    components
    sidebarState=(isSidebarOpen, setSidebarOpen)
    sidebar
    ?breadcrumbs>
    metaElement
    children
  </SidebarLayout>;
};
