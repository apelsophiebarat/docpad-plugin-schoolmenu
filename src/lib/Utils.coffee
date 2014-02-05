fsUtil = require 'fs'
_ = require 'underscore'
moment = require 'moment'
extendr = require 'extendr'

moment.lang('fr')

class Utils
  @readFileContent: readFileContent = (fullPath) ->
    fsUtil.readFileSync(fullPath,'UTF-8')

  @onlyInList: onlyInList = (list) -> (element) -> list.indexOf(element) > -1

  @asMoment: asMoment = (date,fmt='DD/MM/YYYY') ->
    if moment.isMoment(date) then date
    else if _.isString(date) then moment.utc(date,fmt)
    else if _.isDate(date) then moment.utc(date)
    else if _.isUndefined then moment.utc()
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

  @joinArrayWithParams: joinArrayWithParams = (array, params) ->
    {sep,prefix,suffix,lastSep} = params
    sep or= ','
    prefix or= ''
    suffix or= ''
    lastSep or= sep
    return joinArray(array,sep,prefix,suffix,lastSep)

  @joinArray: joinArray = (array,sep=',',prefix='',suffix='',lastSep=sep) ->
    return '' unless array and array.length > 0
    array = [].concat(array)
    if array.length > 1
      lastElem = array.pop()
      joinedArray = [array.join(sep),lastElem].join(lastSep)
    else
      joinedArray = array.join(sep)
    [prefix,joinedArray,suffix].join('')

  @simpleMergeObjects: simpleMergeObjects = (src,others...) ->
    params = [{},src].concat(others)
    extendr.deepExtend.apply(extendr,params)

  @mergeObjects: mergeObjects = (obj1,obj2) ->
    obj1 or= {}
    obj2 or= {}
    merged = {}
    #if both values are arrays then concat arrays
    for k,v1 of obj1
      v2 = obj2[k]
      if _.isArray(v1) and _.isArray(v2)
        merged[k] = v1.concat(v2)
    extendr.clone({},obj1,obj2,merged)

  @now: now = -> moment.utc()

  @parseDate: parseDate = (str,fmt) -> moment.utc(str,fmt)

  @weekdayName: weekdayName = (date) -> asMoment(date).format('dddd')

  @formatDayForJson: formatDayForJson = (date)-> asMoment(date).format('YYYY-MM-DD')

  @fromIsoString: fromIsoString = (str) -> moment.utc(new Date(str))

  @useDocpad: useDocpad = (docpad) -> @docpad = docpad

  @log : log = (level, msg) ->
    if @docpad?
      @docpad.log level, msg
    else
      console.log "#{level}: #{msg}"

  @trace : trace = (msg) -> log 'info',msg

  @warn : warn = (msg) -> log 'warn',msg

module.exports = Utils
