SchoolMenuFileLoader = require './src/restauration/SchoolMenuFileLoader'
SchoolMenuFile = require './src/restauration/SchoolMenuFile'
{parseMenu} = require './src/restauration/SchoolMenuParser'

rootdir = "/Volumes/Externe/tmp/gssb-menu/plugins/docpad-plugin-schoolmenu"
basename = "2014-01-10-menu-primaire"
filepath = "#{rootdir}/test/src/documents/#{basename}.json.menu"
outPath = "#{rootdir}/test/out/#{basename}.json.menu"
file = new SchoolMenuFile(basename,filepath,outPath)
loader = new SchoolMenuFileLoader(file)
menu = loader.load()