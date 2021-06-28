module Section = {
  @react.component
  let make = (~title, ~children) => {
    <div>
      <span className="block text-gray-60 tracking-wide text-14 uppercase mb-4">
        {React.string(title)}
      </span>
      children
    </div>
  }
}

@react.component
let make = () => {
  let linkClass = "hover:underline hover:pointer"
  let iconLink = "hover:pointer hover:text-gray-60-tr"
  <footer className="flex justify-center border-t border-gray-10">
    <div
      className="flex flex-col md:flex-row justify-between max-w-1280 w-full px-8 py-16 text-gray-80 ">
      <div>
        <img className="w-40 mb-5" src="/static/rescript_logo_black.svg" />
        <div className="text-16">
          <p> {React.string(`© 2021 The ReScript Project`)} </p>
          <p>
            {React.string("Software and assets distribution powered by ")}
            <Markdown.A href="https://www.keycdn.com/" target="_blank">
              {React.string("KeyCDN")}
            </Markdown.A>
            {React.string(".")}
          </p>
        </div>
      </div>
      <div
        className="flex flex-col space-y-16 md:flex-row mt-16 md:mt-0 md:ml-16 md:space-y-0 md:space-x-16">
        <Section title="About">
          <ul className="text-16 text-gray-80-tr space-y-2">
            <li>
              <Next.Link href="/community#core-team">
                <a className={linkClass}> {React.string("Team")} </a>
              </Next.Link>
            </li>
            <li>
              <a href="https://rescript-association.org" target="_blank" className=linkClass>
                {React.string("ReScript Association")}
              </a>
            </li>
          </ul>
        </Section>
        <Section title="Find us on">
          <div className="flex space-x-3 text-gray-100">
            <a
              className=iconLink
              target="_blank"
              rel="noopener noreferrer"
              href="https://github.com/rescript-lang">
              <Icon.Github className="w-6 h-6" />
            </a>
            <a
              className=iconLink
              target="_blank"
              rel="noopener noreferrer"
              href="https://twitter.com/rescriptlang">
              <Icon.Twitter className="w-6 h-6" />
            </a>
            <a
              className=iconLink
              target="_blank"
              rel="noopener noreferrer"
              href="https://forum.rescript-lang.org">
              <Icon.Discourse className="w-6 h-6" />
            </a>
          </div>
        </Section>
      </div>
    </div>
  </footer>
}
