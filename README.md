[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v1.4%20adopted-ff69b4.svg)](CODE_OF_CONDUCT.md)

# reasonml.org

This is the repository for [reasonml.org](https://reasonml.org) and is currently **work
in progress**.

## Setup

```
yarn

# Initial build
yarn bs:build

yarn dev

# Open localhost:3000
```

In case you want to run BuckleScript in watchmode:

```
yarn run bs:start
```

## Build Index Data

We are parsing our content for specific index data (such as, all interesting
search terms we need for searching inside the `Belt` docs). You can create your
index by running following command:

```
yarn run update-index
```

All the index data is stored in `index_data`, but will not be tracked by git.
Make sure to build the index after a fresh clone, otherwise Next might not
build specific pages (file `index_data/x.json` not found).

## Run Tests


### Markdown Codeblock Tests

We try to verify our code examples inside markdown files as much as possible.
Currently we are using `scripts/test-examples.js` to test all our example
codeblocks (those blocks marked with `re examples`).

After writing documentation, this is how you can run your codeblock tests:

```
# Tests all files
node scripts/test-examples.js

# Or just a subset (glob pattern)
node scripts/test-examples.js "pages/apis/latest/belt/set-*.mdx"
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

```
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

Build CSS seperately via `postcss` (useful for debugging)

```
# Devmode
postcss styles/main.css -o test.css

# Production
NODE_ENV=production postcss styles/main.css -o test.css
```

## URL Route Design

This is an attempt to formalize the URL structure of this website

### API related urls

By convention, NextJS uses `pages/api` for server related functionality, so we
need to fall back to `pages/apis` instead.

- `/apis/javascript` refers to all BuckleScript related APIs.
- `/apis/javascript/latest` refers to the overview of all JavaScript related modules on the `latest` version
- `/apis/javascript/x.x.x` refers to the overview of all JavaScript related modules on the `x.x.x` version
- `/apis/javascript/latest/list` refers to Belt's List module on the latest version

**Examples:**

```
/apis/javascript/latest (overview)
/apis/javascript/latest/belt
/apis/javascript/latest/js
/apis/javascript/latest/node

/apis/javascript/v6.2.1 (overview)
/apis/javascript/v6.2.1/node
/apis/javascript/v6.2.1/belt

/apis/ (overview / version independent)
```

### Contributing

Check out our [CONTRIBUTING.md](CONTRIBUTING.md) for how to get started working
on this project.

**TLDR:** Read and comply to our [Code of Conduct](CODE_OF_CONDUCT.md); always
make sure to have an issue assigned / create issues / join us in the
[ReasonML Discord #docs channel](https://discord.gg/fscQAnj) to find a good
task to work on.
