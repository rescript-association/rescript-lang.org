// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Mdx from "../common/Mdx.mjs";
import * as Icon from "../components/Icon.mjs";
import * as Meta from "../components/Meta.mjs";
import * as Next from "../bindings/Next.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Footer from "../components/Footer.mjs";
import * as Markdown from "../components/Markdown.mjs";
import * as LzString from "lz-string";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Navigation from "../components/Navigation.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as HighlightJs from "../common/HighlightJs.mjs";

function LandingPageLayout$CallToActionButton(Props) {
  var children = Props.children;
  return React.createElement("button", {
              className: "rounded-lg px-8 py-4 inline-block transition-colors duration-300 body-button text-white hover:bg-fire-70  bg-fire  focus:outline-none"
            }, children);
}

function LandingPageLayout$Intro(Props) {
  return React.createElement("div", {
              className: "px-4 md:px-0 flex flex-col items-center"
            }, React.createElement("h1", {
                  className: "hl-title text-center",
                  style: {
                    maxWidth: "53rem"
                  }
                }, "A simple and fast language for JavaScript developers"), React.createElement("h2", {
                  className: "body-lg text-center text-gray-60 my-4",
                  style: {
                    maxWidth: "42rem"
                  }
                }, "ReScript looks like JS, acts like JS, and compiles to the highest quality of clean, readable and performant JS, directly runnable in browsers and Node."), React.createElement("div", {
                  className: "my-4"
                }, React.createElement(LandingPageLayout$CallToActionButton, {
                      children: "Get started"
                    })));
}

var examples = [{
    res: "module Button = {\n  @react.component\n  let make = (~count: int) => {\n    let times = switch count {\n    | 1 => \"once\"\n    | 2 => \"twice\"\n    | n => Belt.Int.toString(n) ++ \" times\"\n    }\n    let msg = \"Click me \" ++ times\n\n    <button> {msg->React.string} </button>\n  }\n}",
    js: "var React = require(\"react\");\n\nfunction Playground$Button(Props) {\n  var count = Props.count;\n  var times = count !== 1 ? (\n      count !== 2 ? String(count) + \" times\" : \"twice\"\n    ) : \"once\";\n  var msg = \"Click me \" + times;\n  return React.createElement(\"button\", undefined, msg);\n}\n\nvar Button = {\n  make: Playground$Button\n};\n\nexports.Button = Button;"
  }];

function LandingPageLayout$PlaygroundHero(Props) {
  var match = React.useState(function () {
        return examples[0];
      });
  var example = match[0];
  return React.createElement("section", {
              className: "relative mt-20 bg-gray-10",
              style: {
                backgroundColor: "#FAFBFC"
              }
            }, React.createElement("div", {
                  className: "relative flex justify-center w-full"
                }, React.createElement("div", {
                      className: "relative sm:rounded-b-xl pt-6 pb-8 sm:px-8 md:px-16 w-full",
                      style: {
                        maxWidth: "1400px"
                      }
                    }, React.createElement("div", {
                          className: "relative z-2 flex flex-col md:flex-row pb-16 bg-gray-90 mx-auto sm:rounded-lg",
                          style: {
                            maxWidth: "1400px"
                          }
                        }, React.createElement("div", {
                              className: "md:w-1/2"
                            }, React.createElement("div", {
                                  className: "text-14 text-gray-40 text-center py-3 bg-gray-100"
                                }, "Written in ReScript"), React.createElement("pre", {
                                  className: "text-14 px-8 pt-6 pb-12 whitespace-pre-wrap"
                                }, HighlightJs.renderHLJS(undefined, true, example.res, "res", undefined))), React.createElement("div", {
                              className: "md:w-1/2"
                            }, React.createElement("div", {
                                  className: "text-14 text-gray-40 py-3 text-center bg-gray-100 sm:rounded-lg"
                                }, "Compiles to JavaScript"), React.createElement("pre", {
                                  className: "text-14 px-8 pt-6 pb-12 whitespace-pre-wrap"
                                }, HighlightJs.renderHLJS(undefined, true, example.js, "js", undefined)))), React.createElement("div", undefined, React.createElement(Next.Link.make, {
                              href: "/try?code=" + LzString.compressToEncodedURIComponent(example.res) + "}",
                              children: React.createElement("a", {
                                    className: "text-12 px-4 md:px-0 underline text-gray-60",
                                    target: "_blank"
                                  }, "Edit this example in Playground")
                            })), React.createElement("div", {
                          className: "hidden md:block"
                        }, React.createElement("img", {
                              className: "absolute z-0 left-0 top-0 -ml-10 -mt-6",
                              style: {
                                height: "24rem",
                                width: "24rem"
                              },
                              src: "/static/lp/grid.svg"
                            }), React.createElement("img", {
                              className: "absolute z-0 left-0 top-0 -ml-10 mt-10",
                              src: "/static/lp/illu_left.png"
                            })), React.createElement("div", {
                          className: "hidden md:block"
                        }, React.createElement("img", {
                              className: "absolute z-0 right-0 bottom-0 -mb-10 mt-24 -mr-10",
                              style: {
                                height: "24rem",
                                width: "24rem"
                              },
                              src: "/static/lp/grid.svg"
                            }), React.createElement("img", {
                              className: "absolute z-3 right-0 bottom-0 -mr-2 mb-10",
                              src: "/static/lp/illu_right.png"
                            })))));
}

