extendr = require 'extendr'

{mergeObjects,warn,trace,useDocpad} = require './Utils'
{safeParseFileContent} = require './MenuParser'

class PluginDelegate

  constructor: (@docpad,@pluginConfig) ->
    useDocpad(@docpad)
    @database = @docpad.database


  extendCollections: (opts) ->
    {query,defaultMeta} = @pluginConfig
    collection = @database.createLiveChildCollection()
    collection.setQuery 'isMenu', query
    collection.on 'add', (model) ->
      trace("add menu #{model.getFilePath()}")
      model.setMetaDefaults(defaultMeta)
    docpad.setCollection('isMenu',collection)
    @

  extendTemplateData: (opts) ->
    {templateData} = opts
    # Inject template helpers into template data
    for own templateHelperName, templateHelper of @pluginConfig.templateData
      templateData[templateHelperName] = templateHelper
    @

  renderBefore: (opts) ->
    {templateData} = opts
    templateData.menus ?= []
    @

  renderAfter: (opts) ->
    {collection} = opts
    @

  render: (opts) ->
    {inExtension,outExtension,file,templateData} = opts
    {defaultMeta,writeMeta,writeAddedMeta} = @pluginConfig

    if inExtension in ['menu']
      # Prepare
      basename = file.get("basename")
      relativePath = file.get("relativePath")
      fullPath = file.get("fullPath")
      outPath = file.get("outPath")
      content = file.get("content")
      if content.length == 0
        trace("can not create a file from #{relativePath}")
        return @
      # Parse content
      menu = safeParseFileContent(relativePath,content)
      return @ unless menu?
      templateData.menu = menu
      file.set('menu',menu)
      # Add urls for each day
      urls = menu.generateDaysUrl(file.get('url'))
      file.addUrl(urls)
      # Update document metas
      metaFromMenu =
        title: menu.formatter.formatTitle('standard')
        description: menu.formatter.formatDescription('standard')
        tags: [].concat(menu.schoolLevels)
        date: menu.week.from.toDate()
      updatedMeta = mergeObjects(file.getMeta().toJSON(),metaFromMenu)
      file.setMeta(updatedMeta)
      content =
        menu: menu.toJSON()
      if writeMeta or writeAddedMeta
        content.meta = extendr.deepClone(defaultMeta,metaFromMenu) if writeAddedMeta
        content.meta = extendr.deepClone(updatedMeta) if writeMeta
      # Write json content
      opts.content = JSON.stringify(content,null,' ')
    # Done
    @

module.exports = PluginDelegate
