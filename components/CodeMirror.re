open Util.ReactStuff;

type props = CodeMirrorBase.Props.t;

let dynamicComponent: React.component(props) =
  Next.Dynamic.(
    dynamic(
      () => {import("../common/CodeMirrorBase.bs")},
      options(
        ~ssr=false,
        ~loading=
          () => {
            <div
              className="bg-onyx text-snow-darker p-4"
              style={ReactDOMRe.Style.make(~minHeight="40vh", ())}>
              "/* Loading.... */"->s
            </div>
          },
        (),
      ),
    )
  );

[@react.component]
let make =
    (
      ~style=?,
      ~minHeight=?,
      ~className=?,
      ~mode,
      ~readOnly=false,
      ~value: string,
      ~errors=?,
      ~onChange=?,
    ) => {
  let options =
    CodeMirrorBase.CM.Options.t(
      ~theme="material",
      ~mode,
      ~readOnly,
      ~lineNumbers=true,
      (),
    );

  let props =
    CodeMirrorBase.Props.t(
      ~className?,
      ~minHeight?,
      ~style?,
      ~value,
      ~errors?,
      ~onChange?,
      ~options,
      (),
    );

  React.createElement(dynamicComponent, props);
};