var copyToClipboard = (function(str) {
    try {
      const el = document.createElement('textarea');
      el.value = str;
      el.setAttribute('readonly', '');
      el.style.position = 'absolute';
      el.style.left = '-9999px';
      document.body.appendChild(el);
      const selected =
        document.getSelection().rangeCount > 0 ? document.getSelection().getRangeAt(0) : false;
        el.select();
        document.execCommand('copy');
        document.body.removeChild(el);
        if (selected) {
          document.getSelection().removeAllRanges();
          document.getSelection().addRange(selected);
        }
        return true;
      } catch(e) {
        return false;
      }
    });

function LandingPageLayout$QuickInstall$CopyButton(Props) {
  var code = Props.code;
  var match = React.useState(function () {
        return /* Init */0;
      });
  var setState = match[1];
  var state = match[0];
  var buttonRef = React.useRef(null);
  var onClick = function (evt) {
    evt.preventDefault();
    if (copyToClipboard(code)) {
      return Curry._1(setState, (function (param) {
                    return /* Copied */1;
                  }));
    } else {
      return Curry._1(setState, (function (param) {
                    return /* Failed */2;
                  }));
    }
  };
  React.useEffect((function () {
          if (state !== 1) {
            return ;
          }
          var buttonEl = Belt_Option.getExn(Caml_option.nullable_to_opt(buttonRef.current));
          var bannerEl = document.createElement("div");
          bannerEl.className = "foobar opacity-0 absolute top-0 -mt-1 -mr-1 px-2 rounded right-0 bg-turtle text-gray-80-tr transition-all duration-500 ease-in-out ";
          var textNode = document.createTextNode("Copied!");
          bannerEl.appendChild(textNode);
          buttonEl.appendChild(bannerEl);
          var nextFrameId = window.requestAnimationFrame(function (param) {
                bannerEl.classList.toggle("opacity-0");
                bannerEl.classList.toggle("opacity-100");
                
              });
          var timeoutId = setTimeout((function (param) {
                  buttonEl.removeChild(bannerEl);
                  return Curry._1(setState, (function (param) {
                                return /* Init */0;
                              }));
                }), 2000);
          return (function (param) {
                    window.cancelAnimationFrame(nextFrameId);
                    clearTimeout(timeoutId);
                    
                  });
        }), [state]);
  return React.createElement("button", {
              ref: buttonRef,
              className: "relative",
              disabled: state === /* Copied */1,
              onClick: onClick
            }, React.createElement(Icon.Copy.make, {
                  className: "text-gray-40 w-4 h-4 mt-px hover:cursor-pointer hover:text-gray-80"
                }));
}

function copyBox(text) {
  return React.createElement("div", {
              className: "flex justify-between p-4 w-full bg-gray-20 border border-gray-10 rounded",
              style: {
                backgroundColor: "#FAFBFC",
                maxWidth: "22rem"
              }
            }, React.createElement("span", {
                  className: "font-mono text-14 text-gray-80"
                }, text), React.createElement(LandingPageLayout$QuickInstall$CopyButton, {
                  code: text
                }));
}

function LandingPageLayout$QuickInstall$Instructions(Props) {
  return React.createElement("div", {
              className: "w-full"
            }, React.createElement("h2", {
                  className: "font-bold text-24"
                }, "Quick Install"), React.createElement("div", {
                  className: "text-12 pr-10 text-gray-40 my-2 leading-2"
                }, "You can quickly add ReScript to your existing JavaScript codebase via npm / yarn:"), React.createElement("div", {
                  className: "w-full space-y-2"
                }, copyBox("npm install rescript --save-dev"), copyBox("npx rescript init .")));
}

