class SchoolComments
  constructor: (@comments) ->

  toString: -> JSON.stringify(@)

  addAll: (schoolComment) ->
    @comments = @comments.concat(schoolComment.comments)

  clone: -> new SchoolComments(@comments.concat([]))

  @fromJSON: (data) ->
    comments = data.comment or data.commentaire or data.remarque or []
    new SchoolComments(comments)

  toJSON: ->
    @comments if @comments? and @comments.length >0

module.exports = SchoolComments