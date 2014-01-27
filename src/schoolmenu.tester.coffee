{joinArray} = require './lib/Utils'

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
          writeMeta: false
          writeAddedMeta: true
          defaultMeta:
            author: 'commission.restauration'
            layout: 'menu'
            additionalLayouts: ['menurss','menujson']
          templateData:
            prepareLongTitle: (menu) ->          
              menu or= @menu
              week = menu.week
              schoolLevels = joinArray(menu.schoolLevels,', ','pour ','',' et ')
              from = week.from.format('DD MMMM YYYY')
              to = week.to.format('DD MMMM YYYY')
              "Menu #{schoolLevels} de la semaine du #{from} au #{to}"          
            prepareTitle: (menu) ->
              menu or= @menu
              week = menu.week
              from = week.from.format('DD MMMM YYYY')
              to = week.to.format('DD MMMM YYYY')
              "Menu pour la semaine du #{from} au #{to}"
            prepareShortTitle: (menu) ->
              menu or= @menu
              week = menu.week
              from = week.from.format('DD MMM')
              to = week.to.format('DD MMM YYYY')
              "Menu du #{from} au #{to}"
            prepareNavTitle: (menu) ->
              menu or= @menu
              week = menu.week
              from = week.from.format('DD MMM YYYY')
              to = week.to.format('DD MMM YYYY')
              "#{from} --> #{to}"
      enabledPlugins:
        'marked': true
        'eco': true
        'multiplelayouts': true
      #logLevel: 6 #7 for debug