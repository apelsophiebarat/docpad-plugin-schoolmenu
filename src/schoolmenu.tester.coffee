{joinArray} = require './lib/Utils'

# Export Plugin Tester
module.exports = (testers) ->
  # Define Plugin Tester
  class SchoolMenuTester extends testers.RendererTester
    # Configuration
    config:
      removeWhitespace: false

    docpadConfig:
      plugins:
        schoolmenu:
          writeMeta: false
          writeAddedMeta: true
          defaultMeta:
            author: 'commission.restauration'
            layout: 'menu'
            additionalLayouts: ['menurss','menujson']
      enabledPlugins:
        'marked': true
        'eco': true
        'multiplelayouts': true
        'handlebars': true
      #logLevel: 6 #7 for debug