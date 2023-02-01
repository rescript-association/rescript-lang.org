// This file was automatically converted to ReScript from 'Markdown.re'
// Check the output and make sure to delete the original file

module P = {
  @react.component
  let make = (~children) =>
    <p className="md-p md:leading-5 tracking-[-0.015em] text-gray-80 md:text-16"> children </p>
}

// Used for hero like introduction text in
// e.g Doc sections
module Intro = {
  @react.component
  let make = (~children) => <div className="text-24 mt-8 mb-4"> children </div>
}

module Cite = {
  @react.component
  let make = (~author: option<string>, ~children) =>
    // For semantics, check out
    // https://css-tricks.com/quoting-in-html-quotations-citations-and-blockquotes/
    <div
      className="my-10 border-l-2 border-fire font-normal pl-10 py-1 text-fire"
      style={ReactDOM.Style.make(~maxWidth="30rem", ())}>
      <blockquote className="text-32 italic mb-2"> children </blockquote>
      {Belt.Option.mapWithDefault(author, React.null, author =>
        <figcaption className="font-semibold text-14"> {React.string(author)} </figcaption>
      )}
    </div>
}

module Info = {
  @react.component
  let make = (~children) =>
    <div className="infobox my-5 py-6 pl-8 pr-10 rounded-lg bg-sky-5"> children </div>
}

module Warn = {
  @react.component
  let make = (~children) =>
    <div className="my-6 py-6 pl-8 pr-10 rounded-lg bg-orange-10"> children </div>
}

module UrlBox = {
  open! Mdx.MdxChildren

  let imgEl = <img src="/static/hyperlink.svg" className="mr-2 inline-block" />

  @react.component
  let make = (~text: string, ~href: string, ~children: Mdx.MdxChildren.t) => {
    let content = switch classify(children) {
    | String(str) =>
      <p>
        imgEl
        {React.string(str)}
      </p>
    | Element(el) =>
      let subChildren = el->getMdxChildren
      <p>
        imgEl
        {subChildren->toReactElement}
      </p>
    | Array(arr) =>
      // Scenario: Take the first element, rewrap its children with the hyperlink img
      let length = Belt.Array.length(arr)
      if length >= 1 {
        let head = Belt.Array.getExn(arr, 0)
        let headChildren = head->getMdxChildren

        <>
          <P>
            imgEl
            {headChildren->toReactElement}
          </P>
          {if length > 1 {
            arr->Js.Array2.slice(~start=1, ~end_=length)->Mdx.arrToReactElement
          } else {
            React.null
          }}
        </>
      } else {
        React.null
      }
    | Unknown(el) =>
      Js.log2("Received unknown", el)
      React.null
    }

    // Next.Link doesn't allow any absolute URLs, so we need to render
    // a plain <a> component when there is an absolute href
    let link = if Util.Url.isAbsolute(href) {
      <a href rel="noopener noreferrer" className="flex items-center">
        {React.string(text)}
        <Icon.ArrowRight className="ml-1" />
      </a>
    } else {
      <Next.Link href>
        <a className="flex items-center">
          {React.string(text)}
          <Icon.ArrowRight className="ml-1" />
        </a>
      </Next.Link>
    }
    <div className="md-url-box text-16 border-l-2 border-gray-60 my-6 py-6 pl-8 pr-10 bg-gray-5">
      content
      <div className="mt-4 text-sky hover:text-sky-30"> link </div>
    </div>
  }
}

// Used for creating invisible, hoverable <a> anchors for url linking
module Anchor = {
  // Todo: Headers with nested components don't pass a string, we need to flatten
  // everything to a single string first before we are able to use this id transformation
  // function

  @react.component
  let make = (~id: string) => {
    let style = ReactDOM.Style.make(~position="absolute", ~top="-7rem", ())
    <span className="inline group relative">
      <a
        className="invisible text-gray-60 opacity-50 text-inherit hover:opacity-100 hover:text-gray-60 hover:cursor-pointer group-hover:visible"
        href={"#" ++ id}>
        <Icon.Hyperlink className="inline-block align-middle text-gray-40" />
      </a>
      <a style id />
    </span>
  }
}
//*--- HEADLINES ---*//

module H1 = {
  @react.component
  let make = (~children) => <h1 className="hl-1 mb-6 "> children </h1>
}

module H2 = {
  @react.component
  let make = (~id, ~children) => <>
    // Here we know that children is always a string (## headline)
    <h2 className="group mt-16 mb-3 hl-3">
      children
      <span className="ml-2">
        <Anchor id />
      </span>
    </h2>
  </>
}

module H3 = {
  @react.component
  let make = (~id, ~children) =>
    <h3 className="group mt-8 mb-4 hl-4">
      children
      <span className="ml-2">
        <Anchor id />
      </span>
    </h3>
}

module H4 = {
  @react.component
  let make = (~id, ~children) =>
    <h4 className="group mt-8 hl-5">
      children
      <span className="ml-2">
        <Anchor id />
      </span>
    </h4>
}

