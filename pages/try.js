import dynamic from "next/dynamic";

export { getStaticProps } from "src/Try.mjs";
import Try from "src/Try.mjs";

const Playground = dynamic(() => import("src/Playground.mjs"), {
  ssr: false,
  loading: () => <span>Loading...</span>,
})

function Comp(props) {
  return <Try>
    <Playground {...props}/>
  </Try>;
}

export default Comp;
