Formatter = require './Formatter'
config = require('./Config').current()

class Menu
  constructor: (@menuFileName,@days,@comments) ->
    @week = @menuFileName.week
    @schoolLevels = @menuFileName.schoolLevels
    @formatter = new Formatter(config,@)

  generateDaysUrl: (baseUrl) ->
    urls=[]
    groups = config.urlRegexpPattern.exec(baseUrl)
    if groups?
      prefix = groups[1]
      suffix = groups[2]
      for day in @week.days()
        url = [prefix,day.format('YYYY-MM-DD'),suffix].join('')
        urls.push(url)
    return urls

  toJSON: =>
    isMenu: true
    week: @week.toJSON()
    schoolLevels: [].concat(@schoolLevels)
    comments: [].concat(@comments)
    days: d.toJSON() for d in @days
    format: @formatter.toJSON()

module.exports = Menu