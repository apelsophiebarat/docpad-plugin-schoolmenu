pathUtil = require 'path'
chai = require 'chai'
assert = chai.assert
chai.should()

config = require('../../src/lib/Config').current()

describe 'Config', ->

  describe 'getFormat', ->

    it "should return a format by type and name", ->
      actual = config.getFormat('title','standard')
      expected = "Menu du {{from}} au {{to}}{{schoolLevels}}"
      assert.equal(actual,expected)

    it "should raise an exception if format not found", ->
      assert.throws -> config.getFormat('XXXX','standard')
      assert.throws -> config.getFormat('title','XXXX')
      assert.throws -> config.getFormat('XXX','XXXX')
