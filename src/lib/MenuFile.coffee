fs = require 'fs'
path = require 'path'
frontMatter = require 'yaml-front-matter'
cson = require 'cson'
_ = require 'underscore'

{normalizeMenu} = require './Normalizer'
{trace,warn,asMoment} = require './Utils'

regexpPattern = /\b(\d{4})-(\d{2})-(\d{2})-menu-?([\w-]*)?/
schoolLevels = ['primaire','college','lycee']

class MenuFile

  constructor: (basename,@relativePath,fullPath,content) ->
    throw "basename required" unless basename?
    throw "relativePath required" unless @relativePath?
    throw "content or fullPath required" unless (fullPath? or content?)
    unless parameters = basename.match(regexpPattern)
      throw "#{@basename} invalid filename : muste respect #{regexpPattern}"
    [@basename,@year,@month,@day,tags] = parameters
    @date = asMoment("#{@year}/#{@month}/#{@day}","YYYY/MM/DD")
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
    if @content? and @content.length > 0
      trace('content already loaded')
      @content
    else 
      trace("load content from #{@contentPath}")
      rawContent = fs.readFileSync(@contentPath,'UTF-8')
      contentAndMeta = frontMatter.loadFront(rawContent)
      @content = contentAndMeta.__content

  getMenuContent: ->
    trace("loading menu content from #{@toString()}")
    menuContent =
      if @getExtension() == '.menu'
        normalizeMenu cson.parseSync(@getContent())
      else
        JSON.parse @getContent()
    unless menuContent?
      if @content?
        error = "can not load menu from #{@toString()} - invalid content >#{@content}<"
      else
        error = "can not load menu from #{@toString()} - invalid file #{@contentPath}"
      warn(error)      
      throw error
    return menuContent

  toString: ->
    contentStr=if(@content?) then "<content>" else "content from #{@contentPath}"
    "MenuFile(#{@basename}, #{@relativePath}, #{contentStr}, #{@year}, #{@month}, #{@day}, #{@tags})"

module.exports = MenuFile