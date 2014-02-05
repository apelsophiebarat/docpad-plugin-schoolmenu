pathUtil = require 'path'
moment = require 'moment'

chai = require 'chai'
assert = chai.assert
chai.should()

Week = require '../../src/lib/Week'
Formatter = require '../../src/lib/Formatter'
config = require('../../src/lib/Config').current()

sampleMenu =
  week: new Week(moment.utc('2014-02-04','YYYY-MM-DD'))
  schoolLevels: ['primaire','secondaire']

describe 'Formatter', ->

  describe 'formatTitle', ->

    it "should format standard title", ->
      actual = new Formatter(config,sampleMenu).formatTitle('standard')
      expected = "Menu du 03/02/2014 au 07/02/2014 pour le primaire et le secondaire"
      assert.equal(actual,expected)

    it "should format description", ->
      actual = new Formatter(config,sampleMenu).formatTitle('description')
      expected = "Menu du lundi 03 février 2014 au vendredi 07 février 2014 pour le primaire et le secondaire"
      assert.equal(actual,expected)

    it "should format long title", ->
      actual = new Formatter(config,sampleMenu).formatTitle('long')
      expected = "Menu de la semaine du lundi 03 février 2014 au vendredi 07 février 2014"
      assert.equal(actual,expected)

    it "should format long title with tags", ->
      actual = new Formatter(config,sampleMenu).formatTitle('longWithTags')
      expected = "Menu pour le primaire et le secondaire de la semaine du lundi 03 février 2014 au vendredi 07 février 2014"
      assert.equal(actual,expected)

    it "should format nav title", ->
      actual = new Formatter(config,sampleMenu).formatTitle('nav')
      expected = "03 févr. 2014 --> 07 févr. 2014"
      assert.equal(actual,expected)

    it "should format short title with tags", ->
      actual = new Formatter(config,sampleMenu).formatTitle('short')
      expected = "Menu du 03 févr. au 07 févr. 2014"
      assert.equal(actual,expected)
