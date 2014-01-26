_ = require 'underscore'

{trim,lowercase,singularize} = require './Utils'
###
 1 - for all keys:
  1.1 - to lower case
  1.2 - singular
 2 - for all values
  2.1 - if value is a string transform to array of trimmed string
  2.2 - if value is an array of string transform to array of trimmed values
###
class Normalizer
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
    if _.isString(v)
      normalized = v.trim()
    else if _.isArray(v)
      normalized = []
      normalized.push(normalizeValue(vv)) for vv in v
    else if _.isObject(v)
      normalized = normalizeData(v)
    else
      normalized = v
    return normalized

module.exports = Normalizer
