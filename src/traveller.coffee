gettext=require 'gettext'
printf=require 'printf'
  
exports ?= @traveller = {}

# set public properties.
exports.rootPath = './locales' # default root path for locale files.
exports.loader = null # a function which returns file data from a path.
exports.format = 'json' # format for message files
exports.pathSetter = (locale, domain) ->
  # function to generate a message file path from the locale and domain.
  return "#{exports.rootPath}/#{locale}/#{domain}.#{exports.format}"

# declare public methods.

# call node-gettext in a js/coffee like way.
# msgids: either a msgid string, or an array containing the singular and plural string where there is a plural. 
# opts: an object containing domain, context, count, and category if appropriate.
# tokens: an object where the keys are tokens to be replaced with their values after translation, in the form: '%(token)format' where 'format' is a printf style formatting instruction.
exports.t = (msgids, opts, tokens) ->
  # set defaults
  opts ?= {}
  opts.domain ?= null
  opts.context ?= undefined
  opts.count ?= undefined
  opts.category ?= undefined
  if (typeof msgids) == 'string'
    msgid = msgids
    plural = undefined
  else
    msgid = msgids[0]
    plural = msgids[1]
  trans = gettext.dcnpgettext opts.domain, opts.context, msgid, plural, opts.count, opts.category
  if tokens?
    # replace tokens.
    trans = printf trans, tokens
  return trans

# set options for automatic locale loading.
exports.init = (rootPath, loader, format, pathSetter) ->
  exports.pathSetter ?= pathSetter
  if (format == 'json' || format == 'po')
    exports.format = format
  else
    throw new Error "Unsupported message file format."
  if typeof loader == 'function'
    exports.loader = loader
  else
    throw new Error "'loader' must be a function taking a pathname and a callback"
  exports.rootPath = rootPath

# load a language file for a locale
exports.loadLocale = (locale, domain, callback) ->
  if (! callback?)
    callback = domain
    domain = "messages"
  localePath = exports.pathSetter locale, domain
  exports.loader localePath, (data) ->
    if (exports.format == 'json')
      gettext.loadLanguageJSON JSON.parse(data), locale
    else if (exports.format == 'po')
      gettext.loadLanguagePO data, locale, domain
    return callback && callback()
    
# set a given locale.
exports.setLocale = (locale) ->
  # TODO choose domain, set callback and do language fallbacks.
  gettext.setlocale 'LC_ALL', locale
