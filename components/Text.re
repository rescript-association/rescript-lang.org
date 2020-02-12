module Link = {
  let inline = "no-underline border-b border-night-dark hover:border-bs-purple text-inherit";
  let standalone = "no-underline text-fire";
};

module Introduction = {
  [@genType]
  [@react.component]
  let make = (~children) => {
    <div className="text-xl mt-8 mb-4"> children </div>;
  };
};
