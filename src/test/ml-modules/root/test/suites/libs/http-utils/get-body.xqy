xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace json = 'http://marklogic.com/xdmp/json' at '/MarkLogic/json/json.xqy';
import module namespace http-utils = "http://marklogic.com/holy/ml-modules/http-utils" at "/libs/http-utils.xqy";
import module namespace hhc = "http://marklogic.com/holy/ml-modules/holy-hub-constants" at "/constants/holy-hub-constants.xqy";

declare variable $PARAMS-1 as map:map := map:new(map:entry('rs:siglum', 'Rdz 1,1'));

let $response-1 := http-utils:ml-resource-get($hhc:RESOURCES-GET-VERSES, $PARAMS-1)
let $response-2 := http-utils:ml-resource-get('', $PARAMS-1)
let $response-3 := http-utils:ml-resource-get('fake-resource', $PARAMS-1)

let $body-1 := http-utils:get-body($response-1)
let $body-2 := http-utils:get-body($response-2)
let $body-3 := http-utils:get-body($response-3)

let $body-1-json := json:transform-from-json($body-1)
let $body-3-json := json:transform-from-json($body-3)

return (
    test:assert-equal('document', xdmp:node-kind($body-1)),
    test:assert-equal('document', xdmp:node-kind($body-2)),
    test:assert-equal('document', xdmp:node-kind($body-3)),

    test:assert-false(fn:QName("http://marklogic.com/xdmp/json/basic","errorResponse") = ($body-1-json/child::node() ! fn:node-name()), ''),
    test:assert-not-exists($body-2/child::node()),
    test:assert-equal(fn:QName("http://marklogic.com/xdmp/json/basic","errorResponse"), fn:node-name($body-3-json/child::node()))
)