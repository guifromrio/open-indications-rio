request = require 'request'
$ = require 'cheerio'
fs = require 'fs'

year = '1316'

host = "http://mail.camara.rj.gov.br"

config =
  '0711': {
    'fileURL': 'scpro0711.nsf'
    'map': '93A'
  }
  '1316': {
    'fileURL': 'scpro1316.nsf'
    'map': '816'
  }

getURL = (start) -> "#{host}/APL/Legislativos/#{config[year].fileURL}/Internet/IndInt?OpenForm&Start=#{start}&Count=1000&ExpandView"

pages = 20

fs.unlinkSync 'links.txt' if fs.existsSync 'links.txt'

buildIndexFromPage = (start) ->
  request getURL(start), (err, resp, html) ->
    return console.error(err)  if err
    console.log "start #{start}..."

    hrefs = []
    $ = $.load(html)
    links = $('tr td font a')
    links.map (i, a) ->
      hrefs.push host + a.attribs.href if a.children[0].data[0] isnt " "

    className = 'map[name="' + config[year].map + '.map"] area'
    next = $(className)[3]
    newStart = next.attribs.href.replace(/.*Start\=/, "").replace(/&.*/, "")

    console.log "got #{hrefs.length} links"
    fs.appendFileSync 'links.txt', hrefs.join('\n') + '\n'

    if --pages is 0 or hrefs.length is 0
      console.log 'finished'
      process.exit()
    else
      buildIndexFromPage(newStart)

buildIndexFromPage(1)