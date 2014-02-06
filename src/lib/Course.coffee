{courseTypeToOrder} = require './Utils'

class Course
  constructor: (@type, @description) ->
    @order = courseTypeToOrder(type)

  toJSON: ->
    type: @type
    description: @description
    order: @order

module.exports = Course