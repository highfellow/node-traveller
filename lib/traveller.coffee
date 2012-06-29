gettext=require 'gettext'
printf=require 'printf'

module.exports =
  rootPath: './locales'
  loader: null
  format: 'json'
  # give direct access to the real printf and gettext modules.
  printf: printf
  gettext: gettext
  # convenience function for calling gettext in a js/coffee like way.
  t: (msgid, opts, tokens) ->
    # set defaults
    opts ?= {}
    opts.domain ?= null
    opts.context ?= undefined
    opts.plural ?= undefined
    opts.count ?= undefined
    opts.category ?= undefined
    trans = gettext.dcnpgettext opts.domain,opts.context,msgid,opts.plural,opts.count,opts.category
    if tokens
      # replace tokens.
      trans = printf trans, tokens
    return trans
  # set options for automatic locale loading.
  init: (rootPath, loader, format) ->
    if format == 'json'
      @format=format
    else
      throw new Error "Only json format supported at this time."
    if typeof loader == 'function'
      @loader=loader
    else
      throw new Error "'loader' must be a function taking a pathname and a callback"
    @rootPath=rootPath
  # convenience function to load a language file for a locale
  loadLocale: (locale,callback) ->
    localePath="#{@rootPath}/#{locale}/messages.json"
    #console.log "parsed path: #{docPath}"
    gtLoader=(cb)->
      # loader function to pass to node-gettext.
      # loadLanguageFile is expecting a function which passes JSON data to a callback. cb is the callback which it passes in.
      console.log "called back. cb:"
      console.log cb
      @loader localePath, (json)->
        console.log "json loaded"
        console.log json
        cb(JSON.parse json)
    gettext.loadLanguageFile loader, locale, callback
  # convenience function to set and load a given locale.
  setLocale: (locale) ->
    # TODO choose domain, set callback and do language fallbacks.
    gettext.setlocale 'LC_ALL', locale
