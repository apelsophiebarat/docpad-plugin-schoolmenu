# Export Plugin Tester
module.exports = (testers) ->
  # Define Plugin Tester
  class SchoolMenuTester extends testers.RendererTester
    # Configuration
    config:
      removeWhitespace: true

    docpadConfig:
      plugins:
        schoolmenu:
          defaultMeta:
            someMeta: 'meta value'
      enabledPlugins:
        'marked': true
        'eco': true
        'multiplelayouts': true
      #logLevel: 6 #7 for debug