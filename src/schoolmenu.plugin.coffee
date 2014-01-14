SchoolMenuFile = require './restauration/SchoolMenuFile'
SchoolMenuFileLoader = require './restauration/SchoolMenuFileLoader'

# Export Plugin
module.exports = (BasePlugin) ->
	# Define Plugin
	class SchoolMenuPlugin extends BasePlugin
		# Plugin name
		name: 'schoolmenu'

		# Render
		# Called per document, for each extension conversion. Used to render one extension to another.
		render: (opts) ->
			# Prepare
			{inExtension,outExtension,file} = opts

			# Upper case the text document's content if it is using the convention txt.(uc|uppercase)
			if inExtension in ['menu'] and outExtension in ['json']
				basename = file.get("basename")
				fullPath = file.get("fullPath")
				outPath = file.get("outPath")
				menuFile = new SchoolMenuFile(basename,fullPath, outPath)
				loader = new SchoolMenuFileLoader(menuFile)
				# Render synchronously
				opts.content = JSON.stringify(loader.load(),null,'\t')

			# Done
			return
