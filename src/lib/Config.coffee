class Config

  instance = null

  @current: () ->
    instance ?= new Config()
    return instance

  constructor: () ->
    @courseTypes = ['entree','plat','legume','dessert']

    @fileNameRegexpPattern = /\b(\d{4})-(\d{2})-(\d{2})-menu-?([\w-]*)?/

    @urlRegexpPattern = /^(.*)\b\d{4}-\d{2}-\d{2}(-menu-?.*)$/

    @schoolLevels = ['primaire','college','lycee']

    @dayNames = ['lundi','mardi','mercredi','jeudi','vendredi','samedi','dimanche']

    @format =
      standard:
        title:"Menu du {{from}} au {{to}}{{schoolLevels}}"
        from:'DD/MM/YYYY'
        to:'DD/MM/YYYY'
        schoolLevels:
          sep: ', '
          prefix: ' pour le '
          suffix: ''
          lastSep: ' et le '
      description:
        title: "Menu du {{from}} au {{to}}{{schoolLevels}}"
        from:'dddd DD MMMM YYYY'
        to:'dddd DD MMMM YYYY'
        schoolLevels:
          sep: ', '
          prefix: ' pour le '
          suffix: ''
          lastSep: ' et le '
      long:
        title:"Menu de la semaine du {{from}} au {{to}}"
        from:'dddd DD MMMM YYYY'
        to:'dddd DD MMMM YYYY'
      longWithTags:
        title:"Menu{{schoolLevels}} de la semaine du {{from}} au {{to}}"
        from: 'dddd DD MMMM YYYY'
        to: 'dddd DD MMMM YYYY'
        schoolLevels:
          sep: ', le '
          prefix: ' pour le '
          suffix: ''
          lastSep: ' et le '
      nav:
        title:"{{from}} --> {{to}}"
        from: 'DD MMM YYYY'
        to: 'DD MMM YYYY'
      short:
        title: "Menu du {{from}} au {{to}}"
        from: 'DD MMM'
        to: 'DD MMM YYYY'

  getOptionalFormat: (type,fmt) ->
    @format[fmt]?[type]

  getFormat: (type,fmt) ->
    formatByName = @format[fmt]
    throw "can not find format for #{{fmt}}: check configuration" unless formatByName?
    formatForType = formatByName[type]
    throw "can not find format #{fmt} for #{type}: check configuration" unless formatForType?
    return formatForType

module.exports = Config
