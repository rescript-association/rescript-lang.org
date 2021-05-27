@react.component
let make = (~children) =>
  <button
    className="transition-colors duration-200 inline-block text-16 text-fire hover:text-white hover:bg-fire rounded border border-fire-70 px-5 py-2">
    children
  </button>
