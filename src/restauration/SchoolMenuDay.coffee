SchoolComments = require './SchoolComments'
SchoolMenuCourse = require './SchoolMenuCourse'
{formatDayForJson} = require './SchoolUtils'

class SchoolMenuDay
  constructor: (@name,@date,@courses,@comments) ->

  toString: -> JSON.stringify(@)

  toJSON: ->
    name: @name
    date: formatDayForJson(@date)
    courses: @courses
    comments: @comments

  addAll: (otherDay) ->
    otherCourses = course.clone() for course in otherDay.courses
    @courses=@courses.concat(otherCourses)
    @comments.addAll(otherDay.comments)
    return @

  @fromJSON: (name,date,data) ->
    comments = SchoolComments.fromJSON(data)
    courses = []
    for courseType,coursesData of data
      if SchoolMenuCourse.isValidType(courseType)
        loadedCourses = SchoolMenuCourse.fromJSON(courseType,coursesData)
        courses = courses.concat(loadedCourses)
    new  SchoolMenuDay(name,date,courses,comments)

module.exports = SchoolMenuDay
