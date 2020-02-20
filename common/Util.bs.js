


function s(prim) {
  return prim;
}

function ate(prim) {
  return prim;
}

var Unsafe = { };

var ReactStuff = {
  s: s,
  ate: ate,
  Unsafe: Unsafe,
  Style: /* alias */0
};

function camelCase (str){{
     return str.replace(/-([a-z])/g, function (g) { return g[1].toUpperCase(); });
    }};

function capitalize (str){{
      return str && str.charAt(0).toUpperCase() + str.substring(1);
    }};

var $$String = {
  camelCase: camelCase,
  capitalize: capitalize
};

var isAbsolute = (function(str) {
      var r = new RegExp('^(?:[a-z]+:)?//', 'i');
      if (r.test(str))
      {
        return true
      }
      return false;
    });

var Url = {
  isAbsolute: isAbsolute
};

export {
  ReactStuff ,
  $$String ,
  Url ,
  
}
/* No side effect */
