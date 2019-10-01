# Contributing

Thanks for considering contributing to our platform. We really appreciate the help and would
like to give you some tips on how to contribute in the most effective way.

Please make sure to check out our [Code of Conduct](CODE_OF_CONDUCT.md) and
make sure to follow it in all your interactions within this project and the
ReasonML community.

## Ways to contribute

- Writing docs for Belt (later on BuckleScript, Reason, ReasonReact)
- Joining in discussions on our [issue tracker](https://github.com/reason-association/reasonml.org/issues)
- Give feedback for improvements (incomplete / missing docs, bad wording,
  search user experience / design, etc.)
- Advanced: Help building platform features (design system, automatic testing, markdown parsing, etc.)

## How to get started?

### Find an issue

Before you start any work or submit any PRs, make sure to check our [issue
tracker](https://github.com/reason-association/reasonml.org/issues) for any
issues or discussions on the topic.

If you can't find any relevant issues, feel free to create a new one to start a
discussion, or contact @ryyppy / @nikgraf on the [Reason
Discord](https://discord.gg/reasonml) channel for quick feedback. We usually
assign issues to a responsible person to prevent confusion and duplicate
work, so always double check if an issue is currently being worked on, or talk
to the current assignee to take over the task.

**Always make sure to get feedback from the core maintainers before starting any work**

The project follows very specific goals and tries to deliver the highest value
with the least amount of resources. Please help us focus on the tasks at hand
and don't submit any code / bigger refactorings without any proper discussion
on the issue tracker. Otherwise your PR might not be accepted! 

If you need inspiration on what to work on, you can check out issues tagged
with [`good first
issue`](https://github.com/reason-association/reasonml.org/issues?q=is%3Aissue+is%3Aopen+label%3A"good+first+issue").

### Discuss an issue

We really appreciate all input from users, community members and potential
contributors. Please make sure to consider the other person's opinion and
don't assume any common knowledge.

**Most importantly: Keep it professional and be nice to eachother**

There might be situations where others don't understand a proposed feature or
architectural change. That's fine, discussions are always welcome! Communicate
in clear actionables, make your plans clear and always to stick to the original
topic.

If other contributors disagree with certain proposals and don't change their
mind after longer discussions, please don't get discouraged when an issue gets
closed / postponed. Everyone tries their best to make the platform better, and
to look at it in another perspective: Closed issues are also a highly valuable
resource for others to understand technical decisions later on.

### Communication Channels

- [Issue Tracker](https://github.com/reason-association/reasonml.org/issues)
- [ReasonML Discord Chat](https://discord.gg/reasonml) -> [#docs](https://discord.gg/fscQAnj) Channel
- [ReasonML Discourse (General / mostly unrelated discussions)](https://reasonml.chat)

## Working on the reasonml.org codebase

We try to keep our contribution guidelines to a minimum. Please keep following
rules in mind whenever writing code.

### Keep it simple

The less code we write, the better. If there's a way to do rendering on the
server, or enhance existing markdown files, we prefer that over client-side
rendering and external loading.

We also try to keep our third-party dependencies to a minimum. We use specific
high value frameworks to make things work (`unified`, `remark`, `mdx`,
`bs-platform`, etc).  Please try to keep a small JS footprint, especially for
client side code (to keep the bundle size small).

### Think about the target audience & UX

The reasonml.org project aims to be the best documentation experience for
Reason / BuckleScript users. We don't necessarily need to target OCaml users as
well (at least for the start), so keeping the docs minimalistic is important.

Also check if there are any designs for certain UI components and always think
about how to get the best user experience for the users. Jumpy UI, slow
loading, bloaty JS bundles and bad accessibility is not what we stand for.

### Comply to our CSS ways

We use [TailwindCSS](https://tailwindcss.com) for our component styling. Check
out the [tailwind.config.js](tailwind.config.js) file for configured tailwind
features, colors, border-radius values etc..  If you are not familiar with
Tailwind, check out existing components for inspiration.

We sometimes also need to fall back to common css (with tailwind `@apply`
directives to enforce our style system). You can find the CSS main entrypoint
in [styles/main.css](styles/main.css).

**Only fall back to plain CSS if absolutely necessary**

Most of the stuff we want to build can be built as components with Tailwind
classes. We mostly use global CSS if we need to interact with 3rd party code
(such as `highlightjs`), or if we need features like child selectors (markdown
rendering with nested lists).

## PR process

- Clone the project and follow the [README](README.md) instructions
- Always run the page locally and verify your changes (especially when working on code examples)
- When writing markdown with code examples, always run `yarn test` to prevent broken code
- Feel free to open `Draft PRs` when you are working on bigger features (good
  for visibility and asking for feedback)
