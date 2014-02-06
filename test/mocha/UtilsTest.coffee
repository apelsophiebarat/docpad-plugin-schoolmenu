assert = require 'assert'

chai = require 'chai'
chai.should()

#joinArray = (array,sep=',',prefix='',suffix='',lastSep=sep) ->
{joinArray,joinArrayWithParams} = require '../../src/lib/Utils'

describe 'Utils', ->

  describe 'joinArray', ->

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

  describe 'joinArrayWithParams', ->

    complexJoinArrayWithParams = (array) ->
      params=
        sep: ', le '
        prefix: ' pour le '
        suffix: '.'
        lastSep: ' et le '
      joinArrayWithParams(array,params)

    it "should return '' for an undefined,null and empty array", ->
      complexJoinArrayWithParams(undefined).should.equal ''
      complexJoinArrayWithParams(null).should.equal ''
      complexJoinArrayWithParams([]).should.equal ''

    it "should return ' pour le lycee.' for array ['lycee']", ->
      complexJoinArrayWithParams(['lycee']).should.equal ' pour le lycee.'

    it "should return ' pour le lycee et le collège.' for array ['lycee','collège']", ->
      complexJoinArrayWithParams(['lycee','collège']).should.equal ' pour le lycee et le collège.'

    it "should return ' pour le lycee, le primaire et le collège.' for array ['lycee','primaire',collège']", ->
      complexJoinArrayWithParams(['lycee','primaire','collège']).should.equal ' pour le lycee, le primaire et le collège.'
