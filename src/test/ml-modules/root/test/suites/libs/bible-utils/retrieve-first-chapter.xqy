xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace bc = "http://marklogic.com/holy/ml-modules/bible-constants" at "/constants/bible-constants.xqy";
import module namespace bib = "http://marklogic.com/holy/ml-modules/bible-utils" at "/libs/bible-utils.xqy";

declare variable $TOME-SIGLA := (
    'Rdz', 'Wj', 'Kpł', 'Lb', 'Pwt', 'Joz', 'Sdz', 'Rt', '1Sm', '2Sm', '1Krl', '2Krl', '1Krn', '2Krn', 'Ezd', 'Ne',
    'Tb', 'Jdt', 'Est', '1Mch', '2Mch', 'Hi', 'Ps', 'Prz', 'Koh', 'Pnp', 'Mdr', 'Syr', 'Iz', 'Jr', 'Lm', 'Ba', 'Ez',
    'Dn', 'Oz', 'Jl', 'Am', 'Ab', 'Jon', 'Mi', 'Na', 'Ha', 'So', 'Ag', 'Za', 'Ml',
    'Mt', 'Mk', 'Łk', 'J', 'Dz', 'Rz', '1Kor', '2Kor', 'Ga', 'Ef', 'Flp', 'Kol', '1Tes', '2Tes', '1Tm', '2Tm', 'Tt',
    'Flm', 'Hbr', 'Jk', '1P', '2P', '1J', '2J', '3J', 'Jud', 'Ap'
);

for $tome-siglum in $TOME-SIGLA
let $expected := if ($tome-siglum eq $bc:SIGLUM-SYR) then 'Prolog' else '1'
let $actual := bib:retrieve-first-chapter($tome-siglum)
return test:assert-equal($expected, $actual, 'Incorrect first chapter assignement for tome ' || $tome-siglum)