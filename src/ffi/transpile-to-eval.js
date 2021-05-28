import * as acorn from "acorn";
import { walk } from "estree-walker";
import * as escodegen from "escodegen";

function transpileToEval(code) {
  const ast = acorn.parse(code, {
    ecmaVersion: 9,
  });

  walk(ast, {
    enter(node) {
      const isImport =
        node.type === "ImportDeclaration" ||
        (node.type === "VariableDeclaration" &&
          node.declarations[0].id.name === "React" &&
          node.declarations[0].init.type === "CallExpression" &&
          node.declarations[0].init.callee.name === "require");
      const isExport =
        node.type === "ExportDefaultDeclaration" ||
        node.type === "ExportNamedDeclaration" ||
        node.type === "ExportAllDeclaration" ||
        (node.type === "ExpressionStatement" &&
          node.expression.type === "AssignmentExpression" &&
          node.expression.operator === "=" &&
          (node.expression.left.object.name === "exports" ||
            (node.expression.left.object.name === "module" &&
              node.expression.left.property.name === "exports")));
      if (isImport || isExport) {
        this.remove();
      }
    },
  });

  return escodegen.generate(ast);
}

export default transpileToEval;
