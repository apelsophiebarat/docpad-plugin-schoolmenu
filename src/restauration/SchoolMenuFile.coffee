path = require 'path'
moment = require 'moment'

moment.lang('fr')

regexpPattern = /\b(\d{4})-(\d{2})-(\d{2})-menu-([\w-]*)?/

class SchoolMenuFile

  constructor: (basename,@path, @outPath) ->
    throw "#{basename} invalid filename : muste respect #{regexpPattern}" unless parameters = basename.match(regexpPattern)
    [@basename,@year,@month,@day,tags] = parameters
    @tags = tags.split('-')

  getTags: -> @tags

  getDate: -> moment("#{@year}/#{@month}/#{@day}","YYYY/MM/DD")

  getExtension: -> path.extname(@path)

  toString: -> JSON.stringify(@)

module.exports = SchoolMenuFile