fs = require 'fs'

{parseMenu} = require './SchoolMenuParser'

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

module.exports = SchoolMenuFileLoader
