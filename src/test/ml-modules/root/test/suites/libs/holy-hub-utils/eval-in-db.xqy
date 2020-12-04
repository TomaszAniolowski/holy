xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace hh = "http://marklogic.com/holy/ml-modules/holy-hub-utils" at "/libs/holy-hub-utils.xqy";
import module namespace hhc = "http://marklogic.com/holy/ml-modules/holy-hub-constants" at "/constants/holy-hub-constants.xqy";

let $test-final := hh:eval-in-db(
    function(){xdmp:database()},
    $hhc:FINAL-DB-ID
)
let $test-staging := hh:eval-in-db(
    function(){xdmp:database()},
    $hhc:STAGING-DB-ID
)
let $test-job := hh:eval-in-db(
    function(){xdmp:database()},
    $hhc:JOB-DB-ID
)
let $test-modules := hh:eval-in-db(
    function(){xdmp:database()},
    $hhc:MODULES-DB-ID
)
let $test-test := hh:eval-in-db(
    function(){xdmp:database()},
    $hhc:TEST-DB-ID
)
return (
    test:assert-equal($hhc:FINAL-DB-ID, $test-final, $hhc:FINAL-DB-NAME),
    test:assert-equal($hhc:STAGING-DB-ID, $test-staging, $hhc:STAGING-DB-NAME),
    test:assert-equal($hhc:JOB-DB-ID, $test-job, $hhc:JOB-DB-NAME),
    test:assert-equal($hhc:MODULES-DB-ID, $test-modules, $hhc:MODULES-DB-NAME),
    test:assert-equal($hhc:TEST-DB-ID, $test-test, $hhc:TEST-DB-NAME)
)