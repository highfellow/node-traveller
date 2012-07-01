(function() {
  var gettext, printf;

  gettext = require('gettext');

  printf = require('printf');

  if (typeof exports === "undefined" || exports === null) {
    exports = this.traveller = {};
  }

  exports.rootPath = './locales';

  exports.loader = null;

  exports.format = 'json';

  exports.pathSetter = function(locale, domain) {
    return "" + exports.rootPath + "/" + locale + "/" + domain + "." + exports.format;
  };

  exports.t = function(msgids, opts, tokens) {
    var msgid, plural, trans;
    if (opts == null) opts = {};
    if (opts.domain == null) opts.domain = null;
    if (opts.context == null) opts.context = void 0;
    if (opts.count == null) opts.count = void 0;
    if (opts.category == null) opts.category = void 0;
    if ((typeof msgids) === 'string') {
      msgid = msgids;
      plural = void 0;
    } else {
      msgid = msgids[0];
      plural = msgids[1];
    }
    trans = gettext.dcnpgettext(opts.domain, opts.context, msgid, plural, opts.count, opts.category);
    if (tokens != null) trans = printf(trans, tokens);
    return trans;
  };

  exports.init = function(rootPath, loader, format, pathSetter) {
    if (exports.pathSetter == null) exports.pathSetter = pathSetter;
    if (format === 'json' || format === 'po') {
      exports.format = format;
    } else {
      throw new Error("Unsupported message file format.");
    }
    if (typeof loader === 'function') {
      exports.loader = loader;
    } else {
      throw new Error("'loader' must be a function taking a pathname and a callback");
    }
    return exports.rootPath = rootPath;
  };

  exports.loadLocale = function(locale, domain, callback) {
    var localePath;
    if (domain == null) domain = "messages";
    localePath = exports.pathSetter(locale, domain);
    return exports.loader(localePath, function(data) {
      if (exports.format === 'json') {
        gettext.loadLanguageJSON(JSON.parse(data), locale);
      } else if (exports.format === 'po') {
        gettext.loadLanguagePO(data, locale, domain);
      }
      return callback && callback();
    });
  };

  exports.setLocale = function(locale) {
    return gettext.setlocale('LC_ALL', locale);
  };

}).call(this);
