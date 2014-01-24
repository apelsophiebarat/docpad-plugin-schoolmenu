extendr = require 'extendr'
SchoolMenuParser = require './restauration/SchoolMenuParser'
_ = require 'underscore'
{TaskGroup} = require('taskgroup')
{now} = require './restauration/SchoolUtils'
# Export Plugin
module.exports = (BasePlugin) ->
  # Define Plugin
  class SchoolMenuPlugin extends BasePlugin
    # Plugin name
    name: 'schoolmenu'

    config:
      layouts:
        rss: 'menu-rss'
        html: 'menu-html'
      metas:
        rss:
          isMenu: true
        html:
          isMenu: true
        json:
          isMenu: true
      selector:
        query:
          relativeOutDirPath: $startsWith: 'menus'
        sorting:
          [basename:-1]
        paging:
          undefined

    priority: 200

    mergeMeta = (src,others...) ->
      params = [{},src].concat(others)
      extendr.deepExtend.apply(extendr,params)

    prepareHtmlMeta = (meta, config) ->
      metaToAdd = config.metas.html
      meetaForLayout = layout:config.layouts.html
      mergeMeta(meta,metaToAdd,meetaForLayout)

    prepareRssMeta = (meta, config) ->
      metaToAdd = config.metas.rss
      meetaForLayout = layout:config.layouts.rss
      mergeMeta(meta,metaToAdd,meetaForLayout)

    prepareJsonMeta = (meta, config) ->
      metaToAdd = config.metas.json
      mergeMeta(meta,metaToAdd)

    createRssDocument = (menu) ->
      document = docpad.getFile({tumblrId:tumblrPostId})
      # Prepare
      documentAttributes =
        data: JSON.stringify(tumblrPost, null, '\t')
        meta:
          tumblrId: tumblrPostId
          tumblrType: tumblrPost.type
          tumblr: tumblrPost
          title: (tumblrPost.title or tumblrPost.track_name or tumblrPost.text or tumblrPost.caption or '').replace(/<(?:.|\n)*?>/gm, '')
          date: tumblrPostDate
          mtime: tumblrPostMtime
          tags: (tumblrPost.tags or []).concat([tumblrPost.type])
          relativePath: "#{config.relativeDirPath}/#{tumblrPost.type}/#{tumblrPost.id}#{config.extension}"

      # Existing document
      if document?
        document.set(documentAttributes)

      # New Document
      else
        # Create document from opts
        document = docpad.createDocument(documentAttributes)

      # Inject document helper
      config.injectDocumentHelper?.call(plugin, document)

      # Load the document
      document.action 'load', (err) ->
        # Check
        return next(err, document)  if err

        # Add it to the database (with b/c compat)
        docpad.addModel?(document) or docpad.getDatabase().add(document)

        # Complete
        return next(null, document)

      # Return the document
      return document

    extendTemplateData: (templateData) ->
      templateData.now = now()
      @

    contextualizeBefore: (opts, next) ->
      # Prepare
      me = @
      docpad = @docpad
      database = docpad.getDatabase()
      config = @getConfig()
      tasks = new TaskGroup().once('complete', next)
      {collection} = opts

      sourcePageDocuments = collection.findAll(
        config.selector.query,
        config.selector.sorting,
        config.selector.paging
      )

      # add defaults metas to all menu documents
      sourcePageDocuments.forEach (document) ->  tasks.addTask (complete) ->
        updatedMeta = prepareJsonMeta(document.getMeta(),config)
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
      # Upper case the text file's content if it is using the convention txt.(uc|uppercase)
      if inExtension in ['menu'] and outExtension in ['json']
        basename = file.get("basename")
        fullPath = file.get("fullPath")
        outPath = file.get("outPath")
        menu = SchoolMenuParser.parseFromPath(basename,fullPath,outPath)
        updatedMenuMeta = prepareJsonMeta(menu.meta,config)
        updatedFileMeta = mergeMeta(file.getMeta(),updatedMenuMeta)
        menu.meta = updatedMenuMeta
        file.setMeta(updatedFileMeta)
        file.set({menu:menu})
        templateData.menu = menu
        opts.content = JSON.stringify(menu.formatJson(),null,'\t')

      # Done
      return
