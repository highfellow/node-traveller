# Traveller #

Traveller is a translation and token replacement wrapper module for node, using node-gettext but providing a cleaner and more javascript-ish interface.

*This is work in progress* You are welcome to browse the code but please don't use it or ask for support until this message is removed.

## Rationale ##
* Gettext is a mature translation library, which has a javascript version [here](http://jsgettext.berlios.de/). It has been around for long enough that the PO files it uses are a standard for handling locale data. It also handles the multiple plural forms found in some languages better than some other translation libraries. However, gettext was originally a c library, and has a somewhat awkward API because of this. To perform a translation, you have to choose between 12 different functions, depending on the circumstances. Traveller replaces these with a single function ('t'), which takes an options object. You only need to provide the options keys you are using at a given point, and the rest will be filled in with sensible defaults.
* Translated strings often contain tokens, which need to be substituted with the right values before the result is output to the user. jsgettext has a function, strargs, which provides a simple way of doing this. However, there is a javascript [printf module](https://github.com/wdavidw/node-printf) for nodejs which does this much better, allowing the use of named tokens as well as proper printf style formatting of numeric output. Traveller allows you to provide a third parameter in the function call, which is an object containing key-value pairs for tokens to be substituted using node-printf after the string has been translated. This means that all translation can be done through a single function call.
* [Nodejs](http://nodejs.org/) is a popular framework for writing javascript applications, based around a server-side javascript engine. There is a [gettext module](https://github.com/DanielBaulig/node-gettext) for node already, but this suffers from the above problems. It also only works server-side, and is not directly suitable for use in the browser. With Traveller, the calling code provides a file loader function which can load locale files from a given path (either filesystem or http). This makes it independent of any particular platform or protocol.
* Usually, locale data will be kept in some kind of 'path/locale/file.[po|json]' structure, where path is either a filesystem path or an http path. Traveller provides a neat interface for loading language files automatically by locale name.

## Interface ##

* init(rootPath, loader, format) - initialise the library for automatic loading of locale files. Loader(localePath,callback) should be a function which returns loaded locale data from a root path set in 'rootPath'. LocalePath is constructed by adding '/locale/messages.format' to rootPath. Format is either 'po' or 'json' for a PO file or JSON object.
* loadLocale(locale,callback) - load a locale file automatically, using the options set in 'init'.
* loadLocaleData(fileData, locale, callback) - load raw locale data manually.
* setLocale(locale) - set the current locale.
* t(string | [string, plural-string], {options...}, {tokens})


