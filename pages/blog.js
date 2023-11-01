import BlogRes from "src/Blog.mjs";

export { getStaticProps } from "src/Blog.mjs";

export default function Blog(props) {
  return <BlogRes {...props} />
}
