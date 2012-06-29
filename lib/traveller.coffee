gettext=require 'gettext'
printf=require 'printf'
  
exports ?= @traveller = {}

# set public properties.
exports.rootPath = './locales'
exports.loader = null
exports.format = 'json'
exports.gettext = gettext

# declare public methods.

# call node-gettext in a js/coffee like way.
exports.t = (msgid, opts, tokens) ->
  # set defaults
  opts ?= {}
  opts.domain ?= null
  opts.context ?= undefined
  opts.plural ?= undefined
  opts.count ?= undefined
  opts.category ?= undefined
  #console.log "opts, tokens:"
  #console.log opts
  #console.log tokens
  trans = exports.gettext.dcnpgettext opts.domain, opts.context, msgid, opts.plural, opts.count, opts.category
  if tokens
    # replace tokens.
    trans = printf trans, tokens
  console.log "msgid: #{msgid}; trans: #{trans}"
  return trans

# set options for automatic locale loading.
exports.init = (rootPath, loader, format) ->
  if format == 'json'
    exports.format=format
  else
    throw new Error "Only json format supported at this time."
  if typeof loader == 'function'
    exports.loader=loader
  else
    throw new Error "'loader' must be a function taking a pathname and a callback"
  exports.rootPath=rootPath

# load a language file for a locale
exports.loadLocale = (locale,callback) ->
  localePath="#{exports.rootPath}/#{locale}/messages.#{exports.format}"
  #console.log "parsed path: #{docPath}"
  gtLoader=(cb)->
    # loader function to pass to node-gettext.
    # loadLanguageFile is expecting a function which passes JSON data to a callback. cb is the callback which it passes in.
    console.log "called back. cb:"
    console.log cb
    exports.loader localePath, (json)->
      console.log "json loaded"
      cb(JSON.parse json)
  exports.gettext.loadLanguageFile gtLoader, locale, callback

# set a given locale.
exports.setLocale = (locale) ->
  # TODO choose domain, set callback and do language fallbacks.
  console.log "setting locale to: #{locale}"
  exports.gettext.setlocale 'LC_ALL', locale
