open Util.ReactStuff;

module Link = Next.Link;

module Data = {
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
    "require.context('./belt_docs', true, /^\.\/.*\.mdx$/)"
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
};

[@react.component]
let default = () => {
  <BeltDocsLayout>
    <div>
      <ul>
        {Data.getAllBeltModules()
         ->Belt.Array.map(m =>
             <li key={m.id} className="font-bold lg:font-normal">
               <Link href={"/belt_docs/" ++ m.id}>
               <a> m.id->s </a> </Link>
             </li>
           )
         ->ate}
      </ul>
    </div>
  </BeltDocsLayout>;
};
