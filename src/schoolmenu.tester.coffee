# Export Plugin Tester
module.exports = (testers) ->
  # Define Plugin Tester
  class SchoolMenuTester extends testers.RendererTester
    # Configuration
    config:
      removeWhitespace: true

    docpadConfig:
      enabledPlugins:
        'marked': true
        'eco': true