function LandingPageLayout$QuickInstall(Props) {
  return React.createElement("section", {
              className: "my-32 sm:px-4 sm:flex sm:justify-center"
            }, React.createElement("div", {
                  className: "max-w-1280 flex flex-col w-full"
                }, React.createElement("div", {
                      className: "relative px-12"
                    }, React.createElement("div", {
                          style: {
                            maxWidth: "29rem"
                          }
                        }, React.createElement("p", {
                              className: "relative z-1 space-y-12 text-gray-80 font-semibold text-24 md:text-32 leading-2"
                            }, React.createElement("span", {
                                  className: "bg-fire-5 rounded-md border-2 border-fire-10 h-10 w-full"
                                }, "Everything you wan"), "t from JavaScript, minus the parts\n          you don't need."))), React.createElement("div", {
                      className: "w-full pl-12 mt-12 flex flex-col lg:flex-row justify-between"
                    }, React.createElement("p", {
                          className: "relative z-1 text-gray-80 font-semibold text-24 md:text-32 leading-2",
                          style: {
                            maxWidth: "29rem"
                          }
                        }, "ReScript is easy to pick up for JavaScript developers,\n          and helps shipping products with confidence."), React.createElement("div", {
                          className: "mt-16 lg:mt-0 self-end",
                          style: {
                            maxWidth: "25rem"
                          }
                        }, React.createElement(LandingPageLayout$QuickInstall$Instructions, {})))));
}

function LandingPageLayout$MainUSP$Item(Props) {
  var caption = Props.caption;
  var title = Props.title;
  var polygonDirectionOpt = Props.polygonDirection;
  var paragraph = Props.paragraph;
  var polygonDirection = polygonDirectionOpt !== undefined ? polygonDirectionOpt : /* Down */1;
  var polyPointsLg = polygonDirection ? "80,0 85,100 100,100 100,0" : "85,0 80,100 100,100 100,0";
  var polyPointsMobile = polygonDirection ? "0,100 100,100 100,70 0,80" : "0,100 100,100 100,78 0,72";
  var polyColor = polygonDirection ? "text-fire-30" : "text-fire";
  return React.createElement("div", {
              className: "relative flex justify-center w-full bg-gray-90 px-4 sm:px-32 overflow-hidden"
            }, React.createElement("div", {
                  className: "relative max-w-1280 z-3 flex pb-16 pt-20 md:pb-20 md:pt-32 lg:pb-40 md:space-x-4 flex-col lg:flex-row lg:justify-between w-full"
                }, React.createElement("div", {
                      style: {
                        maxWidth: "30rem"
                      }
                    }, React.createElement("div", {
                          className: "hl-overline text-gray-20 mb-4"
                        }, caption), React.createElement("h3", {
                          className: "text-gray-10 mb-4 text-32 font-semibold",
                          style: {
                            maxWidth: "25rem"
                          }
                        }, title), React.createElement("div", {
                          className: "flex"
                        }, React.createElement("div", {
                              className: "text-gray-30 text-16 pr-8"
                            }, paragraph))), React.createElement("div", {
                      className: "relative w-full",
                      style: {
                        maxWidth: "36rem"
                      }
                    }, React.createElement("div", {
                          className: "relative w-full bg-gray-90 rounded-lg flex mt-16 lg:mt-0 items-center justify-center",
                          style: {
                            maxWidth: "35rem",
                            minHeight: "20rem",
                            borderRadius: "8px",
                            boxShadow: "-11px 3px 30px -5px rgba(244,100,106,0.15)"
                          }
                        }, "video of a fast build"), React.createElement("img", {
                          className: "absolute z-1 bottom-0 right-0 -mb-12 -mr-12",
                          style: {
                            maxWidth: "20rem"
                          },
                          src: "/static/lp/grid2.svg"
                        }))), React.createElement("svg", {
                  className: "md:hidden absolute z-1 w-full h-full bottom-0 left-0 " + polyColor,
                  preserveAspectRatio: "none",
                  viewBox: "0 0 100 100"
                }, React.createElement("polygon", {
                      className: "fill-current",
                      points: polyPointsMobile
                    })), React.createElement("svg", {
                  className: "hidden md:block absolute z-1 w-full h-full right-0 top-0 " + polyColor,
                  preserveAspectRatio: "none",
                  viewBox: "0 0 100 100"
                }, React.createElement("polygon", {
                      className: "fill-current",
                      points: polyPointsLg
                    })));
}

