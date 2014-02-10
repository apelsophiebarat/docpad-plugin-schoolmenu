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

module.exports = Config
