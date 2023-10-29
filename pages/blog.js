import BlogRes from "src/Blog.bs.mjs";

export { getStaticProps } from "src/Blog.bs.mjs";

export default function Blog(props) {
  return <BlogRes {...props} />
}
