gettext=require 'gettext'
printf=require 'printf'
  
exports ?= @traveller = {}

# set public properties.
exports.rootPath = './locales'
exports.loader = null
exports.format = 'json'

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
  trans = gettext.dcnpgettext opts.domain, opts.context, msgid, opts.plural, opts.count, opts.category
  if tokens
    # replace tokens.
    trans = printf trans, tokens
  return trans

# set options for automatic locale loading.
exports.init = (rootPath, loader, format) ->
  if (format == 'json' || format == 'po')
    exports.format=format
  else
    throw new Error "Unsupported message file format."
  if typeof loader == 'function'
    exports.loader=loader
  else
    throw new Error "'loader' must be a function taking a pathname and a callback"
  exports.rootPath=rootPath

# load a language file for a locale
exports.loadLocale = (locale,callback) ->
  localePath="#{exports.rootPath}/#{locale}/messages.#{exports.format}"
  exports.loader localePath, (data)->
    if (exports.format == 'json')
      gettext.loadLanguageJSON JSON.parse(data), locale
    else if (exports.format == 'po')
      gettext.loadLanguagePO data, locale, 'messages'
    return callback && callback()
    
# set a given locale.
exports.setLocale = (locale) ->
  # TODO choose domain, set callback and do language fallbacks.
  #console.log "gettext:"
  #console.log gettext
  #console.log "setting locale to: #{locale}"
  gettext.setlocale 'LC_ALL', locale
