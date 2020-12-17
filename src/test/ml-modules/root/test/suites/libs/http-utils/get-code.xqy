xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace http-utils = "http://marklogic.com/holy/ml-modules/http-utils" at "/libs/http-utils.xqy";
import module namespace hhc = "http://marklogic.com/holy/ml-modules/holy-hub-constants" at "/constants/holy-hub-constants.xqy";

declare variable $PARAMS-1 as map:map := map:new(map:entry('rs:siglum', 'Rdz 1,1'));

let $response-1 := http-utils:ml-resource-get($hhc:RESOURCES-GET-VERSES, $PARAMS-1)
let $response-2 := http-utils:ml-resource-get('', $PARAMS-1)
let $response-3 := http-utils:ml-resource-get('fake-resource', $PARAMS-1)

let $code-1 := http-utils:get-code($response-1)
let $code-2 := http-utils:get-code($response-2)
let $code-3 := http-utils:get-code($response-3)

return (
    test:assert-equal(200, $code-1),
    test:assert-equal(404, $code-2),
    test:assert-equal(500, $code-3)
)