xquery version "1.0-ml";

module namespace test-utils = "http://marklogic.com/holy/test/test-utils";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";

declare function test-utils:assert-map-equal
(
        $expected as map:map,
        $actual as map:map,
        $message as xs:string
)
{
    let $expected-keys := map:keys($expected)
    let $actual-keys := map:keys($actual)
    return (
        test:assert-equal(fn:count($expected-keys), fn:count($actual-keys), $message || ' [the number of map keys is different: expected - (' || fn:string-join($expected-keys, ', ') || '); actual - (' || fn:string-join($actual-keys, ', ') || ')].'),
        $expected-keys ! test:assert-true((. = $actual-keys), $message || ' [the actual map does not contain following item: ' || . || '].'),
        for $key in $expected-keys
        let $expected-value := map:get($expected, $key)
        let $actual-value := map:get($actual, $key)
        return
            if (fn:string(xdmp:type($expected-value[1])) eq 'map' and fn:string(xdmp:type($actual-value[1])) eq 'map')
            then test-utils:assert-map-equal($expected-value, $actual-value, $message)
            else test:assert-equal($expected-value, $actual-value, $message || ' [values for the key: "' || $key || '" are different].')
    )
};