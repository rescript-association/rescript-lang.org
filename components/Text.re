module Link = {
  let inline = "no-underline border-b border-night-dark hover:border-bs-purple text-inherit";
  let standalone = "no-underline text-fire";
};

module Introduction = {
  [@genType]
  [@react.component]
  let make = (~children) => {
    <span className="text-xl block"> children </span>;
  };
};
