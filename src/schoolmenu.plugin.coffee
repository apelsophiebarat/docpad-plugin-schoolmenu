extendr = require 'extendr'
SchoolMenuParser = require './restauration/SchoolMenuParser'
_ = require 'underscore'
{TaskGroup} = require('taskgroup')

# Export Plugin
module.exports = (BasePlugin) ->
  # Define Plugin
  class SchoolMenuPlugin extends BasePlugin
    # Plugin name
    name: 'schoolmenu'

    config:
      menuRelativeOutDirPath: "menus"
      defaultMetas :
        isMenu: true

    updateMetaWithDefaults = (meta,config) -> extendr.deepExtend({},config.defaultMetas,meta)

    contextualizeBefore: (opts, next) ->
      # Prepare
      me = @
      docpad = @docpad
      database = docpad.getDatabase()
      config = @getConfig()
      tasks = new TaskGroup().once('complete', next)
      {collection} = opts

      sourcePageDocuments = collection.findAll(
        relativeOutDirPath: $startsWith: config.menuRelativeOutDirPath
      )

      # add defaults metas to all menu documents
      sourcePageDocuments.forEach (document) ->  tasks.addTask (complete) ->
        updatedMeta = updateMetaWithDefaults(document.getMeta(),config)
        document.setMeta(updatedMeta)
        document.normalize (err) ->
          return complete(err)  if err
          complete()

      tasks.run()

      #Chain
      @


    # Render
    # Called per document, for each extension conversion. Used to render one extension to another.
    render: (opts) ->
      # Prepare
      {inExtension,outExtension,file,templateData} = opts
      config = @getConfig()
      # Upper case the text document's content if it is using the convention txt.(uc|uppercase)
      if inExtension in ['menu'] and outExtension in ['json']
        basename = file.get("basename")
        fullPath = file.get("fullPath")
        outPath = file.get("outPath")
        menu = SchoolMenuParser.parseFromPath(basename,fullPath,outPath)
        menu.meta = updateMetaWithDefaults(menu.meta,config)
        file.set({menu:menu})
        templateData['menu'] = menu
        opts.content = JSON.stringify(menu.formatJson(),null,'\t')

      # Done
      return
