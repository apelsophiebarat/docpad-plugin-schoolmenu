_ = require 'underscore'

{asMoment,fromIsoString} = require './SchoolUtils'

class SchoolWeek
  constructor: (date) ->
    @from = asMoment(date).clone().startOf('week')
    @to = @from.clone().add(5,'day').add(-1,'millisecond')

  @parseJson: (date) -> new SchoolWeek(fromIsoString(date))

  toString: -> "SchoolWeek(#{@from},#{@to})"

  formatJson: -> output =
    from: @from
    to: @to

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

module.exports = SchoolWeek
