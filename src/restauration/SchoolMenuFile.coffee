fs = require 'fs'
path = require 'path'
moment = require 'moment'

moment.lang('fr')

regexpPattern = /\b(\d{4})-(\d{2})-(\d{2})-menu-?([\w-]*)?/

class SchoolMenuFile

  constructor: (basename,@path, @outPath) ->
    unless parameters = basename.match(regexpPattern)
      throw "#{@basename} invalid filename : muste respect #{regexpPattern}"
    [@basename,@year,@month,@day,tags] = parameters
    @tags = if tags then tags.split('-')

  getTags: -> @tags

  getDate: -> moment("#{@year}/#{@month}/#{@day}","YYYY/MM/DD")

  getExtension: -> path.extname(@path)

  getContent: -> fs.readFileSync(@path,'UTF-8')

  getMeta: ->
    date = @getDate()
    meta =
      date: date.toISOString()
      tags: @getTags()
      menutags: @getTags()
      year: date.year()
      month: date.month()+1

  toString: -> "SchoolMenuFile(#{@basename}, #{@path}, #{@outPath}, #{@year}, #{@month}, #{@day}, #{@tags})"

module.exports = SchoolMenuFile