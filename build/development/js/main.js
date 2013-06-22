(function() {
  var VENDOR;

  VENDOR = "vendor";

  requirejs.config({
    paths: {
      'jquery': "" + VENDOR + "/jquery.min",
      'backbone': "" + VENDOR + "/backbone-min",
      'underscore': "" + VENDOR + "/underscore-min",
      'd3': "" + VENDOR + "/d3-min",
      'jade': "" + VENDOR + "/jade-min"
    },
    shim: {
      'jquery': {
        exports: '$'
      },
      'backbone': {
        deps: ['underscore', 'jquery'],
        exports: 'Backbone'
      },
      'underscore': {
        exports: '_'
      },
      'jade': {
        exports: 'jade'
      },
      'd3': {
        exports: 'd3'
      }
    }
  });

  requirejs(['jquery'], function($) {
    $.browser = $.browser || {};
    $.browser.iPhone = navigator.userAgent.match(/iPhone/i) != null;
    $.browser.iPad = navigator.userAgent.match(/iPad/i) != null;
    $.browser.iOS = $.browser.iPhone || $.browser.iPad;
    $.browser.android = navigator.userAgent.match(/android/i) != null;
    $.browser.touchDevice = $.browser.android || $.browser.iOS;
    window.requestAnimFrame = (function() {
      return window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || function(callback) {
        return window.setTimeout(callback, 1000 / 60);
      };
    })();
    if ($.browser.touchDevice) {
      $('body').addClass('b-touch_device');
    }
    return console.log('Hola Mundo');
  });

}).call(this);

/*
//@ sourceMappingURL=main.js.map
*/