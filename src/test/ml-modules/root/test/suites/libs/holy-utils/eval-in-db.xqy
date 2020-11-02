xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace utils = "http://marklogic.com/holy/ml-modules/holy-utils" at "/libs/holy-utils.xqy";
import module namespace hhc = "http://marklogic.com/holy/ml-modules/holy-hub-constants" at "/constants/holy-hub-constants.xqy";

let $test-final := utils:eval-in-db(
    function(){xdmp:database()},
    $hhc:FINAL-DB-ID
)
let $test-staging := utils:eval-in-db(
    function(){xdmp:database()},
    $hhc:STAGING-DB-ID
)
let $test-job := utils:eval-in-db(
    function(){xdmp:database()},
    $hhc:JOB-DB-ID
)
let $test-modules := utils:eval-in-db(
    function(){xdmp:database()},
    $hhc:MODULES-DB-ID
)
let $test-test := utils:eval-in-db(
    function(){xdmp:database()},
    $hhc:TEST-DB-ID
)
return (
    test:assert-equal($hhc:FINAL-DB-ID, $test-final, "holy-FINAL"),
    test:assert-equal($hhc:STAGING-DB-ID, $test-staging, "holy-STAGING"),
    test:assert-equal($hhc:JOB-DB-ID, $test-job, "holy-JOBS"),
    test:assert-equal($hhc:MODULES-DB-ID, $test-modules, "holy-MODULES"),
    test:assert-equal($hhc:TEST-DB-ID, $test-test, "holy-TEST")
)