{courseTypes} = require('./Config').current()

class Course
  constructor: (@type, @description) ->
    @order = courseTypes.indexOf(type)

  toJSON: ->
    type: @type
    description: @description
    order: @order

module.exports = Course