let content = {
  open BlogApi.RssFeed
  getLatest()->toXmlString
}

Js.log(content)
