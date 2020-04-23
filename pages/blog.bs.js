

import * as Meta from "../components/Meta.bs.js";
import * as Util from "../common/Util.bs.js";
import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Button from "../components/Button.bs.js";
import * as BlogApi from "../common/BlogApi.bs.js";
import * as DateStr from "../common/DateStr.bs.js";
import * as $$Promise from "reason-promise/src/js/promise.js";
import * as Caml_obj from "bs-platform/lib/es6/caml_obj.js";
import * as Markdown from "../components/Markdown.bs.js";
import * as Link from "next/link";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as Navigation from "../components/Navigation.bs.js";
import * as Belt_Option from "bs-platform/lib/es6/belt_Option.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as React$1 from "@mdx-js/react";
import * as BlogFrontmatter from "../common/BlogFrontmatter.bs.js";
import * as NameInitialsAvatar from "../components/NameInitialsAvatar.bs.js";
import * as Caml_chrome_debugger from "bs-platform/lib/es6/caml_chrome_debugger.js";

function Blog$Badge(Props) {
  var badge = Props.badge;
  return React.createElement("div", {
              className: "inline-block items-center bg-turtle font-medium tracking-tight text-onyx-80 text-14 px-2 rounded-sm py-1"
            }, React.createElement("img", {
                  className: "w-4 inline-block pb-1 mr-1",
                  src: "/static/star.svg"
                }), Util.ReactStuff.s(badge));
}

var Badge = {
  make: Blog$Badge
};

function renderTab(text, isActive, onClick) {
  return React.createElement("div", {
              key: text,
              className: (
                isActive ? "bg-snow-dark text-onyx rounded py-1" : "hover:cursor-pointer hover:text-onyx"
              ) + "  px-4 inline-block",
              onClick: onClick
            }, Util.ReactStuff.s(text));
}

function Blog$CategorySelector(Props) {
  var categories = Props.categories;
  var selected = Props.selected;
  var onSelected = Props.onSelected;
  var tabs = [/* All */0].concat(Belt_Array.map(categories, (function (cat) {
              return /* Category */Caml_chrome_debugger.simpleVariant("Category", [cat]);
            })));
  return React.createElement("div", {
              className: "text-16 w-full flex items-center justify-between text-onyx-50"
            }, Util.ReactStuff.ate(Belt_Array.map(tabs, (function (tab) {
                        var onClick = function (evt) {
                          evt.preventDefault();
                          return Curry._1(onSelected, tab);
                        };
                        var isActive = Caml_obj.caml_equal(selected, tab);
                        var text = tab ? BlogFrontmatter.Category.toString(tab[0]) : "All";
                        return renderTab(text, isActive, onClick);
                      }))));
}

var CategorySelector = {
  renderTab: renderTab,
  make: Blog$CategorySelector
};

var defaultPreviewImg = "https://res.cloudinary.com/dmm9n7v9f/image/upload/v1587479463/Reason%20Association/reasonml.org/reasonml_art2_1280_vhzxnz.png";

function Blog$BlogCard(Props) {
  var previewImg = Props.previewImg;
  var $staropt$star = Props.title;
  Props.author;
  var category = Props.category;
  var badge = Props.badge;
  var date = Props.date;
  var slug = Props.slug;
  var title = $staropt$star !== undefined ? $staropt$star : "Unknown Title";
  var className = "absolute top-0 h-full w-full object-cover";
  return React.createElement("section", {
              className: "h-full"
            }, React.createElement("div", {
                  className: "relative"
                }, badge !== undefined ? React.createElement("div", {
                        className: "absolute z-10 bottom-0 mb-4 -ml-2"
                      }, React.createElement(Blog$Badge, {
                            badge: badge
                          })) : null, React.createElement(Link.default, {
                      href: "/blog/[slug]",
                      as: "/blog/" + slug,
                      children: React.createElement("a", {
                            className: "relative block mb-4 pt-9/16"
                          }, previewImg !== undefined ? React.createElement("img", {
                                  className: className,
                                  src: previewImg
                                }) : React.createElement("img", {
                                  className: className,
                                  src: defaultPreviewImg
                                }))
                    })), React.createElement("div", {
                  className: "px-2"
                }, React.createElement(Link.default, {
                      href: "/blog/[slug]",
                      as: "/blog/" + slug,
                      children: React.createElement("a", undefined, React.createElement("h2", {
                                className: "text-onyx font-semibold text-21 leading-2"
                              }, Util.ReactStuff.s(title)))
                    }), React.createElement("div", {
                      className: "text-night-light text-sm"
                    }, Util.ReactStuff.s(category), Util.ReactStuff.s(" · "), Util.ReactStuff.s(Util.$$Date.toDayMonthYear(date)))));
}

