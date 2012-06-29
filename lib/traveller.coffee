gettext=require 'gettext'
printf=require 'printf'
http=require 'http-browserify'
url=require 'url'

getLocaleJSON = (path, callback)->
  http.get 'path' : path, (result)->
    result.on 'data', (buf) ->
      callback JSON.parse buf

module.exports =
  localeBase: 'locales'
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
    tokens ?= {}
    trans = gettext.dcnpgettext opts.domain,opts.context,msgid,opts.plural,opts.count,opts.category
    repl = @printf trans,tokens
    return repl
  # set the directory to load locale data from
  setLocaleBase: (@localeBase) ->
  # convenience function to load a language file for a locale
  loadLocale: (locale,callback) ->
    urlData=url.parse(document.URL)
    pathbits=urlData.pathname.split "/"
    docPath=pathbits[0...pathbits.length-1].join "/"
    #console.log "parsed path: #{docPath}"
    loader=(cb)->
      # loadLanguageFile is expecting a function which passes JSON data to a callback. cb is the callback which it passes in.
      #console.log "called back. cb=#{cb}"
      getLocaleJSON "#{docPath}/locales/#{locale}/messages.json", (json) ->
        #console.log "json loaded"
        #console.log json
        cb(json)
    gettext.loadLanguageFile loader, locale, callback
  # convenience function to set and load a given locale.
  setLocale: (locale) ->
    # TODO choose domain, set callback and do language fallbacks.
    gettext.setlocale 'LC_ALL', locale
