xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace bib = "http://marklogic.com/holy/ml-modules/bible-utils" at "/libs/bible-utils.xqy";

declare variable $SIGLUM-INVALID as xs:string := "Rdz 1-3,2";
declare variable $SIGLUM-TOME as xs:string := "Rdz";

declare variable $SIGLUM-SINGLE-CHAPTER as xs:string := "Rdz 1";
declare variable $SIGLUM-CHAPTER-RANGE-CORRECT as xs:string := "Rdz 1-3";
declare variable $SIGLUM-CHAPTER-RANGE-INCORRECT-1 as xs:string := "Rdz 1-1";
declare variable $SIGLUM-CHAPTER-RANGE-INCORRECT-2 as xs:string := "Rdz 3-1";
declare variable $SIGLUM-CHAPTER-RANGE-OVERLAPPING as xs:string := "Rdz 1-3; 2-5";
declare variable $SIGLUM-CHAPTER-SEQUENCE as xs:string := "Rdz 1; 3";
declare variable $SIGLUM-CHAPTER-SEQUENCE-OVERLAPPING as xs:string := "Rdz 1; 1";
declare variable $SIGLUM-CHAPTER-RANGE-SEQUENCE-OVERLAPPING as xs:string := "Rdz 1-3; 2";

declare variable $SIGLUM-SINGLE-VERSE as xs:string := "Rdz 1,1";
declare variable $SIGLUM-VERSE-RANGE-CORRECT as xs:string := "Rdz 1,1-3";
declare variable $SIGLUM-VERSE-RANGE-INCORRECT-1 as xs:string := "Rdz 1,1-1";
declare variable $SIGLUM-VERSE-RANGE-INCORRECT-2 as xs:string := "Rdz 1,3-1";
declare variable $SIGLUM-VERSE-RANGE-OVERLAPPING as xs:string := "Rdz 1,1-3. 2-5";
declare variable $SIGLUM-VERSE-SEQUENCE as xs:string := "Rdz 1,1. 3";
declare variable $SIGLUM-VERSE-NEXT as xs:string := "Rdz 1,1n";
declare variable $SIGLUM-VERSE-NEXT-NEXT as xs:string := "Rdz 1,1nn";
declare variable $SIGLUM-VERSE-SEQUENCE-NEXT as xs:string := "Rdz 1,1. 3n";
declare variable $SIGLUM-VERSE-SEQUENCE-OVERLAPPING-1 as xs:string := "Rdz 1,1. 1";
declare variable $SIGLUM-VERSE-SEQUENCE-OVERLAPPING-2 as xs:string := "Rdz 1,1n. 2";
declare variable $SIGLUM-VERSE-SEQUENCE-OVERLAPPING-3 as xs:string := "Rdz 1,1. 2n. 3";
declare variable $SIGLUM-VERSE-RANGE-SEQUENCE-OVERLAPPING as xs:string := "Rdz 1,1-3. 2";

declare variable $SIGLUM-VARIETY-1 as xs:string := "Rdz 1; 3,5; 5,6-10; 8; 10,2. 5. 8-11";
declare variable $SIGLUM-VARIETY-2 as xs:string := "Rdz 1; 3; 3,6";
declare variable $SIGLUM-VARIETY-3 as xs:string := "Rdz 5,3; 5,4; 5,5";
declare variable $SIGLUM-VARIETY-4 as xs:string := "Rdz 5,3-6; 5,4; 5,5";

let $expected-siglum-invalid :=
    map:map()
    => map:with($SIGLUM-INVALID, 'Invalid siglum')
let $expected-siglum-tome :=
    map:map()
    => map:with('tome', 'Rdz')

let $expected-single-chapter :=
    map:map()
    => map:with('tome', 'Rdz')
    => map:with('chapters', map:entry('1', '_all'))
let $expected-chapter-range-correct :=
    map:map()
    => map:with('tome', 'Rdz')
    => map:with('chapters',
            map:map()
            => map:with('1', '_all')
            => map:with('2', '_all')
            => map:with('3', '_all')
    )
let $expected-chapter-range-incorrect-1 :=
    map:map()
    => map:with($SIGLUM-CHAPTER-RANGE-INCORRECT-1, 'Invalid chapter range')
