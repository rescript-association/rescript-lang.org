type intl

/* Supported locales */
type locale = [#CH | #RUS | #SWE | #US]
type abs_locale

let localeToJs: locale => abs_locale
let localeFromJs: abs_locale => locale

module Date: {
  module Weekday: {
    type t = [#long | #short | #narrow]
    type abs_t

    let tToJs: t => abs_t
    let tFromJs: abs_t => t

    let make: t => abs_t
  }

  module Era: {
    type t = [#long | #short | #narrow]
    type abs_t

    let tToJs: t => abs_t
    let tFromJs: abs_t => t

    let make: t => abs_t
  }

  module Year: {
    type t = [#numeric | #twoDigit]
    type abs_t

    let tToJs: t => abs_t
    let tFromJs: abs_t => t

    let make: t => abs_t
  }

  module Day: {
    type t = [#numeric | #twoDigit]
    type abs_t

    let tToJs: t => abs_t
    let tFromJs: abs_t => t

    let make: t => abs_t
  }

  module Month: {
    /* Helper for month option */
    type t = [#long | #short | #narrow | #numeric | #twoDigit]
    type abs_t

    let tToJs: t => abs_t
    let tFromJs: abs_t => t

    let make: t => abs_t
  }

  type options
  let options: (
    ~weekday: Weekday.abs_t=?,
    ~era: Era.abs_t=?,
    ~year: Year.abs_t=?,
    ~day: Day.abs_t=?,
    ~month: Month.abs_t=?,
    unit,
  ) => options

  let dateTimeFormat: (abs_locale, option<options>) => intl

  /* Intl.DateTimeFormat.prototype.format() */
  let format: (intl, Js.Date.t) => string

  let make: (~locale: locale=?, ~options: options=?, Js.Date.t) => string
}
