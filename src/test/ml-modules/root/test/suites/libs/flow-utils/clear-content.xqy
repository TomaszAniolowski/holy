xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace flow = "http://marklogic.com/holy/ml-modules/flow-utils" at "/libs/flow-utils.xqy";

declare variable $SENTENCE-1 as xs:string := ' Na całej ziemi mówiono jednym językiem i posługiwano się jednakowymi wyrazami.      ';
declare variable $SENTENCE-2 as xs:string := '  Izaak modlił się do Pana za swoją żonę, ponieważ była niepłodna. Pan go wysłuchał i jego żona Rebeka zaszła w ciążę.     ';
declare variable $SENTENCE-3 as xs:string := '   Pan zstąpił , aby zobaczyć miasto i wieżę , które ludzie budowali.    ';
declare variable $SENTENCE-4 as xs:string := '    AniołPana znalazł ją w pobliżu źródła na pustyni , przy drodze wiodącej do Szur.   ';
declare variable $SENTENCE-5 as xs:string := '     i zdolnym myśliwym. Dlatego mówi się: „Myśliwy, uzdolniony przezPANA jak Nimrod”.  ';
declare variable $SENTENCE-6 as xs:string := '      Mojżesz odpowiedział: „Gdy tylko wyjdę za miasto , wzniosę ręce doPana. Ustaną grzmoty , grad przestanie padać , żebyś przekonał się , że doPana należy ziemia. ';

let $expected-sentence-1 := 'Na całej ziemi mówiono jednym językiem i posługiwano się jednakowymi wyrazami.'
let $expected-sentence-2 := 'Izaak modlił się do Pana za swoją żonę, ponieważ była niepłodna. Pan go wysłuchał i jego żona Rebeka zaszła w ciążę.'
let $expected-sentence-3 := 'Pan zstąpił, aby zobaczyć miasto i wieżę, które ludzie budowali.'
let $expected-sentence-4 := 'Anioł Pana znalazł ją w pobliżu źródła na pustyni, przy drodze wiodącej do Szur.'
let $expected-sentence-5 := 'i zdolnym myśliwym. Dlatego mówi się: „Myśliwy, uzdolniony przez PANA jak Nimrod”.'
let $expected-sentence-6 := 'Mojżesz odpowiedział: „Gdy tylko wyjdę za miasto, wzniosę ręce do Pana. Ustaną grzmoty, grad przestanie padać, żebyś przekonał się, że do Pana należy ziemia.'

let $actual-sentence-1 := flow:clear-content($SENTENCE-1)
let $actual-sentence-2 := flow:clear-content($SENTENCE-2)
let $actual-sentence-3 := flow:clear-content($SENTENCE-3)
let $actual-sentence-4 := flow:clear-content($SENTENCE-4)
let $actual-sentence-5 := flow:clear-content($SENTENCE-5)
let $actual-sentence-6 := flow:clear-content($SENTENCE-6)

return (
    test:assert-equal($expected-sentence-1, $actual-sentence-1, 'Incorrect content cleaning for sentence 1 (actual sentence: ' || $actual-sentence-1 || ')'),
    test:assert-equal($expected-sentence-2, $actual-sentence-2, 'Incorrect content cleaning for sentence 2 (actual sentence: ' || $actual-sentence-2 || ')'),
    test:assert-equal($expected-sentence-3, $actual-sentence-3, 'Incorrect content cleaning for sentence 3 (actual sentence: ' || $actual-sentence-3 || ')'),
    test:assert-equal($expected-sentence-4, $actual-sentence-4, 'Incorrect content cleaning for sentence 4 (actual sentence: ' || $actual-sentence-4 || ')'),
    test:assert-equal($expected-sentence-5, $actual-sentence-5, 'Incorrect content cleaning for sentence 5 (actual sentence: ' || $actual-sentence-5 || ')'),
    test:assert-equal($expected-sentence-6, $actual-sentence-6, 'Incorrect content cleaning for sentence 6 (actual sentence: ' || $actual-sentence-6 || ')')
)
