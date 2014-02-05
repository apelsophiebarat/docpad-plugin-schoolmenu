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
      schoolLevels:
        standard:
          join:
            sep: ', '
            prefix: ' pour le '
            suffix: ''
            lastSep: ' et le '
        longWithTags:
          join:
            sep: ', le '
            prefix: ' pour le '
            suffix: ''
            lastSep: ' et le '
      description:
        standard:
          template: "Menu du {{from}} au {{to}}{{schoolLevels}}"
          from:'dddd DD MMMM YYYY'
          to:'dddd DD MMMM YYYY'
      title:
        standard:
          template:"Menu du {{from}} au {{to}}{{schoolLevels}}"
          from:'DD/MM/YYYY'
          to:'DD/MM/YYYY'
        long:
          template:"Menu de la semaine du {{from}} au {{to}}"
          from:'dddd DD MMMM YYYY'
          to:'dddd DD MMMM YYYY'
        longWithTags:
          template:"Menu{{schoolLevels}} de la semaine du {{from}} au {{to}}"
          from: 'dddd DD MMMM YYYY'
          to: 'dddd DD MMMM YYYY'
        nav:
          template:"{{from}} --> {{to}}"
          from: 'DD MMM YYYY'
          to: 'DD MMM YYYY'
        short:
          template: "Menu du {{from}} au {{to}}"
          from: 'DD MMM'
          to: 'DD MMM YYYY'

  getOptionalFormat: (type,name,part) -> @format[type]?[name]?[part]

  getFormatTypes: () -> type for type of @format

  getFormatNames: (type) -> name for name of @format[type]

  getFormat: (type,name,part) ->
    formatsByType = @format[type]
    throw "can not find format for element #{{type}}: check configuration" unless formatsByType?
    formatsByName = formatsByType[name]
    throw "can not find format #{name} for element #{type}: check configuration" unless formatsByName?
    format = formatsByName[part]
    throw "can not find format #{name} part #{part} for element #{type}: check configuration" unless format?
    return format

module.exports = Config
