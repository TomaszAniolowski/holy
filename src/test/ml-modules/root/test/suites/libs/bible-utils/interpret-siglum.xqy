xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace test-utils = "http://marklogic.com/holy/test/test-utils" at "/test/lib/test-utils.xqy";
import module namespace bib = "http://marklogic.com/holy/ml-modules/bible-utils" at "/libs/bible-utils.xqy";

declare variable $SIGLUM-INVALID as xs:string := 'Rdz 1-3,2';
declare variable $SIGLUM-TOME as xs:string := 'Rdz';

declare variable $SIGLUM-SINGLE-CHAPTER as xs:string := 'Rdz 1';
declare variable $SIGLUM-CHAPTER-RANGE-CORRECT-1 as xs:string := 'Rdz 1-3';
declare variable $SIGLUM-CHAPTER-RANGE-CORRECT-2 as xs:string := 'Syr Prolog-3';
declare variable $SIGLUM-CHAPTER-RANGE-INCORRECT-1 as xs:string := 'Rdz 1-1';
declare variable $SIGLUM-CHAPTER-RANGE-INCORRECT-2 as xs:string := 'Rdz 3-1';
declare variable $SIGLUM-CHAPTER-RANGE-OVERLAPPING as xs:string := 'Rdz 1-3; 2-5';
declare variable $SIGLUM-CHAPTER-RANGE-OVERLAPPING-2 as xs:string := 'Rdz 2; 1-5';
declare variable $SIGLUM-CHAPTER-SEQUENCE as xs:string := 'Rdz 1; 3';
declare variable $SIGLUM-CHAPTER-SEQUENCE-OVERLAPPING as xs:string := 'Rdz 1; 1';
declare variable $SIGLUM-CHAPTER-RANGE-SEQUENCE-OVERLAPPING as xs:string := 'Rdz 1-3; 2';

declare variable $SIGLUM-SINGLE-VERSE as xs:string := 'Rdz 1,1';
declare variable $SIGLUM-VERSE-RANGE-CORRECT as xs:string := 'Rdz 1,1-3';
declare variable $SIGLUM-VERSE-RANGE-INCORRECT-1 as xs:string := 'Rdz 1,1-1';
declare variable $SIGLUM-VERSE-RANGE-INCORRECT-2 as xs:string := 'Rdz 1,3-1';
declare variable $SIGLUM-VERSE-RANGE-OVERLAPPING as xs:string := 'Rdz 1,1-3. 2-5';
declare variable $SIGLUM-VERSE-SEQUENCE as xs:string := 'Rdz 1,1. 3';
declare variable $SIGLUM-VERSE-NEXT as xs:string := 'Rdz 1,1n';
declare variable $SIGLUM-VERSE-NEXT-NEXT as xs:string := 'Rdz 1,1nn';
declare variable $SIGLUM-VERSE-SEQUENCE-NEXT as xs:string := 'Rdz 1,1. 3n';
declare variable $SIGLUM-VERSE-SEQUENCE-OVERLAPPING-1 as xs:string := 'Rdz 1,1. 1';
declare variable $SIGLUM-VERSE-SEQUENCE-OVERLAPPING-2 as xs:string := 'Rdz 1,1n. 2';
declare variable $SIGLUM-VERSE-SEQUENCE-OVERLAPPING-3 as xs:string := 'Rdz 1,1. 2n. 3';
declare variable $SIGLUM-VERSE-RANGE-SEQUENCE-OVERLAPPING as xs:string := 'Rdz 1,1-3. 2';
declare variable $SIGLUM-VERSE-NOT-FOUND-1 as xs:string := 'Rdz 1,32';
declare variable $SIGLUM-VERSE-NOT-FOUND-2 as xs:string := 'Rdz 1,30-32';
declare variable $SIGLUM-VERSE-NOT-FOUND-3 as xs:string := 'Rdz 1,32-35';
declare variable $SIGLUM-VERSE-NOT-FOUND-4 as xs:string := 'Rdz 1,31n';
declare variable $SIGLUM-VERSE-NOT-FOUND-5 as xs:string := 'Rdz 1,30nn';

declare variable $SIGLUM-VERSE-WITH-LETTER-PART-1 as xs:string := 'Est 1,1a';
declare variable $SIGLUM-VERSE-WITH-LETTER-PART-2 as xs:string := 'Est 1,1n';
declare variable $SIGLUM-VERSE-WITH-LETTER-PART-3 as xs:string := 'Est 1,1nn';
declare variable $SIGLUM-VERSE-WITH-LETTER-PART-4 as xs:string := 'Est 1,1nnn';
declare variable $SIGLUM-VERSE-WITH-LETTER-PART-5 as xs:string := 'Est 1,2n';
declare variable $SIGLUM-VERSE-WITH-LETTER-PART-RANGE-CORRECT-1 as xs:string := 'Est 1,1a-1c';
declare variable $SIGLUM-VERSE-WITH-LETTER-PART-RANGE-CORRECT-2 as xs:string := 'Est 1,1a-2';
declare variable $SIGLUM-VERSE-WITH-LETTER-PART-RANGE-CORRECT-3 as xs:string := 'Est 4,15-17m';
declare variable $SIGLUM-VERSE-WITH-LETTER-PART-RANGE-INCORRECT-1 as xs:string := 'Est 1,1a-1a';
declare variable $SIGLUM-VERSE-WITH-LETTER-PART-RANGE-INCORRECT-2 as xs:string := 'Est 1,1c-1a';
declare variable $SIGLUM-VERSE-WITH-LETTER-PART-RANGE-INCORRECT-3 as xs:string := 'Est 1,3-1a';
declare variable $SIGLUM-VERSE-WITH-LETTER-PART-RANGE-INCORRECT-4 as xs:string := 'Est 4,17m-15';
declare variable $SIGLUM-VERSE-WITH-LETTER-PART-SEQUENCE as xs:string := 'Est 4,17a. 17d';
declare variable $SIGLUM-VERSE-WITH-LETTER-PART-NEXT as xs:string := 'Est 4,17an';
declare variable $SIGLUM-VERSE-WITH-LETTER-PART-NEXT-NEXT as xs:string := 'Est 4,17ann';
declare variable $SIGLUM-VERSE-WITH-LETTER-PART-SEQUENCE-OVERLAPPING-1 as xs:string := 'Est 1,1a. 1a';
declare variable $SIGLUM-VERSE-WITH-LETTER-PART-SEQUENCE-OVERLAPPING-2 as xs:string := 'Est 1,1an. 1b';
declare variable $SIGLUM-VERSE-WITH-LETTER-PART-SEQUENCE-OVERLAPPING-3 as xs:string := 'Est 1,1rn. 1';
declare variable $SIGLUM-VERSE-WITH-LETTER-PART-RANGE-SEQUENCE-OVERLAPPING as xs:string := "Est 1,1a-1c. 1b";

