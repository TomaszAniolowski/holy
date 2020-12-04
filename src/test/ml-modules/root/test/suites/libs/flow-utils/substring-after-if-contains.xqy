xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace flow = "http://marklogic.com/holy/ml-modules/flow-utils" at "/libs/flow-utils.xqy";

declare variable $INPUT as xs:string := 'abcdefghij';

let $actual-value-1 := flow:substring-after-if-contains($INPUT, 'a')
let $actual-value-2 := flow:substring-after-if-contains($INPUT, 'b')
let $actual-value-3 := flow:substring-after-if-contains($INPUT, 'c')
let $actual-value-4 := flow:substring-after-if-contains($INPUT, 'd')
let $actual-value-5 := flow:substring-after-if-contains($INPUT, 'e')
let $actual-value-6 := flow:substring-after-if-contains($INPUT, 'f')
let $actual-value-7 := flow:substring-after-if-contains($INPUT, 'g')
let $actual-value-8 := flow:substring-after-if-contains($INPUT, 'h')
let $actual-value-9 := flow:substring-after-if-contains($INPUT, 'i')
let $actual-value-10 := flow:substring-after-if-contains($INPUT, 'j')
let $actual-value-11 := flow:substring-after-if-contains($INPUT, 'def')
let $actual-value-12 := flow:substring-after-if-contains($INPUT, 'k')
let $actual-value-13 := flow:substring-after-if-contains($INPUT, 'zab')

return (
    test:assert-equal('bcdefghij', $actual-value-1, 'Incorrect output for after-token: a'),
    test:assert-equal('cdefghij', $actual-value-2, 'Incorrect output for after-token: b'),
    test:assert-equal('defghij', $actual-value-3, 'Incorrect output for after-token: c'),
    test:assert-equal('efghij', $actual-value-4, 'Incorrect output for after-token: d'),
    test:assert-equal('fghij', $actual-value-5, 'Incorrect output for after-token: e'),
    test:assert-equal('ghij', $actual-value-6, 'Incorrect output for after-token: f'),
    test:assert-equal('hij', $actual-value-7, 'Incorrect output for after-token: g'),
    test:assert-equal('ij', $actual-value-8, 'Incorrect output for after-token: h'),
    test:assert-equal('j', $actual-value-9, 'Incorrect output for after-token: i'),
    test:assert-equal('', $actual-value-10, 'Incorrect output for after-token: j'),
    test:assert-equal('ghij', $actual-value-11, 'Incorrect output for after-token: def'),
    test:assert-equal($INPUT, $actual-value-12, 'Incorrect output for after-token: k'),
    test:assert-equal($INPUT, $actual-value-13, 'Incorrect output for after-token: ijk')
)
