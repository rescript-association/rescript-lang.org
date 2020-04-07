open Util.ReactStuff;
module Link = Next.Link;

/* JSON doesn't support JS.Date, so we need to codify them as strings */
module DateStr: {
  type t;
  let fromDate: Js.Date.t => t;
  let toDate: t => Js.Date.t;
} = {
  type t = string;

  // Used to prevent issues with webkit based date representations
  let parse = (dateStr: string): Js.Date.t => {
    dateStr->Js.String2.replaceByRe([%re "/-/g"], "/")->Js.Date.fromString;
  };

  let fromDate = date => Js.Date.toString(date);
  let toDate = dateStr => {
    parse(dateStr);
  };
};

module FrontMatter = {
  type t = {
    author: string,
    date: DateStr.t,
    imgUrl: Js.null(string),
    description: Js.null(string),
  };

  let decode = (json: Js.Json.t): result(t, string) => {
    Json.Decode.(
      switch (
        {
          author: json->field("author", string, _),
          date:
            json
            ->field("date", string, _)
            ->Js.Date.fromString
            ->DateStr.fromDate,
          imgUrl: json->nullable(field("imgUrl", string), _),
          description: json->nullable(field("description", string), _),
        }
      ) {
      | fm => Ok(fm)
      | exception (DecodeError(str)) => Error(str)
      }
    );
  };
};

[@react.component]
let make = (~author: string, ~date: Js.Date.t, ~children) => {
  <MainLayout>
    <div className="text-night-light text-lg mb-4">
      {Util.Date.toDayMonthYear(date)->s}
    </div>
    children
    <div
      className="border-t border-snow-darker mt-8 pt-24 flex flex-col items-center">
      <div className="text-4xl text-night-dark font-medium">
        "Want to read more?"->s
      </div>
      <Link href="/blog">
        <a className="text-fire hover:text-fire-80">
          "Back to Overview"->s
          <Icon.ArrowRight className="ml-2 inline-block" />
        </a>
      </Link>
    </div>
  </MainLayout>;
};
