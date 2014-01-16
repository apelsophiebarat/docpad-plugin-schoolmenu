SchoolMenuFileLoader = require './src/restauration/SchoolMenuFileLoader'
SchoolMenuFile = require './src/restauration/SchoolMenuFile'
SchoolMenuDay = require './src/restauration/SchoolMenuDay'
SchoolComments = require './src/restauration/SchoolComments'
SchoolMenuCourse = require './src/restauration/SchoolMenuCourse'
{parseMenu} = require './src/restauration/SchoolMenuParser'

rootdir = "/Volumes/Externe/tmp/gssb-menu/plugins/docpad-plugin-schoolmenu"
#basename = "2014-01-10-menu-primaire"
basename = "2014-01-10-menu"
filepath = "#{rootdir}/test/src/documents/#{basename}.json.menu"
outPath = "#{rootdir}/test/out/#{basename}.json.menu"
file = new SchoolMenuFile(basename,filepath,outPath)
loader = new SchoolMenuFileLoader(file)
menu = loader.load()

courses = [new SchoolMenuCourse('plat','le plat'),new SchoolMenuCourse('entree','une entree')]
menuDay = new SchoolMenuDay(null,null,courses)

test = ->
  menuDay.coursesGroupedByType()
