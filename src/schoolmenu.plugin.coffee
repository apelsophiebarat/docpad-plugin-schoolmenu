PluginDelegate = require './lib/PluginDelegate'

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

    constructor: (opts) ->
      super(opts)
      @delegate = new PluginDelegate(@docpad,@getConfig())

    extendCollections: (opts) ->
      @delegate.extendCollections(opts)
      # Chain
      @

    extendTemplateData: (opts) ->
      @delegate.extendTemplateData(opts)
      # Chain
      @

    renderBefore: (opts) ->
      @delegate.renderBefore(opts)
      # Chain
      @

    # Render
    # Called per document, for each extension conversion.
    # Used to render one extension to another.
    render: (opts) ->
      @delegate.render(opts)
      # Done
      @

    renderAfter: (opts) ->
      @delegate.renderAfter(opts)
      # Chain
      @
