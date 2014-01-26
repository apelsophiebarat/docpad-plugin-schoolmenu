extendr = require 'extendr'

SchoolWeek = require './SchoolWeek'
SchoolComments = require './SchoolComments'
SchoolMenuDay = require './SchoolMenuDay'
SchoolMenuContext = require './SchoolMenuContext'

{now,weekdayName} = require './SchoolUtils'

class SchoolMenu
  constructor: (@week,@days,@comments,@context) ->
    @year = @week.from.year()
    @month = @week.from.month()+1
    






 

  formatJson: ->
    output = 
      meta: @context.getMetaForDocument()
      infos: @context.getContextInfoForContent()
      data:
        comments: @comments.formatJson()
        days: for day in @days then day.formatJson()

  toString: -> "SchoolMenu(#{@week},#{@days},#{@comments},#{@context})"

module.exports = SchoolMenu