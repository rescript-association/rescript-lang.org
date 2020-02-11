open Util.ReactStuff;

module Link = {
  let inline = "no-underline border-b border-night-dark hover:border-bs-purple text-inherit";
  let standalone = "no-underline text-fire";
};

module Anchor = {
  [@react.component]
  let make = (~name: string) => {
    let style = ReactDOMRe.Style.make(~position="absolute", ~top="-7rem", ());
    <span style={ReactDOMRe.Style.make(~position="relative", ())}>
      <a style name />
    </span>;
  };
};

module H1 = {
  [@react.component]
  let make = (~children) => {
    <h1
      className="text-6xl md:text-7xl tracking-tight leading-1 font-sans font-black text-night-dark">
      children
    </h1>;
  };
};

module H2 = {
  [@react.component]
  let make = (~children) => {
    <h2 className="text-4xl leading-3 font-sans font-medium text-night-dark">
      children
    </h2>;
  };
};

module H3 = {
  [@react.component]
  let make = (~children) => {
    <h3 className="text-xl leading-3 font-sans font-bold text-night-darker">
      children
    </h3>;
  };
};

module H4 = {
  [@react.component]
  let make = (~children) => {
    <h4 className="text-lg leading-2 font-sans font-semibold text-night-dark">
      children
    </h4>;
  };
};

module H5 = {
  [@react.component]
  let make = (~children) => {
    <h5
      className="text-xs leading-2 font-sans font-semibold uppercase tracking-wide">
      children
    </h5>;
  };
};

/**
  ~ This is a quite tricky component ~

  You need to understand what HTML structure MDX exposes for Markdown.
  MDX uses Remark to parse Markdown, so be aware that it will put
  sublists of lists in an extra paragraph.

  Markdown is a lot about structured text, that means we need quite
  some cascading to render specific CSS values, like list numbers.
  Refer to the `styles/_styles.css` for custom CSS stuff.

  I tried to inline as much styling as possible in the
  component, to stay true to the Tailwind spirit.
  Everything else cascading-wise can be found as custom
  CSS.
 */
module Md = {
  module Pre = {
    [@react.component]
    let make = (~children) => {
      <pre className="my-8 p-4 block"> children </pre>;
    };
  };

  module InlineCode = {
    [@react.component]
    let make = (~children) => {
      <code className="px-1 rounded-sm text-base font-mono bg-snow">
        children
      </code>;
    };
  };

  module Table = {
    [@react.component]
    let make = (~children) => {
      <div className="overflow-x-auto mt-10 mb-16">
        <table className="md-table">
          children
        </table>
      </div>;
    };
  };

  module Thead = {
    [@react.component]
    let make = (~children) => {
      <thead> children </thead>;
    };
  };

  module Th = {
    [@react.component]
    let make = (~children) => {
      <th className="py-2 pr-8 text-sm uppercase font-medium tracking-wide text-left border-b-2 border-snow-darker">
        children
      </th>;
    };
  };

  module Td = {
    [@react.component]
    let make = (~children) => {
      <td className="border-b border-snow-darker py-3 pr-8"> children </td>;
    };
  };

  module Code = {
    type unknown;
    let typeOf: unknown => string = [%raw thing => "{ return typeof thing; }"];
    let isArray: unknown => bool = [%raw
      thing => "{ return thing instanceof Array; }"
    ];
    let isObject: unknown => bool = [%raw
      thing => "{ return thing instanceof Object; }"
    ];
    let isString: unknown => bool = [%raw
      thing => "{ return thing instanceof String; }"
    ];
    external asStringArray: 'a => array(string) = "%identity";
    external asElement: 'a => React.element = "%identity";

    external unknownAsString: unknown => string = "%identity";

    let makeCodeElement = (~code, ~metastring, ~lang) => {
      let baseClass = "md-code font-mono block leading-tight";
      let codeElement =
        switch (metastring) {
        | None => <CodeExample code lang />
        | Some(metastring) =>
          let metaSplits =
            Js.String.split(" ", metastring)->Belt.List.fromArray;

          if (Belt.List.has(metaSplits, "example", (==))) {
            <CodeExample code lang />;
          } else if (Belt.List.has(metaSplits, "sig", (==))) {
            <CodeSignature code lang />;
          } else {
            <CodeExample code lang />;
          };
        };

      <div className=baseClass> codeElement </div>;
    };

