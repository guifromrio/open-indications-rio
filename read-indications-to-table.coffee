$ = require 'cheerio'
fs = require 'fs'

indication = fs.readFileSync('indications/indication-3397.html').toString()

$ = $.load indication

parsedIndication =
  'INDICATION_NUMBER': $('body form div[align="center"] b')[2].children[0].children[0].data
  'INDICATION_SUMMARY': $('body form table[cellspacing="0"] td[width="430"] font')[0].children[0].data


console.log parsedIndication