var BlogCard = {
  defaultPreviewImg: defaultPreviewImg,
  make: Blog$BlogCard
};

function Blog$FeatureCard(Props) {
  var previewImg = Props.previewImg;
  var $staropt$star = Props.title;
  var author = Props.author;
  var badge = Props.badge;
  var date = Props.date;
  var category = Props.category;
  var $staropt$star$1 = Props.firstParagraph;
  var slug = Props.slug;
  var title = $staropt$star !== undefined ? $staropt$star : "Unknown Title";
  var firstParagraph = $staropt$star$1 !== undefined ? $staropt$star$1 : "";
  var displayName = BlogFrontmatter.Author.getDisplayName(author);
  var match = author.imgUrl;
  var authorImg = match !== null ? React.createElement("img", {
          className: "h-full w-full rounded-full",
          src: match
        }) : React.createElement(NameInitialsAvatar.make, {
          displayName: displayName
        });
  var className = "absolute top-0 h-full w-full object-cover";
  var match$1 = author.twitter;
  return React.createElement("section", {
              className: "flex sm:px-4 md:px-0 flex-col justify-end lg:flex-row sm:items-center h-full"
            }, React.createElement("div", {
                  className: "w-full h-full sm:self-start md:self-auto",
                  style: {
                    maxHeight: "25.4375rem",
                    maxWidth: "38.125rem"
                  }
                }, React.createElement(Link.default, {
                      href: "/blog/[slug]",
                      as: "/blog/" + slug,
                      children: React.createElement("a", {
                            className: "relative block pt-2/3"
                          }, badge !== undefined ? React.createElement("div", {
                                  className: "absolute z-10 top-0 mt-10 ml-4 lg:-ml-4"
                                }, React.createElement(Blog$Badge, {
                                      badge: badge
                                    })) : null, previewImg !== undefined ? React.createElement("img", {
                                  className: className,
                                  src: previewImg
                                }) : React.createElement("div", {
                                  className: "absolute top-0 h-full w-full object-coverbg-night-light"
                                }))
                    })), React.createElement("div", {
                  className: "relative px-4 lg:self-auto md:pt-12 md:px-20 sm:self-start md:ml-16 md:-mt-20 mt-4 bg-white lg:w-full lg:pt-0 lg:mt-8 lg:px-0 lg:ml-12"
                }, React.createElement("div", {
                      className: "max-w-400 "
                    }, React.createElement("h2", {
                          className: "text-onyx font-semibold text-42 leading-2"
                        }, Util.ReactStuff.s(title)), React.createElement("div", {
                          className: "mb-6"
                        }, React.createElement("div", {
                              className: "flex items-center font-medium text-onyx-50 text-sm my-2"
                            }, React.createElement("div", {
                                  className: "inline-block w-4 h-4 mr-2"
                                }, authorImg), React.createElement("div", undefined, match$1 !== null ? React.createElement("a", {
                                        className: "hover:text-onyx-80",
                                        href: "https://twitter.com/" + match$1,
                                        rel: "noopener noreferrer",
                                        target: "_blank"
                                      }, Util.ReactStuff.s(displayName)) : Util.ReactStuff.s(displayName), Util.ReactStuff.s(" · "), Util.ReactStuff.s(category), Util.ReactStuff.s(" · "), Util.ReactStuff.s(Util.$$Date.toDayMonthYear(date)))), React.createElement("p", {
                              className: "text-night-dark text-16"
                            }, Util.ReactStuff.s(firstParagraph)))), React.createElement(Link.default, {
                      href: "/blog/[slug]",
                      as: "/blog/" + slug,
                      children: React.createElement("a", undefined, React.createElement(Button.make, {
                                children: Util.ReactStuff.s("Read Article")
                              }))
                    })));
}

