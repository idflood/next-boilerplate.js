define [
  'use!Underscore', 
  'use!Backbone',
  "cs!core/App",
  "order!libs/qunit-git",
], (_, Backbone) ->
  module "App"
  
  test "App.add", () ->
    app = new Next.App()
    
    equals app.add(1, 2), 3, "1 + 2 = 3"
    equals app.add(8, -2), 6, "8 + (-2) = 6"
