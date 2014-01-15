SchoolWeek = require './SchoolWeek'
SchoolComments = require './SchoolComments'
SchoolMenuDay = require './SchoolMenuDay'

{now,weekdayName,formatDayForJson} = require './SchoolUtils'

class SchoolMenu
  constructor: (@week,@days,@comments,@meta) ->

  @fromJSON: (data) ->
    meta = data.meta or {}
    week = SchoolWeek.fromJSON(meta.date)
    comments = SchoolComments.fromJSON(data)
    menuDays =[]
    if data.tous?
      tous = SchoolMenuDay.fromJSON('tous',now(),data.tous)
    for day in week.days()
      name = weekdayName(day)
      dayData  = data[name]
      if dayData?
        menuDay = SchoolMenuDay.fromJSON(name,day,dayData)
        menuDay.addAll(tous) if data.tous?
        menuDays.push menuDay
    new SchoolMenu(week,menuDays,comments,meta)

  toString: -> JSON.stringify(@)

  toJSON: ->
    metaJson = {}
    for k,v of @meta
      v = formatDayForJson(v) if k == 'date'
      v = undefined if k == 'tags' and v.length < 1
      metaJson[k]=v
    week: @week
    days: @days
    comments: @comments
    meta: metaJson

module.exports = SchoolMenu