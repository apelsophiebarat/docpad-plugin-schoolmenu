assert = require 'assert'

chai = require 'chai'
chai.should()

describe 'Utils', ->

  describe 'joinArray', ->

    #joinArray = (array,sep=',',prefix='',suffix='',lastSep=sep) ->
    {joinArray} = require '../../src/lib/Utils'
    complexJoinArray = (array) -> joinArray(array,', le ',' pour le ','.',' et le ')

    it "should return '' for an undefined,null and empty array", ->
      complexJoinArray(undefined).should.equal ''
      complexJoinArray(null).should.equal ''
      complexJoinArray([]).should.equal ''

    it "should return ' pour le lycee.' for array ['lycee']", ->
      complexJoinArray(['lycee']).should.equal ' pour le lycee.'

    it "should return ' pour le lycee et le collège.' for array ['lycee','collège']", ->
      complexJoinArray(['lycee','collège']).should.equal ' pour le lycee et le collège.'

    it "should return ' pour le lycee, le primaire et le collège.' for array ['lycee','primaire',collège']", ->
      complexJoinArray(['lycee','primaire','collège']).should.equal ' pour le lycee, le primaire et le collège.'
