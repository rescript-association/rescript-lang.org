let apiKey = "d3d9d7cebf13a7b665e47cb85dc9c582"
let indexName = "rescript-lang"
let appId = "BH4D9OD16A"

@react.component
let make = () => {
  let router = Next.Router.useRouter()

  <DocSearch
    apiKey
    appId
    indexName
    // transformItems={items => {
    //   items->Belt.Array.map(item => {
    //     let new_url = Util.Url.make(item.url)
    //     {...item, url: `${new_url.pathname}${new_url.hash}`}
    //   })
    // }}
    // hitComponent={({hit, children}) => {
    //   <Next.Link href=hit.url> <a> children </a> </Next.Link>
    // }}
    navigator={{
      navigate: {
        ({itemUrl}) => {
          router->Next.Router.push(itemUrl)
        }
      },
    }}
  />
}