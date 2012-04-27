require(['require-config', 'libs/namespace'], function () {
  console.log("Tests starting...");
  require(['cs!tests/AppTest', "order!libs/qunit-git"], function() {
    console.log("Tests done!");
  });
});
