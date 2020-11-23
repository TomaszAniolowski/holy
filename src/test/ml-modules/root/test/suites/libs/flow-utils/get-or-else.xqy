xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace flow = "http://marklogic.com/holy/ml-modules/flow-utils" at "/libs/flow-utils.xqy";

declare variable $VAL-EMPTY-SEQ as empty-sequence() := ();
declare variable $VAL-EMPTY-STR as xs:string := '';
declare variable $VAL-STR-1 as xs:string := ' ';
declare variable $VAL-STR-2 as xs:string := '1';
declare variable $VAL-INT as xs:int := 1;
declare variable $VAL-TRUE as xs:boolean := fn:true();
declare variable $VAL-FALSE as xs:boolean := fn:false();
declare variable $VAL-DATE as xs:dateTime := fn:current-dateTime();
declare variable $VAL-ALTER as xs:string := 'alter';

let $actual-val-1 := flow:get-or-else($VAL-EMPTY-SEQ, $VAL-ALTER)
let $actual-val-2 := flow:get-or-else($VAL-EMPTY-STR, $VAL-ALTER)
let $actual-val-3 := flow:get-or-else($VAL-STR-1, $VAL-ALTER)
let $actual-val-4 := flow:get-or-else($VAL-STR-2, $VAL-ALTER)
let $actual-val-5 := flow:get-or-else($VAL-INT, $VAL-ALTER)
let $actual-val-6 := flow:get-or-else($VAL-TRUE, $VAL-ALTER)
let $actual-val-7 := flow:get-or-else($VAL-FALSE, $VAL-ALTER)
let $actual-val-8 := flow:get-or-else($VAL-DATE, $VAL-ALTER)

return (
    test:assert-equal($VAL-ALTER, $actual-val-1, 'Incorrect value returned for empty sequence value'),
    test:assert-equal($VAL-ALTER, $actual-val-2, 'Incorrect value returned for empty string value'),
    test:assert-equal($VAL-ALTER, $actual-val-3, 'Incorrect value returned for space string value'),
    test:assert-equal($VAL-STR-2, $actual-val-4, 'Incorrect value returned for string value'),
    test:assert-equal($VAL-INT, $actual-val-5, 'Incorrect value returned for integer value'),
    test:assert-equal($VAL-TRUE, $actual-val-6, 'Incorrect value returned for boolean true value'),
    test:assert-equal($VAL-FALSE, $actual-val-7, 'Incorrect value returned for boolean false value'),
    test:assert-equal($VAL-DATE, $actual-val-8, 'Incorrect value returned for date value')
)