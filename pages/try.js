import dynamic from "next/dynamic";

const Try = dynamic(() => import("src/Try.mjs"), {
  ssr: false,
  //loading: () => <div> Loading... </div>
});

function Comp() {
  return <Try />;
}

export default Comp;
