@react.component
let make: (~fixed: bool=?, ~overlayState: (bool, (bool => bool) => unit)) => React.element