var FeatureCard = {
  make: Blog$FeatureCard
};

function orderByDate(posts) {
  return posts.slice().sort((function (a, b) {
                var aV = DateStr.toDate(a.frontmatter.date).valueOf();
                var bV = DateStr.toDate(b.frontmatter.date).valueOf();
                if (aV === bV) {
                  return 0;
                } else if (aV > bV) {
                  return -1;
                } else {
                  return 1;
                }
              }));
}

var Post = {
  orderByDate: orderByDate
};

var Malformed = { };

function $$default(props) {
  var availableCategories = props.availableCategories;
  var malformed = props.malformed;
  var posts = props.posts;
  var match = React.useState((function () {
          return /* All */0;
        }));
  var setSelection = match[1];
  var currentSelection = match[0];
  var errorBox = process.env.ENV === "development" && malformed.length !== 0 ? React.createElement("div", {
          className: "mb-12"
        }, React.createElement(Markdown.Warn.make, {
              children: null
            }, React.createElement("h2", {
                  className: "font-bold text-night-dark text-2xl mb-2"
                }, Util.ReactStuff.s("Some Blog Posts are Malformed!")), React.createElement("p", undefined, Util.ReactStuff.s("Any blog post with invalid data will not be displayed in production.")), React.createElement("div", undefined, React.createElement("p", {
                      className: "font-bold mt-4"
                    }, Util.ReactStuff.s("Errors:")), React.createElement("ul", undefined, Util.ReactStuff.ate(Belt_Array.map(malformed, (function (m) {
                                return React.createElement("li", {
                                            className: "list-disc ml-5"
                                          }, Util.ReactStuff.s("pages/blog/" + (m.id + (".mdx: " + m.message))));
                              }))))))) : null;
  var content;
  if (posts.length === 0) {
    content = React.createElement("div", undefined, Util.ReactStuff.s("Currently no posts available"));
  } else {
    var filtered;
    if (currentSelection) {
      var selected = currentSelection[0];
      filtered = Belt_Array.keep(posts, (function (param) {
              return param.frontmatter.category === selected;
            }));
    } else {
      filtered = posts;
    }
    var match$1 = filtered.length;
    var result;
    if (match$1 !== 0) {
      var first = Belt_Array.getExn(posts, 0);
      var rest = posts.slice(1);
      var tmp = {
        title: first.frontmatter.title,
        author: first.frontmatter.author,
        date: DateStr.toDate(first.frontmatter.date),
        category: BlogFrontmatter.Category.toString(first.frontmatter.category),
        slug: first.id
      };
      var tmp$1 = Caml_option.null_to_opt(first.frontmatter.previewImg);
      if (tmp$1 !== undefined) {
        tmp.previewImg = Caml_option.valFromOption(tmp$1);
      }
      var tmp$2 = Belt_Option.map(Caml_option.null_to_opt(first.frontmatter.badge), BlogFrontmatter.Badge.toString);
      if (tmp$2 !== undefined) {
        tmp.badge = Caml_option.valFromOption(tmp$2);
      }
      var tmp$3 = Caml_option.null_to_opt(first.frontmatter.description);
      if (tmp$3 !== undefined) {
        tmp.firstParagraph = Caml_option.valFromOption(tmp$3);
      }
      var featureBox = React.createElement("div", {
            className: "mb-24 lg:px-4 xl:px-0"
          }, React.createElement(Blog$FeatureCard, tmp));
      var postsBox = rest.length !== 0 ? React.createElement("div", {
              className: "px-4 xl:px-0 grid grid-cols-1 xs:grid-cols-2 md:grid-cols-3 gap-20 row-gap-12 md:row-gap-24 w-full"
            }, Util.ReactStuff.ate(Belt_Array.mapWithIndex(rest, (function (i, post) {
                        var badge = Belt_Option.map(Caml_option.null_to_opt(post.frontmatter.badge), BlogFrontmatter.Badge.toString);
                        var tmp = {
                          title: post.frontmatter.title,
                          author: post.frontmatter.author,
                          category: BlogFrontmatter.Category.toString(post.frontmatter.category),
                          date: DateStr.toDate(post.frontmatter.date),
                          slug: post.id,
                          key: post.id + String(i)
                        };
                        var tmp$1 = Caml_option.null_to_opt(post.frontmatter.previewImg);
                        if (tmp$1 !== undefined) {
                          tmp.previewImg = Caml_option.valFromOption(tmp$1);
                        }
                        if (badge !== undefined) {
                          tmp.badge = Caml_option.valFromOption(badge);
                        }
                        return React.createElement(Blog$BlogCard, tmp);
                      })))) : null;
      result = React.createElement(React.Fragment, undefined, featureBox, postsBox);
    } else {
      result = React.createElement("div", undefined, Util.ReactStuff.s("No posts for this category available..."));
    }
    var catSelector = availableCategories.length >= 2 ? React.createElement("div", {
            className: "hidden sm:flex justify-center "
          }, React.createElement("div", {
                className: "my-16 w-full",
                style: {
                  maxWidth: "32rem"
                }
              }, React.createElement(Blog$CategorySelector, {
                    categories: availableCategories,
                    selected: currentSelection,
                    onSelected: (function (selection) {
                        return Curry._1(setSelection, (function (param) {
                                      return selection;
                                    }));
                      })
                  }))) : React.createElement("div", {
            className: "md:mt-32"
          });
    content = React.createElement(React.Fragment, undefined, catSelector, result);
  }
  var overlayState = React.useState((function () {
          return false;
        }));
  return React.createElement(React.Fragment, undefined, React.createElement(Meta.make, { }), React.createElement("div", {
                  className: "mb-32 mt-16 pt-2"
                }, React.createElement("div", {
                      className: "text-night text-lg"
                    }, React.createElement(Navigation.make, {
                          overlayState: overlayState
                        }), React.createElement("div", {
                          className: "flex justify-center overflow-hidden"
                        }, React.createElement("main", {
                              className: "min-w-320 lg:align-center w-full lg:px-0 max-w-1280 "
                            }, React.createElement(React$1.MDXProvider, {
                                  components: Markdown.$$default,
                                  children: React.createElement("div", {
                                        className: "flex justify-center"
                                      }, React.createElement("div", {
                                            style: {
                                              maxWidth: "66.625rem"
                                            }
                                          }, errorBox, content))
                                }))))));
}

