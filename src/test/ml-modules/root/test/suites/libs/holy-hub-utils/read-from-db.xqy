xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace hh = "http://marklogic.com/holy/ml-modules/holy-hub-utils" at "/libs/holy-hub-utils.xqy";
import module namespace hhc = "http://marklogic.com/holy/ml-modules/holy-hub-constants" at "/constants/holy-hub-constants.xqy";
import module namespace tdc = "http://marklogic.com/holy/test-data/constants" at "test-data/constants.xqy";

let $expected := $tdc:TEST-DOC-ROOT
let $actual := hh:read-from-db($tdc:TEST-DOC-URI, $hhc:STAGING-DB-ID)/child::node()
return (
    test:assert-equal($expected, $actual)
)