declare variable $SIGLUM-EXCEPTIONAL-VERSES-1-CORRECT as xs:string := 'Est 1,1a-1';
declare variable $SIGLUM-EXCEPTIONAL-VERSES-1-INCORRECT as xs:string := 'Est 1,1-1a';
declare variable $SIGLUM-EXCEPTIONAL-VERSES-2-CORRECT as xs:string := 'Est 10,3-3a';
declare variable $SIGLUM-EXCEPTIONAL-VERSES-2-INCORRECT as xs:string := 'Est 10,3a-3';
declare variable $SIGLUM-EXCEPTIONAL-VERSES-3-CORRECT-1 as xs:string := 'Ne 11,3a-4b';
declare variable $SIGLUM-EXCEPTIONAL-VERSES-3-CORRECT-2 as xs:string := 'Ne 11,3b-3a';
declare variable $SIGLUM-EXCEPTIONAL-VERSES-3-CORRECT-3 as xs:string := 'Ne 11,3b-4a';
declare variable $SIGLUM-EXCEPTIONAL-VERSES-3-CORRECT-4 as xs:string := 'Ne 11,3b-4b';
declare variable $SIGLUM-EXCEPTIONAL-VERSES-3-CORRECT-5 as xs:string := 'Ne 11,4a-3a';
declare variable $SIGLUM-EXCEPTIONAL-VERSES-3-CORRECT-6 as xs:string := 'Ne 11,4a-4b';
declare variable $SIGLUM-EXCEPTIONAL-VERSES-3-INCORRECT-1 as xs:string := 'Ne 11,3a-3b';
declare variable $SIGLUM-EXCEPTIONAL-VERSES-3-INCORRECT-2 as xs:string := 'Ne 11,3a-4a';
declare variable $SIGLUM-EXCEPTIONAL-VERSES-3-INCORRECT-3 as xs:string := 'Ne 11,4a-3b';
declare variable $SIGLUM-EXCEPTIONAL-VERSES-3-INCORRECT-4 as xs:string := 'Ne 11,4b-3a';
declare variable $SIGLUM-EXCEPTIONAL-VERSES-3-INCORRECT-5 as xs:string := 'Ne 11,4b-3b';
declare variable $SIGLUM-EXCEPTIONAL-VERSES-3-INCORRECT-6 as xs:string := 'Ne 11,4b-4a';
declare variable $SIGLUM-EXCEPTIONAL-VERSES-4-CORRECT-1 as xs:string := 'Ne 3,26b-27';
declare variable $SIGLUM-EXCEPTIONAL-VERSES-4-CORRECT-2 as xs:string := 'Ne 3,26b-26a';
declare variable $SIGLUM-EXCEPTIONAL-VERSES-4-CORRECT-3 as xs:string := 'Ne 3,27-26a';
declare variable $SIGLUM-EXCEPTIONAL-VERSES-4-INCORRECT-1 as xs:string := 'Ne 3,27-26b';
declare variable $SIGLUM-EXCEPTIONAL-VERSES-4-INCORRECT-2 as xs:string := 'Ne 3,26a-26b';
declare variable $SIGLUM-EXCEPTIONAL-VERSES-4-INCORRECT-3 as xs:string := 'Ne 3,26a-27';

declare variable $SIGLUM-VARIETY-1 as xs:string := 'Rdz 1; 3,5; 5,6-10; 8; 10,2. 5. 8-11';
declare variable $SIGLUM-VARIETY-2 as xs:string := 'Rdz 1; 3; 3,6';
declare variable $SIGLUM-VARIETY-3 as xs:string := 'Rdz 5,3; 5,4; 5,5';
declare variable $SIGLUM-VARIETY-4 as xs:string := 'Rdz 5,3-6; 5,4; 5,5';

let $expected-siglum-invalid :=
    map:map()
    => map:with($SIGLUM-INVALID, 'Invalid siglum')
let $expected-siglum-tome :=
    map:map()
    => map:with('tome', 'Rdz')
    => map:with('chapters',
            map:new(((1 to 50) ! map:entry(xs:string(.), '_all')))
    )

let $expected-single-chapter :=
    map:map()
    => map:with('tome', 'Rdz')
    => map:with('chapters', map:entry('1', '_all'))
let $expected-chapter-range-correct-1 :=
    map:map()
    => map:with('tome', 'Rdz')
    => map:with('chapters',
            map:map()
            => map:with('1', '_all')
            => map:with('2', '_all')
            => map:with('3', '_all')
    )
