pathUtil = require 'path'
_ = require 'underscore'

Week = require './Week'
{asMoment,onlyInList} = require './Utils'
{regexpPattern,schoolLevels} = require('./Config').current()

class MenuFileName
  constructor: (filename)->
    throw "filename required" unless filename?
    basename = pathUtil.basename filename
    unless parameters = basename.match(regexpPattern)
      throw "#{basename} invalid basename : must respect #{regexpPattern}"
    [@basename,year,month,day,tags] = parameters
    date = asMoment("#{year}/#{month}/#{day}","YYYY/MM/DD")
    @week = new Week(date)
    @tags = if tags then tags.split('-') else []
    @schoolLevels = _.filter @tags, onlyInList(schoolLevels)
    @extension= pathUtil.extname(filename)

  toJSON: ->
    basename: @basename
    extension: @extension
    tags: @tags
    schoolLevels: @schoolLevels
    week: @week.toJSON()
    year: @week.from.year()
    month: @week.from.month()+1

module.exports = MenuFileName
