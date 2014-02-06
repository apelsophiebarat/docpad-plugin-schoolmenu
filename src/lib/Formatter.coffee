_ = require 'underscore'
{joinArrayWithParams,capitalize} = require './Utils'

class Formatter
  constructor: (@config,@menu) ->
    throw "configuration required" unless @config?
    throw "menu required" unless @menu?
    # prepare templates
    @templates = {}
    # mustache style
    _.templateSettings = interpolate: /\{\{(.+?)\}\}/g

  formatWeekRange: (type,format) ->
    fromFmt = @config.getFormat(type,format,'from')
    toFmt = @config.getFormat(type,format,'to')
    output =
      from: @menu.week.from.format(fromFmt)
      to: @menu.week.to.format(toFmt)

  getTemplate: (type,format) ->
    typeTemplates = @templates[type] or= {}
    template = typeTemplates[format] or= _.template(@config.getFormat(type,format,'template'))


  formatTitleOrDescription: (type,format) ->
    {from,to} = @formatWeekRange(type,format)
    schoolLevels = @formatOptionalSchoolLevels(format)
    data =
      from:from
      to:to
      schoolLevels:schoolLevels
    @getTemplate(type,format)(data)

  formatTitle: (format) -> @formatTitleOrDescription('title',format)

  formatDescription: (format) -> @formatTitleOrDescription('description',format)

  formatSchoolLevels: (format) ->
    joinOptions = @config.getFormat('schoolLevels',format,'join')
    joinArrayWithParams(@menu.schoolLevels,joinOptions)

  formatOptionalSchoolLevels: (format) ->
    joinOptions = @config.getOptionalFormat('schoolLevels',format,'join')
    joinArrayWithParams(@menu.schoolLevels,joinOptions) if joinOptions?

  ###
  Generate some output like this :
    title:
      long: "..."
      short: "..."
    description:
      standard: "..."
      nav: "..."
  ###
  toJSON: () =>
    output = {}
    for type in @config.getFormatTypes()
      output[type]={}
      fnName = 'format'+capitalize(type)
      for name in @config.getFormatNames(type)
        output[type][name] = @[fnName](name)
    output

module.exports = Formatter