function getStaticProps(_ctx) {
  var authors = BlogFrontmatter.Author.getAllAuthors(/* () */0);
  var match = Belt_Array.reduce(BlogApi.getAllPosts(/* () */0), /* tuple */[
        [],
        [],
        []
      ], (function (acc, postData) {
          var availableCategories = acc[2];
          var malformed = acc[1];
          var posts = acc[0];
          var id = postData.slug;
          var decoded = BlogFrontmatter.decode(authors, postData.frontmatter);
          if (decoded.tag) {
            var m_message = decoded[0];
            var m = {
              id: id,
              message: m_message
            };
            var malformed$1 = Belt_Array.concat(malformed, [m]);
            return /* tuple */[
                    posts,
                    malformed$1,
                    availableCategories
                  ];
          } else {
            var frontmatter = decoded[0];
            var p = {
              id: id,
              frontmatter: frontmatter
            };
            var posts$1 = Belt_Array.concat(posts, [p]);
            var hasCategory = availableCategories.some((function (c) {
                    return c === frontmatter.category;
                  }));
            var newAvailableCat = hasCategory ? availableCategories : Belt_Array.concat(availableCategories, [frontmatter.category]);
            return /* tuple */[
                    posts$1,
                    malformed,
                    newAvailableCat
                  ];
          }
        }));
  var props_posts = orderByDate(match[0]);
  var props_malformed = match[1];
  var props_availableCategories = match[2];
  var props = {
    posts: props_posts,
    malformed: props_malformed,
    availableCategories: props_availableCategories
  };
  return $$Promise.resolved({
              props: props
            });
}

var Link$1 = /* alias */0;

export {
  Link$1 as Link,
  Badge ,
  CategorySelector ,
  BlogCard ,
  FeatureCard ,
  Post ,
  Malformed ,
  $$default ,
  $$default as default,
  getStaticProps ,
  
}
/* Meta Not a pure module */
