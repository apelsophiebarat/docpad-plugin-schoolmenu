SchoolMenuParser = require './src/restauration/SchoolMenuParser'

rootdir = "/Volumes/Externe/tmp/gssb-menu/plugins/schoolmenu"
basename = "2014-01-10-menu-primaire"
#basename = "2014-01-10-menu"
filepath = "#{rootdir}/test/src/documents/#{basename}.json.menu"
outPath = "#{rootdir}/test/out/#{basename}.json.menu"

menu = SchoolMenuParser.parseFromPath(basename,filepath,outPath)

JSON.stringify(menu.formatJson(),null,'\t')

#courses = [new SchoolMenuCourse('plat','le plat'),new SchoolMenuCourse('entree','une entree')]
#menuDay = new SchoolMenuDay(null,null,courses)

test = ->
  menuDay.coursesGroupedByType()

module.exports = menu