import BlogRes from "re_pages/Blog";

export { getStaticProps } from "re_pages/Blog";

export default function Blog(props) {
  return <BlogRes {...props} />
}
