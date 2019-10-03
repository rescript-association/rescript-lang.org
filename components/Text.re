open Util.ReactStuff;

module Link = {
  let inline = "no-underline border-b hover:text-main-lighten-20 hover:border-primary-dark-10 border-primary-lighten-50 text-inherit";
  let standalone = "no-underline text-primary";
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

module Box = {
  [@react.component]
  let make = (~children) => {
    <div className="mt-12"> children </div>;
  };
};

module H1 = {
  [@react.component]
  let make = (~children) => {
    <h1
      className="text-5xl lg:text-6xl leading-3 lg:leading-2 font-montserrat font-medium lg:font-bold text-main-black">
      children
    </h1>;
  };
};

module H2 = {
  [@react.component]
  let make = (~children) => {
    <h2
      className="text-4xl leading-3 font-montserrat font-medium text-main-black">
      children
    </h2>;
  };
};

module H3 = {
  [@react.component]
  let make = (~children) => {
    <h3
      className="text-xl leading-3 font-montserrat font-semibold text-main-black">
      children
    </h3>;
  };
};

module H4 = {
  [@react.component]
  let make = (~children) => {
    <h4
      className="text-lg leading-2 font-montserrat font-semibold text-main-black">
      children
    </h4>;
  };
};

module H5 = {
  [@react.component]
  let make = (~children) => {
    <h5
      className="text-xs leading-2 font-montserrat font-semibold uppercase tracking-wide text-main-lighten-50">
      children
    </h5>;
  };
};

module Overline = {
  [@react.component]
  let make = (~underline=false, ~children) => {
    let className =
      "font-overpass font-black text-main-black text-xl mt-5"
      ++ (underline ? " pb-3 border-b border-main-lighten-90" : "");

    <div className> children </div>;
  };
};

module P = {
  type spacing = [ | `none | `default];

  [@react.component]
  let make = (~spacing: spacing=`default, ~children) => {
    let spacingClass =
      switch (spacing) {
      | `none => ""
      | `default => "mt-3"
      };
    let className = "text-lg leading-4 text-main-lighten-15 " ++ spacingClass;
    <p className> children </p>;
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
      <pre className="my-8 p-4 block bg-main-lighten-95"> children </pre>;
    };
  };

  module Code = {
    [@react.component]
    let make =
        (
          ~className: option(string)=?,
          ~metastring: option(string),
          ~children,
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
      let langClass = "lang-" ++ lang;
      let base = {
        "className":
          langClass ++ " font-mono block overflow-x-scroll leading-tight hljs",
        "metastring": metastring,
      };

      /* If there is a configured language for HLJS,
         we use the highlight function to highlight the code,
         which in this context is always a string parsed from
         the markdown, otherwise we will just pass children down
         without any modification */
      let codeElement =
        switch (lang) {
        | "re"
        | "reason" =>
          let highlighted =
            HighlightJs.(
              highlight(~lang, ~value=children->Obj.magic)->valueGet
            );
          let finalProps =
            Js.Obj.assign(
              base,
              {
                "dangerouslySetInnerHTML": {
                  "__html": highlighted,
                },
              },
            );
          ReactDOMRe.createElementVariadic(
            "code",
            ~props=ReactDOMRe.objToDOMProps(finalProps),
            [||],
          );
        | _ =>
          ReactDOMRe.createElementVariadic(
            "code",
            ~props=ReactDOMRe.objToDOMProps(base),
            children,
          )
        };

      switch (metastring) {
      | None => codeElement
      | Some(metastring) =>
        let metaSplits =
          Js.String.split(" ", metastring)->Belt.List.fromArray;

        if (Belt.List.has(metaSplits, "example", (==))) {
          <CodeExample> codeElement </CodeExample>;
        } else {
          codeElement;
        };
      };
    };
  };

  module InlineCode = {
    [@react.component]
    let make = (~children) => {
      <code
        className="px-1 rounded-sm text-inherit font-mono bg-sand-lighten-20">
        children
      </code>;
    };
  };
  module P = {
    [@react.component]
    let make = (~children) => {
      <p className="text-lg leading-4 my-6 text-main-lighten-15">
        children
      </p>;
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
            <span
              className="hover:text-main-lighten-20 hover:border-b border-primary">
              children
            </span>
            <sup
              style={ReactDOMRe.Style.make(
                ~left="0.05rem",
                ~top="-0.5rem",
                (),
              )}
              className="font-overpass border-b-0 font-bold text-primary text-xs">
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
      <ol className="md-ol -ml-4 text-primary"> children </ol>;
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
             {Obj.magic(children)->ReasonReact.string} </p>;
            /* Scenario 1 */
        } else {
          <p>
             children </p>;
            /* Unknown Scenario */
        };

      <li className="md-li mt-4 leading-4 ml-8 text-lg text-main-lighten-15">
        elements
      </li>;
    };
  };
};

module Small = {
  [@react.component]
  let make = (~children) => {
    <p className="text-base font-overpass leading-4 text-main-lighten-15">
      children
    </p>;
  };
};

module Xsmall = {
  let component = ReasonReact.statelessComponent("Text.Xsmall");

  [@react.component]
  let make = (~children) => {
    <p
      className="text-sm font-overpass text-normal leading-3 text-main-lighten-15">
      children
    </p>;
  };
};

module Lead = {
  [@react.component]
  let make = (~children) => {
    <p
      className="text-2xl font-montserrat font-medium leading-4 mt-2 text-main-black">
      children
    </p>;
  };
};

module Quote = {
  [@react.component]
  let make = (~bold=true, ~children) => {
    <div className={"flex flex-row mt-5 mb-3 " ++ (bold ? "font-bold" : "")}>
      <div
        className="border-l-2 border-primary w-2 mt-3 mb-3 md:mt-3 md:mb-3"
      />
      <div
        className="text-main-lighten-15 leading-4 text-lg pl-5 md:pl-8 md:text-2xl italic  md:pr-10 md:py-5">
        children
      </div>
    </div>;
  };
};

/* Page for centered, readable text (like /about) */
module Page = {
  [@react.component]
  let make = (~children) => {
    <div className="flex sm:justify-center mb-24">
      <div className="pt-12 px-5 xl:px-0 sm:w-4/5 lg:w-3/5 xl:w-1/2">
        children
      </div>
    </div>;
  };
};
