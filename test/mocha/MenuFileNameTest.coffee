chai = require 'chai'
assert = chai.assert
chai.should()

moment = require 'moment'
MenuFileName = require '../../src/lib/MenuFileName'

describe 'MenuFileName', ->

  describe 'construction', ->

    it "should raise exception if filename parameter is missing", ->
      assert.throws () -> new MenuFileName()
      assert.throws () -> new MenuFileName(null)
      assert.throws () -> new MenuFileName(undefined)
      assert.throws () -> new MenuFileName('')

    it "should raise exception if filename is not well formatted", ->
      assert.throws () ->
        new MenuFileName('invelid-filename')

    it "should decode parameters from a valid filename", ->
      menuFileName = new MenuFileName('2014-02-04-menu-primaire.menu')
      expected =
        filename: '2014-02-04-menu-primaire.menu'
        basename: '2014-02-04-menu-primaire'
        year: 2014
        month: 2
        week:
          from: "2014-02-03T00:00:00.000Z",
          to: "2014-02-07T23:59:59.999Z"
        tags: ['primaire']
        schoolLevels: ['primaire']
        extension: '.menu'
        menuDate: "2014-02-04T00:00:00.000Z",
      assert.deepEqual(menuFileName.toJSON(), expected)

    it "should handle empty tags", ->
      new MenuFileName('2014-02-04-menu.menu').schoolLevels.should.be.empty

    it "should filter invalid tags", ->
      new MenuFileName('2014-02-04-menu-rss.menu').schoolLevels.should.be.empty
      new MenuFileName('2014-02-04-menu-rss-primaire-secondaire-secondaire.menu').schoolLevels.should.contain('primaire','secondaire')