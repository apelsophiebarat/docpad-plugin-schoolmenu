_ = require 'underscore'
cson = require 'cson'
frontMatter = require 'yaml-front-matter'

MenuFileName = require './MenuFileName'
Menu = require './Menu'
Day = require './Day'
Course = require './Course'
{normalize} = require './Normalizer'
{courseTypes} = require('./Config').current()
{weekdayName,now,trim,asArray,readFileContent} = require './Utils'

class MenuParser
  checkStringParameter = (name,value) ->
    throw "invalid #{name} " unless value? and value.length>0

  checkParameters = (fileName,content) ->
    checkStringParameter 'fileName', fileName
    checkStringParameter 'content', content

  @safeParseFileContent: safeParseFileContent = (fileName,content) ->
    try checkParameters(fileName,content)
    catch error then return ''
    new MenuParser().parse(fileName,content)

  @parseFileContent: parseFileContent = (fileName,content) ->
    checkParameters(fileName,content)
    new MenuParser().parse(fileName,content)

  @safeParseFromFile: (fileName,fullPath) ->
    safeParseFileContent fileName,readFileContent(fullPath)

  @parseFromFile: (fileName,fullPath) ->
    parseFileContent fileName,readFileContent(fullPath)

  extractMetaAndContent = (rawContent) ->
    contentAndMeta = frontMatter.loadFront(rawContent)
    content = cson.parseSync(contentAndMeta.__content)
    delete(contentAndMeta.__content)
    meta = contentAndMeta
    return [content,meta]

  parse: (fileName,content) ->
    @fileName = new MenuFileName(fileName)
    [content,@meta] = extractMetaAndContent(content)
    @content = normalize(content)
    comments = @parseComments(@content)
    baseDay = @parseDay(now(),@content.tous,'tous') if @content.tous?
    days = @parseDays(@content,@fileName.week,baseDay)
    {week,schoolLevels}=@fileName
    new Menu(week,schoolLevels,days,comments)

  parseComments: (data)->
    comments = data?.comment or data?.commentaire or data?.remarque or []
    comments = asArray(comments)

  parseDay: (date,data,name) ->
    comments = @parseComments(data)
    courses = []
    for courseType in courseTypes
      if data[courseType]
        loadedCourses = @parseCourses(courseType, data[courseType])
        courses = courses.concat(loadedCourses)
    name = weekdayName(date) unless name?
    new Day(name,date,courses,comments)

  parseCourses: (courseType, data) ->
    descriptions = @parseDescriptions(data)
    courses = for description in descriptions
      new Course(courseType,description)

  parseDescriptions: (data) ->
    if _.isString(data)
      descriptions = data.trim().split('/')
      descriptions = _.map(descriptions,trim)
    else if _.isArray(data)
      descriptions = _.map(data,@parseDescriptions)
      descriptions = _.flatten(descriptions)
    else
      descriptions = []
    return descriptions

  parseDays: (menuContent,week,baseDay) ->
    menuDays =[]
    for day in week.days()
      name = weekdayName(day)
      dayData  = menuContent[name]
      if dayData?
        menuDay = @parseDay(day,dayData)
        menuDay.addAll(baseDay) if baseDay?
        menuDays.push menuDay
    return menuDays

  asJSON: -> if @menu? then @menu.toJSON() else {}

module.exports = MenuParser