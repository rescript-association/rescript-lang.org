type t
@module("unified") external make: unit => t = "unified"

@send external use: (t, 'a) => t = "use"

type vfile = {value: string}
@send external process: (t, string) => promise<vfile> = "process"

type parse
@module("remark-parse") external remarkParse: parse = "default"

@module("rehype-stringify") external rehypeStringify: parse = "default"
@module("remark-rehype") external remarkRehype: parse = "default"
