_ = require 'lodash'

{asMoment,now,parseDate,formatDayForJson} = require './SchoolUtils'

class SchoolWeek
  constructor: (date) ->
    @from = asMoment(date).clone().startOf('week')
    @to = @from.clone().add(5,'day').add(-1,'millisecond')    

  @fromJSON: (raw, fmt) ->
    if _.isUndefined(raw)
      date = now()
    else if _.isString(raw)
      date = parseDate(raw,fmt)
    else
      date = asMoment(raw).clone()
    return new SchoolWeek(date)

  @allDayNames: -> ['lundi','mardi','mercredi','jeudi','vendredi','samedi','dimanche']

  isInWeek: (date) =>
    if date.before(@from) or date.after(@to) then return false
    else return true

  days: () ->
    days=[]
    for weekday in [0..4]
      day = @from.clone().set('weekday',weekday)
      days.push(day)
    days

  #TODO verify if used
  dayByName: (name) ->
    name = name.toLowerCase()
    for weekdayIndex,weekdayName of allDayNames()
      if name == weekdayName then return @from.clone().set('weekday',weekdayIndex)
    return undefined

  toString: -> JSON.stringify(@)

  toJSON: ->
    from: formatDayForJson(@from)
    to: formatDayForJson(@to)


module.exports = SchoolWeek
