open Util.ReactStuff;

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
// Used for creating invisible, hoverable <a> anchors
// for url linking
module Anchor = {
  [@react.component]
  let make = (~id: string) => {
    let style = ReactDOMRe.Style.make(~position="absolute", ~top="-7rem", ());
    <span className="inline group relative">
      <a
        className="invisible text-night-light opacity-50 text-inherit hover:opacity-100 hover:text-night-light hover:cursor-pointer group-hover:visible"
        href={"#" ++ id}>
        {j|#|j}->s
      </a>
      <a style id />
    </span>;
  };
};

module H1 = {
  [@react.component]
  let make = (~children) => {
    <h1
      className="text-6xl leading-1 mb-2 font-sans font-medium text-night-dark">
      children
    </h1>;
  };
};

module H2 = {
  [@react.component]
  let make = (~children) => {
    <>
      // Here we know that children is always a string (## headline)
      <h2
        className="group mt-8 text-3xl leading-1 font-sans font-medium text-night-dark">
        <span className="-ml-8 pr-2">
          <Anchor id={children->Unsafe.elementAsString} />
        </span>
        children
      </h2>
    </>;
  };
};

module H3 = {
  [@react.component]
  let make = (~children) => {
    <h3
      className="group text-xl mt-12 leading-3 font-sans font-medium text-night-darker">
      <span className="-ml-6 pr-2">
        <Anchor id={children->Unsafe.elementAsString} />
      </span>
      children
    </h3>;
  };
};

module H4 = {
  [@react.component]
  let make = (~children) => {
    <h4
      className="group text-lg mt-12 leading-2 font-sans font-semibold text-night-dark">
      <span className="-ml-5 pr-2">
        <Anchor id={children->Unsafe.elementAsString} />
      </span>
      children
    </h4>;
  };
};

module H5 = {
  [@react.component]
  let make = (~children) => {
    <h5
      className="group mt-12 text-xs leading-2 font-sans font-semibold uppercase tracking-wide">
      <span className="-ml-5 pr-2">
        <Anchor id={children->Unsafe.elementAsString} />
      </span>
      children
    </h5>;
  };
};

module Pre = {
  [@react.component]
  let make = (~children) => {
    <pre className="text-inherit mt-3 leading-4 text-night"> children </pre>;
  };
};

module InlineCode = {
  [@react.component]
  let make = (~children) => {
    <code
      className="md-inline-code px-1 text-smaller-1 rounded-sm font-mono bg-snow">
      children
    </code>;
  };
};

module Table = {
  [@react.component]
  let make = (~children) => {
    <div className="overflow-x-auto mt-10 mb-16">
      <table className="md-table"> children </table>
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
    <th
      className="py-2 pr-8 text-sm uppercase font-medium tracking-wide text-left border-b-2 border-snow-darker">
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
  // TODO: Might be refactorable with the new @unboxed feature
  type unknown = Mdx.Components.unknown;

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
    let baseClass = "md-code font-mono block leading-tight mt-4 mb-10";
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
    <p className="mt-3 leading-4"> children </p>;
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
  [@react.component]
  let make = (~href, ~children) => {
    <a href rel="noopener noreferrer" className=Text.Link.inline>
      children
    </a>;
  };
};

module Ul = {
  [@react.component]
  let make = (~children) => {
    <ul className="md-ul mt-4 mb-16"> children </ul>;
  };
};

module Ol = {
  [@react.component]
  let make = (~children) => {
    <ol className="md-ol ml-2 mt-4 mb-16"> children </ol>;
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
        const type = element.props.mdxType;
        return type === 'ul' || type === 'ol';
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
        let arr = children->asArray;
        let last = Belt.Array.(arr->getExn(arr->length - 1));

        if (isSublist(last)) {
          /* Scenario 2 */
          let head =
            Js.Array2.slice(arr, ~start=0, ~end_=arr->Belt.Array.length - 1);
          <> <p> head->ate </p> last </>;
        } else {
          <p>
             children </p>;
            /* Scenario 3 */
        };
      } else if (typeOf(children) === "string") {
        <p>
           {children->Unsafe.elementAsString->ReasonReact.string} </p>;
          /* Scenario 1 */
      } else {
        /* Unknown Scenario */
        switch (Mdx.(children->fromReactElement->getMdxType)) {
        | "p" => children
        | _ => <p> children </p>
        };
      };

    <li className="md-li mt-3 leading-4 ml-4 text-lg"> elements </li>;
  };
};

// Used for the MdxJS Provider

/* Sets our preferred branded styles
   We most likely will never need a different ~components
   option on our website. */
let default =
  Mdx.Components.t(
    ~p=P.make,
    ~li=Li.make,
    ~h1=H1.make,
    ~h2=H2.make,
    ~h3=H3.make,
    ~h4=H4.make,
    ~h5=H5.make,
    ~ul=Ul.make,
    ~ol=Ol.make,
    ~table=Table.make,
    ~thead=Thead.make,
    ~th=Th.make,
    ~td=Td.make,
    ~a=A.make,
    ~pre=Pre.make,
    ~inlineCode=InlineCode.make,
    ~code=Code.make,
    (),
  );