    [@react.component]
    let make =
        (
          ~className: option(string)=?,
          ~metastring: option(string),
          ~children: unknown,
        ) => {
      let lang =
        switch (className) {
        | None => "re"
        | Some(str) =>
          switch (Js.String.split("-", str)) {
          | [|"language", ""|] => "none"
          | [|"language", lang|] => lang
          | _ => "none"
          }
        };

      /*
        Converts the given children provided by remark, depending on
        given scenarios.

        Scenario 1 (children = array(string):
        Someone is using a literal <code> tag with some source in it
        e.g. <code> hello world </code>

        Then remark would call this component with children = [ "hello", "world" ].
        In this case we need to open the Array,

        Scenario 2 (children = React element / object):
        Children is an element, so we will need to render the given
        React element without adding our own components.

        Scenario 3 (children = string):
        Children is already a string, we will go straight to the
       */
      if (isArray(children)) {
        // Scenario 1
        let code = children->asStringArray->Js.Array2.joinWith("");
        <InlineCode> code->s </InlineCode>;
      } else if (isObject(children)) {
        // Scenario 2
        children->asElement;
      } else {
        // Scenario 3
        let code = unknownAsString(children);
        makeCodeElement(~code, ~metastring, ~lang);
      };
    };
  };

  module P = {
    [@react.component]
    let make = (~children) => {
      <p className="text-lg leading-4 my-6 text-inherit"> children </p>;
    };
  };

  /*
      This will map either to an external link, or
      an anchor / reference link.

      TODO: Remark / Markdown actually has its own syntax
            for references: e.g. [my article][1]
            but it seems MDX doesn't map this to anything
            specific (It seems as if it was represented as a text
            node inside a <p> tag).

            Example for the AST:
            https://astexplorer.net/#/gist/2befce6edce1475eb4bbec001356b222/cede33d4c7545b8b2d759ded256802036ec3551c

            Possible solution could be to write our own plugin to categorize those
            specific component.
   */
  module A = {
    /* Used to sync the Project_Details.ReferenceTable */
    let refPrefix = "ref-";

    /* Used to refer back to the text node */
    let textRefPrefix = "ref-text-";

    [@react.component]
    let make = (~href, ~children) => {
      let num = Js.Float.fromString(href);

      if (Js.Float.isNaN(num)) {
        <a href rel="noopener noreferrer" className=Link.inline> children </a>;
      } else {
        let id = int_of_float(num) |> string_of_int;
        <>
          <Anchor name={textRefPrefix ++ id} />
          <a
            href={"#" ++ refPrefix ++ id}
            className="no-underline text-inherit">
            <span className="hover:border-b border-fire"> children </span>
            <sup
              style={ReactDOMRe.Style.make(
                ~left="0.05rem",
                ~top="-0.5rem",
                (),
              )}
              className="font-sans border-b-0 font-bold text-fire text-xs">
              id->s
            </sup>
          </a>
        </>;
      };
    };
  };

  module Ul = {
    [@react.component]
    let make = (~children) => {
      <ul className="md-ul my-4"> children </ul>;
    };
  };

  module Ol = {
    [@react.component]
    let make = (~children) => {
      <ol className="md-ol -ml-4"> children </ol>;
    };
  };

  module Li = {
    let typeOf: 'a => string = [%raw thing => "{ return typeof thing; }"];
    let isArray: 'a => bool = [%raw
      thing => "{ return thing instanceof Array; }"
    ];
    external asArray: 'a => array(ReasonReact.reactElement) = "%identity";
    let isSublist: 'a => bool = [%raw
      element => "{
        if(element == null || element.props == null) {
          return false;
        }
        const name = element.props.name;
        return name === 'ul' || name === 'ol';
      }"
    ];

    [@react.component]
    let make = (~children) => {
      /*
       There are 3 value scenarios for `children`

       1) string (if bullet point is standalone text)
       2) array(<p>, <ul>|<ol>) (if nested list)
       3) array(<p>,<inlineCode>,...,<p>) (if text with nested content)

       We are iterating on these here with quite some bailout JS
       */
      let elements: ReasonReact.reactElement =
        if (isArray(children)) {
          switch (children->asArray) {
          | [|_p, potentialSublist|] =>
            if (isSublist(potentialSublist)) {
              /* Scenario 2 */
              children;
            } else {
              <p>
                 children </p>;
                /* Scenario 3 */
            }
          | _ =>
            /* Scenario 3 */
            <p> children </p>
          };
        } else if (typeOf(children) === "string") {
          <p>
             {Unsafe.elementAsString(children)->ReasonReact.string} </p>;
            /* Scenario 1 */
        } else {
          children;
          /* Unknown Scenario */
        };

      <li className="md-li mt-4 leading-4 ml-4 text-lg"> elements </li>;
    };
  };
};

module Introduction = {
  [@genType]
  [@react.component]
  let make = (~children) => {
    <span className="text-xl block"> children </span>;
  };
};
