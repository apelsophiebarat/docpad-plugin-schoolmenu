_ = require 'underscore'

{trim} = require './SchoolUtils'

prepareDescriptions = (data) ->
  if _.isString(data)
    descriptions = data.trim().split('/')
    descriptions = _.map(descriptions,trim)
  else if _.isArray(data)
    descriptions = _.map(data,prepareDescriptions)
    descriptions = _.flatten(descriptions)
  else
    descriptions = []
  return descriptions

class SchoolMenuCourse
  constructor: (@type, @description) ->

  @allTypes = allTypes = ['entree','plat','legume','dessert']

  ###
  datas can be :
    a single string : can be split by '/'
    an array of strings
    in a future maybe an object or an array of strings and/or objects
  ###
  @parseJson: (type,datas) ->
    courses = []
    for description in prepareDescriptions(datas)
      course = new SchoolMenuCourse(type,description)
      courses.push(course)
    return courses

  toString: -> "SchoolMenuCourse(#{@type}, #{@description})"

  formatJson: ->
    type: @type
    description: @description

  clone: -> new SchoolMenuCourse(@type, @description)

  order: -> allTypes.indexOf(@type) or -1

module.exports = SchoolMenuCourse