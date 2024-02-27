import * as acorn from "acorn";
import { walk } from "estree-walker";
import * as escodegen from "escodegen";

export function hasEntryPoint(ast) {
  let existsApp = false;

  walk(ast, {
    enter(node) {
      const isAppVar = node?.type === "VariableDeclaration" && 
        node?.declarations[0]?.type === "VariableDeclarator" &&
        node?.declarations[0]?.id.name === "App" &&
        node?.declarations[0]?.id.type === "Identifier";

      if (isAppVar) {
        const isObject = node?.declarations[0].init.type === "ObjectExpression"
        if (isObject) {
          const hasMake = [...node?.declarations[0].init.properties].some(
            p => p?.type === "Property" && p?.key?.type === "Identifier" && p?.key?.name === "make"
          )
          existsApp = hasMake
        }
      }
    }
  })

  return existsApp
}

export function parse(code) {
  return acorn.parse(code, {
      ecmaVersion: 9,
      sourceType: "module"
  });
}

export function removeImportsAndExports(ast) {
  walk(ast, {
    enter(node) {
      const isImport =
        node?.type === "ImportDeclaration" ||
        (node?.type === "VariableDeclaration" &&
          node?.declarations[0]?.init?.type === "CallExpression" &&
          node?.declarations[0]?.init?.callee?.name === "require");
      const isExport =
        node?.type === "ExportDefaultDeclaration" ||
        node?.type === "ExportNamedDeclaration" ||
        node?.type === "ExportAllDeclaration" ||
        (node?.type === "ExpressionStatement" &&
          node?.expression?.type === "AssignmentExpression" &&
          node?.expression?.operator === "=" &&
          (node?.expression?.left?.object?.name === "exports" ||
            (node?.expression?.left?.object?.name === "module" &&
              node?.expression?.left?.property?.name === "exports")));
      if (isImport || isExport) {
        this.remove();
      }
    },
  });

  return escodegen.generate(ast);
}
