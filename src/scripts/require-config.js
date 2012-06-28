require.config({
  paths: {
    jquery: 'libs/jquery-1.7.2',
    "jquery.ui": 'libs/jquery-ui/js/jquery-ui-1.9m6',
    Underscore: 'libs/underscore',
    Backbone: 'libs/backbone',
    text: "libs/require/text",
    "socket.io": "libs/socket.io/socket.io",
    cs: "libs/require/cs",
    CoffeeScript: "libs/coffee-script"
  },
  shim: {
    'Underscore': {
      exports: "_"
    },
    'Backbone': {
      deps: ['Underscore', 'jquery'],
      exports: "Backbone"
    },
    'jquery.ui': {
      deps: ['jquery'],
      exports: "jquery"
    }
  }
});
