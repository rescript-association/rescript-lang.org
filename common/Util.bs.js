


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
        return "January";
    case 1 :
        return "February";
    case 2 :
        return "March";
    case 3 :
        return "April";
    case 4 :
        return "May";
    case 5 :
        return "June";
    case 6 :
        return "July";
    case 7 :
        return "August";
    case 8 :
        return "September";
    case 9 :
        return "October";
    case 10 :
        return "November";
    case 11 :
        return "December";
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
