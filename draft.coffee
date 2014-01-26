SchoolMenuParser = require './src/restauration/SchoolMenuParser'

rootdir = "/Volumes/Externe/tmp/docpad-plugin-schoolmenu"
basename = "2014-01-10-menu-primaire"
#basename = "2014-01-10-menu"
relativePath = "menus/#{basename}.html.menu"
#fullPath = "#{rootdir}/test/src/documents/#{relativePath}"
fullPath = null
outPath = "#{rootdir}/test/out/#{relativePath}"
content=
  """
lundi:
  entree: "ssssssSalade de tomates"
  plat: "Cordon bleu"
  legumes: "Tortis au gruyères/Haricots verts persillés"
  dessert: "Ananas au sirop"
mardi:
  entree: "Concombres bulgares"
  plat: "Steack haché"
  legumes: "Pommes noisettes/Poêlée méridionale"
  desserts: [
    "Compotes de fruits"
    "Fruits"
  ]
mercredi:
  entree: "Macédoine mayonnaise"
  plat: "Lasagnes bolognaise"
  legumes: "Salade verte"
  dessert: "Clémentines"
jeudi:
  entree: "Betteraves mimosa"
  plat: "Sauté de porc à la provençale"
  legumes: "Semoule au jus/Gratin de brocolis"
  dessert: "Cookies"
vendredi:
  entree:"Œufs durs mayonnaise"
  plat: "Dos de merlu blanc au basilic"
  legumes: "Riz safrané/Epinards à la crème"
  desserts: "Fromage blanc/Purée de framboise"
tous:
  desserts: "Produits laitiers ou fromages"
remarques: [
  "Nous nous réservons la psssssssssssossibilité de modifier le menu en fonction des arrivages, tout en respectant l'équilibre nutritionnel"
]

  """
defaultMeta=
  someMeta: 'value of some meta'
defaultInfo=
  someInfo: 'value of some info'
parser = new SchoolMenuParser(defaultMeta,defaultInfo)

menu = parser.parseFromPath(basename,relativePath,fullPath,content)

JSON.stringify(menu.formatJson(),null,'\t')

#courses = [new SchoolMenuCourse('plat','le plat'),new SchoolMenuCourse('entree','une entree')]
#menuDay = new SchoolMenuDay(null,null,courses)

test = ->
  menuDay.coursesGroupedByType()

module.exports = menu