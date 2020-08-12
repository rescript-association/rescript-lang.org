const glob = require("glob");
const fs = require("fs");
const child_process = require("child_process");
const path = require("path");

let tempFileName = path.join(__dirname, '..', '_tempFile.res')
let tempFileNameRegex = /_tempFile\.res/g
let bsc = path.join(__dirname, '..', 'node_modules', 'bs-platform', process.platform, 'bsc.exe')

let parseFile = content => {
  if (!/```res (example|prelude|sig)/.test(content)) {
    return
  }

  let inCodeBlock = false
  let moduleId = 0
  return content.split('\n').map(line => {
    let modifiedLine = ''
    if (line.startsWith('```res example')) {
      inCodeBlock = true
      modifiedLine = `/* _MODULE_EXAMPLE_START */ module M_${moduleId++} = {`
    } else if (line.startsWith('```res prelude')) {
      inCodeBlock = true
      modifiedLine = `/* _MODULE_PRELUDE_START */ include {`
    } else if (line.startsWith('```res sig')) {
      inCodeBlock = true
      modifiedLine = `/* _MODULE_SIG_START */ module type M_${moduleId++} = {`
    } else if (inCodeBlock) {
      if (line.startsWith('```')) {
        inCodeBlock = false
        modifiedLine = '} // _MODULE_END'
      } else {
        modifiedLine = line
      }
    }

    return modifiedLine
  }).join('\n')
}

let postprocessOutput = (file, error) => {
  return error.stderr.toString()
    .replace(tempFileNameRegex, path.relative('.', file))
    .replace(/\/\* _MODULE_(EXAMPLE|PRELUDE|SIG)_START \*\/.+/g, (_, capture) => {
      return '```res ' + (capture === 'EXAMPLE' ? 'example' : capture === 'PRELUDE' ? 'prelude' : 'sig')
    })
    .replace(/(.*)\}(.*)\/\/ _MODULE_END/g, (_, cap1, cap2) => {
      // cap1 cap2 might be empty or ansi coloring code
      return cap1 + '```' + cap2
    })
}

fs.writeFileSync(tempFileName, '')

glob.sync(__dirname + '/../pages/**/*.mdx').forEach((file) => {
  let content = fs.readFileSync(file, {encoding: 'utf-8'})
  let parsedResult = parseFile(content)
  if (parsedResult != null) {
    fs.writeFileSync(tempFileName, parsedResult)
    try {
      child_process.execFileSync(bsc, ['-i', tempFileName], {stdio: 'pipe'})
    } catch (e) {
      process.stdout.write(postprocessOutput(file, e))
      process.exit(e.status);
    }
  }
})

fs.unlinkSync(tempFileName)
