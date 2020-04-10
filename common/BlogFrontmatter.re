// Note: Every optional value in here must be encoded
// as Js.Null.t, since it will be used for JSON serialization
// within Next's static generation

module Author = {
  type social =
    | Twitter
    | Github;

  type t = {
    username: string,
    social: Js.Null.t(social),
  };

  let socialUrl = social =>
    switch (social) {
    | Twitter => "https://twitter.com"
    | Github => "https://github.com"
    };

  // Example formats:
  // twitter.com/ryyppy
  // github.com/ryyppy
  // ryyppy
  let parse = (str: string): result(t, string) => {
    switch (Js.String2.split(str, "/")) {
    | [|"twitter.com", username|] =>
      Ok({username, social: Js.Null.return(Twitter)})
    | [|"github.com", username|] =>
      Ok({username, social: Js.Null.return(Github)})
    | [|socialUrl, _username|] => Error("Unknown url: " ++ socialUrl)
    | [|username|] =>
      if (String.length(username) === 0) {
        Error("username should not be empty");
      } else {
        Ok({username, social: Js.null});
      }
    | _ => Error("unknown username format: " ++ str)
    };
  };
};

module Category = {
  type t =
    | NewsAndUpdates
    | Community;
};

type t = {
  author: Author.t,
  date: DateStr.t,
  previewImg: Js.null(string),
  title: string,
  category: Category.t,
  description: Js.null(string),
};

let decodeAuthor = (str: string): Author.t => {
  switch (Author.parse(str)) {
  | Ok(author) => author
  | Error(msg) => raise(Json.Decode.DecodeError(msg))
  };
};

let decodeCategory = (str: string): Category.t => {
  switch (Js.String2.toLowerCase(str)) {
  | "updates"
  | "news" => NewsAndUpdates
  | "community" => Community
  | str => raise(Json.Decode.DecodeError({j|Unknown category "$str"|j}))
  };
};

let decode = (json: Js.Json.t): result(t, string) => {
  Json.Decode.(
    switch (
      {
        author: json->field("author", string, _)->decodeAuthor,
        date:
          json
          ->field("date", string, _)
          ->Js.Date.fromString
          ->DateStr.fromDate,
        category: json->field("category", string, _)->decodeCategory,
        previewImg: json->nullable(field("previewImg", string), _),
        title: json->field("title", string, _),
        description: json->nullable(field("description", string), _),
      }
    ) {
    | fm => Ok(fm)
    | exception (DecodeError(str)) => Error(str)
    }
  );
};
