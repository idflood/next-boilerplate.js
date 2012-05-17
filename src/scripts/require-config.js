require.config({
  paths: {
    jquery: 'libs/jquery-1.7.2',
    "jquery.ui": 'libs/jquery-ui/js/jquery-ui-1.9m6',
    Underscore: 'libs/underscore',
    Backbone: 'libs/backbone',
    use: "libs/require/use",
    text: "libs/require/text",
    order: "libs/require/order",
    "socket.io": "libs/socket.io/socket.io",
    cs: "libs/require/cs",
    CoffeeScript: "libs/coffee-script"
  },
  use: {
    'Underscore': {
      attach: "_"
    },
    'Backbone': {
      deps: ['Underscore', 'jquery'],
      attach: "Backbone"
    },
    'jquery.ui': {
      deps: ['jquery'],
      attach: "jquery"
    }
  }
});
