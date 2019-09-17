import React from "react";
import Highlight, { defaultProps } from "prism-react-renderer";

export const jsExample = `
const a = "test";

function foo(a){
  console.log("hello world: " + a);
}

foo(a)
}
`;

export const reasonExample = `let foo = 1;

let add = (a, b) => a + b;

let add1 = add(foo);`;

export default ({code, language}) => {
  return (
    <Highlight {...defaultProps} code={code} language={language}>
      {({ className, style, tokens, getLineProps, getTokenProps }) => (
        <pre className={className + " py-4 px-4"} style={style}>
          {tokens.map((line, i) => (
            <div {...getLineProps({ line, key: i })}>
              {line.map((token, key) => (
                <span {...getTokenProps({ token, key })} />
              ))}
            </div>
          ))}
        </pre>
      )}
    </Highlight>
  );
};
