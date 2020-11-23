xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace flow = "http://marklogic.com/holy/ml-modules/flow-utils" at "/libs/flow-utils.xqy";

declare variable $INPUT as xs:string := 'abcdefghij';

let $actual-value-1 := flow:substring-before-if-contains($INPUT, 'a')
let $actual-value-2 := flow:substring-before-if-contains($INPUT, 'b')
let $actual-value-3 := flow:substring-before-if-contains($INPUT, 'c')
let $actual-value-4 := flow:substring-before-if-contains($INPUT, 'd')
let $actual-value-5 := flow:substring-before-if-contains($INPUT, 'e')
let $actual-value-6 := flow:substring-before-if-contains($INPUT, 'f')
let $actual-value-7 := flow:substring-before-if-contains($INPUT, 'g')
let $actual-value-8 := flow:substring-before-if-contains($INPUT, 'h')
let $actual-value-9 := flow:substring-before-if-contains($INPUT, 'i')
let $actual-value-10 := flow:substring-before-if-contains($INPUT, 'j')
let $actual-value-11 := flow:substring-before-if-contains($INPUT, 'def')
let $actual-value-12 := flow:substring-before-if-contains($INPUT, 'k')
let $actual-value-13 := flow:substring-before-if-contains($INPUT, 'ijk')
let $actual-value-14 := flow:substring-before-if-contains($INPUT, '')

return (
    test:assert-equal('', $actual-value-1, 'Incorrect output for before-token: a'),
    test:assert-equal('a', $actual-value-2, 'Incorrect output for before-token: b'),
    test:assert-equal('ab', $actual-value-3, 'Incorrect output for before-token: c'),
    test:assert-equal('abc', $actual-value-4, 'Incorrect output for before-token: d'),
    test:assert-equal('abcd', $actual-value-5, 'Incorrect output for before-token: e'),
    test:assert-equal('abcde', $actual-value-6, 'Incorrect output for before-token: f'),
    test:assert-equal('abcdef', $actual-value-7, 'Incorrect output for before-token: g'),
    test:assert-equal('abcdefg', $actual-value-8, 'Incorrect output for before-token: h'),
    test:assert-equal('abcdefgh', $actual-value-9, 'Incorrect output for before-token: i'),
    test:assert-equal('abcdefghi', $actual-value-10, 'Incorrect output for before-token: j'),
    test:assert-equal('abc', $actual-value-11, 'Incorrect output for before-token: def'),
    test:assert-equal($INPUT, $actual-value-12, 'Incorrect output for before-token: k'),
    test:assert-equal($INPUT, $actual-value-13, 'Incorrect output for before-token: ijk'),
    test:assert-equal($INPUT, $actual-value-14, 'Incorrect output for empty before-token')
)
