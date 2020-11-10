// This file was automatically converted to ReScript from 'Util.re'
// Check the output and make sure to delete the original file
module Debounce = {
  // See: https://davidwalsh.name/javascript-debounce-function
  let debounce = (~wait, fn) => {
    let timeout = ref(None)

    () => {
      let unset = () => timeout := None

      switch timeout.contents {
      | Some(id) => Js.Global.clearTimeout(id)
      | None => fn()
      }
      timeout := Some(Js.Global.setTimeout(unset, wait))
    }
  }

  let debounce3 = (~wait, ~immediate=false, fn) => {
    let timeout = ref(None)

    (a1, a2, a3) => {
      let unset = () => {
        timeout := None
        immediate ? fn(a1, a2, a3) : ()
      }

      switch timeout.contents {
      | Some(id) => Js.Global.clearTimeout(id)
      | None => fn(a1, a2, a3)
      }
      timeout := Some(Js.Global.setTimeout(unset, wait))

      if immediate && timeout.contents === None {
        fn(a1, a2, a3)
      } else {
        ()
      }
    }
  }
}
module ReactStuff = {
  let s = ReasonReact.string
  let ate = ReasonReact.array

  module Unsafe = {
    external elementAsString: React.element => string = "%identity"
  }
  module Style = ReactDOMRe.Style

  @bs.module("react")
  external lazy_: (unit => Js.Promise.t<'a>) => 'a = "lazy"

  module Suspense = {
    @bs.module("react") @react.component
    external make: (~children: React.element) => React.element = "Suspense"
  }
}

module String = {
  let camelCase: string => string = %raw(
    "str => {
     return str.replace(/-([a-z])/g, function (g) { return g[1].toUpperCase(); });
    }"
  )

  let capitalize: string => string = %raw(
    "str => {
      return str && str.charAt(0).toUpperCase() + str.substring(1);
    }"
  )
}

module Json = {
  @bs.val @bs.scope("JSON")
  external prettyStringify: (Js.Json.t, @bs.as(json`null`) _, @bs.as(4) _) => string = "stringify"
}

module Url = {
  let isAbsolute: string => bool = %raw(
    `
    function(str) {
      var r = new RegExp('^(?:[a-z]+:)?//', 'i');
      if (r.test(str))
      {
        return true
      }
      return false;
    }
  ` //', 'i');
  )
}

module Date = {
  /*
   let toMonthStr = (date: Js.Date.t) =>
     Js.Date.getUTCMonth(date)
     ->Belt.Float.toInt
     ->(
         fun
         | 0 => "Jan"
         | 1 => "Feb"
         | 2 => "Mar"
         | 3 => "Apr"
         | 4 => "May"
         | 5 => "Jun"
         | 6 => "Jul"
         | 7 => "Aug"
         | 8 => "Sep"
         | 9 => "Oct"
         | 10 => "Nov"
         | 11 => "Dec"
         | _ => "???"
       );

   // Pads a number smaller 10 with "0"
   let pad = (n: int) =>
     if (n < 10) {
       "0" ++ Js.Int.toString(n);
     } else {
       Js.Int.toString(n);
     };

   let toDayMonthYear = (date: Js.Date.t) => {
     let month = toMonthStr(date);
     let day = Js.Date.getDate(date)->int_of_float->pad;
     let year = Js.Date.getFullYear(date)->int_of_float;

     {j|$month $day, $year|j};
   };
 */
  let toDayMonthYear = (date: Js.Date.t) => {
    open IntlDateTimeFormat
    open Date
    make(
      ~locale=#US,
      ~options=options(
        ~month=Month.make(#short),
        ~day=Day.make(#numeric),
        ~year=Year.make(#numeric),
        (),
      ),
      date,
    )
  }
}
