xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace custom = "http://marklogic.com/data-hub/custom" at '/custom-modules/custom/psw-transform-xhtml-into-tome/lib.xqy';
import module namespace json = "http://marklogic.com/xdmp/json" at "/MarkLogic/json/json.xqy";
import module namespace flow = "http://marklogic.com/holy/ml-modules/flow-utils" at "/libs/flow-utils.xqy";
import module namespace bib = "http://marklogic.com/holy/ml-modules/bible-utils" at "/libs/bible-utils.xqy";
import module namespace bc = "http://marklogic.com/holy/ml-modules/bible-constants" at "/constants/bible-constants.xqy";
import module namespace fc = "http://marklogic.com/holy/ml-modules/flow-constants" at "/constants/flow-constants.xqy";

declare variable $TOME-SIGLUM as xs:string := $bc:SIGLUM-IZ;
declare variable $TESTAMENT as xs:string := bib:retrieve-testament($TOME-SIGLUM);
declare variable $TOME-NAME as xs:string := bib:retrieve-tome-name($TOME-SIGLUM);
declare variable $TOME-FIRST-CHAPTER as xs:string := bib:retrieve-first-chapter($TOME-SIGLUM);
declare variable $TOME-LAST-CHAPTER as xs:string := bib:retrieve-last-chapter($TOME-SIGLUM);
declare variable $SOURCE-URIS := flow:get-xhtml-source-uris()[fn:contains(., $TOME-SIGLUM)];
declare variable $PERICOPE-1-TITLE as xs:string := 'Tytuł';
declare variable $PERICOPE-2-TITLE as xs:string := 'Bóg skarży się na swój lud';

let $tome := custom:create-tome-instance($TOME-SIGLUM, $SOURCE-URIS)

let $expected-pericopes-count := 182
let $expected-pericope-1-verse-id := fn:concat($TESTAMENT, $TOME-SIGLUM, '1', '1', 'I') => flow:generate-unique-id()
let $expected-pericope-2-first-verse-id := fn:concat($TESTAMENT, $TOME-SIGLUM, '1', '2', 'I') => flow:generate-unique-id()
let $expected-pericope-2-last-verse-id := fn:concat($TESTAMENT, $TOME-SIGLUM, '1', '9', 'IV') => flow:generate-unique-id()
let $expected-pericope-1-id := fn:concat($TOME-SIGLUM, $expected-pericope-1-verse-id, $expected-pericope-1-verse-id) => flow:generate-unique-id()
let $expected-pericope-2-id := fn:concat($TOME-SIGLUM, $expected-pericope-2-first-verse-id, $expected-pericope-2-last-verse-id) => flow:generate-unique-id()
let $expected-pericope-2-verses := (
    (1 to 5) ! flow:generate-unique-id(fn:concat($TESTAMENT, $TOME-SIGLUM, '1', '2', flow:get-roman-numeral-from-int(.))),
    (1 to 4) ! flow:generate-unique-id(fn:concat($TESTAMENT, $TOME-SIGLUM, '1', '3', flow:get-roman-numeral-from-int(.))),
    (1 to 7) ! flow:generate-unique-id(fn:concat($TESTAMENT, $TOME-SIGLUM, '1', '4', flow:get-roman-numeral-from-int(.))),
    (1 to 4) ! flow:generate-unique-id(fn:concat($TESTAMENT, $TOME-SIGLUM, '1', '5', flow:get-roman-numeral-from-int(.))),
    (1 to 5) ! flow:generate-unique-id(fn:concat($TESTAMENT, $TOME-SIGLUM, '1', '6', flow:get-roman-numeral-from-int(.))),
    (1 to 5) ! flow:generate-unique-id(fn:concat($TESTAMENT, $TOME-SIGLUM, '1', '7', flow:get-roman-numeral-from-int(.))),
    (1 to 4) ! flow:generate-unique-id(fn:concat($TESTAMENT, $TOME-SIGLUM, '1', '8', flow:get-roman-numeral-from-int(.))),
    (1 to 4) ! flow:generate-unique-id(fn:concat($TESTAMENT, $TOME-SIGLUM, '1', '9', flow:get-roman-numeral-from-int(.)))
)

