extendr = require 'extendr'
SchoolMenuFile = require './restauration/SchoolMenuFile'
SchoolMenuFileLoader = require './restauration/SchoolMenuFileLoader'

# Export Plugin
module.exports = (BasePlugin) ->
	# Define Plugin
	class SchoolMenuPlugin extends BasePlugin
		# Plugin name
		name: 'schoolmenu'

		config:
			defaultMetas : {}

		# Render
		# Called per document, for each extension conversion. Used to render one extension to another.
		render: (opts) ->
			# Prepare
			{inExtension,outExtension,file,templateData} = opts

			# Upper case the text document's content if it is using the convention txt.(uc|uppercase)
			if inExtension in ['menu'] and outExtension in ['json']
				basename = file.get("basename")
				fullPath = file.get("fullPath")
				outPath = file.get("outPath")
				menuFile = new SchoolMenuFile(basename,fullPath, outPath)
				loader = new SchoolMenuFileLoader(menuFile)
				# Render synchronously
				menu = loader.load()
				menu.meta = extendr.extend(menu.meta, @config.defaultMetas)
				templateData['menu'] = menu
				opts.content = JSON.stringify(menu,null,'\t')

			# Done
			return
