type kind = PrimaryRed | PrimaryBlue | SecondaryRed
type size = Small | Large

@react.component
let make: (
  ~href: string=?,
  ~target: string=?,
  ~kind: kind=?,
  ~size: size=?,
  ~children: React.element,
) => React.element
