cheerio = require 'cheerio'
fs = require 'fs'
_ = require 'underscore'

separator = '&*'

dateRegExp = /(\d{1,2})\sde\s(\w+)(?:\sde)?\s(\d{4})/

columnsMap = {
  'NUMBER':2,
  'SUMMARY': 3,
  'AUTHOR': 5,
  'DAY': null
  'MONTH': null
  'YEAR': null
}

indicationIndexes = [0..5750]
#indicationIndexes = [0..0]

indications = indicationIndexes.map (i) -> try fs.readFileSync('indications/indication-' + ("0000" + i).slice(-4) + '.html').toString()
indications = _.uniq indications
indications = _.compact indications

parsedIndications = indications.map (html) ->
  $ = cheerio.load html
  fonts = []

  $('body form font').each (i, font) ->
    text = cheerio(font).text()
    if text and text.trim().length > 0
      fonts.push text.trim()

#  return fonts.slice(0,10)

  indication = {}
  for k, v of columnsMap
    indication[k] = if v then fonts[v] else 'UNDEFINED'

  dateFont = _.find fonts, (f) -> dateRegExp.test f

  if dateFont
    date = dateRegExp.exec dateFont
    indication['DAY'] = date[1]
    indication['MONTH'] = date[2]
    indication['YEAR'] = date[3]

  return indication

fileName = 'indications-table.csv'
unless fs.existsSync fileName
  fs.writeFileSync fileName, Object.keys(columnsMap).join(separator) + '\n'

for indication in parsedIndications
  values = []
  values.push v for k, v of indication
  joinedValues = values.join(separator)
  # console.log joinedValues
  fs.appendFileSync 'indications-table.csv', joinedValues + '\n'
