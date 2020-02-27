open Util.ReactStuff;
module Link = Next.Link;

module FrontMatter = {
  type t = {
    author: string,
    date: Js.Date.t,
  };

  let validate = (json: Js.Json.t): result(t, string) => {
    Js.Json.(
      switch (json->Js.Json.classify) {
      | JSONObject(obj) =>
        let authorJson =
          Js.Dict.get(obj, "author")
          ->Belt.Option.mapWithDefault(None, json => Some(classify(json)));
        let dateJson =
          Js.Dict.get(obj, "date")
          ->Belt.Option.mapWithDefault(None, json => Some(classify(json)));
        switch (authorJson, dateJson) {
        | (Some(JSONString(author)), Some(JSONString(dateStr))) =>
          Ok({author, date: Js.Date.fromString(dateStr)})
        | (Some(JSONString(_)), _) => Error("json.date not a string")
        | (_, Some(JSONString(_))) => Error("json.author not a string")
        | _ => Error("json.author / json.date not a string")
        };

      | _ => Error("Given json is not an object")
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
