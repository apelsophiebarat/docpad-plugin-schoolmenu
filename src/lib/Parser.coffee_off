_ = require 'underscore'

MenuFile = require './MenuFile'
Week = require './Week'
{trace,warn,mergeObjects,fromIsoString,trim,now,weekdayName} = require './Utils'

class Parser

  @parseFromPath: (basename,relativePath,fullPath,content) ->
    file = new MenuFile(basename,relativePath,fullPath,content)
    @parseFromFile(file)

  @parseFromFile:(file) ->
    menuContent = file.getMenuContent()
    unless menuContent?
      warn("menu content is undefined for #{file.toString()}")
      return undefined
    week = parseWeek(file)
    comments = parseComments(menuContent)
    days = parseDays(menuContent,week)
    menu =
      isMenu:true
      week: week
      schoolLevels: file.getSchoolLevels()
      date: file.getDate()
      comments: comments
      days: days

  parseWeek = (file) -> new Week(fromIsoString(file.getDate()))

  parseComments = (doc) ->
    comments = doc.comment or doc.commentaire or doc.remarque or []

  parseDays = (menuContent,week) ->
    menuDays =[]
    if menuContent.tous?
      tous = parseDay('tous',now(),menuContent.tous)
    for day in week.days()
      name = weekdayName(day)
      daymenuContent  = menuContent[name]
      if daymenuContent?
        menuDay = parseDay(name,day,daymenuContent)
        menuDay = mergeDays(menuDay,tous) if menuContent.tous?
        menuDays.push menuDay
    menuDays

  mergeDays = (menuDay, allDay) ->
    menuDay.comments = mergeObjects(menuDay.comments, allDay.comments)
    menuDay.courses = menuDay.courses.concat(allDay.courses or [])
    menuDay

  courseTypes = ['entree','plat','legume','dessert']
  parseDay = (name,date,data) ->
    comments = parseComments(data)
    courses = []
    for courseType in courseTypes
      if data[courseType]
        loadedCourses = parseCourses(courseType, data[courseType])
        courses = courses.concat(loadedCourses)
    day =
      name: weekdayName(date)
      date: date
      comments: comments
      courses: courses

  parseCourses = (courseType, data) ->
    descriptions = parseCourseDescriptions(data)
    courses = for description in descriptions
      type: courseType
      description: description
      order: courseTypes.indexOf(courseType)

  parseCourseDescriptions = (data) ->
    if _.isString(data)
      descriptions = data.trim().split('/')
      descriptions = _.map(descriptions,trim)
    else if _.isArray(data)
      descriptions = _.map(data,parseCourseDescriptions)
      descriptions = _.flatten(descriptions)
    else
      descriptions = []
    return descriptions

module.exports = Parser