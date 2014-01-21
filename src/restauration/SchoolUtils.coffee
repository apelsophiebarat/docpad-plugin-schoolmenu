_ = require 'underscore'
moment = require 'moment'

moment.lang('fr')

class SchoolUtils
  @asMoment: asMoment = (date,fmt='DD/MM/YYYY') ->
    if moment.isMoment(date) then date
    else if _.isString(date) then moment(date,fmt)
    else if _.isDate(date) then moment(date)
    else if _.isUndefined then moment()
    else throw "invalid date #{date}"

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

  @now: now = -> moment()

  @parseDate: parseDate = (str,fmt) -> moment(str,fmt)

  @weekdayName: weekdayName = (date) -> asMoment(date).format('dddd')

  @formatDayForJson: formatDayForJson = (date)-> asMoment(date).format('YYYY-MM-DD')

  @fromIsoString: fromIsoString = (str) -> moment(new Date(str))

module.exports = SchoolUtils
