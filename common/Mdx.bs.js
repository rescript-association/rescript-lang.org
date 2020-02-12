


function getMdxType (element){{
      if(element == null || element.props == null) {
        return 'unknown';
      }
      return element.props.mdxType;
    }};

var Components = { };

var Provider = { };

export {
  getMdxType ,
  Components ,
  Provider ,
  
}
/* No side effect */
