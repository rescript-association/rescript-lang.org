let langShortname = (lang: string) =>
  switch lang {
  | "ocaml" => "ml"
  | "reasonml"
  | "reason" => "re"
  | "bash" => "sh"
  | "text" => ""
  | rest => rest
  }

module LzString = {
  @bs.module("lz-string")
  external compressToEncodedURIComponent: string => string = "compressToEncodedURIComponent"
}

module CopyButton = {
  let copyToClipboard: string => bool = %raw(j`
  function(str) {
    try {
      const el = document.createElement('textarea');
      el.value = str;
      el.setAttribute('readonly', '');
      el.style.position = 'absolute';
      el.style.left = '-9999px';
      document.body.appendChild(el);
      const selected =
        document.getSelection().rangeCount > 0 ? document.getSelection().getRangeAt(0) : false;
        el.select();
        document.execCommand('copy');
        document.body.removeChild(el);
        if (selected) {
          document.getSelection().removeAllRanges();
          document.getSelection().addRange(selected);
        }
        return true;
      } catch(e) {
        return false;
      }
    }
    `)

  type state =
    | Init
    | Copied
    | Failed

  @react.component
  let make = (~code) => {
    let (state, setState) = React.useState(_ => Init)

    let onClick = evt => {
      ReactEvent.Mouse.preventDefault(evt)
      if copyToClipboard(code) {
        setState(_ => Copied)
      } else {
        setState(_ => Failed)
      }
    }

    React.useEffect1(() => {
      switch state {
      | Copied =>
        let timeoutId = Js.Global.setTimeout(() => {
          setState(_ => Init)
        }, 2000)

        Some(
          () => {
            Js.Global.clearTimeout(timeoutId)
          },
        )
      | _ => None
      }
    }, [state])

    let activeClass = switch state {
    | Copied => "opacity-100"
    | _ => "opacity-0 hidden"
    }

    let banner =
      <div
        className={"absolute top-0 -mt-1 -mr-1 px-2 rounded right-0 bg-turtle text-gray-80-tr transition-all duration-500 ease-in-out " ++
        activeClass}>
        {React.string("Copied!")}
      </div>

    <button disabled={state === Copied} className="relative" onClick>
      banner <Icon.Copy className="text-gray-20 mt-px hover:cursor-pointer hover:text-gray-80" />
    </button>
  }
}

@react.component
let make = (~highlightedLines=[], ~code: string, ~showLabel=true, ~lang="text") => {
  let children = HighlightJs.renderHLJS(~highlightedLines, ~code, ~lang, ())

  let label = if showLabel {
    let label = langShortname(lang)
    <div className="absolute right-0 px-4 pb-4 bg-gray-5 font-sans text-12 font-bold text-gray-60 ">
      {//RES or JS Label
      Js.String2.toUpperCase(label)->React.string}
    </div>
  } else {
    React.null
  }

  <div //normal code-text without tabs
    className="relative w-full flex-col rounded-none xs:rounded-lg border-t border-b xs:border border-gray-10 bg-gray-5 py-2 text-gray-80">
    label <div className="px-5 text-14 pt-4 pb-2 overflow-x-auto -mt-2"> children </div>
  </div>
}

module Toggle = {
  type tab = {
    highlightedLines: option<array<int>>,
    label: option<string>,
    lang: option<string>,
    code: string,
  }

  @react.component
  let make = (~tabs: array<tab>) => {
    let (selected, setSelected) = React.useState(_ => 0)

    switch tabs {
    | [tab] =>
      make({
        "highlightedLines": tab.highlightedLines,
        "code": tab.code,
        "lang": tab.lang,
        "showLabel": Some(true),
      })
    | multiple =>
      let numberOfItems = Js.Array.length(multiple)
      let tabElements = Belt.Array.mapWithIndex(multiple, (i, tab) => {
        // if there's no label, infer the label from the language
        let label = switch tab.label {
        | Some(label) => label
        | None =>
          switch tab.lang {
          | Some(lang) => langShortname(lang)->Js.String2.toUpperCase
          | None => Belt.Int.toString(i)
          }
        }

        let activeClass = if selected === i {
          "font-medium text-gray-90 bg-gray-5 border-t-2 first:border-l"
        } else {
          "font-medium hover:text-gray-60 border-t-2 bg-gray-10 hover:cursor-pointer"
        }

        let onClick = evt => {
          ReactEvent.Mouse.preventDefault(evt)
          setSelected(_ => i)
        }
        let key = label ++ ("-" ++ Belt.Int.toString(i))

        let paddingX = switch numberOfItems {
        | 1
        | 2 => "sm:px-4"
        | 3 => "lg:px-8"
        | _ => ""
        }

        let borderColor = if selected === i {
          "#f4646a #EDF0F2"
        } else {
          "transparent"
        }

        <span
          key
          style={ReactDOM.Style.make(~borderColor, ())}
          className={paddingX ++
          (" flex-none px-4 inline-block p-1 first:rounded-tl " ++
          activeClass)}
          onClick>
          {React.string(label)}
        </span>
      })

      let children =
        Belt.Array.get(multiple, selected)
        ->Belt.Option.map(tab => {
          let lang = Belt.Option.getWithDefault(tab.lang, "text")
          HighlightJs.renderHLJS(~highlightedLines=?tab.highlightedLines, ~code=tab.code, ~lang, ())
        })
        ->Belt.Option.getWithDefault(React.null)

      let buttonDiv = switch Js.Array2.find(multiple, tab => {
        switch tab.lang {
        | Some("res") | Some("rescript") => true
        | _ => false
        }
      }) {
      | Some({code: ""}) => React.null
      | Some(tab) =>
        let playgroundLinkButton =
          <Next.Link href={`/try?code=${LzString.compressToEncodedURIComponent(tab.code)}}`}>
            <a target="_blank">
              <Icon.ExternalLink className="text-gray-20 hover:cursor-pointer hover:text-gray-80" />
            </a>
          </Next.Link>

        let copyButton = <CopyButton code={tab.code} />

        <div className="flex items-center justify-end h-full pr-4 space-x-3">
          playgroundLinkButton copyButton
        </div>
      | None => React.null
      }

      <div className="relative pt-6 w-full rounded-none text-gray-80">
        //text within code-box
        <div
          className="absolute flex w-full overflow-auto scrolling-touch font-sans bg-transparent text-14 text-gray-40 "
          style={ReactDOM.Style.make(~marginTop="-30px", ())}>
          <div className="flex ml-2 xs:ml-0"> {React.array(tabElements)} </div>
          <div className="flex-1 w-full bg-gray-10 border-b rounded-tr border-gray-10 items-center">
            buttonDiv
          </div>
        </div>
        <div
          className="px-4 lg:px-5 text-14 pb-4 pt-4 overflow-x-auto bg-gray-5 border-gray-10 xs:rounded-b-lg border">
          <pre> children </pre>
        </div>
      </div>
    }
  }
}
