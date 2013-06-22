define ['backbone', 'jquery', 'templates', 'd3'], (Backbone, $, JST, d3) ->
  class PublicIndexView extends Backbone.View
    el: '#j_public-index-view'
    template: JST['public_index']
    
    render: ->
      @$el.html @template()
      
      # Now, do your JS magic here...
