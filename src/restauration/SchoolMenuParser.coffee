frontMatter = require 'yaml-front-matter'
cson = require 'cson'

{normalizeMenu} = require ('./SchoolMenuNormalizer')

class SchoolMenuParser
  @parseMenu: (raw) ->
    meta = frontMatter.loadFront(raw)
    content = meta.__content
    delete meta.__content
    content = normalizeMenu(cson.parseSync(content))
    content['meta'] =  meta
    return content

module.exports = SchoolMenuParser
