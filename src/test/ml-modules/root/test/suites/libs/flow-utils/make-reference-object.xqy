xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace flow = "http://marklogic.com/holy/ml-modules/flow-utils" at "/libs/flow-utils.xqy";
import module namespace fc = "http://marklogic.com/holy/ml-modules/flow-constants" at "/constants/flow-constants.xqy";

declare variable $TYPE as xs:string := 'TestEntity';
declare variable $REF as xs:string := 'TestReference';
declare variable $NS-PREFIX as xs:string := 'test';
declare variable $NS as xs:string := 'http://marklogic.com/holy/test-data';

let $actual-ref-object := flow:make-reference-object($TYPE, $REF, $NS-PREFIX, $NS)
let $actual-ref-object-key-count := $actual-ref-object => map:keys() => fn:count()
let $actual-ref-object-type := map:get($actual-ref-object, $fc:DHF-TYPE)
let $actual-ref-object-ref := map:get($actual-ref-object, $fc:DHF-REF)
let $actual-ref-object-ns-prefix := map:get($actual-ref-object, $fc:DHF-NS-PREFIX)
let $actual-ref-object-ns := map:get($actual-ref-object, $fc:DHF-NS)

return (
    test:assert-equal(4, $actual-ref-object-key-count),
    test:assert-equal($TYPE, $actual-ref-object-type),
    test:assert-equal($REF, $actual-ref-object-ref),
    test:assert-equal($NS-PREFIX, $actual-ref-object-ns-prefix),
    test:assert-equal($NS, $actual-ref-object-ns)
)