_ = require 'lodash'

{trim} = require './SchoolUtils'

class SchoolMenuCourse
  constructor: (@type, @description) ->

  clone: -> new SchoolMenuCourse(@type, @description)

  toString: -> JSON.stringify(@)

  order: -> allTypes.indexOf(@type)

  allTypes = ['entree','plat','legume','dessert']

  @isValidType: (type) -> allTypes.indexOf(type) > -1

  ###
  datas can be :
    a single string : can be split by '/'
    an array of strings
    in a future maybe an object or an array of strings and/or objects
  ###
  @fromJSON: (type,datas) ->
    courses = []
    for data in prepareJsonData(datas)
      course = fromSingleJSON(type,data)
      courses.push(course)
    return courses

  prepareJsonData = (data) ->
    if _.isString(data)
      descriptions = data.trim().split('/')
      descriptions = _.map(descriptions,trim)
    else if _.isArray(data)
      descriptions = _(data).map(prepareJsonData).flatten().value()
    else
      descriptions = []
    return descriptions

  @fromSingleJSON: fromSingleJSON = (type,data) ->
    description = prepareJsonData(data).pop()
    throw "fromSingleJSON error : invalid data #{data}" unless description?
    new SchoolMenuCourse(type,description)

module.exports = SchoolMenuCourse