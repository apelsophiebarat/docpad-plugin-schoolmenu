frontMatter = require 'yaml-front-matter'
cson = require 'cson'
extendr = require 'extendr'
_ = require 'underscore'

SchoolMenuFile = require './SchoolMenuFile'
SchoolMenu = require './SchoolMenu'
{normalizeMenu} = require './SchoolMenuNormalizer'

splitMetaAndData = (rawContent) ->
  contentAndMeta = frontMatter.loadFront(rawContent)
  data = contentAndMeta.__content
  delete contentAndMeta.__content
  meta = contentAndMeta
  output =
    meta: meta
    data: data

parseMenu = (rawContent) ->
  {meta,data}=splitMetaAndData(rawContent)
  output =
    meta: meta
    data: normalizeMenu cson.parseSync(data)

parseJson = (rawContent) ->
  {meta,data}=splitMetaAndData(rawContent)
  output =
    meta:meta
    data:JSON.parse(data)

mergeMeta = (meta1,meta2) ->
  meta1 or= {}
  meta2 or= {}
  merged = {}
  #if both values are arrays then concat arrays
  for k,v1 of meta1
    v2 = meta2[k]
    if _.isArray(v1) and _.isArray(v2)
      merged[k] = v1.concat(v2)
  extendr.clone({},meta1,meta2,merged)

class SchoolMenuParser
  @parseFromPath: (basename,path,outpath) ->
    file = new SchoolMenuFile(basename,path,outpath)
    @parseFromFile(file)

  @parseFromFile:(file) ->
    date = file.getDate()
    {meta,data} =
      if file.getExtension() == '.menu'
        parseMenu file.getContent()
      else
        JSON.parse file.getContent()
    doc =
      data: data
      meta: mergeMeta(meta,file.getMeta())
    @parseFromJson(doc)

  @parseFromJson: (doc) -> SchoolMenu.parseJson(doc)

module.exports = SchoolMenuParser