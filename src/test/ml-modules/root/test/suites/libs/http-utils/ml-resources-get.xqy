xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace http-utils = "http://marklogic.com/holy/ml-modules/http-utils" at "/libs/http-utils.xqy";
import module namespace hhc = "http://marklogic.com/holy/ml-modules/holy-hub-constants" at "/constants/holy-hub-constants.xqy";

declare variable $PARAMS-1 as map:map := map:new(map:entry('rs:siglum', 'Rdz 1,1'));

let $response-1 := http-utils:ml-resource-get($hhc:RESOURCES-GET-VERSES, $PARAMS-1)
let $response-2 := http-utils:ml-resource-get('', $PARAMS-1)
let $response-3 := http-utils:ml-resource-get('fake-resource', $PARAMS-1)

return (
    test:assert-equal(2, fn:count($response-1), 'First response sequence should contain 2 elements'),
    test:assert-equal(2, fn:count($response-2), 'Second response sequence should contain 2 elements'),
    test:assert-equal(2, fn:count($response-3), 'Third response sequence should contain 2 elements'),
    test:assert-equal(fn:QName("xdmp:http","response"), fn:node-name($response-1[1]), 'First element of the first response should be <{xdmp:http}response/> element'),
    test:assert-equal(fn:QName("xdmp:http","response"), fn:node-name($response-2[1]), 'First element of the second response should be <{xdmp:http}response/> element'),
    test:assert-equal(fn:QName("xdmp:http","response"), fn:node-name($response-3[1]), 'First element of the third response should be <{xdmp:http}response/> element'),
    test:assert-equal("document", xdmp:node-kind($response-1[2]), 'Second element of the first response should be of document type'),
    test:assert-equal("document", xdmp:node-kind($response-2[2]), 'Second element of the second response should be of document type'),
    test:assert-equal("document", xdmp:node-kind($response-3[2]), 'Second element of the third response should be of document type'),
    test:assert-not-exists($response-1[2]/errorResponse, 'First response should not contain the errorResponse node'),
    test:assert-exists($response-3[2]/errorResponse, 'Third response should contain the errorResponse node')
)