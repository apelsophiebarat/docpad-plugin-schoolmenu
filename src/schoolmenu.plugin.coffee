extendr = require 'extendr'
_ = require 'underscore'
{TaskGroup} = require('taskgroup')

Parser = require './lib/Parser'
{now,mergeObjects,joinArray} = require './lib/Utils'

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
        prepareTitle: (menu) ->
          menu or= @menu
          week = menu.week
          from = week.from.format('DD/MM/YYYY')
          to = week.to.format('DD/MM/YYYY')
          schoolLevels = joinArray(menu.schoolLevels,', ','pour ','',' et ')
          "Menu du #{from} au #{to} #{schoolLevels}"
        prepareDescription: (menu) ->
          menu or= @menu
          week = menu.week
          from = week.from.format('DDDD MMMM YYYY')
          to = week.to.format('DDDD MMMM YYYY')
          schoolLevels = joinArray(menu.schoolLevels,', ','pour ','',' et ')
          "Menu du #{from} au #{to} #{schoolLevels}"
      defaultMeta:
        isMenu: true
      query:
        relativeOutDirPath: $startsWith: 'menus'
      sorting:
        [basename:-1]
      paging:
        undefined

    priority: 1000

    extendCollections: (opts) ->
      # Prepare
      me = @
      docpad = @docpad
      config = @getConfig()

      {query,sorting,paging} = config
      files = docpad.getFiles(query,sorting,paging)

      files.on 'add', (model) ->
        docpad.log('debug', "add menu #{model.getFilePath()}")
        model.setMetaDefaults(config.defaultMeta)

      # Chain
      @

    extendTemplateData: (opts) ->
      {templateData} = opts
      config = @getConfig()

      # Inject template helpers into template data
      for own templateHelperName, templateHelper of config.templateData
        templateData[templateHelperName] = templateHelper

      # Chain
      @

    renderMeta = (menu,templateData) ->
      meta =
        title: templateData.prepareTitle(menu)
        date: menu.date
        description: templateData.prepareDescription(menu)
        tags: menu.schoolLevels

    # Render
    # Called per document, for each extension conversion. Used to render one extension to another.
    render: (opts) ->
      # Prepare
      me = @
      {inExtension,outExtension,file,templateData} = opts
      {defaultMeta,writeMeta,writeAddedMeta} = @getConfig()

      # Upper case the text file's content if it is using the convention txt.(uc|uppercase)
      if inExtension in ['menu']
        basename = file.get("basename")
        relativePath = file.get("relativePath")
        fullPath = file.get("fullPath")
        outPath = file.get("outPath")
        content = file.get("content")
        menu = Parser.parseFromPath(basename,relativePath,fullPath,content)
        templateData.menu = menu
        metaFromMenu = renderMeta(menu,templateData)
        meta = extendr.extend {},metaFromMenu,file.getMeta().toJSON()
        if writeMeta or writeAddedMeta
          if writeAddedMeta
            menu.meta = extendr.deepClone(defaultMeta,metaFromMenu)
          else
            menu.meta = extendr.deepClone(meta)
        file.setMeta(meta)
        opts.content = JSON.stringify(menu,null,'\t')

      # Done
      @
