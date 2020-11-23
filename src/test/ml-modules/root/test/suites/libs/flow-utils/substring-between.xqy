xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace flow = "http://marklogic.com/holy/ml-modules/flow-utils" at "/libs/flow-utils.xqy";

declare variable $INPUT as xs:string := 'abcdefghij';

let $actual-value-1 := flow:substring-between($INPUT, 'a', 'j')
let $actual-value-2 := flow:substring-between($INPUT, 'b', 'i')
let $actual-value-3 := flow:substring-between($INPUT, 'c', 'h')
let $actual-value-4 := flow:substring-between($INPUT, 'd', 'g')
let $actual-value-5 := flow:substring-between($INPUT, 'e', 'f')
let $actual-value-6 := flow:substring-between($INPUT, '', 'j')
let $actual-value-7 := flow:substring-between($INPUT, 'a', '')
let $actual-value-8 := flow:substring-between($INPUT, '', '')
let $actual-value-9 := flow:substring-between($INPUT, 'a', 'k')
let $actual-value-10 := flow:substring-between($INPUT, 'z', 'j')
let $actual-value-11 := flow:substring-between($INPUT, 'z', 'k')

return (
    test:assert-equal('bcdefghi', $actual-value-1, 'Incorrect output for tokens: a and j'),
    test:assert-equal('cdefgh', $actual-value-2, 'Incorrect output for tokens: b and i'),
    test:assert-equal('defg', $actual-value-3, 'Incorrect output for tokens: c and h'),
    test:assert-equal('ef', $actual-value-4, 'Incorrect output for tokens: d and g'),
    test:assert-equal('', $actual-value-5, 'Incorrect output for tokens: e and f'),
    test:assert-equal('', $actual-value-6, 'Incorrect output for tokens: empty value and j'),
    test:assert-equal('', $actual-value-7, 'Incorrect output for tokens: a and empty value'),
    test:assert-equal('', $actual-value-8, 'Incorrect output for tokens: empty value and empty value'),
    test:assert-equal('', $actual-value-9, 'Incorrect output for tokens: a and k'),
    test:assert-equal('', $actual-value-10, 'Incorrect output for tokens: z and j'),
    test:assert-equal('', $actual-value-11, 'Incorrect output for tokens: z and k')
)
