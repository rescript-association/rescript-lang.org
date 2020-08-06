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
      ~maxHeight=?,
      ~className=?,
      ~mode,
      ~readOnly=false,
      ~lineWrapping=false,
      ~value: string,
      ~errors=?,
      ~onMarkerFocus=?,
      ~onMarkerFocusLeave=?,
      ~onChange=?,
    ) => {
  let options =
    CodeMirrorBase.CM.Options.t(
      ~theme="material",
      ~mode,
      ~readOnly,
      ~lineNumbers=true,
      ~lineWrapping,
      (),
    );

  let props =
    CodeMirrorBase.Props.t(
      ~className?,
      ~minHeight?,
      ~maxHeight?,
      ~style?,
      ~value,
      ~errors?,
      ~onChange?,
      ~onMarkerFocus?,
      ~onMarkerFocusLeave?,
      ~options,
      (),
    );

  React.createElement(dynamicComponent, props);
};
