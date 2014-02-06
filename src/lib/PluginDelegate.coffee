extendr = require 'extendr'

utils = require './Utils'
{mergeObjects,warn,trace,useDocpad} = utils
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
    templateData.menuUtils = utils
    # Inject template helpers into template data
    for own templateHelperName, templateHelper of @pluginConfig.templateData
      templateData[templateHelperName] = templateHelper
    @

  contextualizeAfter: (opts) ->
    {collection} = opts
    #console.log collection.toArray().length
    #docs = collection.findAll(@pluginConfig.query).models
    #_ = require 'underscore'
    #menus = _.chain(docs).filter((doc)->doc.get("menu")?).value()
    #console.log "menus:"+menus?.length
    #.filter((doc)->doc.get("menu")?).toArray().length
    #.forEach (document)->
    #console.log("contextualize #{document.url}")
    @

  renderBefore: (opts) ->
    {templateData} = opts
    @

  renderAfter: (opts) ->
    {collection} = opts
    @

  render: (opts) ->
    {inExtension,outExtension,file,templateData} = opts
    {defaultMeta,writeMeta,writeAddedMeta} = @pluginConfig
    if inExtension in ['menu']
      # Prepare
      relativePath = file.get("relativePath")
      content = file.get("content")
      if content.length == 0
        trace("can not create a file from #{relativePath}")
        return @
      # Parse content
      menu = safeParseFileContent(relativePath,content)
      return @ unless menu?
      menuData = menu.toJSON()
      templateData.menu = menuData
      # Add urls for each day
      urls = menu.generateDaysUrl(file.get('url'))
      file.addUrl(urls)
      # Update document metas
      metaFromMenu =
        title: templateData.prepareMenuTitle(menuData)
        description: templateData.prepareMenuDescription(menuData)
        tags: [].concat(menuData.fileName.schoolLevels)
        date: menuData.fileName.week.from
      updatedMeta = mergeObjects(file.getMeta().toJSON(),metaFromMenu)
      file.setMeta(updatedMeta)
      content =
        menu: menuData
      if writeMeta or writeAddedMeta
        content.meta = extendr.deepClone(defaultMeta,metaFromMenu) if writeAddedMeta
        content.meta = extendr.deepClone(updatedMeta) if writeMeta
      # Write json content
      opts.content = JSON.stringify(content,null,' ')
    # Done
    @

module.exports = PluginDelegate
