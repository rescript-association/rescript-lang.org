@react.component
let make = (~children) => {
  let scrollDir = Hooks.useScrollDirection()

  <div
    className={switch scrollDir {
    | Up(_) => "group nav-appear"
    | Down(_) => "group nav-disappear"
    }}>
    children
  </div>
}
