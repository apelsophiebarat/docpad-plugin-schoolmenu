_ = require 'underscore'
{joinArrayWithParams} = require './Utils'

class Formatter
  constructor: (@config,@menu) ->
    throw "configuration required" unless @config?
    throw "menu required" unless @menu?
    # prepare templates
    @templates = {}
    # mustache style
    _.templateSettings = interpolate: /\{\{(.+?)\}\}/g

  formatWeekRange: (format) ->
    fromFmt = @config.getFormat('from',format)
    toFmt = @config.getFormat('to',format)
    output =
      from: @menu.week.from.format(fromFmt)
      to: @menu.week.to.format(toFmt)

  formatOptionalSchoolLevels: (format) ->
    fmt = @config.getOptionalFormat('schoolLevels',format)
    joinArrayWithParams(@menu.schoolLevels,fmt) if fmt?

  getTemplate: (type,format) ->
    typeTemplates = @templates[type] or= {}
    template = typeTemplates[format] or= _.template(@config.getFormat(type,format))

  formatTitle: (format) ->
    {from,to} = @formatWeekRange(format)
    schoolLevels = @formatOptionalSchoolLevels(format)
    data =
      from:from
      to:to
      schoolLevels:schoolLevels
    @getTemplate('title',format)(data)

module.exports = Formatter