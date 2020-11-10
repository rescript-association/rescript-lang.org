


var Upload = {};

function decodeReadyState(param) {
  if (param > 4 || param < 0) {
    return /* Unknown */5;
  } else {
    return param;
  }
}

function readyState(xhr) {
  return decodeReadyState(xhr.readyState);
}

export {
  Upload ,
  decodeReadyState ,
  readyState ,
  
}
/* No side effect */
