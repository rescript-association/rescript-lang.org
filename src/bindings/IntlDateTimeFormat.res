type intl

/* Supported locales */
@bs.deriving({jsConverter: newType})
type locale = [@bs.as("zh") #CH | @bs.as("ru-RU") #RUS | @bs.as("sv-SE") #SWE | @bs.as("en-US") #US]

module Date = {
  module Weekday = {
    @bs.deriving({jsConverter: newType})
    type t = [#long | #short | #narrow]

    let make = value => tToJs(value)
  }

  module Era = {
    @bs.deriving({jsConverter: newType})
    type t = [#long | #short | #narrow]

    let make = value => tToJs(value)
  }

  module Year = {
    @bs.deriving({jsConverter: newType})
    type t = [#numeric | @bs.as("2-digit") #twoDigit]

    let make = value => tToJs(value)
  }

  module Day = {
    @bs.deriving({jsConverter: newType})
    type t = [#numeric | @bs.as("2-digit") #twoDigit]

    let make = value => tToJs(value)
  }

  module Month = {
    /* Helper for month option */
    @bs.deriving({jsConverter: newType})
    type t = [#long | #short | #narrow | #numeric | @bs.as("2-digit") #twoDigit]

    let make = value => tToJs(value)
  }

  /* Options for Intl.DateTimeFormat */
  @bs.deriving(abstract)
  type options = {
    @bs.optional
    weekday: Weekday.abs_t,
    @bs.optional
    era: Era.abs_t,
    @bs.optional
    year: Year.abs_t,
    @bs.optional
    day: Day.abs_t,
    @bs.optional
    month: Month.abs_t,
  }

  /*
    Intl.DateTimeFormat
    https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/DateTimeFormat
 */
  @bs.new @bs.scope("Intl")
  external dateTimeFormat: (abs_locale, option<options>) => intl = "DateTimeFormat"

  /* Intl.DateTimeFormat.prototype.format() */
  @bs.send external format: (intl, Js.Date.t) => string = "format"

  let make = (~locale=#US, ~options=?, date) =>
    dateTimeFormat(localeToJs(locale), options)->format(date)
}
