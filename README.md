[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v1.4%20adopted-ff69b4.svg)](code-of-conduct.md)

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

We try to verify our code examples inside markdown files as much as possible.
Currently we are using `scripts/test-belt-examples.js` to test all our example
codeblocks (those blocks marked with `re examples`).

After writing documentation, make sure to run this code before submitting a PR:

```
# Tests all files
node scripts/test-belt-examples.js

# Or just a subset (glob pattern)
node scripts/test-belt-examples.js "pages/belt_docs/set-*.mdx"
```

## Design / UX

Design mockups can be found
[here](https://xd.adobe.com/spec/15aaca36-8352-45aa-48c2-18fc508c81ed-639b/grid).

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

### Contributing

Check out our [CONTRIBUTING.md](CONTRIBUTING.md) for how to get started working
on this project.

**TLDR:** Read and comply to our [Code of Conduct](CODE_OF_CONDUCT.md); always
make sure to have an issue assigned / create issues / join us in the
[ReasonML Discord #docs channel](https://discord.gg/fscQAnj) to find a good
task to work on.
