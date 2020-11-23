xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace flow = "http://marklogic.com/holy/ml-modules/flow-utils" at "/libs/flow-utils.xqy";

declare variable $INPUT-1-1 as xs:string := 'abcdef';
declare variable $INPUT-1-2 as xs:string := ' abcdef ';
declare variable $INPUT-1-3 as xs:string := 'a b c d e f';
declare variable $INPUT-1-4 as xs:string := 'ABCDEF';
declare variable $INPUT-1-5 as xs:string := ' A B C D E F ';
declare variable $INPUT-2-1 as xs:string := 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
declare variable $INPUT-2-2 as xs:string := 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaab';
declare variable $INPUT-2-3 as xs:string := 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaac';
declare variable $INPUT-2-4 as xs:string := 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaad';
declare variable $INPUT-2-5 as xs:string := 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaae';
declare variable $INPUT-2-6 as xs:string := 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaf';
declare variable $INPUT-2-7 as xs:string := 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaag';
declare variable $INPUT-2-8 as xs:string := 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaah';
declare variable $INPUT-2-9 as xs:string := 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaai';
declare variable $INPUT-2-10 as xs:string := 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaj';

let $expected-id-1-1 := flow:generate-unique-id($INPUT-1-1)

let $actual-id-1-1 := flow:generate-unique-id($INPUT-1-1)
let $actual-id-1-2 := flow:generate-unique-id($INPUT-1-2)
let $actual-id-1-3 := flow:generate-unique-id($INPUT-1-3)
let $actual-id-1-4 := flow:generate-unique-id($INPUT-1-4)
let $actual-id-1-5 := flow:generate-unique-id($INPUT-1-5)
let $actual-id-2-1 := flow:generate-unique-id($INPUT-2-1)
let $actual-id-2-2 := flow:generate-unique-id($INPUT-2-2)
let $actual-id-2-3 := flow:generate-unique-id($INPUT-2-3)
let $actual-id-2-4 := flow:generate-unique-id($INPUT-2-4)
let $actual-id-2-5 := flow:generate-unique-id($INPUT-2-5)
let $actual-id-2-6 := flow:generate-unique-id($INPUT-2-6)
let $actual-id-2-7 := flow:generate-unique-id($INPUT-2-7)
let $actual-id-2-8 := flow:generate-unique-id($INPUT-2-8)
let $actual-id-2-9 := flow:generate-unique-id($INPUT-2-9)
let $actual-id-2-10 := flow:generate-unique-id($INPUT-2-10)

let $actual-unique-ids := (
    $actual-id-2-1, $actual-id-2-2, $actual-id-2-3, $actual-id-2-4, $actual-id-2-5,
    $actual-id-2-6, $actual-id-2-7, $actual-id-2-8, $actual-id-2-9, $actual-id-2-10
)

return (
    test:assert-equal($expected-id-1-1, $actual-id-1-1, '1-1'),
    test:assert-equal($expected-id-1-1, $actual-id-1-2, '1-2'),
    test:assert-equal($expected-id-1-1, $actual-id-1-3, '1-3'),
    test:assert-equal($expected-id-1-1, $actual-id-1-4, '1-4'),
    test:assert-equal($expected-id-1-1, $actual-id-1-5, '1-5'),

    for $id at $pos in $actual-unique-ids
    let $next := $pos + 1
    for $comparison in $actual-unique-ids[$next to 10]
    return test:assert-not-equal($comparison, $id)
)