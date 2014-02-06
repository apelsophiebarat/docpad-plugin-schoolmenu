{joinArrayWithParams} = require './lib/Utils'
moment = require 'moment'


formatSchoolLevels = (menu,opts) -> joinArrayWithParams(menu.schoolLevels,opts)

formatJsonDate = (date,fmt) -> moment.utc(date).format(fmt)

formatFromDate = (menu,fmt) -> formatJsonDate(menu.fileName.week.from,fmt)

formatToDate = (menu,fmt) -> formatJsonDate(menu.fileName.week.to,fmt)

# Export Plugin Tester
module.exports = (testers) ->
  # Define Plugin Tester
  class SchoolMenuTester extends testers.RendererTester
    # Configuration
    config:
      removeWhitespace: false

    docpadConfig:
      templateData:
        prepareMenuTitle: (menu) ->
          joinOpts = sep: ', ',prefix: ' pour le ',suffix: '',lastSep: ' et le '
          schoolLevels = formatSchoolLevels menu,joinOpts
          from = formatFromDate menu,'DD/MM/YYYY'
          to = formatToDate menu,'DD/MM/YYYY'
          "Menu du #{from} au #{to}#{schoolLevels}"
        prepareMenuLongTitle: (menu) ->
          from = formatFromDate menu,'dddd DD MM YYYY'
          to = formatToDate menu,'dddd DD MMMM YYYY'
          "Menu du {{from}} au {{to}}"
        prepareMenuDescription: (menu) ->
          joinOpts = sep: ', ',prefix: ' pour le ',suffix: '' ,lastSep: ' et le '
          schoolLevels = formatSchoolLevels menu,joinOpts
          from = formatFromDate menu,'dddd DD MMMM YYYY'
          to = formatToDate menu,'dddd DD MMMM YYYY'
          "Menu du #{from} au #{to}#{schoolLevels}"
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