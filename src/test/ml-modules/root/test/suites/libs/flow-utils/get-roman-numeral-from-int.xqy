xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace flow = "http://marklogic.com/holy/ml-modules/flow-utils" at "/libs/flow-utils.xqy";

let $actual-output-1 := flow:get-roman-numeral-from-int(1)
let $actual-output-2 := flow:get-roman-numeral-from-int(2)
let $actual-output-3 := flow:get-roman-numeral-from-int(3)
let $actual-output-4 := flow:get-roman-numeral-from-int(4)
let $actual-output-5 := flow:get-roman-numeral-from-int(5)
let $actual-output-6 := flow:get-roman-numeral-from-int(6)
let $actual-output-7 := flow:get-roman-numeral-from-int(7)
let $actual-output-8 := flow:get-roman-numeral-from-int(8)
let $actual-output-9 := flow:get-roman-numeral-from-int(9)
let $actual-output-10 := flow:get-roman-numeral-from-int(10)
let $actual-output-11 := flow:get-roman-numeral-from-int(0)
let $actual-output-12 := flow:get-roman-numeral-from-int(11)

return (
    test:assert-equal('I', $actual-output-1, 'Incorrect output for value 1'),
    test:assert-equal('II', $actual-output-2, 'Incorrect output for value 2'),
    test:assert-equal('III', $actual-output-3, 'Incorrect output for value 3'),
    test:assert-equal('IV', $actual-output-4, 'Incorrect output for value 4'),
    test:assert-equal('V', $actual-output-5, 'Incorrect output for value 5'),
    test:assert-equal('VI', $actual-output-6, 'Incorrect output for value 6'),
    test:assert-equal('VII', $actual-output-7, 'Incorrect output for value 7'),
    test:assert-equal('VIII', $actual-output-8, 'Incorrect output for value 8'),
    test:assert-equal('IX', $actual-output-9, 'Incorrect output for value 9'),
    test:assert-equal('X', $actual-output-10, 'Incorrect output for value 10'),
    test:assert-equal('OUT_OF_RANGE', $actual-output-11, 'Incorrect output for value 0'),
    test:assert-equal('OUT_OF_RANGE', $actual-output-12, 'Incorrect output for value 11')
)