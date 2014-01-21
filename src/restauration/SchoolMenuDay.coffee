_ = require 'underscore'

SchoolComments = require './SchoolComments'
SchoolMenuCourse = require './SchoolMenuCourse'
{formatDayForJson} = require './SchoolUtils'

class SchoolMenuDay
  constructor: (@name,@date,@courses,@comments) ->

  @parseJson: (name,date,data) ->
    comments = SchoolComments.parseJson(data)
    courses = []
    for courseType in SchoolMenuCourse.allTypes
      loadedCourses = SchoolMenuCourse.parseJson(courseType,data[courseType])
      courses = courses.concat(loadedCourses)
    new  SchoolMenuDay(name,date,courses,comments)

  toString: -> "SchoolMenuDay(#{@name},#{@date},#{@courses},#{@comments})"

  formatJson: ->
    name: @name
    date: @date.toISOString()
    courses: for course in @courses then course.formatJson()
    comments: @comments.formatJson()

  addAll: (otherDay) ->
    otherCourses = course.clone() for course in otherDay.courses
    @courses=@courses.concat(otherCourses)
    @comments.addAll(otherDay.comments)
    return @

  coursesGroupedByType: =>
    grouped = _(@courses).sortBy((c)->c.order()).groupBy('type').value()
    output = {type: type, courses: courses} for type,courses of grouped

module.exports = SchoolMenuDay
