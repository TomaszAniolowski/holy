xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace bc = "http://marklogic.com/holy/ml-modules/bible-constants" at "/constants/bible-constants.xqy";
import module namespace bib = "http://marklogic.com/holy/ml-modules/bible-utils" at "/libs/bible-utils.xqy";

declare variable $OLD-TESTAMENT-TOME-SIGLA := (
    'Rdz', 'Wj', 'Kpł', 'Lb', 'Pwt', 'Joz', 'Sdz', 'Rt', '1Sm', '2Sm', '1Krl', '2Krl', '1Krn', '2Krn', 'Ezd', 'Ne',
    'Tb', 'Jdt', 'Est', '1Mch', '2Mch', 'Hi', 'Ps', 'Prz', 'Koh', 'Pnp', 'Mdr', 'Syr', 'Iz', 'Jr', 'Lm', 'Ba', 'Ez',
    'Dn', 'Oz', 'Jl', 'Am', 'Ab', 'Jon', 'Mi', 'Na', 'Ha', 'So', 'Ag', 'Za', 'Ml'
);
declare variable $NEW-TESTAMENT-TOME-SIGLA := (
    'Mt', 'Mk', 'Łk', 'J', 'Dz', 'Rz', '1Kor', '2Kor', 'Ga', 'Ef', 'Flp', 'Kol', '1Tes', '2Tes', '1Tm', '2Tm', 'Tt',
    'Flm', 'Hbr', 'Jk', '1P', '2P', '1J', '2J', '3J', 'Jud', 'Ap'
);

let $old-testament-assertions :=
    for $tome-siglum in $OLD-TESTAMENT-TOME-SIGLA
    let $actual := bib:retrieve-testament($tome-siglum)
    return test:assert-equal($bc:OLD-TESTAMENT, $actual, 'Incorrect testament assignement for tome siglum ' || $tome-siglum)
let $new-testament-assertions :=
    for $tome-siglum in $NEW-TESTAMENT-TOME-SIGLA
    let $actual := bib:retrieve-testament($tome-siglum)
    return test:assert-equal($bc:NEW-TESTAMENT, $actual, 'Incorrect testament assignement for tome siglum ' || $tome-siglum)
return ($old-testament-assertions, $new-testament-assertions)