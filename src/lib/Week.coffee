{asMoment} = require './Utils'

class Week
  constructor: (date) ->
    @from = asMoment(date).clone().startOf('week')
    @to = @from.clone().add(5,'day').add(-1,'millisecond')

  toJSON: ->
    from: @from
    to: @to
    year: @from.year()
    month: @from.month()+1
    days: @days()

  toString: -> "Week(#{@from},#{@to})"

  @allDayNames: -> ['lundi','mardi','mercredi','jeudi','vendredi','samedi','dimanche']

  isInWeek: (date) =>
    if date.before(@from) or date.after(@to) then return false
    else return true

  isBeforeWeek: (date) => date.before(@from)
  
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

module.exports = Week
