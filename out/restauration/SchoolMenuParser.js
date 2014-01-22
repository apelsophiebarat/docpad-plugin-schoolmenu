// Generated by CoffeeScript 1.6.3
(function() {
  var SchoolMenu, SchoolMenuFile, SchoolMenuParser, cson, extendr, frontMatter, mergeMeta, normalizeMenu, parseJson, parseMenu, splitMetaAndData, _;

  frontMatter = require('yaml-front-matter');

  cson = require('cson');

  extendr = require('extendr');

  _ = require('underscore');

  SchoolMenuFile = require('./SchoolMenuFile');

  SchoolMenu = require('./SchoolMenu');

  normalizeMenu = require('./SchoolMenuNormalizer').normalizeMenu;

  splitMetaAndData = function(rawContent) {
    var contentAndMeta, data, meta, output;
    contentAndMeta = frontMatter.loadFront(rawContent);
    data = contentAndMeta.__content;
    delete contentAndMeta.__content;
    meta = contentAndMeta;
    return output = {
      meta: meta,
      data: data
    };
  };

  parseMenu = function(rawContent) {
    var data, meta, output, _ref;
    _ref = splitMetaAndData(rawContent), meta = _ref.meta, data = _ref.data;
    return output = {
      meta: meta,
      data: normalizeMenu(cson.parseSync(data))
    };
  };

  parseJson = function(rawContent) {
    var data, meta, output, _ref;
    _ref = splitMetaAndData(rawContent), meta = _ref.meta, data = _ref.data;
    return output = {
      meta: meta,
      data: JSON.parse(data)
    };
  };

  mergeMeta = function(meta1, meta2) {
    var k, merged, v1, v2;
    meta1 || (meta1 = {});
    meta2 || (meta2 = {});
    merged = {};
    for (k in meta1) {
      v1 = meta1[k];
      v2 = meta2[k];
      if (_.isArray(v1) && _.isArray(v2)) {
        merged[k] = v1.concat(v2);
      }
    }
    return extendr.clone({}, meta1, meta2, merged);
  };

  SchoolMenuParser = (function() {
    function SchoolMenuParser() {}

    SchoolMenuParser.parseFromPath = function(basename, path, outpath) {
      var file;
      file = new SchoolMenuFile(basename, path, outpath);
      return this.parseFromFile(file);
    };

    SchoolMenuParser.parseFromFile = function(file) {
      var data, date, doc, meta, _ref;
      date = file.getDate();
      _ref = file.getExtension() === '.menu' ? parseMenu(file.getContent()) : JSON.parse(file.getContent()), meta = _ref.meta, data = _ref.data;
      doc = {
        data: data,
        meta: mergeMeta(meta, file.getMeta())
      };
      return this.parseFromJson(doc);
    };

    SchoolMenuParser.parseFromJson = function(doc) {
      return SchoolMenu.parseJson(doc);
    };

    return SchoolMenuParser;

  })();

  module.exports = SchoolMenuParser;

}).call(this);
