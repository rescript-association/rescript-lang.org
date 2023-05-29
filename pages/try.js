import dynamic from "next/dynamic";

export { getStaticProps } from "src/Try.mjs";

const Try = dynamic(() => import("src/Try.mjs"), {
  ssr: false,
  //loading: () => <div> Loading... </div>
});

function Comp(props) {
  return <Try {...props} />;
}

export default Comp;
