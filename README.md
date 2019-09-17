# Reason NextJS Workshop

This repo will be the starting point for building some Reason app.

## Setup

```
git clone https://github.com/ryyppy/reason-workshop-nextjs
cd reason-workshop-nextjs
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

## Useful commands

Build CSS seperately via `postcss` (useful for debugging)

```
# Devmode
postcss styles/main.css -o test.css

# Production
NODE_ENV=production postcss styles/main.css -o test.css
```
