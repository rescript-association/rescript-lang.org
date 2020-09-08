import dynamic from "next/dynamic";

const Playground = dynamic(() => import("../re_pages/Playground.bs"), {
  ssr: false,
  //loading: () => <div> Loading... </div>
});

export default Playground;