let $actual-pericopes := json:array-values(map:get($tome, $fc:PERICOPES))
let $actual-pericope-1 := $actual-pericopes[1]
let $actual-pericope-2 := $actual-pericopes[2]
let $actual-pericope-1-verse-refs := json:array-values(map:get($actual-pericope-1, $fc:VERSES)) ! map:get(., $fc:DHF-REF)
let $actual-pericope-2-verse-refs := json:array-values(map:get($actual-pericope-2, $fc:VERSES)) ! map:get(., $fc:DHF-REF)

return (
    (: TOME TESTS :)
    test:assert-equal($fc:TOME-ENTITY, map:get($tome, $fc:DHF-TYPE), 'Wrong tome entity type name.'),
    test:assert-equal($fc:TOME-VERSION, map:get($tome, $fc:DHF-VERSION), 'Wrong tome entity version.'),
    test:assert-equal($fc:TOME-NS-URI, map:get($tome, $fc:DHF-NS), 'Wrong tome entity namespace uri.'),
    test:assert-equal($fc:TOME-NS-PREFIX, map:get($tome, $fc:DHF-NS-PREFIX), 'Wrong tome entity namespace prefix.'),
    test:assert-equal($TOME-SIGLUM, map:get($tome, $fc:SIGLUM), 'Wrong tome siglum.'),
    test:assert-equal($TOME-NAME, map:get($tome, $fc:NAME), 'Wrong tome name.'),
    test:assert-equal($TESTAMENT, map:get($tome, $fc:TESTAMENT), 'Wrong tome testament.'),
    test:assert-equal($TOME-FIRST-CHAPTER, map:get($tome, $fc:FIRST-CHAPTER), 'Wrong tome first chapter.'),
    test:assert-equal($TOME-LAST-CHAPTER, map:get($tome, $fc:LAST-CHAPTER), 'Wrong tome last chapter.'),
    test:assert-equal($expected-pericopes-count, fn:count($actual-pericopes), 'Wrong pericopes count.'),
    test:assert-not-exists(map:get($tome, $fc:SUBTITLES), 'There should be no subtitles.'),

    (: PERICOPES GENERAL TESTS :)
    $actual-pericopes ! (
        test:assert-equal($fc:PERICOPE-ENTITY, map:get(., $fc:DHF-TYPE), 'Wrong pericope entity type name.'),
        test:assert-equal($fc:PERICOPE-VERSION, map:get(., $fc:DHF-VERSION), 'Wrong pericope entity version.'),
        test:assert-equal($fc:PERICOPE-NS-URI, map:get(., $fc:DHF-NS), 'Wrong pericope entity namespace uri.'),
        test:assert-equal($fc:PERICOPE-NS-PREFIX, map:get(., $fc:DHF-NS-PREFIX), 'Wrong pericope entity namespace prefix.'),
        test:assert-equal($TOME-SIGLUM, map:get(., $fc:TOME), 'Wrong pericope entity tome siglum.')
    ),

    (: PERICOPE 1 TESTS :)
    test:assert-equal($expected-pericope-1-id, map:get($actual-pericopes[1], $fc:ID), 'Wrong id in the first pericope tested.'),
    test:assert-equal($PERICOPE-1-TITLE, map:get($actual-pericopes[1], $fc:TITLE), 'Wrong title in the first pericope tested.'),
    test:assert-equal(1, fn:count($actual-pericope-1-verse-refs), 'The first pericope tested should contain only 1 verse.'),
    test:assert-equal($expected-pericope-1-verse-id, $actual-pericope-1-verse-refs, 'Wrong title in the first pericope tested.'),

    (: PERICOPE 2 TESTS :)
    test:assert-equal($expected-pericope-2-id, map:get($actual-pericope-2, $fc:ID), 'Wrong id in the second pericope tested.'),
    test:assert-equal($PERICOPE-2-TITLE, map:get($actual-pericope-2, $fc:TITLE), 'Wrong title in the second pericope tested.'),
    test:assert-equal(fn:count($expected-pericope-2-verses), fn:count($actual-pericope-2-verse-refs), 'The second pericope tested should contain 38 verses.'),
    $expected-pericope-2-verses ! test:assert-true(. = $actual-pericope-2-verse-refs, 'The second pericope should contain verse with id ' || .)
)