let content = BlogApi.RssFeed.(getLatest()->toXmlString);


Js.log(content);
