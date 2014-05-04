request = require 'request'
$ = require 'cheerio'
fs = require 'fs'
async = require 'async'

links = fs.readFileSync('links.txt').toString()
links = links.split '\n'

unless fs.existsSync 'indications'
  fs.mkdirSync 'indications'

generateGetIndicationFunction = (link, index) ->
  (callback) ->
    console.log("starting download of indication at", index)
    request links[index], (err, resp, body) ->
      return callback err if err

      name = 'indications/indication-' + ("0000" + index).slice(-4) + '.html'
      fs.writeFileSync name, body
      console.log 'wrote file', name
      callback(null, index)

async.parallelLimit links.map(generateGetIndicationFunction), 20, -> console.log "done"