let $expected-chapter-range-incorrect-2 :=
    map:map()
    => map:with($SIGLUM-CHAPTER-RANGE-INCORRECT-2, 'Invalid chapter range')
let $expected-chapter-range-overlapping :=
    map:map()
    => map:with($SIGLUM-CHAPTER-RANGE-OVERLAPPING, 'Chapters overlap')
let $expected-chapter-sequence :=
    map:map()
    => map:with('tome', 'Rdz')
    => map:with('chapters',
            map:map()
            => map:with('1', '_all')
            => map:with('3', '_all')
    )
let $expected-chapter-sequence-overlapping :=
    map:map()
    => map:with($SIGLUM-CHAPTER-SEQUENCE-OVERLAPPING, 'Chapters overlap')
let $expected-chapter-range-sequence-overlapping :=
    map:map()
    => map:with($SIGLUM-CHAPTER-RANGE-SEQUENCE-OVERLAPPING, 'Chapters overlap')

let $expected-single-verse :=
    map:map()
    => map:with('tome', 'Rdz')
    => map:with('chapters',
            map:map()
            => map:with('1', '1')
    )
let $expected-verse-range-correct :=
    map:map()
    => map:with('tome', 'Rdz')
    => map:with('chapters',
            map:map()
            => map:with('1', ('1', '2', '3'))
    )
let $expected-verse-range-incorrect-1 :=
    map:map()
    => map:with($SIGLUM-VERSE-RANGE-INCORRECT-1, 'Invalid verse range')
let $expected-verse-range-incorrect-2 :=
    map:map()
    => map:with($SIGLUM-VERSE-RANGE-INCORRECT-2, 'Invalid verse range')
let $expected-verse-range-overlapping :=
    map:map()
    => map:with($SIGLUM-VERSE-RANGE-OVERLAPPING, 'Verses overlap')
let $expected-verse-sequence :=
    map:map()
    => map:with('tome', 'Rdz')
    => map:with('chapters',
            map:map()
            => map:with('1', ('1', '3'))
    )
let $expected-verse-next :=
    map:map()
    => map:with('tome', 'Rdz')
    => map:with('chapters',
            map:map()
            => map:with('1', ('1', '2'))
    )
let $expected-verse-next-next :=
    map:map()
    => map:with('tome', 'Rdz')
    => map:with('chapters',
            map:map()
            => map:with('1', ('1', '2', '3'))
    )
let $expected-verse-sequence-next :=
    map:map()
    => map:with('tome', 'Rdz')
    => map:with('chapters',
            map:map()
            => map:with('1', ('1', '3', '4'))
    )
let $expected-verse-sequence-overlapping-1 :=
    map:map()
    => map:with($SIGLUM-VERSE-SEQUENCE-OVERLAPPING-1, 'Verses overlap')
let $expected-verse-sequence-overlapping-2 :=
    map:map()
    => map:with($SIGLUM-VERSE-SEQUENCE-OVERLAPPING-2, 'Verses overlap')
let $expected-verse-sequence-overlapping-3 :=
    map:map()
    => map:with($SIGLUM-VERSE-SEQUENCE-OVERLAPPING-3, 'Verses overlap')
let $expected-verse-range-sequence-overlapping :=
    map:map()
    => map:with($SIGLUM-VERSE-RANGE-SEQUENCE-OVERLAPPING, 'Verses overlap')

let $expected-siglum-variety-1 :=
    map:map()
    => map:with('tome', 'Rdz')
    => map:with('chapters',
            map:map()
            => map:with('1', '_all')
            => map:with('3', '5')
            => map:with('5', ('6', '7', '8', '9', '10'))
            => map:with('8', '_all')
            => map:with('10', ('2', '5', '8', '9', '10', '11'))
    )
let $expected-siglum-variety-2 :=
    map:map()
    => map:with($SIGLUM-VARIETY-2, 'Chapters overlap')
let $expected-siglum-variety-3 :=
    map:map()
    => map:with($SIGLUM-VARIETY-3, 'Chapters overlap')
