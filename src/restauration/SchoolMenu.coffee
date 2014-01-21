extendr = require 'extendr'

SchoolWeek = require './SchoolWeek'
SchoolComments = require './SchoolComments'
SchoolMenuDay = require './SchoolMenuDay'

{now,weekdayName,formatDayForJson} = require './SchoolUtils'

class SchoolMenu
  constructor: (@week,@days,@comments,@meta) ->

  @parseJson: (doc) ->
      {meta,data} = doc
      week = SchoolWeek.parseJson(meta.date)
      comments = SchoolComments.parseJson(data)
      menuDays =[]
      if data.tous?
        tous = SchoolMenuDay.parseJson('tous',now(),data.tous)
      for day in week.days()
        name = weekdayName(day)
        dayData  = data[name]
        if dayData?
          menuDay = SchoolMenuDay.parseJson(name,day,dayData)
          menuDay.addAll(tous) if data.tous?
          menuDays.push menuDay
      new SchoolMenu(week,menuDays,comments,meta)

  formatJson: ->
    meta = extendr.clone(@meta)
    meta.week = @week.formatJson()
    output =
      meta: meta
      data:
        comments: @comments.formatJson()
        days: for day in @days then day.formatJson()

  toString: -> "SchoolMenu(#{@week},#{@days},#{@comments},#{@meta})"

module.exports = SchoolMenu