require('coffee-script');

// Check for "build" parameter (node server.js build)
var is_build = (process.argv[2] == "build");

if (is_build == false) {
  require('./_server');
}
else {
  require('./_build');
}
