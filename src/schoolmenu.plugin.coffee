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
      templateData:
        prepareLongTitle: (menu) ->          
          menu or= @menu          
          schoolLevels = joinArray(menu.infos.schoolLevels,', ','pour ','',' et ')
          from = menu.infos.from.format('DD MMMM YYYY')
          to = menu.infos.to.format('DD MMMM YYYY')
          "Menu #{schoolLevels} de la semaine du #{from} au #{to}"          
        prepareTitle: (menu) ->
          menu or= @menu

          from = menu.infos.from.format('DD MMMM YYYY')
          to = menu.infos.to.format('DD MMMM YYYY')
          "Menu pour la semaine du #{from} au #{to}"
        prepareShortTitle: (menu) ->
          menu or= @menu
          from = menu.infos.from.format('DD MMM')
          to = menu.infos.to.format('DD MMM YYYY')
          "Menu du #{from} au #{to}"
        prepareNavTitle: (menu) ->
          menu or= @menu
          from = menu.infos.from.format('DD MMM YYYY')
          to = menu.infos.to.format('DD MMM YYYY')
          "#{from} --> #{to}"
        now: -> now()
      defaultMeta:
        layout: 'menujson' #additionalLayouts: ['menu','menurss']
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
        #docpad.log('debug', util.format(locale.addingPartial, model.getFilePath()))
        #me.removeAdditionalLayoutsFor(document)
        docpad.log('debug', "add menu #{model.getFilePath()}")
        model.setDefaults(config.defaultMeta)

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

    # Render
    # Called per document, for each extension conversion. Used to render one extension to another.
    render: (opts) ->
      # Prepare
      me = @
      {inExtension,outExtension,file,templateData} = opts
      {defaultMeta,defaultInfo} = @getConfig()
      
      # Upper case the text file's content if it is using the convention txt.(uc|uppercase)
      if inExtension in ['menu']
        parser = new Parser(defaultMeta,defaultInfo)
        basename = file.get("basename")
        relativePath = file.get("relativePath")
        fullPath = file.get("fullPath")
        outPath = file.get("outPath")
        content = file.get("content")
        menu = parser.parseFromPath(basename,relativePath,fullPath,content)
        templateData.menu = menu
        menu.meta = mergeObjects(menu.meta,defaultMeta)
        menu.meta.simpleTitle = templateData.prepareTitle(menu)
        menu.meta.longTitle = templateData.prepareLongTitle(menu)
        menu.meta.shortTitle = templateData.prepareShortTitle(menu)
        menu.meta.navTitle = templateData.prepareNavTitle(menu)
        opts.content = JSON.stringify(menu,null,'\t')

      # Done
      @

    XXXXcontextualizeBefore: (opts, next) ->
      # Prepare
      me = @
      docpad = @docpad
      database = docpad.getDatabase()
      {defaultMeta,defaultInfo,query,sorting,paging} = @getConfig()
      tasks = new TaskGroup().once('complete', next)
      {collection} = opts

      sourcePageDocuments = collection.findAll(query,sorting,paging)

      # add defaults metas to all menu documents
      sourcePageDocuments.forEach (document) ->
        tasks.addTask (complete) ->
          updateDocumentMeta(document,defaultMeta)
          document.normalize (err) ->
            return complete(err)  if err
            complete()

      tasks.run()

      #Chain
      @
