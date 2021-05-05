import dynamic from "next/dynamic";

const Playground = dynamic(() => import("src/Playground.mjs"), {
  ssr: false,
  //loading: () => <div> Loading... </div>
});

function Try() {
  return <Playground />;
}

export default Try;
