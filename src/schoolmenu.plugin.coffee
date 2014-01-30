extendr = require 'extendr'
_ = require 'underscore'
{TaskGroup} = require('taskgroup')

Parser = require './lib/Parser'
{now,mergeObjects,joinArray,useDocpad} = require './lib/Utils'

# Export Plugin
module.exports = (BasePlugin) ->
  # Define Plugin
  class SchoolMenuPlugin extends BasePlugin
    # Plugin name
    name: 'schoolmenu'

    coursesGroupedByType = (courses) ->
      grouped = _.chain(courses).sortBy((c)->c.order).groupBy('type').value()
      output = {type: type, courses: groupedCourses} for type,groupedCourses of grouped

    prepareTitle = () ->
      week = @menu.week
      from = week.from.format('DD/MM/YYYY')
      to = week.to.format('DD/MM/YYYY')
      schoolLevels = joinArray(@menu.schoolLevels,', ','pour ','',' et ')
      "Menu du #{from} au #{to} #{schoolLevels}"

    prepareDescription = () ->      
      week = @menu.week
      from = week.from.format('DDDD MMMM YYYY')
      to = week.to.format('DDDD MMMM YYYY')
      schoolLevels = joinArray(@menu.schoolLevels,', ','pour ','',' et ')
      "Menu du #{from} au #{to} #{schoolLevels}"

    config:
      writeAddedMeta: false
      writeMeta: false
      templateData:
        now: -> now()
        prepareTitle: prepareTitle
        prepareDescription: prepareDescription
        coursesGroupedByType: coursesGroupedByType
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
      me = @
      docpad = @docpad
      useDocpad(docpad)

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
      useDocpad(@docpad)
      # Inject template helpers into template data
      for own templateHelperName, templateHelper of config.templateData
        templateData[templateHelperName] = templateHelper

      # Chain
      @

    renderMeta = (menu,templateData) ->
      meta =
        title: templateData.prepareTitle(menu)
        date: menu.date.toDate()
        description: templateData.prepareDescription(menu)
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
        opts.content = JSON.stringify(menu,null,'\t')
      # Done
      @

    renderAfter: (opts) ->
      {collection} = opts


