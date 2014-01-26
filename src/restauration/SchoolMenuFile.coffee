fs = require 'fs'
path = require 'path'
frontMatter = require 'yaml-front-matter'
cson = require 'cson'
moment = require 'moment'
_ = require 'underscore'

{normalizeMenu} = require './SchoolMenuNormalizer'

moment.lang('fr')

regexpPattern = /\b(\d{4})-(\d{2})-(\d{2})-menu-?([\w-]*)?/
schoolLevels = ['primaire','college','lycee']

class SchoolMenuFile

  constructor: (basename,@relativePath,fullPath,content) ->
    throw "basename required" unless basename?
    throw "relativePath required" unless @relativePath?
    throw "content or fullPath required" unless (fullPath? or content?)
    unless parameters = basename.match(regexpPattern)
      throw "#{@basename} invalid filename : muste respect #{regexpPattern}"
    [@basename,@year,@month,@day,tags] = parameters
    @date = moment("#{@year}/#{@month}/#{@day}","YYYY/MM/DD")
    @tags = if tags then tags.split('-')
    @contentPath=fullPath
    @content = content

  toJSON: ->
    tags: @tags
    date: @date

  getDate: -> @date
  
  getTags: -> @tags
  
  getSchoolLevels: -> _.filter @tags, (t) -> schoolLevels.indexOf(t) > -1

  getExtension: -> path.extname(@relativePath)

  getContent: ->
    if @content? then @content
    else 
      rawContent = fs.readFileSync(@contentPath,'UTF-8')
      contentAndMeta = frontMatter.loadFront(rawContent)
      @content = contentAndMeta.__content

  getMenuContent: ->
    if @getExtension() == '.menu'
      normalizeMenu cson.parseSync(@getContent())
    else
      JSON.parse @getContent()

  toString: ->
    contentStr=if(@content) "<content>" else "content from #{@contentPath}"
    "SchoolMenuFile(#{@basename}, #{@relativePath}, #{@contentStr}, #{@year}, #{@month}, #{@day}, #{@tags})"

module.exports = SchoolMenuFile