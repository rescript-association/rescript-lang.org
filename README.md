[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v1.4%20adopted-ff69b4.svg)](CODE_OF_CONDUCT.md)

<a href="https://simpleanalytics.com/rescript-lang.org?utm_source=rescript-lang.org&utm_content=badge" referrerpolicy="origin" target="_blank"><img src="https://simpleanalyticsbadge.com/rescript-lang.org?counter=true" loading="lazy" referrerpolicy="no-referrer" crossorigin="anonymous" /></a>

# rescript-lang.org

This is the official documentation platform for the [ReScript](https://rescript-lang.org) programming language.

**In case you want to report a technical issue, please refer to the appropriate repository:**
- [rescript-compiler](https://github.com/rescript-lang/rescript-compiler): The compiler and build system
- [rescript-syntax](https://github.com/rescript-lang/syntax): The ReScript syntax

## Setup

```sh
# For first time clone / build (install dependencies)
yarn

# Initial build
yarn bs:build

# Build the index data
yarn run update-index

# In a new tab
yarn dev

# then open localhost:3000
```

In case you want to run BuckleScript in watchmode:

```sh
yarn run bs:start
```

## Build Index Data

We are parsing our content for specific index data (such as, all interesting
search terms we need for searching inside the `Belt` docs). You can create your
index by running following command:

```sh
yarn run update-index
```

All the index data is stored in `index_data`, but will not be tracked by git.
Make sure to build the index after a fresh clone, otherwise Next might not
build specific pages (file `index_data/x.json` not found).

## Run Tests

### Markdown Codeblock Tests

We check the validity of our code examples marked with:
- `` ```res example `` (ReScript code snippet)
- `` ```res sig `` (signature)
- `` ```res prelude `` (ReScript code snippet available for all subsequent code snippets)

Run the checks with:

```sh
node scripts/test-examples.js
```

### Markdown Hyperlink Tests

We are also verifying markdown href links to relative resources (via
`[text](url)` syntax) with our `scripts/test-hrefs.js` script. Here is a short
explanation on how the href testing works:

Domain relative links, such as `/docs/manual/latest`, `./introduction`,
`introduction`, `/docs/foo/introduction.md` will be verified. That means the
tester will check if given path exists in the `pages` directory.

If there are any anchor refs, such as `/docs/manual#test`, then the anchor will
be ignored for the specific file path check. If there are any hrefs with `.md`,
`.mdx` or `.html` file extension, then those will be stripped before the check
happens (the markdown renderer drops file extensions on relative links as
well).

External hrefs, such as `https://www.hello.world`, `//www.hello.world` will NOT be
checked since they are assumed to be external resources.

Here is an example on how to run the tests:

```sh
# Tests all files
node scripts/test-hrefs.js

# Or just a subset (glob pattern)
node scripts/test-hrefs.js "pages/docs/manual/**/*.mdx"
```

### Continous Integration

Always make sure to run `npm test` before pushing any content, otherwise our CI
might trigger a failure warning. Failing branches are very unlikely to be merged.

## Design / UX

Design mockups can be found
[here](https://xd.adobe.com/spec/1cd19c3a-a0bb-4f93-4e11-725589888696-6ae0/grid/).

Be aware that some screen designs might still be work in progress, if you have
any design / UX questions, either comment directly on the design tool as guest,
or open an issue.

## Useful commands

Build CSS seperately via `npx postcss` (useful for debugging)

```sh
# Devmode
npx postcss styles/main.css -o test.css

# Production
NODE_ENV=production npx postcss styles/main.css -o test.css
```

## Writing Blog Posts

In case you are a blog author, please refer to our [guide on writing blog
posts](https://rescript-lang.org/blogpost-guide).

**Quick-takeaways:**

- Blogposts are located in `_blogposts`
- Author metadata is located in `index_data/blog_authors.json`
- Make sure to follow the file naming rules

### Contributing

Check out our [CONTRIBUTING.md](CONTRIBUTING.md) for how to get started working
on this project.

**TLDR:** Please read and comply to our [Code of Conduct](CODE_OF_CONDUCT.md).
