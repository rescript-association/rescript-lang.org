module Ast = {
  type t

  @tag("type")
  type lval = Identifier({name: string})

  @tag("type")
  type objectProperties = ObjectProperty({key: lval, value: lval})

  @tag("type")
  type expression = ObjectExpression({properties: array<objectProperties>})

  type variableDeclarator = {
    @as("type") type_: string,
    id: lval,
    init?: Null.t<expression>,
  }
  @tag("type")
  type node = VariableDeclaration({kind: string, declarations: array<variableDeclarator>})
  type nodePath = {node: node}
}

module Parser = {
  type options = {sourceType?: string}
  @module("@babel/parser") external parse: (string, options) => Ast.t = "parse"
}

module Traverse = {
  @module("@babel/traverse") external traverse: (Ast.t, {..}) => unit = "default"
}

module Generator = {
  @send external remove: Ast.nodePath => unit = "remove"

  type t = {code: string}
  @module("@babel/generator") external generator: Ast.t => t = "default"
}

module PlaygroundValidator = {
  type validator = {
    entryPointExists: bool,
    code: string,
  }

  let validate = ast => {
    let entryPoint = ref(false)

    let remove = nodePath => Generator.remove(nodePath)
    Traverse.traverse(
      ast,
      {
        "ImportDeclaration": remove,
        "ExportNamedDeclaration": remove,
        "VariableDeclaration": (nodePath: Ast.nodePath) => {
          switch nodePath.node {
          | VariableDeclaration({declarations}) if Array.length(declarations) > 0 =>
            let firstDeclaration = Array.getUnsafe(declarations, 0)

            switch (firstDeclaration.id, firstDeclaration.init) {
            | (Identifier({name}), Some(init)) if name === "App" =>
              switch init->Null.toOption {
              | Some(ObjectExpression({
                  properties: [
                    ObjectProperty({
                      key: Identifier({name: "make"}),
                      value: Identifier({name: "Playground$App"}),
                    }),
                  ],
                })) =>
                entryPoint.contents = true
              | _ => ()
              }
            | _ => ()
            }
          | _ => ()
          }
        },
      },
    )

    {entryPointExists: entryPoint.contents, code: Generator.generator(ast).code}
  }
}
