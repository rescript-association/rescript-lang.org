module ReactStuff = {
  let s = ReasonReact.string;
  let ate = ReasonReact.array;

  module Unsafe = {
    external elementAsString: React.element => string = "%identity";
  };
  module Style = ReactDOMRe.Style;
};

module String = {
  let camelCase: string => string = [%raw
    str => "{
     return str.replace(/-([a-z])/g, function (g) { return g[1].toUpperCase(); });
    }"
  ];

  let capitalize: string => string = [%raw
    str => "{
      return str && str.charAt(0).toUpperCase() + str.substring(1);
    }"
  ];
};

module Url = {
  let isAbsolute: string => bool = [%raw
    {|
    function(str) {
      var r = new RegExp('^(?:[a-z]+:)?//', 'i');
      if (r.test(str))
      {
        return true
      }
      return false;
    }
  |}
  ];
};

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
    IntlDateTimeFormat.(
      Date.(
        make(
          ~locale=`US,
          ~options=
            options(
              ~month=Month.make(`short),
              ~day=Day.make(`numeric),
              ~year=Year.make(`numeric),
              (),
            ),
          date,
        )
      )
    );
  };
};
