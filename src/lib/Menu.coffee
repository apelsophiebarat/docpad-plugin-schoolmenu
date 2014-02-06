config = require('./Config').current()

class Menu
  constructor: (@menuFileName,@days,@comments) ->
    @week = @menuFileName.week
    @schoolLevels = @menuFileName.schoolLevels

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
    fileName: @menuFileName.toJSON()
    comments: @comments
    days: d.toJSON() for d in @days

module.exports = Menu