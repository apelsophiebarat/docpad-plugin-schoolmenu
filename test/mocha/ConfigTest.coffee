pathUtil = require 'path'
{expect,assert} = require 'chai'

config = require('../../src/lib/Config').current()

describe 'Config', ->

  describe 'getFormat', ->

    it "should return a format by type and name", ->
      actual = config.getFormat('title','standard','template')
      expected = "Menu du {{from}} au {{to}}{{schoolLevels}}"
      expect(actual).to.equal(expected)

    it "should raise an exception if format not found", ->
      assert.throws -> config.getFormat('XXXX','standard','template')
      assert.throws -> config.getFormat('title','XXXX','template')
      assert.throws -> config.getFormat('title','standard','XXXX')
      assert.throws -> config.getFormat('XXX','XXXX','XXXX')
