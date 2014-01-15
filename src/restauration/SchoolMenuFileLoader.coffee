fs = require 'fs'

{parseMenu} = require './SchoolMenuParser'
SchoolMenu = require './SchoolMenu'

class SchoolMenuFileLoader
  constructor: (@schoolMenuFile) ->

  setRawContent: (rawContent) ->
    @_rawContent=rawContent

  setContent: (content) ->
    @_content=content

  clearContent: ->
    @_rawContent = undefined
    @_content = undefined

  getRawContent: ->
    rawContent=fs.readFileSync(@schoolMenuFile.path,'UTF-8') unless @_rawContent?

  getContent: ->
    return @_content if @_content?
    if(@schoolMenuFile.getExtension()=='.menu')
      @_content = parseMenu(@getRawContent())
    else
      @_content = JSON.parse(@getRawContent())

  load: ->
    date = @schoolMenuFile.getDate()
    tags = @schoolMenuFile.getTags()
    content = @getContent()
    content.meta['date'] = date
    tags = tags.concat(content.meta.tags or [])
    content.meta['tags'] = tags
    return SchoolMenu.fromJSON(content)

module.exports = SchoolMenuFileLoader
