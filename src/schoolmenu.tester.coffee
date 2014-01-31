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
          templateData:
            prepareMenuTitle: (menu) ->
              menu = @menu
              week = menu.week
              from = week.from.format('DD/MM/YYYY')
              to = week.to.format('DD/MM/YYYY')
              schoolLevels = joinArray(menu.schoolLevels,', ',' pour le ','',' et le ')
              "Menu du #{from} au #{to}#{schoolLevels}"
            prepareMenuDescription: (menu) ->
              menu = @menu
              week = menu.week
              from = week.from.format('dddd DD MMMM YYYY')
              to = week.to.format('dddd DD MMMM YYYY')
              schoolLevels = joinArray(menu.schoolLevels,', ',' pour le ','',' et le ')
              "Menu du #{from} au #{to}#{schoolLevels}"
            coursesGroupedByType: (courses) ->
              grouped = _.chain(courses).sortBy((c)->c.order).groupBy('type').value()
              output = {type: type, courses: groupedCourses} for type,groupedCourses of grouped
            prepareLongTitle: (menu) ->
              menu or= @menu
              week = menu.week
              schoolLevels = joinArray(menu.schoolLevels,', ','pour ','',' et ')
              from = week.from.format('DD MMMM YYYY')
              to = week.to.format('DD MMMM YYYY')
              "Menu#{schoolLevels} de la semaine du #{from} au #{to}"
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
        'handlebars': true
      #logLevel: 6 #7 for debug