let $expected-siglum-variety-4 :=
    map:map()
    => map:with($SIGLUM-VARIETY-4, 'Chapters overlap')

let $actual-siglum-invalid := bib:interpret-siglum($SIGLUM-INVALID)
let $actual-siglum-tome := bib:interpret-siglum($SIGLUM-TOME)
let $actual-single-chapter := bib:interpret-siglum($SIGLUM-SINGLE-CHAPTER)
let $actual-chapter-range-correct := bib:interpret-siglum($SIGLUM-CHAPTER-RANGE-CORRECT)
let $actual-chapter-range-incorrect-1 := bib:interpret-siglum($SIGLUM-CHAPTER-RANGE-INCORRECT-1)
let $actual-chapter-range-incorrect-2 := bib:interpret-siglum($SIGLUM-CHAPTER-RANGE-INCORRECT-2)
let $actual-chapter-range-overlapping := bib:interpret-siglum($SIGLUM-CHAPTER-RANGE-OVERLAPPING)
let $actual-chapter-sequence := bib:interpret-siglum($SIGLUM-CHAPTER-SEQUENCE)
let $actual-chapter-sequence-overlapping := bib:interpret-siglum($SIGLUM-CHAPTER-SEQUENCE-OVERLAPPING)
let $actual-chapter-range-sequence-overlapping := bib:interpret-siglum($SIGLUM-CHAPTER-RANGE-SEQUENCE-OVERLAPPING)
let $actual-single-verse := bib:interpret-siglum($SIGLUM-SINGLE-VERSE)
let $actual-verse-range-correct := bib:interpret-siglum($SIGLUM-VERSE-RANGE-CORRECT)
let $actual-verse-range-incorrect-1 := bib:interpret-siglum($SIGLUM-VERSE-RANGE-INCORRECT-1)
let $actual-verse-range-incorrect-2 := bib:interpret-siglum($SIGLUM-VERSE-RANGE-INCORRECT-2)
let $actual-verse-range-overlapping := bib:interpret-siglum($SIGLUM-VERSE-RANGE-OVERLAPPING)
let $actual-verse-sequence := bib:interpret-siglum($SIGLUM-VERSE-SEQUENCE)
let $actual-verse-next := bib:interpret-siglum($SIGLUM-VERSE-NEXT)
let $actual-verse-next-next := bib:interpret-siglum($SIGLUM-VERSE-NEXT-NEXT)
let $actual-verse-sequence-next := bib:interpret-siglum($SIGLUM-VERSE-SEQUENCE-NEXT)
let $actual-verse-sequence-overlapping-1 := bib:interpret-siglum($SIGLUM-VERSE-SEQUENCE-OVERLAPPING-1)
let $actual-verse-sequence-overlapping-2 := bib:interpret-siglum($SIGLUM-VERSE-SEQUENCE-OVERLAPPING-2)
let $actual-verse-sequence-overlapping-3 := bib:interpret-siglum($SIGLUM-VERSE-SEQUENCE-OVERLAPPING-3)
let $actual-verse-range-sequence-overlapping := bib:interpret-siglum($SIGLUM-VERSE-RANGE-SEQUENCE-OVERLAPPING)
let $actual-siglum-variety-1 := bib:interpret-siglum($SIGLUM-VARIETY-1)
let $actual-siglum-variety-2 := bib:interpret-siglum($SIGLUM-VARIETY-2)
let $actual-siglum-variety-3 := bib:interpret-siglum($SIGLUM-VARIETY-3)
let $actual-siglum-variety-4 := bib:interpret-siglum($SIGLUM-VARIETY-4)

