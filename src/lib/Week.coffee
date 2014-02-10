{asMoment} = require './Utils'
{dayNames} = require('./Config').current()

class Week
  constructor: (date) ->
    @from = asMoment(date).clone().startOf('week')
    @to = @from.clone().add(5,'day').add(-1,'millisecond')

  toJSON: ->
    from: @from.toDate()
    to: @to.toDate()

  isInWeek: (date) =>
    if date.before(@from) or date.after(@to) then return false
    else return true

  isBeforeWeek: (date) => date.before(@from)

  days: () ->
    days=[]
    for weekday in [0..6]
      day = @from.clone().set('weekday',weekday)
      days.push(day)
    days

  #TODO verify if used
  dayByName: (name) ->
    name = name.toLowerCase()
    for weekdayIndex,weekdayName of dayNames()
      if name == weekdayName then return @from.clone().set('weekday',weekdayIndex)
    return undefined

module.exports = Week
