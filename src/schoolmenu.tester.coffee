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
          defaultMetas:
            layout: 'restauration/menu'
      enabledPlugins:
        'marked': true
        'eco': true