module H5 = {
  @react.component
  let make = (~id, ~children) =>
    <h5
      className="group mt-12 mb-3 text-12 leading-2 font-sans font-semibold uppercase tracking-wide text-gray-80">
      children
      <span className="ml-2">
        <Anchor id />
      </span>
    </h5>
}

module Pre = {
  @react.component
  let make = (~children) => <pre className="mt-2 mb-4 -mx-6 xs:mx-0 block"> children </pre>
}

module InlineCode = {
  @react.component
  let make = (~children) =>
    <code
      className="md-inline-code px-2 py-0.5  text-gray-60 font-mono rounded-sm bg-gray-10-tr border border-gray-90 border-opacity-5">
      children
    </code>
}

module Table = {
  @react.component
  let make = (~children) =>
    <div className="overflow-x-auto mt-10 mb-16">
      <table className="md-table"> children </table>
    </div>
}

module Thead = {
  @react.component
  let make = (~children) => <thead> children </thead>
}

module Th = {
  @react.component
  let make = (~children) =>
    <th
      className="py-2 pr-8 text-12 text-gray-60 uppercase font-medium tracking-wide text-left border-b-2 border-gray-20">
      children
    </th>
}

module Td = {
  @react.component
  let make = (~children) => <td className="border-b border-gray-20 py-3 pr-8"> children </td>
}

module Code = {
  @module("../ffi/parse-numeric-range.js")
  external parseNumericRange: string => array<int> = "parsePart"

  // TODO: Might be refactorable with the new @unboxed feature
  type unknown = Mdx.Components.unknown

  let isArray: unknown => bool = %raw("thing => { return thing instanceof Array; }")
  let isObject: unknown => bool = %raw("thing => { return thing instanceof Object; }")
  external asStringArray: unknown => array<string> = "%identity"
  external asElement: unknown => React.element = "%identity"

  external unknownAsString: unknown => string = "%identity"

  let parseNumericRangeMeta = (metastring: string) =>
    Js.String2.split(metastring, " ")
    ->Js.Array2.find(s => Js.String2.startsWith(s, "{") && Js.String2.endsWith(s, "}"))
    ->Belt.Option.map(str => {
      let nums = Js.String2.replaceByRe(str, %re("/[\{\}]/g"), "")->parseNumericRange
      nums
    })
    ->Belt.Option.getWithDefault([])

  let makeCodeElement = (~code, ~metastring, ~lang) => {
    let baseClass = "md-code font-mono w-full block mt-5 mb-5"
    let codeElement = switch metastring {
    | None => <CodeExample code lang />
    | Some(metastring) =>
      let metaSplits = Js.String2.split(metastring, " ")->Belt.List.fromArray

      let highlightedLines = parseNumericRangeMeta(metastring)

      if Belt.List.has(metaSplits, "example", \"=") {
        <CodeExample code lang />
      } else if Belt.List.has(metaSplits, "sig", \"=") {
        <CodeExample code lang showLabel=false />
      } else {
        <CodeExample highlightedLines code lang />
      }
    }

    <div className=baseClass> codeElement </div>
  }

  @react.component
  let make = (~className: option<string>=?, ~metastring: option<string>, ~children: unknown) => {
    let lang = switch className {
    | None => "text"
    | Some(str) =>
      switch Js.String2.split(str, "-") {
      | ["language", ""] => "text"
      | ["language", lang] => lang
      | _ => "text"
      }
    }

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
      Children is already a string, we don't need to anything special
 */
    if isArray(children) {
      // Scenario 1
      let code = children->asStringArray->Js.Array2.joinWith("")
      <InlineCode> {React.string(code)} </InlineCode>
    } else if isObject(children) {
      // Scenario 2
      children->asElement
    } else {
      // Scenario 3
      let code = unknownAsString(children)
      makeCodeElement(~code, ~metastring, ~lang)
    }
  }
}

module CodeTab = {
  let getMdxMetastring: Mdx.mdxComponent => option<string> = %raw("element => {
      if(element == null || element.props == null) {
        return;
      }
      return element.props.metastring;
    }")
  @react.component
  let make = (~children: Mdx.MdxChildren.t, ~labels: array<string>=[]) => {
    let mdxElements = switch Mdx.MdxChildren.classify(children) {
    | Array(mdxElements) => mdxElements
    | Element(el) => [el]
    | _ => []
    }

    let tabs = Belt.Array.reduceWithIndex(mdxElements, [], (acc, mdxElement, i) => {
      let child = mdxElement->Mdx.MdxChildren.getMdxChildren->Mdx.MdxChildren.classify

      switch child {
      | Element(codeEl) =>
        switch codeEl->Mdx.getMdxType {
        | "code" =>
          let className = Mdx.getMdxClassName(codeEl)->Belt.Option.getWithDefault("")

          let metastring = getMdxMetastring(codeEl)->Belt.Option.getWithDefault("")

          let lang = switch Js.String2.split(className, "-") {
          | ["language", lang] => Some(lang)
          | _ => None
          }

          let code = Js.String2.make(Mdx.MdxChildren.getMdxChildren(codeEl))
          let label = Belt.Array.get(labels, i)
          let tab = {
            CodeExample.Toggle.lang,
            code,
            label,
            highlightedLines: Some(Code.parseNumericRangeMeta(metastring)),
          }
          Js.Array2.push(acc, tab)->ignore

        | _ => ()
        }
      | _ => ()
      }
      acc
    })

    <div className="md-codetab mt-8 mb-8 -mx-6 xs:mx-0">
      <CodeExample.Toggle tabs />
    </div>
  }
}

