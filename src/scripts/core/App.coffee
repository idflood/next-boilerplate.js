define [
  'use!Underscore',
  'use!Backbone',
  'jquery',
  'libs/namespace',
], (_, Backbone) ->
  #### App
  
  namespace "Next",
    App: class App
      constructor: () ->
        console.log "App init"
        console.log @add(2, 3)
        $("#footer").before($("<div>22 + 20 = #{@add(22, 20)}</div>"))
      
      add: (x, y) => x + y
