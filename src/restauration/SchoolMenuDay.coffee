_ = require 'underscore'

SchoolComments = require './SchoolComments'
SchoolMenuCourse = require './SchoolMenuCourse'
{formatDayForJson} = require './SchoolUtils'

class SchoolMenuDay
  constructor: (@name,@date,@courses,@comments) ->

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
    sorted = _.sortBy(@courses,(c)->c.order())
    grouped = _.groupBy(sorted,'type')
    output = {type: type, courses: courses} for type,courses of grouped

module.exports = SchoolMenuDay
