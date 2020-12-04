xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace hhc = "http://marklogic.com/holy/ml-modules/holy-hub-constants" at "/constants/holy-hub-constants.xqy";
import module namespace tdc = "http://marklogic.com/holy/test-data/constants" at "test-data/constants.xqy";

test:load-test-file('Chapter-Iz-1.xml', xdmp:database($hhc:CURRENT-DB-NAME), $tdc:CHAPTER-ENTITY-URI, xdmp:default-permissions(), $tdc:TEST-COLLECTION)