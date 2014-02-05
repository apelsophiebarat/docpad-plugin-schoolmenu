class Menu
  constructor: (@week,@schoolLevels,@days,@comments) ->

  toJSON: ->
    isMenu: true
    week: @week.toJSON()
    schoolLevels: [].concat(@schoolLevels)
    comments: [].concat(@comments)
    days: d.toJSON() for d in @days

module.exports = Menu