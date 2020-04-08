


function fromDate(date) {
  return date.toString();
}

function toDate(dateStr) {
  var dateStr$1 = dateStr;
  return new Date(dateStr$1.replace(/-/g, "/"));
}

export {
  fromDate ,
  toDate ,
  
}
/* No side effect */
