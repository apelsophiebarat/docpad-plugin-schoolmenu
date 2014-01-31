extendr = require 'extendr'
_ = require 'underscore'
{TaskGroup} = require('taskgroup')

Parser = require './lib/Parser'
{now,mergeObjects,joinArray,trace,useDocpad} = require './lib/Utils'

# Export Plugin
module.exports = (BasePlugin) ->
  # Define Plugin
  class SchoolMenuPlugin extends BasePlugin
    # Plugin name
    name: 'schoolmenu'

    config:
      writeAddedMeta: false
      writeMeta: false
      templateData:
        now: -> now()
      defaultMeta:
        isMenu: true
        renderSingleExtensions: true
      query:
        relativeOutDirPath: $startsWith: 'menus'
      sorting:
        [basename:-1]
      paging:
        undefined

    priority: 1000

    extendCollections: (opts) ->
      # Prepare
      useDocpad(@docpad)
      me = @
      docpad = @docpad
      useDocpad(docpad)
      config = @getConfig()
      {query,sorting,paging} = config

      files = docpad.getFiles(query,sorting,paging)
      files.on 'add', (model) ->
        trace("add menu #{model.getFilePath()}")
        model.setMetaDefaults(config.defaultMeta)

      # Chain
      @

    extendTemplateData: (opts) ->
      # Prepare
      useDocpad(@docpad)
      {templateData} = opts
      config = @getConfig()
      # Inject template helpers into template data
      for own templateHelperName, templateHelper of config.templateData
        templateData[templateHelperName] = templateHelper

      # Chain
      @

    renderMeta = (menu,templateData) ->
      meta =
        title: templateData.prepareMenuTitle(menu)
        date: menu.date.toDate()
        description: templateData.prepareMenuDescription(menu)
        tags: menu.schoolLevels

    # Render
    # Called per document, for each extension conversion. Used to render one extension to another.
    render: (opts) ->
      # Prepare
      docpad = @docpad
      me = @
      {inExtension,outExtension,file,templateData} = opts
      {defaultMeta,writeMeta,writeAddedMeta} = @getConfig()
      # Upper case the text file's content if it is using the convention txt.(uc|uppercase)
      if inExtension in ['menu']
        # Prepare
        basename = file.get("basename")
        relativePath = file.get("relativePath")
        fullPath = file.get("fullPath")
        outPath = file.get("outPath")
        content = file.get("content")
        # Parse content
        menu = Parser.parseFromPath(basename,relativePath,fullPath,content)
        # Add content to template data 'menu'
        templateData.menu = menu
        # Update document metas
        metaFromMenu = renderMeta(menu,templateData)
        meta = extendr.extend {},metaFromMenu,file.getMeta().toJSON()
        file.setMeta(meta)
        if writeMeta or writeAddedMeta
          if writeAddedMeta
            menu.meta = extendr.deepClone(defaultMeta,metaFromMenu)
          else
            menu.meta = extendr.deepClone(meta)
        # Write json content
        opts.content = JSON.stringify(menu,null,'	')
      # Done
      @

    renderAfter: (opts) ->
      {collection} = opts


