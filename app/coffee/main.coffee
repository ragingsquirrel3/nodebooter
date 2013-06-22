VENDOR = "vendor"
requirejs.config
  paths:
    'jquery': "#{VENDOR}/jquery.min" # "//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min"
    'backbone': "#{VENDOR}/backbone.min"
    'underscore': "#{VENDOR}/underscore.min"
    'd3': "#{VENDOR}/d3.min"
    'jade': "#{VENDOR}/jade.min"
  shim:
    'jquery': exports: '$'
    'backbone':
      deps: ['underscore', 'jquery']
      exports: 'Backbone'
    'underscore': exports: '_'
    'jade': exports: 'jade'
    'd3': exports: 'd3'


requirejs ['routers/public_router','jquery'], (PublicRouter, $) ->
  $.browser = $.browser || {}
  $.browser.iPhone = navigator.userAgent.match(/iPhone/i)?
  $.browser.iPad = navigator.userAgent.match(/iPad/i)?
  $.browser.iOS = $.browser.iPhone || $.browser.iPad
  $.browser.android = navigator.userAgent.match(/android/i)?
  $.browser.touchDevice = $.browser.android || $.browser.iOS

  # shim layer with setTimeout fallback
  window.requestAnimFrame = ( ->
    window.requestAnimationFrame       or
    window.webkitRequestAnimationFrame or
    window.mozRequestAnimationFrame    or
    window.oRequestAnimationFrame      or
    window.msRequestAnimationFrame     or
    (callback) ->
      window.setTimeout(callback, 1000 / 60);
  )()

  $('body').addClass 'b-touch_device' if $.browser.touchDevice
  
  # Init the app here by starting the router
  router = new PublicRouter()
  Backbone.history.start()
