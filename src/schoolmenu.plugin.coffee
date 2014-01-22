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
        updatedMeta = extendr.deepExtend({},config.defaultMetas,document.getMeta())
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

      # Upper case the text document's content if it is using the convention txt.(uc|uppercase)
      if inExtension in ['menu'] and outExtension in ['json']
        config = @getConfig()
        basename = file.get("basename")
        fullPath = file.get("fullPath")
        outPath = file.get("outPath")
        menu = SchoolMenuParser.parseFromPath(basename,fullPath,outPath)
        menu.meta = extendr.extend(_.clone(config.defaultMetas),menu.meta)
        file.set({menu:menu})
        #file.set(menu.meta)
        templateData['menu'] = menu
        opts.content = JSON.stringify(menu.formatJson(),null,'\t')

      # Done
      return