var item1 = React.createElement(LandingPageLayout$MainUSP$Item, {
      caption: "Fast and simple",
      title: "The fastest build system on the web",
      paragraph: "ReScript cares about a consistent and fast feedback loop for any\n            codebase size. No need for memory hungry build processes, and no\n            corrupted caches. Switch branches as you please without worrying\n            about stale caches or wrong type information."
    });

var item2 = React.createElement(LandingPageLayout$MainUSP$Item, {
      caption: "A robust type system",
      title: React.createElement("span", {
            className: "text-transparent bg-clip-text bg-gradient-to-r from-berry-dark-50 to-fire-50"
          }, "Type Better"),
      polygonDirection: /* Up */0,
      paragraph: " Every ReScript app is fully typed and provides\n      correct type information to any given value. We prioritize simpler types\n      / discourage complex types for the sake of clarity and easy debugability.\n      No `any`, no magic types, no surprise `undefined`.\n      "
    });

var item3 = React.createElement(LandingPageLayout$MainUSP$Item, {
      caption: "Seamless JS Integration",
      title: React.createElement(React.Fragment, undefined, React.createElement("span", {
                className: "text-orange-dark"
              }, "The familiar JS ecosystem"), " at your fingertips"),
      paragraph: "Use any library from javascript, export rescript\n      libraries to javascript, generate typescript and flow types, etc. It's\n      like you've never left the good parts of javascript at all."
    });

function LandingPageLayout$MainUSP(Props) {
  return React.createElement("section", {
              className: "w-full bg-gray-90 overflow-hidden",
              style: {
                minHeight: "37rem"
              }
            }, item1, item2, item3);
}

function LandingPageLayout$OtherSellingPoints(Props) {
  return React.createElement("section", {
              className: "flex justify-center w-full bg-gray-80 "
            }, React.createElement("div", {
                  className: "max-w-1280 flex flex-col lg:flex-row lg:space-x-8 px-4 lg:px-16 pt-24 pb-20"
                }, React.createElement("div", {
                      className: "pb-24 md:pb-32",
                      style: {
                        maxWidth: "39.125rem"
                      }
                    }, React.createElement("div", {
                          className: "bg-gray-10 w-full rounded-lg",
                          style: {
                            minHeight: "16.8rem"
                          }
                        }), React.createElement("h3", {
                          className: "hl-4 text-gray-20 my-6"
                        }, "A community of programmers who value getting things done"), React.createElement("p", {
                          className: "body-md text-gray-40"
                        }, "No language can be popular without a solid community. A\n        great type system isn't useful if library authors abuse it. Performance\n        doesn't show if all the libraries are slow. Join the ReScript community\n        of programmers who all care about simplicity, speed and practicality.\n        ")), React.createElement("div", {
                      className: "flex lg:flex-col space-x-4 lg:space-x-0 lg:space-y-4"
                    }, React.createElement("div", {
                          style: {
                            maxWidth: "24.875rem"
                          }
                        }, React.createElement("div", {
                              className: "bg-turtle-dark w-full rounded-lg",
                              style: {
                                minHeight: "5.625rem"
                              }
                            }), React.createElement("h3", {
                              className: "hl-4 text-gray-20 my-6"
                            }, "Tooling that finally lets a good language shine"), React.createElement("p", {
                              className: "body-md text-gray-40"
                            }, "Some languages have great features, some other\n            languages have great tooling. ReScript has both.")), React.createElement("div", {
                          style: {
                            maxWidth: "24.875rem"
                          }
                        }, React.createElement("div", {
                              className: "bg-gray-10 w-full rounded-lg",
                              style: {
                                minHeight: "5.625rem"
                              }
                            }), React.createElement("h3", {
                              className: "hl-4 text-gray-20 my-6"
                            }, "The only language you can easily un-adopt"), React.createElement("p", {
                              className: "body-md text-gray-40"
                            }, "ReScript allows you to remove the source files and\n            keep its clean javascript output. Tell your coworkers that your\n            project will keep functioning with or without ReScript!")))));
}

