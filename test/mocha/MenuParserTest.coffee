pathUtil = require 'path'
chai = require 'chai'
assert = chai.assert
chai.should()

{safeParseFileContent,parseFromFile} = require '../../src/lib/MenuParser'

relativePath = (path) -> pathUtil.join './test/mocha', path

describe 'MenuParser', ->

  describe 'construction', ->

    it "should return undefined on error during a safe parsing", ->
      assert.equal safeParseFileContent('xxx',''),undefined
      assert.equal safeParseFileContent('xxx',undefined),undefined
      assert.equal safeParseFileContent(null,'xxx'),undefined
      assert.equal safeParseFileContent(undefined,'xxx'),undefined

  describe 'parse', ->

    it "should parse a simple menu", ->
      menu = parseFromFile('2014-02-04-menu-primaire-college-lycee.menu',relativePath 'MenuParserTest-simple-menu.menu')
      expected =
        fileName:
          basename: "2014-02-04-menu-primaire-college-lycee",
          extension: ".menu",
          filename: "2014-02-04-menu-primaire-college-lycee.menu",
          menuDate: "2014-02-04T00:00:00.000Z",
          month: 2,
          schoolLevels: [
            "primaire",
            "college",
            "lycee"
          ],
          tags: [
            "primaire",
            "college",
            "lycee"
          ],
          week: {
            from: "2014-02-03T00:00:00.000Z",
            to: "2014-02-07T23:59:59.999Z"
          },
          year: 2014
        comments: ['remarque1']
        days: [
          {
            name: "lundi",
            comments:["remarque1"],
            date:"2014-02-03T00:00:00.000Z",
            coursesByType: [
              { type: "entree" ,order: 0, courses: [{type: "entree",order: 0,description: "entree1"}] },
              { type: "plat" , order: 1, courses: [{type: "plat",order: 1,description: "plat1"}]},
              { type: "legume" , order: 2, courses: [{type: "legume",order: 2,description: "legume1"},{type: "legume",order: 2,description: "legume2"}]},
              { type: "dessert" , order: 3, courses: [{type: "dessert",order: 3,description: "dessert1"},{type: "dessert",order: 3,description: "dessert3"}]}
            ],
            courses: [
              {description: "entree1", order: 0, type: "entree"},
              {description: "plat1", order: 1, type: "plat"},
              {description: "legume1", order: 2, type: "legume"},
              {description: "legume2", order: 2, type: "legume"},
              {description: "dessert1", order: 3, type: "dessert"},
              {description: "dessert3", order: 3, type: "dessert"}
            ]
          }, {
            name: "mardi",
            comments:[],
            date:"2014-02-04T00:00:00.000Z",
            coursesByType: [
              { type: "dessert" , order: 3, courses: [{type: "dessert",order: 3,description: "dessert1"},{type: "dessert",order: 3,description: "dessert2"},{type: "dessert",order: 3,description: "dessert3"}]}
            ],
            courses: [
              {description: "dessert1", order: 3, type: "dessert"},
              {description: "dessert2", order: 3, type: "dessert"},
              {description: "dessert3", order: 3, type: "dessert"}
            ]
          }]
        format:
          description:
            standard: "Menu du lundi 03 février 2014 au vendredi 07 février 2014 pour le primaire, college et le lycee"
          schoolLevels:
            simple: "primaire,college,lycee"
            longWithTags: " pour le primaire, le college et le lycee"
            standard: " pour le primaire, college et le lycee"
          title:
            long: "Menu du lundi 03 février 2014 au vendredi 07 février 2014",
            longWithTags: "Menu pour le primaire, le college et le lycee de la semaine du lundi 03 février 2014 au vendredi 07 février 2014",
            nav: "03 févr. 2014 --> 07 févr. 2014",
            short: "Menu du 03 févr. au 07 févr. 2014",
            standard: "Menu du 03/02/2014 au 07/02/2014 pour le primaire, college et le lycee"

      assert.deepEqual(menu.toJSON(),expected)
