// Generated by CoffeeScript 1.6.3
(function() {
  var Utils, config, extendr, fsUtil, moment, _,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
    __slice = [].slice;

  fsUtil = require('fs');

  _ = require('underscore');

  moment = require('moment');

  extendr = require('extendr');

  moment.lang('fr');

  config = require('./Config').current();

  Utils = (function() {
    var asArray, asMoment, capitalize, courseTypeToOrder, formatDayForJson, fromIsoString, joinArray, joinArrayWithParams, log, lowercase, mergeObjects, now, onlyInList, parseDate, readFileContent, simpleMergeObjects, singularize, trace, trim, useDocpad, warn, weekdayName;

    function Utils() {}

    Utils.capitalize = capitalize = function(content) {
      return content.charAt(0).toUpperCase() + content.slice(1);
    };

    Utils.readFileContent = readFileContent = function(fullPath) {
      return fsUtil.readFileSync(fullPath, 'UTF-8');
    };

    Utils.onlyInList = onlyInList = function(list) {
      return function(element) {
        return list.indexOf(element) > -1;
      };
    };

    Utils.asMoment = asMoment = function(date, fmt) {
      if (fmt == null) {
        fmt = 'DD/MM/YYYY';
      }
      if (moment.isMoment(date)) {
        return date;
      } else if (_.isString(date)) {
        return moment.utc(date, fmt);
      } else if (_.isDate(date)) {
        return moment.utc(date);
      } else if (_.isUndefined) {
        return moment.utc();
      } else {
        throw "invalid date " + date;
      }
    };

    Utils.trim = trim = function(s) {
      return s != null ? s.trim() : void 0;
    };

    Utils.lowercase = lowercase = function(s) {
      return s != null ? s.toLowerCase() : void 0;
    };

    Utils.singularize = singularize = function(s, exceptions) {
      var lastPos, len;
      if (s != null) {
        len = s.length;
        lastPos = s.lastIndexOf('s');
        if (__indexOf.call(exceptions, s) >= 0) {
          return s;
        }
        if (lastPos === len - 1) {
          return s.substr(0, len - 1);
        }
      }
      return s;
    };

    Utils.asArray = asArray = function(value, fn) {
      if (fn == null) {
        fn = trim;
      }
      if (_.isString(value)) {
        return new Array(fn(value));
      } else if (_.isArray(value)) {
        return _.map(value, fn);
      } else {
        return [];
      }
    };

    Utils.joinArrayWithParams = joinArrayWithParams = function(array, params) {
      var lastSep, prefix, sep, suffix;
      sep = params.sep, prefix = params.prefix, suffix = params.suffix, lastSep = params.lastSep;
      sep || (sep = ',');
      prefix || (prefix = '');
      suffix || (suffix = '');
      lastSep || (lastSep = sep);
      return joinArray(array, sep, prefix, suffix, lastSep);
    };

    Utils.joinArray = joinArray = function(array, sep, prefix, suffix, lastSep) {
      var joinedArray, lastElem;
      if (sep == null) {
        sep = ',';
      }
      if (prefix == null) {
        prefix = '';
      }
      if (suffix == null) {
        suffix = '';
      }
      if (lastSep == null) {
        lastSep = sep;
      }
      if (!(array && array.length > 0)) {
        return '';
      }
      array = [].concat(array);
      if (array.length > 1) {
        lastElem = array.pop();
        joinedArray = [array.join(sep), lastElem].join(lastSep);
      } else {
        joinedArray = array.join(sep);
      }
      return [prefix, joinedArray, suffix].join('');
    };

    Utils.simpleMergeObjects = simpleMergeObjects = function() {
      var others, params, src;
      src = arguments[0], others = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      params = [{}, src].concat(others);
      return extendr.deepExtend.apply(extendr, params);
    };

    Utils.mergeObjects = mergeObjects = function(obj1, obj2) {
      var k, merged, v1, v2;
      obj1 || (obj1 = {});
      obj2 || (obj2 = {});
      merged = {};
      for (k in obj1) {
        v1 = obj1[k];
        v2 = obj2[k];
        if (_.isArray(v1) && _.isArray(v2)) {
          merged[k] = v1.concat(v2);
        }
      }
      return extendr.clone({}, obj1, obj2, merged);
    };

    Utils.now = now = function() {
      return moment.utc();
    };

    Utils.parseDate = parseDate = function(str, fmt) {
      return moment.utc(str, fmt);
    };

    Utils.weekdayName = weekdayName = function(date) {
      return asMoment(date).format('dddd');
    };

    Utils.formatDayForJson = formatDayForJson = function(date) {
      return asMoment(date).format('YYYY-MM-DD');
    };

    Utils.fromIsoString = fromIsoString = function(str) {
      return moment.utc(new Date(str));
    };

    Utils.useDocpad = useDocpad = function(docpad) {
      return this.docpad = docpad;
    };

    Utils.log = log = function(level, msg) {
      if (this.docpad != null) {
        return this.docpad.log(level, msg);
      } else {
        return console.log("" + level + ": " + msg);
      }
    };

    Utils.trace = trace = function(msg) {
      return log('debug', msg);
    };

    Utils.warn = warn = function(msg) {
      return log('warn', msg);
    };

    Utils.courseTypeToOrder = courseTypeToOrder = function(type) {
      return config.courseTypes.indexOf(type);
    };

    return Utils;

  })();

  module.exports = Utils;

}).call(this);