var companies = [
  {
    TAG: 0,
    name: "Facebook Messenger",
    path: "/static/messenger-logo-64@2x.png",
    style: {
      height: "64px"
    },
    [Symbol.for("name")]: "Logo"
  },
  {
    TAG: 1,
    _0: "Facebook",
    [Symbol.for("name")]: "Name"
  },
  {
    TAG: 1,
    _0: "Rohea",
    [Symbol.for("name")]: "Name"
  },
  {
    TAG: 1,
    _0: "Beop",
    [Symbol.for("name")]: "Name"
  },
  {
    TAG: 1,
    _0: "Travel World",
    [Symbol.for("name")]: "Name"
  },
  {
    TAG: 0,
    name: "Pupilfirst",
    path: "/static/pupilfirst-logo.png",
    style: {
      height: "42px"
    },
    [Symbol.for("name")]: "Logo"
  },
  {
    TAG: 1,
    _0: "NomadicLabs",
    [Symbol.for("name")]: "Name"
  }
];

function LandingPageLayout$TrustedBy(Props) {
  return React.createElement("section", {
              className: "mt-20"
            }, React.createElement("h3", {
                  className: "text-48 text-gray-42 tracking-tight leading-2 font-semibold text-center max-w-576 mx-auto"
                }, "Trusted by developers around the world"), React.createElement("div", {
                  className: "flex justify-between items-center max-w-xl mx-auto mt-16"
                }, companies.map(function (company) {
                      var match;
                      if (company.TAG === /* Logo */0) {
                        match = [
                          company.name,
                          React.createElement("img", {
                                className: "max-w-sm",
                                style: company.style,
                                src: company.path
                              })
                        ];
                      } else {
                        var name = company._0;
                        match = [
                          name,
                          name
                        ];
                      }
                      return React.createElement("div", {
                                  key: match[0]
                                }, match[1]);
                    })), React.createElement("div", {
                  className: "text-center mt-16 text-14"
                }, "and many more…"), React.createElement("div", {
                  className: "mt-10 max-w-320 overflow-hidden opacity-50",
                  style: {
                    maxHeight: "6rem"
                  }
                }, React.createElement("img", {
                      className: "w-full h-full",
                      src: "/static/lp/grid.svg"
                    })));
}

var cards = [
  {
    imgSrc: "/static/ic_manual@2x.png",
    title: "Language Manual",
    descr: "Look up the basics: reference for all language features",
    href: "/docs/manual/latest/introduction"
  },
  {
    imgSrc: "/static/ic_rescript_react@2x.png",
    title: "ReScript + React",
    descr: "First Class bindings for ReactJS. Developed for small and big ass scale projects.",
    href: "/docs/react/latest/introduction"
  },
  {
    imgSrc: "/static/ic_manual@2x.png",
    title: "Add ReScript to an existing project",
    descr: "This guide will help you to transfer your project without hassle.",
    href: "/docs/manual/latest/installation#integrate-into-an-existing-js-project"
  },
  {
    imgSrc: "/static/ic_gentype@2x.png",
    title: "TypeScript Integration",
    descr: "Integrate TypeScript and Flow seamlessly and with ease.",
    href: "/docs/gentype/latest/introduction"
  }
];

var templates = [
  {
    imgSrc: "/static/nextjs_starter_logo.svg",
    title: React.createElement(React.Fragment, undefined, React.createElement("div", undefined, "ReScript & "), React.createElement("div", {
              className: "text-gray-40"
            }, "NextJS")),
    descr: "Get started with our our NextJS starter template.",
    href: "https://github.com/ryyppy/rescript-nextjs-template"
  },
  {
    imgSrc: "/static/vitejs_starter_logo.svg",
    title: React.createElement(React.Fragment, undefined, React.createElement("div", undefined, "ReScript & "), React.createElement("div", {
              style: {
                color: "#6571FB"
              }
            }, "ViteJS")),
    descr: "Get started with ViteJS and ReScript.",
    href: "/"
  },
  {
    imgSrc: "/static/nodejs_starter_logo.svg",
    title: React.createElement(React.Fragment, undefined, React.createElement("div", undefined, "ReScript & "), React.createElement("div", {
              className: "text-gray-40",
              style: {
                color: "#699D65"
              }
            }, "NodeJS")),
    descr: "Get started with ReScript targeting the Node platform.",
    href: "/"
  }
];

