define [
  'Underscore',
  'Backbone',
  'jquery',
  'libs/namespace',
  'cs!core/utils/AutoReload',
], (_, Backbone) ->
  #### App
  
  namespace "Next",
    App: class App
      constructor: () ->
        new Next.AutoReload()
        
        console.log "App init"
        console.log @add(2, 4)
        $("#footer").before($("<div>22 + 20 = #{@add(22, 20)}</div>"))
      
      add: (x, y) => x + y
