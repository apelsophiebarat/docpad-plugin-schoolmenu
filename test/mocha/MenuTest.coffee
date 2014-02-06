moment = require 'moment'

{expect} = require 'chai'

Menu = require '../../src/lib/Menu'
MenuFileName = require '../../src/lib/MenuFileName'
Week = require '../../src/lib/Week'

describe 'Menu', ->

  describe 'generateDaysUrl', ->

    it "should generate a valid url for each days in the week", ->
      menuFileName = new MenuFileName('2014-02-04-menu.menu')
      menu = new Menu(menuFileName,[],[],[])
      baseUrl = '/restauration/menu/2014-02-04-menu-primaire.json'
      actual = menu.generateDaysUrl(baseUrl)
      expected = [
        '/restauration/menu/2014-02-03-menu-primaire.json',
        '/restauration/menu/2014-02-04-menu-primaire.json',
        '/restauration/menu/2014-02-05-menu-primaire.json',
        '/restauration/menu/2014-02-06-menu-primaire.json',
        '/restauration/menu/2014-02-07-menu-primaire.json'
      ]
      expect(actual).to.deep.equal(expected)

    it "should generate an other valid url for each days in the week", ->
      menuFileName = new MenuFileName('2014-01-10-menu.menu')
      menu = new Menu(menuFileName,[],[],[])
      baseUrl = '/menus/2014-01-10-menu-menujson.json'
      actual = menu.generateDaysUrl(baseUrl)
      expected = [
        '/menus/2014-01-06-menu-menujson.json',
        '/menus/2014-01-07-menu-menujson.json',
        '/menus/2014-01-08-menu-menujson.json',
        '/menus/2014-01-09-menu-menujson.json',
        '/menus/2014-01-10-menu-menujson.json'
      ]
      expect(actual).to.deep.equal(expected)