function LandingPageLayout$CuratedResources(Props) {
  return React.createElement("section", {
              className: "bg-gray-100 w-full pb-40 pt-20"
            }, React.createElement("div", {
                  className: "mb-20 flex flex-col justify-center items-center"
                }, React.createElement("div", {
                      className: "body-sm md:body-lg text-gray-40 w-40 mb-4 xs:w-auto"
                    }, "To start or advance your ReScript projects"), React.createElement("h2", {
                      className: "hl-2 md:hl-1 text-gray-20 max-w-md mx-auto text-center"
                    }, "Carefully curated resources")), React.createElement("div", undefined, React.createElement("div", {
                      className: "uppercase text-14 text-center mb-20"
                    }, "guides and docs"), React.createElement("div", {
                      className: "flex justify-between max-w-1280 mx-auto"
                    }, Belt_Array.mapWithIndex(cards, (function (i, card) {
                            return React.createElement(Next.Link.make, {
                                        href: card.href,
                                        children: React.createElement("a", {
                                              className: "bg-gray-90 px-5 pb-8 relative rounded-xl",
                                              style: {
                                                maxWidth: "296px"
                                              }
                                            }, React.createElement("img", {
                                                  className: "h-12 absolute mt-5",
                                                  src: card.imgSrc
                                                }), React.createElement("h5", {
                                                  className: "text-gray-10 font-semibold mt-32 h-12"
                                                }, card.title), React.createElement("div", {
                                                  className: "text-gray-40 mt-8 text-14"
                                                }, card.descr)),
                                        key: String(i)
                                      });
                          }))), React.createElement("div", {
                      className: "uppercase text-14 text-center mb-20 mt-20"
                    }, "templates"), React.createElement("div", {
                      className: "flex justify-between max-w-1280 mx-auto"
                    }, Belt_Array.mapWithIndex(templates, (function (i, card) {
                            return React.createElement("a", {
                                        key: String(i),
                                        className: "bg-gray-90 px-5 pb-8 relative rounded-xl",
                                        style: {
                                          maxWidth: "406px"
                                        },
                                        href: card.href,
                                        target: "_blank"
                                      }, React.createElement("img", {
                                            className: "h-12 absolute mt-5",
                                            src: card.imgSrc
                                          }), React.createElement("h5", {
                                            className: "text-gray-10 font-semibold mt-32 h-12"
                                          }, card.title), React.createElement("div", {
                                            className: "text-gray-40 mt-8 text-14"
                                          }, card.descr));
                          })))));
}

function LandingPageLayout$Sponsors(Props) {
  return React.createElement("div", {
              className: "mt-24"
            }, React.createElement("h2", {
                  className: "hl-1 text-center"
                }, "Sponsors"));
}

function LandingPageLayout(Props) {
  var componentsOpt = Props.components;
  var children = Props.children;
  var components = componentsOpt !== undefined ? Caml_option.valFromOption(componentsOpt) : Markdown.$$default;
  var overlayState = React.useState(function () {
        return false;
      });
  return React.createElement(React.Fragment, undefined, React.createElement(Meta.make, {}), React.createElement("div", {
                  className: "mt-4 xs:mt-16"
                }, React.createElement("div", {
                      className: "text-gray-80 text-18"
                    }, React.createElement(Navigation.make, {
                          overlayState: overlayState
                        }), React.createElement("div", {
                          className: "absolute top-16 w-full"
                        }, React.createElement("div", {
                              className: "relative overflow-hidden pb-32"
                            }, React.createElement("main", {
                                  className: "mt-10 min-w-320 lg:align-center w-full"
                                }, React.createElement(Mdx.Provider.make, {
                                      components: components,
                                      children: React.createElement("div", {
                                            className: ""
                                          }, React.createElement("div", {
                                                className: "w-full"
                                              }, React.createElement("div", {
                                                    className: "mt-16 md:mt-32 lg:mt-40 mb-12"
                                                  }, React.createElement(LandingPageLayout$Intro, {})), React.createElement(LandingPageLayout$PlaygroundHero, {}), React.createElement(LandingPageLayout$QuickInstall, {}), React.createElement(LandingPageLayout$MainUSP, {}), React.createElement(LandingPageLayout$OtherSellingPoints, {}), React.createElement(LandingPageLayout$TrustedBy, {}), React.createElement(LandingPageLayout$CuratedResources, {}), React.createElement(LandingPageLayout$Sponsors, {}), children))
                                    }))), React.createElement(Footer.make, {})))));
}

var make = LandingPageLayout;

export {
  make ,
  
}
/* item1 Not a pure module */
