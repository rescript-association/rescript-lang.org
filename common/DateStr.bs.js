


function fromDate(date) {
  return date.toString();
}

function toDate(dateStr) {
  var dateStr$1 = dateStr;
  return new Date(dateStr$1.replace(/-/g, "/"));
}

function fromString(prim) {
  return prim;
}

export {
  fromString ,
  fromDate ,
  toDate ,
  
}
/* No side effect */
