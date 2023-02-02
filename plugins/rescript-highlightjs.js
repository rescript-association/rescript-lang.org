/*
Language: ReScript
Author: Gidi Meir Morris <oss@gidi.io>, Cheng Lou, Patrick Ecker
Category: common
*/

// Note: Extracted and adapted from the reason-highlightjs package:
// https://github.com/reasonml-editor/reason-highlightjs
module.exports = function(hljs) {
  function orReValues(ops){
    return ops
    .map(function(op) {
      return op
        .split('')
        .map(function(char) {
          return '\\' + char;
        })
        .join('');
    })
    .join('|');
  }

  var RE_IDENT = '[a-z_][0-9a-zA-Z_]*';
  var RE_ATTRIBUTE = '[A-Za-z_][A-Za-z0-9_\\.]*';
  var RE_MODULE_IDENT = '[A-Z_][0-9a-zA-Z_]*';

  var KEYWORDS = {
    // See: https://github.com/rescript-lang/syntax/blob/4872b983eb023f78a972063eb367339e6897bf16/src/res_token.ml#L166
    keyword:
      'and as assert catch constraint downto else exception export external false for ' +
      'if import in include lazy let module mutable of open private rec switch ' +
      'to true try type when while with async await',
    // not reliable
     //built_in:
       //'array bool bytes char exn|5 float int int32 int64 list lazy_t|5 nativeint|5 ref string unit',
    literal:
      'true false'
  };

  const STRING_MODE = {
    className: 'string',
    variants: [
      {
        begin: '"',
        end: '"',
        contains: [hljs.BACKSLASH_ESCAPE],
      },
      // {foo|bla|foo}
      {
        begin: '\\{(' + RE_IDENT + ')?\\|',
        end: '\\|(' + RE_IDENT + ')?\\}',
      },
      {
        begin: '(' + RE_IDENT + ')?`',
        end: '`',
      },
    ]
  };

  const FUNCTION_MODE = {
    className: 'function',
    begin: '=>',
  };

  const CHARACTER_MODE = {
    className: 'character',
    begin: '\'[\\x00-\\x7F]\'',
    relevance: 0
  };

  const NUMBER_MODE = {
    className: 'number',
    relevance: 0,
    begin: '\\b(0[xX][a-fA-F0-9_]+[Lln]?|' +
      '0[oO][0-7_]+[Lln]?|' +
      '0[bB][01_]+[Lln]?|' +
      '[0-9][0-9_]*([Lln]|(\\.[0-9_]+)?([eE][-+]?[0-9_]+)?)?)\\b'
  };

  const OPERATOR_MODE = {
    className: 'operator',
    relevance: 0,
    begin: "("+ orReValues([
      '->', '||', '&&', '++', '**', '+.', '+', '-.', '-',
      '*.', '*', '/.', '/', '...', '..', '|>', '===', '==', '^',
      ':=', '!', '>=', '<=',
    ]) + ")"
  };

  const ASSIGNMENT_MODE = {
    className: 'operator',
    begin: '='
  };

  // as in variant constructor
  const CONSTRUCTOR_MODE = {
    className: 'constructor',
    begin: '\\b([A-Z][0-9a-zA-Z_]*)|(`[a-zA-Z][0-9a-zA-Z_]*)|(#[a-zA-Z][0-9a-zA-Z_]*)\\b',
  };

  const ARRAY_MODES = {
    className: 'literal',
    variants: [
      {
        begin: '\\[\\|',
      },
      {
        begin: '\\|\\]',
      },
    ]
  };

  const LIST_MODES = {
    className: 'literal',
    variants: [
      {
        begin: 'list\\{',
      },
      {
        begin: '\\{',
      },
      {
        begin: '\\}',
      },
    ]
  };

  const OBJECT_ACCESS_MODE = {
    className: 'object-access',
    variants: [
      {
        begin: RE_IDENT + '\\[',
        end: '\\]',
        contains: [
          // hljs.BACKSLASH_ESCAPE
          STRING_MODE
        ],
      },
    ]
  };

  const MODULE_ACCESS_MODE = {
    begin: "\\b" + RE_MODULE_IDENT + "\\.",
    returnBegin: true,
    contains: [
      {
        begin: RE_MODULE_IDENT,
        className: 'module-identifier',
      },
    ]
  };

  const JSX_MODE = {
    variants: [
      {
        begin: "<>|</>|/>",
      },
      {
        begin: "</",
        contains: [
          {
            begin: RE_IDENT,
          },
          {
            begin: RE_MODULE_IDENT,
            className: 'module-identifier',
          },
        ]
      },
      {
        begin: "<",
        contains: [
          {
            begin: RE_MODULE_IDENT,
            className: 'module-identifier',
          },
        ]
      },
    ]
  };

  // Foo.Bar.Baz where Baz is actually a module, not a constructor
  const MODULE_ACCESS_ENDS_WITH_MODULE = {
    begin: RE_MODULE_IDENT,
    returnBegin: true,
    contains: [
      {
        begin: RE_MODULE_IDENT,
        className: "module-identifier",
      },
      {
        begin: "\\.",
        contains: [
          {
            begin: RE_MODULE_IDENT,
            className: "module-identifier",
          }
        ]
      },
    ]
  };

  const ATTRIBUTE_MODE = {
    className: 'attribute',
    variants: [
      // order matters here
      {
        begin: "@@?(" + RE_ATTRIBUTE + ') *\\(',
        end: '\\s*\\)',
      },
      {
        begin: "@@?(" + RE_ATTRIBUTE + ')',
      },
      {
        begin: "%%?(" + RE_ATTRIBUTE + ')\\(',
        end: '\\s*\\)',
      },
      {
        begin: "%%?(" + RE_ATTRIBUTE + ')',
      },
      {
        begin: "\\[@",
        end: "\\s*\\]",
        contains: [
          {
            begin: RE_ATTRIBUTE + "\\s*",
          },
        ],
      },
      {
        begin: "\\[%",
        end: "\\s*\\]",
        contains: [
          {
            begin: RE_ATTRIBUTE + "\\s*",
          },
        ],
      },
      {
        begin: "\\[%%",
        end: "\\s*\\]",
        contains: [
          {
            begin: RE_ATTRIBUTE + "\\s*",
          },
        ],
      },
      {
        begin: "\\[%%%",
        end: "\\s*\\]",
        contains: [
          {
            begin: RE_ATTRIBUTE + "\\s*",
          },
        ],
      },
    ]
  };

  // all the modes below are mutually recursive
  let OPEN_OR_INCLUDE_MODULE_MODE = {
    begin: "\\b(open|include)\\s*",
    keywords: KEYWORDS,
    contains: [
      MODULE_ACCESS_ENDS_WITH_MODULE,
    ]
  };
  let MODULE_MODE = {
    begin: "\\s*\\{\\s*",
    end: "\\s*\\}\\s*",
    keywords: KEYWORDS,
    // most of the order here is important
    contains: [
      hljs.C_LINE_COMMENT_MODE,
      hljs.C_BLOCK_COMMENT_MODE,
      // there's also a block mode technically, but for our purpose, a module {}
      // and a block {} can be considered the same for highlighting
      CHARACTER_MODE,
      STRING_MODE,
      FUNCTION_MODE,
      ATTRIBUTE_MODE,
      ARRAY_MODES,
      LIST_MODES,
      JSX_MODE,
      OPERATOR_MODE,
      ASSIGNMENT_MODE,
      NUMBER_MODE,
      OPEN_OR_INCLUDE_MODULE_MODE,
      MODULE_ACCESS_MODE,
      CONSTRUCTOR_MODE,
      OBJECT_ACCESS_MODE,
    ]
  };
  const MODULE_DECLARATION_MODE = {
    begin: "\\bmodule\\s+(type\\s+)?(of\\s+)?",
    keywords: KEYWORDS,
    contains: [
      // this definitely gets matched, and first. always `module Foo`
      {
        begin: RE_MODULE_IDENT,
        className: "module-identifier",
      },
      // and then an optional type signature is matched. Hopefully this regex
      // doesn't accidentally match something else
      {
        begin: "\\s*:\\s*",
        contains: [
          {
            begin: RE_MODULE_IDENT,
            className: "module-identifier",
          },
          MODULE_MODE
        ],
      },
      // then the = part and the right hand side
      {
        begin: "\\s*=\\s*",
        contains: [
          MODULE_ACCESS_ENDS_WITH_MODULE,
          // alternatively, a functor declaration
          {
            begin: "\\s*\\(\\s*",
            end: "\\s*\\)\\s*",
            keywords: KEYWORDS,
            contains: [
              {
                begin: RE_MODULE_IDENT,
                className: "module-identifier",
              },
              // module Foo = (Bar: Baz) => ...
              {
                begin: "\\s*:\\s*",
                contains: [
                  {
                    begin: RE_MODULE_IDENT,
                    className: "module-identifier",
                  },
                  MODULE_MODE,
                  {
                    begin: "\\s*,\\s*",
                  }
                ]
              },
              MODULE_MODE,
            ]
          },
          MODULE_MODE,
          {
            begin: "\\s*=>\\s*"
          }
        ]
      },
    ]
  };
  MODULE_MODE.contains.unshift(MODULE_DECLARATION_MODE);
  OPEN_OR_INCLUDE_MODULE_MODE.contains.push(MODULE_MODE)

  return {
    aliases: ['res', 'resi'],
    keywords: KEYWORDS,
    illegal: '(:\\-|:=|\\${|\\+=)',
    // lol beautiful
    contains: MODULE_MODE.contains,
  };
}
