_ = require 'lodash'
moment = require 'moment'

moment.lang('fr')

class SchoolUtils
  @asMoment: asMoment = (date,fmt='DD/MM/YYYY') ->
    if date
      if moment.isMoment(date) then date
      if _.isString(date) then moment(date,fmt)
      else moment(date)
    else
      moment()

  @trim: trim = (s) -> s?.trim()

  @lowercase: lowercase = (s) -> s?.toLowerCase()

  @singularize: singularize = (s,exceptions) ->
    if s?
      len = s.length
      lastPos = s.lastIndexOf('s')
      return s if exceptions and _.indexOf(exceptions,s)>-1
      return s.substr(0,len-1) if lastPos == len-1
    return s

  @asArray: asArray = (value,fn=trim) ->
    if _.isString(value)
      new Array(fn(value))
    else if _.isArray(value)
      _.map(value,fn)
    else
      []

module.exports = SchoolUtils