let $expected-chapter-range-correct-2 :=
    map:map()
    => map:with('tome', 'Syr')
    => map:with('chapters',
            map:map()
            => map:with('Prolog', '_all')
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
let $expected-chapter-range-overlapping-2 :=
    map:map()
    => map:with($SIGLUM-CHAPTER-RANGE-OVERLAPPING-2, 'Chapters overlap')
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
let $expected-verse-not-found-1 :=
    map:map()
    => map:with($SIGLUM-VERSE-NOT-FOUND-1, 'Verse not found [' || $SIGLUM-VERSE-NOT-FOUND-1 || ']')
let $expected-verse-not-found-2 :=
    map:map()
    => map:with($SIGLUM-VERSE-NOT-FOUND-2, 'Verse not found [Rdz 1,32]')
let $expected-verse-not-found-3 :=
    map:map()
    => map:with($SIGLUM-VERSE-NOT-FOUND-3, 'Verse not found [Rdz 1,32]')
let $expected-verse-not-found-4 :=
    map:map()
    => map:with($SIGLUM-VERSE-NOT-FOUND-4, 'Verse not found [' || $SIGLUM-VERSE-NOT-FOUND-4 || ']')
let $expected-verse-not-found-5 :=
    map:map()
    => map:with($SIGLUM-VERSE-NOT-FOUND-5, 'Verse not found [' || $SIGLUM-VERSE-NOT-FOUND-5 || ']')

let $expected-verse-with-letter-part-1 :=
    map:map()
    => map:with('tome', 'Est')
    => map:with('chapters',
            map:map()
            => map:with('1', '1a')
    )
let $expected-verse-with-letter-part-2 :=
    map:map()
    => map:with('tome', 'Est')
    => map:with('chapters',
            map:map()
            => map:with('1', '1n')
    )
let $expected-verse-with-letter-part-3 :=
    map:map()
    => map:with('tome', 'Est')
    => map:with('chapters',
            map:map()
            => map:with('1', ('1n', '1o'))
    )
let $expected-verse-with-letter-part-4 :=
    map:map()
    => map:with('tome', 'Est')
    => map:with('chapters',
            map:map()
            => map:with('1', ('1n', '1o', '1p'))
    )
let $expected-verse-with-letter-part-5 :=
    map:map()
    => map:with('tome', 'Est')
    => map:with('chapters',
            map:map()
            => map:with('1', ('2', '3'))
    )
let $expected-verse-with-letter-part-range-correct-1 :=
    map:map()
    => map:with('tome', 'Est')
    => map:with('chapters',
            map:map()
            => map:with('1', ('1a', '1b', '1c'))
    )
let $expected-verse-with-letter-part-range-correct-2 :=
    map:map()
    => map:with('tome', 'Est')
    => map:with('chapters',
            map:map()
            => map:with('1', ('1a', '1b', '1c', '1d', '1e', '1f', '1g', '1h', '1i', '1k', '1l', '1m', '1n', '1o', '1p', '1q', '1r', '1', '2'))
    )
let $expected-verse-with-letter-part-range-correct-3 :=
    map:map()
    => map:with('tome', 'Est')
    => map:with('chapters',
            map:map()
            => map:with('4', ('15', '16', '17', '17a', '17b', '17c', '17d', '17e', '17f', '17g', '17h', '17i', '17k', '17l', '17m'))
    )
let $expected-verse-with-letter-part-range-incorrect-1 :=
    map:map()
    => map:with($SIGLUM-VERSE-WITH-LETTER-PART-RANGE-INCORRECT-1, 'Invalid verse range')
let $expected-verse-with-letter-part-range-incorrect-2 :=
    map:map()
    => map:with($SIGLUM-VERSE-WITH-LETTER-PART-RANGE-INCORRECT-2, 'Invalid verse range')
let $expected-verse-with-letter-part-range-incorrect-3 :=
    map:map()
    => map:with($SIGLUM-VERSE-WITH-LETTER-PART-RANGE-INCORRECT-3, 'Invalid verse range')
let $expected-verse-with-letter-part-range-incorrect-4 :=
    map:map()
    => map:with($SIGLUM-VERSE-WITH-LETTER-PART-RANGE-INCORRECT-4, 'Invalid verse range')
let $expected-verse-with-letter-part-sequence :=
    map:map()
    => map:with('tome', 'Est')
    => map:with('chapters',
            map:map()
            => map:with('4', ('17a', '17d'))
    )
let $expected-verse-with-letter-part-next :=
    map:map()
    => map:with('tome', 'Est')
    => map:with('chapters',
            map:map()
            => map:with('4', ('17a', '17b'))
    )
let $expected-verse-with-letter-part-next-next :=
    map:map()
    => map:with('tome', 'Est')
    => map:with('chapters',
            map:map()
            => map:with('4', ('17a', '17b', '17c'))
    )
let $expected-verse-with-letter-part-sequence-overlapping-1 :=
    map:map()
    => map:with($SIGLUM-VERSE-WITH-LETTER-PART-SEQUENCE-OVERLAPPING-1, 'Verses overlap')
let $expected-verse-with-letter-part-sequence-overlapping-2 :=
    map:map()
    => map:with($SIGLUM-VERSE-WITH-LETTER-PART-SEQUENCE-OVERLAPPING-2, 'Verses overlap')
let $expected-verse-with-letter-part-sequence-overlapping-3 :=
    map:map()
    => map:with($SIGLUM-VERSE-WITH-LETTER-PART-SEQUENCE-OVERLAPPING-3, 'Verses overlap')
let $expected-verse-with-letter-part-range-sequence-overlapping :=
    map:map()
    => map:with($SIGLUM-VERSE-WITH-LETTER-PART-RANGE-SEQUENCE-OVERLAPPING, 'Verses overlap')

let $expected-exceptional-verses-1-correct :=
    map:map()
    => map:with('tome', 'Est')
    => map:with('chapters',
            map:map()
            => map:with('1', ('1a', '1b', '1c', '1d', '1e', '1f', '1g', '1h', '1i', '1k', '1l', '1m', '1n', '1o', '1p', '1q', '1r', '1'))
    )
let $expected-exceptional-verses-1-incorrect :=
    map:map()
    => map:with($SIGLUM-EXCEPTIONAL-VERSES-1-INCORRECT, 'Invalid verse range')
let $expected-exceptional-verses-2-correct :=
    map:map()
    => map:with('tome', 'Est')
    => map:with('chapters',
            map:map()
            => map:with('10', ('3', '3a'))
    )
let $expected-exceptional-verses-2-incorrect :=
    map:map()
    => map:with($SIGLUM-EXCEPTIONAL-VERSES-2-INCORRECT, 'Invalid verse range')
let $expected-exceptional-verses-3-correct-1 :=
    map:map()
    => map:with('tome', 'Ne')
    => map:with('chapters',
            map:map()
            => map:with('11', ('3a', '4b'))
    )
let $expected-exceptional-verses-3-correct-2 :=
    map:map()
    => map:with('tome', 'Ne')
    => map:with('chapters',
            map:map()
            => map:with('11', ('3b', '4a', '3a'))
    )
let $expected-exceptional-verses-3-correct-3 :=
    map:map()
    => map:with('tome', 'Ne')
    => map:with('chapters',
            map:map()
            => map:with('11', ('3b', '4a'))
    )
let $expected-exceptional-verses-3-correct-4 :=
    map:map()
    => map:with('tome', 'Ne')
    => map:with('chapters',
            map:map()
            => map:with('11', ('3b', '4a', '3a', '4b'))
    )
let $expected-exceptional-verses-3-correct-5 :=
    map:map()
    => map:with('tome', 'Ne')
    => map:with('chapters',
            map:map()
            => map:with('11', ('4a', '3a'))
    )
let $expected-exceptional-verses-3-correct-6 :=
    map:map()
    => map:with('tome', 'Ne')
    => map:with('chapters',
            map:map()
            => map:with('11', ('4a', '3a', '4b'))
    )
let $expected-exceptional-verses-3-incorrect-1 :=
    map:map()
    => map:with($SIGLUM-EXCEPTIONAL-VERSES-3-INCORRECT-1, 'Invalid verse range')
let $expected-exceptional-verses-3-incorrect-2 :=
    map:map()
    => map:with($SIGLUM-EXCEPTIONAL-VERSES-3-INCORRECT-2, 'Invalid verse range')
let $expected-exceptional-verses-3-incorrect-3 :=
    map:map()
    => map:with($SIGLUM-EXCEPTIONAL-VERSES-3-INCORRECT-3, 'Invalid verse range')
let $expected-exceptional-verses-3-incorrect-4 :=
    map:map()
    => map:with($SIGLUM-EXCEPTIONAL-VERSES-3-INCORRECT-4, 'Invalid verse range')
let $expected-exceptional-verses-3-incorrect-5 :=
    map:map()
    => map:with($SIGLUM-EXCEPTIONAL-VERSES-3-INCORRECT-5, 'Invalid verse range')
let $expected-exceptional-verses-3-incorrect-6 :=
    map:map()
    => map:with($SIGLUM-EXCEPTIONAL-VERSES-3-INCORRECT-6, 'Invalid verse range')
let $expected-exceptional-verses-4-correct-1 :=
    map:map()
    => map:with('tome', 'Ne')
    => map:with('chapters',
            map:map()
            => map:with('3', ('26b', '27'))
    )
let $expected-exceptional-verses-4-correct-2 :=
    map:map()
    => map:with('tome', 'Ne')
    => map:with('chapters',
            map:map()
            => map:with('3', ('26b', '27', '26a'))
    )
let $expected-exceptional-verses-4-correct-3 :=
    map:map()
    => map:with('tome', 'Ne')
    => map:with('chapters',
            map:map()
            => map:with('3', ('27', '26a'))
    )
let $expected-exceptional-verses-4-incorrect-1 :=
    map:map()
    => map:with($SIGLUM-EXCEPTIONAL-VERSES-4-INCORRECT-1, 'Invalid verse range')
let $expected-exceptional-verses-4-incorrect-2 :=
    map:map()
    => map:with($SIGLUM-EXCEPTIONAL-VERSES-4-INCORRECT-2, 'Invalid verse range')
let $expected-exceptional-verses-4-incorrect-3 :=
    map:map()
    => map:with($SIGLUM-EXCEPTIONAL-VERSES-4-INCORRECT-3, 'Invalid verse range')

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
let $actual-chapter-range-correct-1 := bib:interpret-siglum($SIGLUM-CHAPTER-RANGE-CORRECT-1)
let $actual-chapter-range-correct-2 := bib:interpret-siglum($SIGLUM-CHAPTER-RANGE-CORRECT-2)
let $actual-chapter-range-incorrect-1 := bib:interpret-siglum($SIGLUM-CHAPTER-RANGE-INCORRECT-1)
let $actual-chapter-range-incorrect-2 := bib:interpret-siglum($SIGLUM-CHAPTER-RANGE-INCORRECT-2)
let $actual-chapter-range-overlapping := bib:interpret-siglum($SIGLUM-CHAPTER-RANGE-OVERLAPPING)
let $actual-chapter-range-overlapping-2 := bib:interpret-siglum($SIGLUM-CHAPTER-RANGE-OVERLAPPING-2)
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
let $actual-verse-not-found-1 := bib:interpret-siglum($SIGLUM-VERSE-NOT-FOUND-1)
let $actual-verse-not-found-2 := bib:interpret-siglum($SIGLUM-VERSE-NOT-FOUND-2)
let $actual-verse-not-found-3 := bib:interpret-siglum($SIGLUM-VERSE-NOT-FOUND-3)
let $actual-verse-not-found-4 := bib:interpret-siglum($SIGLUM-VERSE-NOT-FOUND-4)
let $actual-verse-not-found-5 := bib:interpret-siglum($SIGLUM-VERSE-NOT-FOUND-5)
let $actual-verse-with-letter-part-1 := bib:interpret-siglum($SIGLUM-VERSE-WITH-LETTER-PART-1)
let $actual-verse-with-letter-part-2 := bib:interpret-siglum($SIGLUM-VERSE-WITH-LETTER-PART-2)
let $actual-verse-with-letter-part-3 := bib:interpret-siglum($SIGLUM-VERSE-WITH-LETTER-PART-3)
let $actual-verse-with-letter-part-4 := bib:interpret-siglum($SIGLUM-VERSE-WITH-LETTER-PART-4)
let $actual-verse-with-letter-part-5 := bib:interpret-siglum($SIGLUM-VERSE-WITH-LETTER-PART-5)
let $actual-verse-with-letter-part-range-correct-1 := bib:interpret-siglum($SIGLUM-VERSE-WITH-LETTER-PART-RANGE-CORRECT-1)
let $actual-verse-with-letter-part-range-correct-2 := bib:interpret-siglum($SIGLUM-VERSE-WITH-LETTER-PART-RANGE-CORRECT-2)
let $actual-verse-with-letter-part-range-correct-3 := bib:interpret-siglum($SIGLUM-VERSE-WITH-LETTER-PART-RANGE-CORRECT-3)
let $actual-verse-with-letter-part-range-incorrect-1 := bib:interpret-siglum($SIGLUM-VERSE-WITH-LETTER-PART-RANGE-INCORRECT-1)
let $actual-verse-with-letter-part-range-incorrect-2 := bib:interpret-siglum($SIGLUM-VERSE-WITH-LETTER-PART-RANGE-INCORRECT-2)
let $actual-verse-with-letter-part-range-incorrect-3 := bib:interpret-siglum($SIGLUM-VERSE-WITH-LETTER-PART-RANGE-INCORRECT-3)
let $actual-verse-with-letter-part-range-incorrect-4 := bib:interpret-siglum($SIGLUM-VERSE-WITH-LETTER-PART-RANGE-INCORRECT-4)
let $actual-verse-with-letter-part-sequence := bib:interpret-siglum($SIGLUM-VERSE-WITH-LETTER-PART-SEQUENCE)
let $actual-verse-with-letter-part-next := bib:interpret-siglum($SIGLUM-VERSE-WITH-LETTER-PART-NEXT)
let $actual-verse-with-letter-part-next-next := bib:interpret-siglum($SIGLUM-VERSE-WITH-LETTER-PART-NEXT-NEXT)
let $actual-verse-with-letter-part-sequence-overlapping-1 := bib:interpret-siglum($SIGLUM-VERSE-WITH-LETTER-PART-SEQUENCE-OVERLAPPING-1)
let $actual-verse-with-letter-part-sequence-overlapping-2 := bib:interpret-siglum($SIGLUM-VERSE-WITH-LETTER-PART-SEQUENCE-OVERLAPPING-2)
let $actual-verse-with-letter-part-sequence-overlapping-3 := bib:interpret-siglum($SIGLUM-VERSE-WITH-LETTER-PART-SEQUENCE-OVERLAPPING-3)
let $actual-verse-with-letter-part-range-sequence-overlapping := bib:interpret-siglum($SIGLUM-VERSE-WITH-LETTER-PART-RANGE-SEQUENCE-OVERLAPPING)
let $actual-exceptional-verses-1-correct := bib:interpret-siglum($SIGLUM-EXCEPTIONAL-VERSES-1-CORRECT)
let $actual-exceptional-verses-1-incorrect := bib:interpret-siglum($SIGLUM-EXCEPTIONAL-VERSES-1-INCORRECT)
let $actual-exceptional-verses-2-correct := bib:interpret-siglum($SIGLUM-EXCEPTIONAL-VERSES-2-CORRECT)
let $actual-exceptional-verses-2-incorrect := bib:interpret-siglum($SIGLUM-EXCEPTIONAL-VERSES-2-INCORRECT)
let $actual-exceptional-verses-3-correct-1 := bib:interpret-siglum($SIGLUM-EXCEPTIONAL-VERSES-3-CORRECT-1)
let $actual-exceptional-verses-3-correct-2 := bib:interpret-siglum($SIGLUM-EXCEPTIONAL-VERSES-3-CORRECT-2)
let $actual-exceptional-verses-3-correct-3 := bib:interpret-siglum($SIGLUM-EXCEPTIONAL-VERSES-3-CORRECT-3)
let $actual-exceptional-verses-3-correct-4 := bib:interpret-siglum($SIGLUM-EXCEPTIONAL-VERSES-3-CORRECT-4)
let $actual-exceptional-verses-3-correct-5 := bib:interpret-siglum($SIGLUM-EXCEPTIONAL-VERSES-3-CORRECT-5)
let $actual-exceptional-verses-3-correct-6 := bib:interpret-siglum($SIGLUM-EXCEPTIONAL-VERSES-3-CORRECT-6)
let $actual-exceptional-verses-3-incorrect-1 := bib:interpret-siglum($SIGLUM-EXCEPTIONAL-VERSES-3-INCORRECT-1)
let $actual-exceptional-verses-3-incorrect-2 := bib:interpret-siglum($SIGLUM-EXCEPTIONAL-VERSES-3-INCORRECT-2)
let $actual-exceptional-verses-3-incorrect-3 := bib:interpret-siglum($SIGLUM-EXCEPTIONAL-VERSES-3-INCORRECT-3)
let $actual-exceptional-verses-3-incorrect-4 := bib:interpret-siglum($SIGLUM-EXCEPTIONAL-VERSES-3-INCORRECT-4)
let $actual-exceptional-verses-3-incorrect-5 := bib:interpret-siglum($SIGLUM-EXCEPTIONAL-VERSES-3-INCORRECT-5)
let $actual-exceptional-verses-3-incorrect-6 := bib:interpret-siglum($SIGLUM-EXCEPTIONAL-VERSES-3-INCORRECT-6)
let $actual-exceptional-verses-4-correct-1 := bib:interpret-siglum($SIGLUM-EXCEPTIONAL-VERSES-4-CORRECT-1)
let $actual-exceptional-verses-4-correct-2 := bib:interpret-siglum($SIGLUM-EXCEPTIONAL-VERSES-4-CORRECT-2)
let $actual-exceptional-verses-4-correct-3 := bib:interpret-siglum($SIGLUM-EXCEPTIONAL-VERSES-4-CORRECT-3)
let $actual-exceptional-verses-4-incorrect-1 := bib:interpret-siglum($SIGLUM-EXCEPTIONAL-VERSES-4-INCORRECT-1)
let $actual-exceptional-verses-4-incorrect-2 := bib:interpret-siglum($SIGLUM-EXCEPTIONAL-VERSES-4-INCORRECT-2)
let $actual-exceptional-verses-4-incorrect-3 := bib:interpret-siglum($SIGLUM-EXCEPTIONAL-VERSES-4-INCORRECT-3)
let $actual-siglum-variety-1 := bib:interpret-siglum($SIGLUM-VARIETY-1)
let $actual-siglum-variety-2 := bib:interpret-siglum($SIGLUM-VARIETY-2)
let $actual-siglum-variety-3 := bib:interpret-siglum($SIGLUM-VARIETY-3)
let $actual-siglum-variety-4 := bib:interpret-siglum($SIGLUM-VARIETY-4)

return (
    test-utils:assert-map-equal($expected-siglum-invalid, $actual-siglum-invalid, 'Incorrect interpretation for siglum: ' || $SIGLUM-INVALID),
    test-utils:assert-map-equal($expected-siglum-tome, $actual-siglum-tome, 'Incorrect interpretation for siglum: ' || $SIGLUM-TOME),
    test-utils:assert-map-equal($expected-single-chapter, $actual-single-chapter, 'Incorrect interpretation for siglum: ' || $SIGLUM-SINGLE-CHAPTER),
    test-utils:assert-map-equal($expected-chapter-range-correct-1, $actual-chapter-range-correct-1, 'Incorrect interpretation for siglum: ' || $SIGLUM-CHAPTER-RANGE-CORRECT-1),
    test-utils:assert-map-equal($expected-chapter-range-correct-2, $actual-chapter-range-correct-2, 'Incorrect interpretation for siglum: ' || $SIGLUM-CHAPTER-RANGE-CORRECT-2),
    test-utils:assert-map-equal($expected-chapter-range-incorrect-1, $actual-chapter-range-incorrect-1, 'Incorrect interpretation for siglum: ' || $SIGLUM-CHAPTER-RANGE-INCORRECT-1),
    test-utils:assert-map-equal($expected-chapter-range-incorrect-2, $actual-chapter-range-incorrect-2, 'Incorrect interpretation for siglum: ' || $SIGLUM-CHAPTER-RANGE-INCORRECT-2),
    test-utils:assert-map-equal($expected-chapter-range-overlapping, $actual-chapter-range-overlapping, 'Incorrect interpretation for siglum: ' || $SIGLUM-CHAPTER-RANGE-OVERLAPPING),
    test-utils:assert-map-equal($expected-chapter-range-overlapping-2, $actual-chapter-range-overlapping-2, 'Incorrect interpretation for siglum: ' || $SIGLUM-CHAPTER-RANGE-OVERLAPPING-2),
    test-utils:assert-map-equal($expected-chapter-sequence, $actual-chapter-sequence, 'Incorrect interpretation for siglum: ' || $SIGLUM-CHAPTER-SEQUENCE),
    test-utils:assert-map-equal($expected-chapter-sequence-overlapping, $actual-chapter-sequence-overlapping, 'Incorrect interpretation for siglum: ' || $SIGLUM-CHAPTER-SEQUENCE-OVERLAPPING),
    test-utils:assert-map-equal($expected-chapter-range-sequence-overlapping, $actual-chapter-range-sequence-overlapping, 'Incorrect interpretation for siglum: ' || $SIGLUM-CHAPTER-RANGE-SEQUENCE-OVERLAPPING),
    test-utils:assert-map-equal($expected-single-verse, $actual-single-verse, 'Incorrect interpretation for siglum: ' || $SIGLUM-SINGLE-VERSE),
    test-utils:assert-map-equal($expected-verse-range-correct, $actual-verse-range-correct, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-RANGE-CORRECT),
    test-utils:assert-map-equal($expected-verse-range-incorrect-1, $actual-verse-range-incorrect-1, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-RANGE-INCORRECT-1),
    test-utils:assert-map-equal($expected-verse-range-incorrect-2, $actual-verse-range-incorrect-2, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-RANGE-INCORRECT-2),
    test-utils:assert-map-equal($expected-verse-range-overlapping, $actual-verse-range-overlapping, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-RANGE-OVERLAPPING),
    test-utils:assert-map-equal($expected-verse-sequence, $actual-verse-sequence, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-SEQUENCE),
    test-utils:assert-map-equal($expected-verse-next, $actual-verse-next, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-NEXT),
    test-utils:assert-map-equal($expected-verse-next-next, $actual-verse-next-next, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-NEXT-NEXT),
    test-utils:assert-map-equal($expected-verse-sequence-next, $actual-verse-sequence-next, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-SEQUENCE-NEXT),
    test-utils:assert-map-equal($expected-verse-sequence-overlapping-1, $actual-verse-sequence-overlapping-1, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-SEQUENCE-OVERLAPPING-1),
    test-utils:assert-map-equal($expected-verse-sequence-overlapping-2, $actual-verse-sequence-overlapping-2, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-SEQUENCE-OVERLAPPING-2),
    test-utils:assert-map-equal($expected-verse-sequence-overlapping-3, $actual-verse-sequence-overlapping-3, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-SEQUENCE-OVERLAPPING-3),
    test-utils:assert-map-equal($expected-verse-range-sequence-overlapping, $actual-verse-range-sequence-overlapping, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-RANGE-SEQUENCE-OVERLAPPING),
    test-utils:assert-map-equal($expected-verse-not-found-1, $actual-verse-not-found-1, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-NOT-FOUND-1),
    test-utils:assert-map-equal($expected-verse-not-found-2, $actual-verse-not-found-2, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-NOT-FOUND-2),
    test-utils:assert-map-equal($expected-verse-not-found-3, $actual-verse-not-found-3, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-NOT-FOUND-3),
    test-utils:assert-map-equal($expected-verse-not-found-4, $actual-verse-not-found-4, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-NOT-FOUND-4),
    test-utils:assert-map-equal($expected-verse-not-found-5, $actual-verse-not-found-5, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-NOT-FOUND-5),
    test-utils:assert-map-equal($expected-verse-with-letter-part-1, $actual-verse-with-letter-part-1, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-WITH-LETTER-PART-1),
    test-utils:assert-map-equal($expected-verse-with-letter-part-2, $actual-verse-with-letter-part-2, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-WITH-LETTER-PART-2),
    test-utils:assert-map-equal($expected-verse-with-letter-part-3, $actual-verse-with-letter-part-3, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-WITH-LETTER-PART-3),
    test-utils:assert-map-equal($expected-verse-with-letter-part-4, $actual-verse-with-letter-part-4, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-WITH-LETTER-PART-4),
    test-utils:assert-map-equal($expected-verse-with-letter-part-5, $actual-verse-with-letter-part-5, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-WITH-LETTER-PART-5),
    test-utils:assert-map-equal($expected-verse-with-letter-part-range-correct-1, $actual-verse-with-letter-part-range-correct-1, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-WITH-LETTER-PART-RANGE-CORRECT-1),
    test-utils:assert-map-equal($expected-verse-with-letter-part-range-correct-2, $actual-verse-with-letter-part-range-correct-2, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-WITH-LETTER-PART-RANGE-CORRECT-2),
    test-utils:assert-map-equal($expected-verse-with-letter-part-range-correct-3, $actual-verse-with-letter-part-range-correct-3, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-WITH-LETTER-PART-RANGE-CORRECT-3),
    test-utils:assert-map-equal($expected-verse-with-letter-part-range-incorrect-1, $actual-verse-with-letter-part-range-incorrect-1, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-WITH-LETTER-PART-RANGE-INCORRECT-1),
    test-utils:assert-map-equal($expected-verse-with-letter-part-range-incorrect-2, $actual-verse-with-letter-part-range-incorrect-2, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-WITH-LETTER-PART-RANGE-INCORRECT-2),
    test-utils:assert-map-equal($expected-verse-with-letter-part-range-incorrect-3, $actual-verse-with-letter-part-range-incorrect-3, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-WITH-LETTER-PART-RANGE-INCORRECT-3),
    test-utils:assert-map-equal($expected-verse-with-letter-part-range-incorrect-4, $actual-verse-with-letter-part-range-incorrect-4, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-WITH-LETTER-PART-RANGE-INCORRECT-4),
    test-utils:assert-map-equal($expected-verse-with-letter-part-sequence, $actual-verse-with-letter-part-sequence, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-WITH-LETTER-PART-SEQUENCE),
    test-utils:assert-map-equal($expected-verse-with-letter-part-next, $actual-verse-with-letter-part-next, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-WITH-LETTER-PART-NEXT),
    test-utils:assert-map-equal($expected-verse-with-letter-part-next-next, $actual-verse-with-letter-part-next-next, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-WITH-LETTER-PART-NEXT-NEXT),
    test-utils:assert-map-equal($expected-verse-with-letter-part-sequence-overlapping-1, $actual-verse-with-letter-part-sequence-overlapping-1, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-WITH-LETTER-PART-SEQUENCE-OVERLAPPING-1),
    test-utils:assert-map-equal($expected-verse-with-letter-part-sequence-overlapping-2, $actual-verse-with-letter-part-sequence-overlapping-2, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-WITH-LETTER-PART-SEQUENCE-OVERLAPPING-2),
    test-utils:assert-map-equal($expected-verse-with-letter-part-sequence-overlapping-3, $actual-verse-with-letter-part-sequence-overlapping-3, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-WITH-LETTER-PART-SEQUENCE-OVERLAPPING-3),
    test-utils:assert-map-equal($expected-verse-with-letter-part-range-sequence-overlapping, $actual-verse-with-letter-part-range-sequence-overlapping, 'Incorrect interpretation for siglum: ' || $SIGLUM-VERSE-WITH-LETTER-PART-RANGE-SEQUENCE-OVERLAPPING),
    test-utils:assert-map-equal($expected-exceptional-verses-1-correct, $actual-exceptional-verses-1-correct, 'Incorrect interpretation for siglum: ' || $SIGLUM-EXCEPTIONAL-VERSES-1-CORRECT),
    test-utils:assert-map-equal($expected-exceptional-verses-1-incorrect, $actual-exceptional-verses-1-incorrect, 'Incorrect interpretation for siglum: ' || $SIGLUM-EXCEPTIONAL-VERSES-1-INCORRECT),
    test-utils:assert-map-equal($expected-exceptional-verses-2-correct, $actual-exceptional-verses-2-correct, 'Incorrect interpretation for siglum: ' || $SIGLUM-EXCEPTIONAL-VERSES-2-CORRECT),
    test-utils:assert-map-equal($expected-exceptional-verses-2-incorrect, $actual-exceptional-verses-2-incorrect, 'Incorrect interpretation for siglum: ' || $SIGLUM-EXCEPTIONAL-VERSES-2-INCORRECT),
    test-utils:assert-map-equal($expected-exceptional-verses-3-correct-1, $actual-exceptional-verses-3-correct-1, 'Incorrect interpretation for siglum: ' || $SIGLUM-EXCEPTIONAL-VERSES-3-CORRECT-1),
    test-utils:assert-map-equal($expected-exceptional-verses-3-correct-2, $actual-exceptional-verses-3-correct-2, 'Incorrect interpretation for siglum: ' || $SIGLUM-EXCEPTIONAL-VERSES-3-CORRECT-2),
    test-utils:assert-map-equal($expected-exceptional-verses-3-correct-3, $actual-exceptional-verses-3-correct-3, 'Incorrect interpretation for siglum: ' || $SIGLUM-EXCEPTIONAL-VERSES-3-CORRECT-3),
    test-utils:assert-map-equal($expected-exceptional-verses-3-correct-4, $actual-exceptional-verses-3-correct-4, 'Incorrect interpretation for siglum: ' || $SIGLUM-EXCEPTIONAL-VERSES-3-CORRECT-4),
    test-utils:assert-map-equal($expected-exceptional-verses-3-correct-5, $actual-exceptional-verses-3-correct-5, 'Incorrect interpretation for siglum: ' || $SIGLUM-EXCEPTIONAL-VERSES-3-CORRECT-5),
    test-utils:assert-map-equal($expected-exceptional-verses-3-correct-6, $actual-exceptional-verses-3-correct-6, 'Incorrect interpretation for siglum: ' || $SIGLUM-EXCEPTIONAL-VERSES-3-CORRECT-6),
    test-utils:assert-map-equal($expected-exceptional-verses-3-incorrect-1, $actual-exceptional-verses-3-incorrect-1, 'Incorrect interpretation for siglum: ' || $SIGLUM-EXCEPTIONAL-VERSES-3-INCORRECT-1),
    test-utils:assert-map-equal($expected-exceptional-verses-3-incorrect-2, $actual-exceptional-verses-3-incorrect-2, 'Incorrect interpretation for siglum: ' || $SIGLUM-EXCEPTIONAL-VERSES-3-INCORRECT-2),
    test-utils:assert-map-equal($expected-exceptional-verses-3-incorrect-3, $actual-exceptional-verses-3-incorrect-3, 'Incorrect interpretation for siglum: ' || $SIGLUM-EXCEPTIONAL-VERSES-3-INCORRECT-3),
    test-utils:assert-map-equal($expected-exceptional-verses-3-incorrect-4, $actual-exceptional-verses-3-incorrect-4, 'Incorrect interpretation for siglum: ' || $SIGLUM-EXCEPTIONAL-VERSES-3-INCORRECT-4),
    test-utils:assert-map-equal($expected-exceptional-verses-3-incorrect-5, $actual-exceptional-verses-3-incorrect-5, 'Incorrect interpretation for siglum: ' || $SIGLUM-EXCEPTIONAL-VERSES-3-INCORRECT-5),
    test-utils:assert-map-equal($expected-exceptional-verses-3-incorrect-6, $actual-exceptional-verses-3-incorrect-6, 'Incorrect interpretation for siglum: ' || $SIGLUM-EXCEPTIONAL-VERSES-3-INCORRECT-6),
    test-utils:assert-map-equal($expected-exceptional-verses-4-correct-1, $actual-exceptional-verses-4-correct-1, 'Incorrect interpretation for siglum: ' || $SIGLUM-EXCEPTIONAL-VERSES-4-CORRECT-1),
    test-utils:assert-map-equal($expected-exceptional-verses-4-correct-2, $actual-exceptional-verses-4-correct-2, 'Incorrect interpretation for siglum: ' || $SIGLUM-EXCEPTIONAL-VERSES-4-CORRECT-2),
    test-utils:assert-map-equal($expected-exceptional-verses-4-correct-3, $actual-exceptional-verses-4-correct-3, 'Incorrect interpretation for siglum: ' || $SIGLUM-EXCEPTIONAL-VERSES-4-CORRECT-3),
    test-utils:assert-map-equal($expected-exceptional-verses-4-incorrect-1, $actual-exceptional-verses-4-incorrect-1, 'Incorrect interpretation for siglum: ' || $SIGLUM-EXCEPTIONAL-VERSES-4-INCORRECT-1),
    test-utils:assert-map-equal($expected-exceptional-verses-4-incorrect-2, $actual-exceptional-verses-4-incorrect-2, 'Incorrect interpretation for siglum: ' || $SIGLUM-EXCEPTIONAL-VERSES-4-INCORRECT-2),
    test-utils:assert-map-equal($expected-exceptional-verses-4-incorrect-3, $actual-exceptional-verses-4-incorrect-3, 'Incorrect interpretation for siglum: ' || $SIGLUM-EXCEPTIONAL-VERSES-4-INCORRECT-3),
    test-utils:assert-map-equal($expected-siglum-variety-1, $actual-siglum-variety-1, 'Incorrect interpretation for siglum: ' || $SIGLUM-VARIETY-1),
    test-utils:assert-map-equal($expected-siglum-variety-2, $actual-siglum-variety-2, 'Incorrect interpretation for siglum: ' || $SIGLUM-VARIETY-2),
    test-utils:assert-map-equal($expected-siglum-variety-3, $actual-siglum-variety-3, 'Incorrect interpretation for siglum: ' || $SIGLUM-VARIETY-3),
    test-utils:assert-map-equal($expected-siglum-variety-4, $actual-siglum-variety-4, 'Incorrect interpretation for siglum: ' || $SIGLUM-VARIETY-4)
)
(:https://github.com/marklogic-community/marklogic-unit-test/blob/63a8aa4a36d1d2576469a8972ec91960b204a980/marklogic-unit-test-modules/src/main/ml-modules/root/test/test-helper.xqy#L732:)

(:The test:assert-equal-json-recursive() function contains comparing instruction (in the default scope of typeswitch) that will return true for two different sequences that have 1 common element [e.g ('1', '2') = ('1', '3') will return true]:)