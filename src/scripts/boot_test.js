document.qunitResult = {};
require(['require-config'], function () {
  require(['libs/qunit-git', 'jquery'], function () {
    console.log("Tests starting...");
    
    // add callback function on qunit.done
    QUnit.done(function(){
      var $target = $("#qunit-testresult");
      var passed = parseInt($(".passed", $target).html());
      var total = parseInt($(".total", $target).html());
      var failed = parseInt($(".failed", $target).html());
      
      if (total > 0) {
        // If total is greater than 0 tests are finished.
        // Save the result in a window variable so
        // they can be accessed by testrunner.js
        // @see: testrunner.js
        document.qunitResult.passed = passed;
        document.qunitResult.total = total;
        document.qunitResult.failed = failed;
        
        if (failed > 0) {
          document.qunitResult.errors = [];
          $("#qunit-tests > li.fail").each(function(){
            var err = {};
            err.module = $(".module-name", this).html();
            err.test = $(".test-name", this).html();
            err.passed = parseInt($(".counts .passed", this).html());
            err.failed = parseInt($(".counts .failed", this).html());
            err.total = err.passed + err.failed;
            err.items = [];
            
            $("ol > li.fail", this).each(function(){
              var err2 = {};
              if ($(".test-message", this).length < 1) {
                // test probably died
                err2.message = $(this).html().substr(0, 150) + "...";
              }
              else {
                err2.message = $(".test-message", this).html();
                err2.expected = $(".test-expected", this).text();
                err2.actual = $(".test-actual", this).text();
              }
              
              err.items.push(err2);
            });
            document.qunitResult.errors.push(err);
          });
        }
      }
      else {
        // If total is 0 then tests haven't run yet
      }
    });

    require(['cs!tests/AppTest'], function() {
      // Tests loaded, do nothing

    });
  });
  
});
