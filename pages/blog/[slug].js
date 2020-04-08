import { useRouter } from "next/router";

export {
  default,
  getStaticPaths,
  getStaticProps
} from "../../re_pages/Blog_slug.bs";

function Page(props) {
  const router = useRouter();
  const { slug } = router.query;
  const { default: Component } = require(`../../_blogposts/${slug}.mdx`);

  console.log("test", slug);

  return <Component />;
}

/*
export async function getStaticProps(context) {
  return {
    props: {} // will be passed to the page component as props
  };
}

export async function getStaticPaths(ctx) {
  return {
    paths: [
      { params: { slug: "first-post" } },
      { params: { slug: "second-post" } },
      { params: { slug: "foobar" } }
    ],
    fallback: false
  };
}

export default Page;
*/
