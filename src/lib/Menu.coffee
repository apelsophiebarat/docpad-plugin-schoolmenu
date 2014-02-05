class Menu
  constructor: (@week,@schoolLevels,@days,@comments) ->

  toJSON: ->
    week: @week.toJSON()
    schoolLevels: @schoolLevels
    comments: @comments
    days: d.toJSON() for d in @days

module.exports = Menu