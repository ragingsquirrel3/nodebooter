define ['backbone'], (Backbone) ->
  
  # generic holder for static data
  class StaticSummary extends Backbone.Model
    # Add some general purpose data here, unless it needs to come from a server.
