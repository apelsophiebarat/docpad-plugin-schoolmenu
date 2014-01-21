class SchoolComments
  constructor: (@comments) ->

  @parseJson: (doc) ->
    comments = doc.comment or doc.commentaire or doc.remarque or []
    new SchoolComments(comments)

  formatJson: -> @comments if @comments?.length

  toString: -> "SchoolComments(#{@comments})"

  addAll: (schoolComment) ->
    @comments = @comments.concat(schoolComment.comments)

  clone: -> new SchoolComments(@comments.concat([]))

module.exports = SchoolComments