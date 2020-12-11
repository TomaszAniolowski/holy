xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace bc = "http://marklogic.com/holy/ml-modules/bible-constants" at "/constants/bible-constants.xqy";
import module namespace bib = "http://marklogic.com/holy/ml-modules/bible-utils" at "/libs/bible-utils.xqy";

declare variable $VERSE-NUM-1 := '1';
declare variable $VERSE-NUM-2 := '1a';
declare variable $VERSE-NUM-3 := '11a';
declare variable $VERSE-NUM-4 := 'a11';

let $expected-digit-part-1 := '1'
let $expected-digit-part-2 := '1'
let $expected-digit-part-3 := '11'
let $expected-digit-part-4 := '11'

let $actual-digit-part-1 := bib:pull-verse-digit-part($VERSE-NUM-1)
let $actual-digit-part-2 := bib:pull-verse-digit-part($VERSE-NUM-2)
let $actual-digit-part-3 := bib:pull-verse-digit-part($VERSE-NUM-3)
let $actual-digit-part-4 := bib:pull-verse-digit-part($VERSE-NUM-4)

return (
    test:assert-equal($expected-digit-part-1, $actual-digit-part-1, 'Incorrect digit-part for verse 1 (actual digit-part: ' || $actual-digit-part-1 || ')'),
    test:assert-equal($expected-digit-part-2, $actual-digit-part-2, 'Incorrect digit-part for verse 2 (actual digit-part: ' || $actual-digit-part-2 || ')'),
    test:assert-equal($expected-digit-part-3, $actual-digit-part-3, 'Incorrect digit-part for verse 3 (actual digit-part: ' || $actual-digit-part-3 || ')'),
    test:assert-equal($expected-digit-part-4, $actual-digit-part-4, 'Incorrect digit-part for verse 4 (actual digit-part: ' || $actual-digit-part-4 || ')')
)