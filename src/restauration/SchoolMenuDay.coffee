class SchoolMenuDay
  constructor: (@date,@weekdayName,@courses=[],comments=[]) ->

  toString: -> JSON.stringify(@)

module.Exports = SchoolMenuDay