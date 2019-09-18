type rawModule;
type parsedMdxModule = {
  id: string, /* Id, which is also part of the Url */
  filepath: string,
};

[@bs.deriving abstract]
type webpackCtx = {keys: unit => array(string)};

let getMdxModule: (webpackCtx, string) => rawModule = [%raw
  (ctx, filepath) => "{ return ctx(filepath); }"
];

let beltCtx: webpackCtx = [%raw
  "require.context('../pages/belt_docs', true, /^\.\/.*\.mdx$/)"
];

let toMdxModules = (ctx: webpackCtx): array(parsedMdxModule) =>
  ctx
  ->keysGet()
  ->Belt.Array.map(filepath => {
      let id =
        switch (Js.String.match([%re "/\\.\\/(.*)\\.mdx/"], filepath)) {
        | Some([|_, id|]) => id
        | _ => filepath
        };

      let correctedFilepath =
        Js.String.replaceByRe([%re "/^\\.\\//"], "./pages/belt/", filepath);

      /*let m = ctx->getMdxModule(filepath);*/

      {id, filepath: correctedFilepath};
    });

let getAllBeltModules = () => {
  beltCtx->toMdxModules;
};