return (
    test:assert-equal-json($expected-siglum-invalid, $actual-siglum-invalid, 'Incorrect interpretation for siglum: ' || $SIGLUM-INVALID),
    test:assert-equal-json($expected-siglum-tome, $actual-siglum-tome, 'Incorrect interpretation for siglum: ' || $SIGLUM-TOME),
    test:assert-equal-json($expected-single-chapter, $actual-single-chapter, 'Incorrect interpretation for siglum: ' || $SIGLUM-SINGLE-CHAPTER),
    test:assert-equal-json($expected-chapter-range-correct, $actual-chapter-range-correct, 'Incorrect interpretation for siglum: ' || $SIGLUM-CHAPTER-RANGE-CORRECT),
    test:assert-equal-json($expected-chapter-range-incorrect-1, $actual-chapter-range-incorrect-1, 'Incorrect interpretation for siglum: ' || $SIGLUM-CHAPTER-RANGE-INCORRECT-1),
    test:assert-equal-json($expected-chapter-range-incorrect-2, $actual-chapter-range-incorrect-2, 'Incorrect interpretation for siglum: ' || $SIGLUM-CHAPTER-RANGE-INCORRECT-2),
    test:assert-equal-json($expected-chapter-range-overlapping, $actual-chapter-range-overlapping, 'Incorrect interpretation for siglum: ' || $SIGLUM-CHAPTER-RANGE-OVERLAPPING),
    test:assert-equal-json($expected-chapter-sequence, $actual-chapter-sequence, 'Incorrect interpretation for siglum: ' || $SIGLUM-CHAPTER-SEQUENCE),
    test:assert-equal-json($expected-chapter-sequence-overlapping, $actual-chapter-sequence-overlapping, 'Incorrect interpretation for siglum: ' || $SIGLUM-CHAPTER-SEQUENCE-OVERLAPPING),
    test:assert-equal-json($expected-chapter-range-sequence-overlapping, $actual-chapter-range-sequence-overlapping, 'Incorrect interpretation for siglum: ' || $SIGLUM-CHAPTER-RANGE-SEQUENCE-OVERLAPPING),
    test:assert-equal-json($expected-single-verse, $actual-single-verse, 'Incorrect interpretation for siglum: ' || $SIGLUM-SINGLE-VERSE),
    test:assert-equal-json($expected-verse-range-correct, $actual-verse-range-correct, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-RANGE-CORRECT),
    test:assert-equal-json($expected-verse-range-incorrect-1, $actual-verse-range-incorrect-1, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-RANGE-INCORRECT-1),
    test:assert-equal-json($expected-verse-range-incorrect-2, $actual-verse-range-incorrect-2, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-RANGE-INCORRECT-2),
    test:assert-equal-json($expected-verse-range-overlapping, $actual-verse-range-overlapping, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-RANGE-OVERLAPPING),
    test:assert-equal-json($expected-verse-sequence, $actual-verse-sequence, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-SEQUENCE),
    test:assert-equal-json($expected-verse-next, $actual-verse-next, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-NEXT),
    test:assert-equal-json($expected-verse-next-next, $actual-verse-next-next, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-NEXT-NEXT),
    test:assert-equal-json($expected-verse-sequence-next, $actual-verse-sequence-next, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-SEQUENCE-NEXT),
    test:assert-equal-json($expected-verse-sequence-overlapping-1, $actual-verse-sequence-overlapping-1, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-SEQUENCE-OVERLAPPING-1),
    test:assert-equal-json($expected-verse-sequence-overlapping-2, $actual-verse-sequence-overlapping-2, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-SEQUENCE-OVERLAPPING-2),
    test:assert-equal-json($expected-verse-sequence-overlapping-3, $actual-verse-sequence-overlapping-3, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-SEQUENCE-OVERLAPPING-3),
    test:assert-equal-json($expected-verse-range-sequence-overlapping, $actual-verse-range-sequence-overlapping, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-RANGE-SEQUENCE-OVERLAPPING),
    test:assert-equal-json($expected-siglum-variety-1, $actual-siglum-variety-1, 'Incorrect interpretation for siglum: ' || $SIGLUM-VARIETY-1),
    test:assert-equal-json($expected-siglum-variety-2, $actual-siglum-variety-2, 'Incorrect interpretation for siglum: ' || $SIGLUM-VARIETY-2),
    test:assert-equal-json($expected-siglum-variety-3, $actual-siglum-variety-3, 'Incorrect interpretation for siglum: ' || $SIGLUM-VARIETY-3),
    test:assert-equal-json($expected-siglum-variety-4, $actual-siglum-variety-4, 'Incorrect interpretation for siglum: ' || $SIGLUM-VARIETY-4)
)