import BlogRes from "src/Blog";

export { getStaticProps } from "src/Blog";

export default function Blog(props) {
  return <BlogRes {...props} />
}
