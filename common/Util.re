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
  let toMonthStr = (date: Js.Date.t) =>
    Js.Date.getUTCMonth(date)
    ->Belt.Float.toInt
    ->(
        fun
        | 0 => "January"
        | 1 => "February"
        | 2 => "March"
        | 3 => "April"
        | 4 => "May"
        | 5 => "June"
        | 6 => "July"
        | 7 => "August"
        | 8 => "September"
        | 9 => "October"
        | 10 => "November"
        | 11 => "December"
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
};
