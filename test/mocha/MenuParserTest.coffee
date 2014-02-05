pathUtil = require 'path'
chai = require 'chai'
assert = chai.assert
chai.should()

{safeParseFileContent,parseFromFile} = require '../../src/lib/MenuParser'

relativePath = (path) -> pathUtil.join './test/mocha', path

describe 'MenuParser', ->

  describe 'construction', ->

    it "should return an empty string on a safe parsing", ->
      assert.equal safeParseFileContent('xxx',''),''
      assert.equal safeParseFileContent('xxx',undefined),''
      assert.equal safeParseFileContent(null,'xxx'),''
      assert.equal safeParseFileContent(undefined,'xxx'),''

  describe 'parse', ->

    it "should parse a simple menu", ->
      menu = parseFromFile('2014-02-04-menu-primaire-college-lycee.menu',relativePath 'MenuParserTest-simple-menu.menu')
      expected =
        isMenu: true
        comments: ['remarque1']
        schoolLevels: ["primaire","college","lycee"]
        week:
          from: "2014-02-03T00:00:00.000Z",
          to: "2014-02-07T23:59:59.999Z"
        days: [
          {
            name: "lundi",
            comments:["remarque1"],
            date:"2014-02-03T00:00:00.000Z",
            courses: [
              { type: "entree" , courses: [{type: "entree",order: 0,description: "entree1"}] },
              { type: "plat" , courses: [{type: "plat",order: 1,description: "plat1"}]},
              { type: "legume" , courses: [{type: "legume",order: 2,description: "legume1"},{type: "legume",order: 2,description: "legume2"}]},
              { type: "dessert" , courses: [{type: "dessert",order: 3,description: "dessert1"},{type: "dessert",order: 3,description: "dessert3"}]}
            ]
          }, {
            name: "mardi",
            comments:[],
            date:"2014-02-04T00:00:00.000Z",
            courses: [
              { type: "dessert" , courses: [{type: "dessert",order: 3,description: "dessert1"},{type: "dessert",order: 3,description: "dessert2"},{type: "dessert",order: 3,description: "dessert3"}]}
            ]
          }
        ]
      assert.deepEqual(menu.toJSON(),expected)
