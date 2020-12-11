xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace xqy3 = 'http://marklogic.com/holy/ml-modules/xqy-3-utils' at '/libs/xqy-3-utils.xqy';

declare variable $VERSE-NUM-1 as xs:string := '1';
declare variable $VERSE-NUM-2 as xs:string := '1a';
declare variable $VERSE-NUM-3 as xs:string := '1b';
declare variable $VERSE-NUM-4 as xs:string := '1c';
declare variable $VERSE-NUM-5 as xs:string := '1d';
declare variable $VERSE-NUM-6 as xs:string := '11';
declare variable $VERSE-NUM-7 as xs:string := '11a';
declare variable $VERSE-NUM-8 as xs:string := '11b';
declare variable $VERSE-NUM-9 as xs:string := '11c';
declare variable $VERSE-NUM-10 as xs:string := '11d';

let $expected-division-1 := ('1')
let $expected-division-2 := ('1', 'a')
let $expected-division-3 := ('1', 'b')
let $expected-division-4 := ('1', 'c')
let $expected-division-5 := ('1', 'd')
let $expected-division-6 := ('11')
let $expected-division-7 := ('11', 'a')
let $expected-division-8 := ('11', 'b')
let $expected-division-9 := ('11', 'c')
let $expected-division-10 := ('11', 'd')

let $actual-division-1 := xqy3:split-verse-num($VERSE-NUM-1)
let $actual-division-2 := xqy3:split-verse-num($VERSE-NUM-2)
let $actual-division-3 := xqy3:split-verse-num($VERSE-NUM-3)
let $actual-division-4 := xqy3:split-verse-num($VERSE-NUM-4)
let $actual-division-5 := xqy3:split-verse-num($VERSE-NUM-5)
let $actual-division-6 := xqy3:split-verse-num($VERSE-NUM-6)
let $actual-division-7 := xqy3:split-verse-num($VERSE-NUM-7)
let $actual-division-8 := xqy3:split-verse-num($VERSE-NUM-8)
let $actual-division-9 := xqy3:split-verse-num($VERSE-NUM-9)
let $actual-division-10 := xqy3:split-verse-num($VERSE-NUM-10)

return (
    test:assert-equal($expected-division-1, $actual-division-1, 'Incorrect division for verse 1 (actual division: ' || fn:string-join($actual-division-1, ',') || ')'),
    test:assert-equal($expected-division-2, $actual-division-2, 'Incorrect division for verse 2 (actual division: ' || fn:string-join($actual-division-2, ',') || ')'),
    test:assert-equal($expected-division-3, $actual-division-3, 'Incorrect division for verse 3 (actual division: ' || fn:string-join($actual-division-3, ',') || ')'),
    test:assert-equal($expected-division-4, $actual-division-4, 'Incorrect division for verse 4 (actual division: ' || fn:string-join($actual-division-4, ',') || ')'),
    test:assert-equal($expected-division-5, $actual-division-5, 'Incorrect division for verse 5 (actual division: ' || fn:string-join($actual-division-5, ',') || ')'),
    test:assert-equal($expected-division-6, $actual-division-6, 'Incorrect division for verse 6 (actual division: ' || fn:string-join($actual-division-6, ',') || ')'),
    test:assert-equal($expected-division-7, $actual-division-7, 'Incorrect division for verse 7 (actual division: ' || fn:string-join($actual-division-7, ',') || ')'),
    test:assert-equal($expected-division-8, $actual-division-8, 'Incorrect division for verse 8 (actual division: ' || fn:string-join($actual-division-8, ',') || ')'),
    test:assert-equal($expected-division-9, $actual-division-9, 'Incorrect division for verse 9 (actual division: ' || fn:string-join($actual-division-9, ',') || ')'),
    test:assert-equal($expected-division-10, $actual-division-10, 'Incorrect division for verse 10 (actual division: ' || fn:string-join($actual-division-10, ',') || ')')
)
