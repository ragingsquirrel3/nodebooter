define ['backbone', '../views/public/index'], (Backbone, PublicIndexView) ->
  class PublicRouter extends Backbone.Router

    routes:
      '.*'        : 'index'
      
      
      # Add some more routes here.

    index: ->
      @view = @view ? new PublicIndexView()
      @view.render()
