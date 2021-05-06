(** Provides functions for encoding a JSON data structure *)

type 'a encoder = 'a -> Js.Json.t
(** The type of a encoder combinator *)

external null : Js.Json.t = "null" [@@bs.val]
(** [null] is the singleton null JSON value *)

external string : string -> Js.Json.t = "%identity"
(** [string s] makes a JSON string of the [string] [s] *)

external float : float -> Js.Json.t = "%identity"
(** [float n] makes a JSON number of the [float] [n] *)

external int : int -> Js.Json.t = "%identity"
(** [int n] makes a JSON number of the [int] [n] *)

external bool : bool -> Js.Json.t = "%identity"
(** [bool b] makes a JSON boolean of the [bool] [b] *)

val char : char -> Js.Json.t
(** [char c] makes a JSON string of the [char] [c] *)

val date : Js.Date.t -> Js.Json.t
(** [date d] makes an ISO 8601 JSON string of the [Js.Date.t] [d] *)

val nullable : 'a encoder -> 'a option -> Js.Json.t
(** [nullable encoder option] returns either the encoded value or [null] *)

val withDefault : Js.Json.t -> 'a encoder -> 'a option -> Js.Json.t
(** [withDefault default encoder option] returns the encoded value if present, oterwise [default] *)

val pair : 'a encoder -> 'b encoder -> ('a * 'b) -> Js.Json.t
(** [pair encoder encoder tuple] creates a JSON array from a tuple of size 2 *)

val tuple2 : 'a encoder -> 'b encoder -> ('a * 'b) -> Js.Json.t
(** [tuple2 encoder encoder tuple] creates a JSON array from a tuple of size 2. Alias of [pair] *)

val tuple3 : 'a encoder -> 'b encoder -> 'c encoder -> ('a * 'b * 'c) -> Js.Json.t
(** [tuple3 enc enc enc tuple] creates a JSON array from a tuple of size 3 *)

val tuple4 : 'a encoder -> 'b encoder -> 'c encoder -> 'd encoder -> ('a * 'b * 'c * 'd) -> Js.Json.t
(** [tuple4 enc enc enc enc tuple] creates a JSON array from a tuple of size 4 *)

external jsonDict : Js.Json.t Js_dict.t -> Js.Json.t = "%identity"
(** [jsonDict d] makes a JSON object of the [Js.Dict.t] [d] *)

val dict : 'a encoder -> 'a Js_dict.t encoder
(** [dict encoder d] makes a JSON object of the [Js.Dict.t] [d] with the given [encoder] *)

val object_ : (string * Js.Json.t) list -> Js.Json.t
(** [object_ props] makes a JSON object of the [props] list of properties *)

val array : 'a encoder -> 'a array encoder
(** [array encoder l] makes a JSON array of the [list] [l] using the given [encoder]
 *  NOTE: This will be renamed `array` once the existing and deprecated `array` function
 *  has been removed.
 *)

val list : 'a encoder -> 'a list encoder
(** [list encoder a] makes a JSON array of the [array] [a] using the given [encoder] *)

(** The functions below are specialized for specific array type which
    happened to be already JSON object in the BuckleScript runtime. Therefore
    they are more efficient (constant time rather than linear conversion). *)

external jsonArray : Js.Json.t array -> Js.Json.t = "%identity"
(** [jsonArray a] makes a JSON array of the [Js.Json.t array] [a] *)

external stringArray : string array -> Js.Json.t = "%identity"
(** [stringArray a] makes a JSON array of the [string array] [a] *)

external numberArray : float array -> Js.Json.t = "%identity"
(** [numberArray a] makes a JSON array of the [float array] [a] *)

external boolArray : bool array -> Js.Json.t = "%identity"
(** [boolArray] makes a JSON array of the [bool array] [a] *)
