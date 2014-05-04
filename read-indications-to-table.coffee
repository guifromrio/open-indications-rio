cheerio = require 'cheerio'
fs = require 'fs'

indications = [fs.readFileSync('indications/indication-0000.html').toString(),
               fs.readFileSync('indications/indication-3397.html').toString()]

parsedIndications = indications.map (html) ->
  $ = cheerio.load html
  return {
    'NUMBER': $('body form font')[4].children[0].data
    'SUMMARY': $('body form font')[5].children[0].data
    'AUTHOR': $('body form font')[7].children[0].data
    'BODY': $('body form font')[8].children[0].data
    'MOTIVE': $('body form font')[9].children[0].data
    'LOCATION': $('body form font')[10].children[0].data.split(',')[0]
    'DATE': $('body form font')[10].children[0].data.split(',')[1].slice(1).replace(/\.$/, '')
    'AUTHOR_TITLE': $('body form font')[12].children[0].data
  }

console.log parsedIndications