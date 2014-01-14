_ = require 'lodash'

{trim,lowercase,singularize} = require './SchoolUtils'
###
 1 - for all keys:
  1.1 - to lower case
  1.2 - singular
 2 - for all values
  2.1 - if value is a string transform to array of trimmed string
  2.2 - if value is an array of string transform to array of trimmed values
###
class SchoolMenuNormalizer
  @normalizeMenu: (data) ->
    normalizeData(data) if data?

  normalizeData = (data) ->
    normalized = {}
    for own key,value of data
      nk = normalizeKey(key)
      nv = normalizeValue(value)
      normalized[nk]=nv
    normalized

  normalizeKey = (key) ->
    singularize(lowercase(trim(key)),['tous'])

  normalizeValue = (v) ->
    normalized = v
    if v?
      normalized = normalizeData(v) if _.isObject(v)
      normalized = new Array(v.trim()) if _.isString(v)
      if(_.isArray(v))
        normalized = []
        for vv in v
          normalized.push(normalizeValue(vv))
    return normalized

module.exports = SchoolMenuNormalizer
