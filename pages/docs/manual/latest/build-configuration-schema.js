import dynamic from "next/dynamic";

const Docson = dynamic(() => import("components/Docson").then((comp) => {
  return comp.make;
}), {
  ssr: false,
  loading: () => <div> Loading... </div>
});

function BuildConfigurationSchemaPage() {
  return <Docson/>;
}

export default BuildConfigurationSchemaPage;
