(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var Colours;

Colours = (function() {
  function Colours(options) {
    if (options == null) {
      options = {};
    }
    this.count = options.count || 10;
    this.saturation = options.saturation || 70;
    this.lightness = options.lightness || 60;
  }

  Colours.prototype.create = function(index, arg) {
    var alpha, count, hue, ref, ref1, ref2;
    ref = arg != null ? arg : {}, count = (ref1 = ref.count) != null ? ref1 : this.count, alpha = (ref2 = ref.alpha) != null ? ref2 : 1;
    hue = index * (360 / count);
    return "hsla(" + hue + ", " + this.saturation + "%, " + this.lightness + "%, " + alpha + ")";
  };

  return Colours;

})();

module.exports = Colours;

},{}]},{},[1]);