module Blockquote = {
  @react.component
  let make = (~children) =>
    <blockquote className="md-blockquote">
      <Info> children </Info>
    </blockquote>
}

module Hr = {
  @react.component
  let make = () => <hr className="my-4" />
}

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
  @react.component
  let make = (~href, ~target=?, ~children) =>
    // In case we are handling a relative URL, we will use the Next routing
    if Util.Url.isAbsolute(href) {
      <a href rel="noopener noreferrer" className="no-underline text-fire hover:underline" ?target>
        children
      </a>
    } else {
      // We drop any .md / .mdx / .html extensions on every href...
      // Ideally one would check if this link is relative first,
      // but it's very unlikely we'd refer to an absolute URL ending
      // with .md
      let regex = %re("/\.md(x)?|\.html$/")
      let href = switch Js.String2.split(href, "#") {
      | [pathname, anchor] => Js.String2.replaceByRe(pathname, regex, "") ++ ("#" ++ anchor)
      | [pathname] => Js.String2.replaceByRe(pathname, regex, "")
      | _ => href
      }
      <Next.Link href>
        <a
          href rel="noopener noreferrer" className="no-underline text-fire hover:underline" ?target>
          children
        </a>
      </Next.Link>
    }
}

module Ul = {
  @react.component
  let make = (~children) => <ul className="md-ul mt-12 mb-16"> children </ul>
}

module Ol = {
  @react.component
  let make = (~children) => <ol className="md-ol ml-2"> children </ol>
}

module Li = {
  let typeOf: 'a => string = %raw("thing => { return typeof thing; }")
  let isArray: 'a => bool = %raw("thing => { return thing instanceof Array; }")
  external asArray: 'a => array<React.element> = "%identity"

  @react.component
  let make = (~children) => {
    /*
     There are 3 value scenarios for `children`

     1) string (if bullet point is standalone text)
     2) array(<p>, <ul>|<ol>) (if nested list)
     3) array(<p>,<inlineCode>,...,<p>) (if text with nested content)
     4) array(<strong>, <inlineCode>, string,...) (if nested content without wrapping <p>)

     We are iterating on these here with quite some bailout JS
 */

    let elements: React.element = if isArray(children) {
      let arr = children->asArray
      let last: React.element = {
        open Belt.Array
        arr->getExn(arr->length - 1)
      }

      let head = Js.Array2.slice(arr, ~start=0, ~end_=arr->Belt.Array.length - 1)

      let first = Belt.Array.getExn(head, 0)

      switch {
        open Mdx
        last->fromReactElement->getMdxType
      } {
      | "ul"
      | "li"
      | "pre" =>
        switch {
          open Mdx
          first->fromReactElement->getMdxType
        } {
        | "p" =>
          <>
            {React.array(head)}
            last
          </>
        | _ =>
          <>
            <p> {React.array(head)} </p>
            last
          </>
        }
      | _ => <p> children </p>
      /* Scenario 3 */
      }
    } else if typeOf(children) === "string" {
      <p> {children->Util.Unsafe.elementAsString->React.string} </p>
    } else {
      switch {
        /* Unknown Scenario */
        open Mdx
        children->fromReactElement->getMdxType
      } {
      | "pre" => children
      | "p" => children
      | _ => <p> children </p>
      }
    }

    <li className="md-li mt-3 leading-4 ml-2"> elements </li>
  }
}

module Strong = {
  @react.component
  let make = (~children) => <strong className="font-semibold"> children </strong>
}

// Useful for debugging injected values in props
//  let mdxTestComponent: React.component<{.}> = %raw(`
//  function(children) {
//    console.log(children);
//    return React.createElement("div");
//  }
// `)

// Used for the MdxJS Provider

/* Sets our preferred branded styles
   We most likely will never need a different ~components
   option on our website. */
let default = Mdx.Components.t(
  ~cite=Cite.make,
  ~info=Info.make,
  ~intro=Intro.make,
  ~warn=Warn.make,
  ~urlBox=UrlBox.make,
  ~codeTab=CodeTab.make,
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
  ~hr=Hr.make,
  ~strong=Strong.make,
  ~a=A.make,
  ~pre=Pre.make,
  ~blockquote=Blockquote.make,
  ~inlineCode=InlineCode.make,
  ~code=Code.make,
  (),
)
