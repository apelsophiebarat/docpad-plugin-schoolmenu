extendr = require 'extendr'
SchoolMenuParser = require './restauration/SchoolMenuParser'

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
				config = @getConfig()
				basename = file.get("basename")
				fullPath = file.get("fullPath")
				outPath = file.get("outPath")
				menu = SchoolMenuParser.parseFromPath(basename,fullPath,outPath)
				menu.meta = extendr.extend(config.defaultMetas,menu.meta)
				file.set({menu:menu})
				templateData['menu'] = menu
				opts.content = JSON.stringify(menu.formatJson(),null,'\t')

			# Done
			return
