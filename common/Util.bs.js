


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

function toMonthStr(date) {
  var param = date.getUTCMonth() | 0;
  switch (param) {
    case 0 :
        return "Jan";
    case 1 :
        return "Feb";
    case 2 :
        return "Mar";
    case 3 :
        return "Apr";
    case 4 :
        return "May";
    case 5 :
        return "Jun";
    case 6 :
        return "Jul";
    case 7 :
        return "Aug";
    case 8 :
        return "Sep";
    case 9 :
        return "Oct";
    case 10 :
        return "Nov";
    case 11 :
        return "Dec";
    default:
      return "???";
  }
}

function pad(n) {
  if (n < 10) {
    return "0" + n.toString();
  } else {
    return n.toString();
  }
}

function toDayMonthYear(date) {
  var month = toMonthStr(date);
  var day = pad(date.getDate() | 0);
  var year = date.getFullYear() | 0;
  return "" + (String(month) + (" " + (String(day) + (", " + (String(year) + "")))));
}

var $$Date = {
  toMonthStr: toMonthStr,
  pad: pad,
  toDayMonthYear: toDayMonthYear
};

export {
  ReactStuff ,
  $$String ,
  Url ,
  $$Date ,
  
}
/* No side effect */
