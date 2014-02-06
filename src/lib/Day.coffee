_ = require 'underscore'

{courseTypeToOrder} = require './Utils'

class Day
  constructor: (@name,@date,@courses,@comments)->

  addAll: (otherDay)->
    if otherDay?
      @comments=@comments.concat(otherDay.comments)
      @courses=@courses.concat(otherDay.courses)
    @

  coursesGroupedByType: (json=false)->
    orderFn = (course) -> course.order
    toJsonFn = (coll) ->
      if json then c.toJSON() for c in coll
      else coll
    mapFn = (courses,type) ->
      type: type
      order: courseTypeToOrder(type)
      courses: toJsonFn(courses)
    _.chain(@courses).sortBy('order').groupBy('type').map(mapFn).value()

  toJSON: ->
    output =
      name: @name
      date: @date.toJSON()
      coursesByType: @coursesGroupedByType(true)
      courses: c.toJSON() for c in @courses
      comments: [].concat(@comments)

module.exports = Day