_ = require 'underscore'

{joinArray,mergeObjects} = require './SchoolUtils'

class SchoolMenuContext
  constructor: (@week,file,@defaultMeta,@defaultInfo) ->
      @fileDate = file.getDate()
      @fileTags = file.getTags()

  getSchooLevels: -> _.filter @fileTags, (t) -> schoolLevels.indexOf(t) > -1

  getPreparedTitleLong: ->
    schoolLevels = joinArray(@getSchooLevels(),', ','pour ','',' et ')
    from = @week.from.format('DD MMMM YYYY')
    to = @week.to.format('DD MMMM YYYY')
    "Menu #{schoolLevels} de la semaine du #{from} au #{to}"

  getPreparedTitle: ->
    from = @week.from.format('DD MMMM YYYY')
    to = @week.to.format('DD MMMM YYYY')
    "Menu pour la semaine du #{from} au #{to}"

  getPreparedTitleShort: ->
    from = @week.from.format('DD MMM')
    to = @week.to.format('DD MMM YYYY')
    "Menu du #{from} au #{to}"

  getPreparedTitleNav: ->
    from = @week.from.format('DD MMM YYYY')
    to = @week.to.format('DD MMM YYYY')
    "#{from} --> #{to}"

  getMetaForDocument: ->
    meta =
      title: @getPreparedTitle()
      date: @fileDate.toDate()
      description: @getPreparedTitleLong()
      author: '???'
      tags: @getSchooLevels()
    mergeObjects(meta,@defaultMeta)
    
  getContextInfoForContent: ->
    info =
      from: @week.from
      to: @week.to
      year: @fileDate.year()
      month: @fileDate.month()+1
      simpleTitle: @getPreparedTitle()
      longTitle: @getPreparedTitleLong()
      shortTitle: @getPreparedTitleShort()
      navTitle: @getPreparedTitleNav()
      schoolLevels: @getSchooLevels()
      days: @week.days()
    mergeObjects(info,@defaultInfo)

module.exports = SchoolMenuContext