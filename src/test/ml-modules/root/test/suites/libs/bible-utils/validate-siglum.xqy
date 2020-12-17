xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace bib = "http://marklogic.com/holy/ml-modules/bible-utils" at "/libs/bible-utils.xqy";

declare variable $SIGLUM-01 as xs:string := 'Rdz';
declare variable $SIGLUM-02 as xs:string := 'Rdz; Wj';
declare variable $SIGLUM-03 as xs:string := 'Rdz 1';
declare variable $SIGLUM-04 as xs:string := 'Rdz 11';
declare variable $SIGLUM-05 as xs:string := 'Rdz 1112';
declare variable $SIGLUM-06 as xs:string := 'Rdz 1,';
declare variable $SIGLUM-07 as xs:string := 'Rdz 1,1';
declare variable $SIGLUM-08 as xs:string := 'Rdz 1,1n';
declare variable $SIGLUM-09 as xs:string := 'Rdz 1,1nn';
declare variable $SIGLUM-10 as xs:string := 'Rdz 1,1nnn';
declare variable $SIGLUM-11 as xs:string := 'Rdz 1,11';
declare variable $SIGLUM-12 as xs:string := 'Rdz 1,11n';
declare variable $SIGLUM-13 as xs:string := 'Rdz 1,11nn';
declare variable $SIGLUM-14 as xs:string := 'Rdz 1,1111';
declare variable $SIGLUM-15 as xs:string := 'Rdz 11,1';
declare variable $SIGLUM-16 as xs:string := 'Rdz 11,1n';
declare variable $SIGLUM-17 as xs:string := 'Rdz 11,1nn';
declare variable $SIGLUM-18 as xs:string := 'Rdz 11,11';
declare variable $SIGLUM-19 as xs:string := 'Rdz 11,11n';
declare variable $SIGLUM-20 as xs:string := 'Rdz 11,11nn';
declare variable $SIGLUM-21 as xs:string := 'Rdz 11,11nnn';
declare variable $SIGLUM-22 as xs:string := 'Rdz 11,1111';
declare variable $SIGLUM-23 as xs:string := 'Rdz 1111,1';
declare variable $SIGLUM-24 as xs:string := 'Rdz 1,1-';
declare variable $SIGLUM-25 as xs:string := 'Rdz 1,1-5';
declare variable $SIGLUM-26 as xs:string := 'Rdz 1,1-5n';
declare variable $SIGLUM-27 as xs:string := 'Rdz 1,1-55';
declare variable $SIGLUM-28 as xs:string := 'Rdz 1,1-55n';
declare variable $SIGLUM-29 as xs:string := 'Rdz 1,1-5555';
declare variable $SIGLUM-30 as xs:string := 'Rdz 1,11-5n';
declare variable $SIGLUM-31 as xs:string := 'Rdz 1,11-55';
declare variable $SIGLUM-32 as xs:string := 'Rdz 1,11-55n';
declare variable $SIGLUM-33 as xs:string := 'Rdz 1,11-5555';
declare variable $SIGLUM-34 as xs:string := 'Rdz 1,1111-5';
declare variable $SIGLUM-35 as xs:string := 'Rdz 1,1.';
declare variable $SIGLUM-36 as xs:string := 'Rdz 1,1. 3';
declare variable $SIGLUM-37 as xs:string := 'Rdz 1,1. 3n';
declare variable $SIGLUM-38 as xs:string := 'Rdz 1,1. 3nn';
declare variable $SIGLUM-39 as xs:string := 'Rdz 1,1. 3nnn';
declare variable $SIGLUM-40 as xs:string := 'Rdz 1,1n. 3';
declare variable $SIGLUM-41 as xs:string := 'Rdz 1,1nn. 3';
declare variable $SIGLUM-42 as xs:string := 'Rdz 1,1nnn. 3';
declare variable $SIGLUM-43 as xs:string := 'Rdz 1,1n. 3n';
declare variable $SIGLUM-44 as xs:string := 'Rdz 1,1nn. 3nn';
declare variable $SIGLUM-45 as xs:string := 'Rdz 1,1. 33';
declare variable $SIGLUM-46 as xs:string := 'Rdz 1,1. 33n';
declare variable $SIGLUM-47 as xs:string := 'Rdz 1,1. 3333';
declare variable $SIGLUM-48 as xs:string := 'Rdz 1,11. 3';
declare variable $SIGLUM-49 as xs:string := 'Rdz 1,11. 3n';
declare variable $SIGLUM-50 as xs:string := 'Rdz 1,11. 33';
declare variable $SIGLUM-51 as xs:string := 'Rdz 1,11. 33n';
declare variable $SIGLUM-52 as xs:string := 'Rdz 1,11. 3333';
declare variable $SIGLUM-53 as xs:string := 'Rdz 1,1111. 3';
declare variable $SIGLUM-54 as xs:string := 'Rdz 1,1-5.';
declare variable $SIGLUM-55 as xs:string := 'Rdz 1,1-5. 7';
declare variable $SIGLUM-56 as xs:string := 'Rdz 1,1-5. 7n';
declare variable $SIGLUM-57 as xs:string := 'Rdz 1,11-51. 71';
declare variable $SIGLUM-58 as xs:string := 'Rdz 1,11-51n. 71';
declare variable $SIGLUM-59 as xs:string := 'Rdz 1,11-51. 71n';
declare variable $SIGLUM-60 as xs:string := 'Rdz 1,1111-51. 71';
declare variable $SIGLUM-61 as xs:string := 'Rdz 1,11-5111. 71';
declare variable $SIGLUM-62 as xs:string := 'Rdz 1,11-51. 7111';
declare variable $SIGLUM-63 as xs:string := 'Rdz 1,1. 5-';
declare variable $SIGLUM-64 as xs:string := 'Rdz 1,1. 5-7';
declare variable $SIGLUM-65 as xs:string := 'Rdz 1,1-3. 5-';
declare variable $SIGLUM-66 as xs:string := 'Rdz 1,1-3. 5-7';
declare variable $SIGLUM-67 as xs:string := 'Rdz 1,1-3. 5-7. 9. 10-12. 15. 17. 19. 21-29';
declare variable $SIGLUM-68 as xs:string := 'Rdz 1,1-3. 5-7. 9n. 10-12. 15n. 17. 19n. 21-29';
declare variable $SIGLUM-69 as xs:string := 'Rdz 1; 2,5,7';
declare variable $SIGLUM-70 as xs:string := 'Rdz 1; 2,';
declare variable $SIGLUM-71 as xs:string := 'Rdz 1; 3; 5';
declare variable $SIGLUM-72 as xs:string := 'Rdz 1. 3';
declare variable $SIGLUM-73 as xs:string := 'Rdz 1,3; 3';
declare variable $SIGLUM-74 as xs:string := 'Rdz 1,3; 3,4';
declare variable $SIGLUM-75 as xs:string := 'Rdz 1,3; 3; 5; 10,5';
declare variable $SIGLUM-76 as xs:string := 'Rdz 1-3';
declare variable $SIGLUM-77 as xs:string := 'Rdz 1-3,5';
declare variable $SIGLUM-78 as xs:string := 'Rdz 1-3; 5,8; 9-12';
declare variable $SIGLUM-79 as xs:string := 'Rdz 1-3; 5,8; 9-12';
declare variable $SIGLUM-80 as xs:string := 'Rdz 1-3; 5,7-8. 10n. 15-20; 9-12';
declare variable $SIGLUM-81 as xs:string := 'Rdz 1-3; 5-7,8; 9-12';
declare variable $SIGLUM-82 as xs:string := 'Rdz 1,2nn; 3,6nn';
declare variable $SIGLUM-83 as xs:string := 'Syr Prolog';
declare variable $SIGLUM-84 as xs:string := 'Syr Prolog,3';
declare variable $SIGLUM-85 as xs:string := 'Ps 112';
declare variable $SIGLUM-86 as xs:string := 'Ps 1,111';
declare variable $SIGLUM-87 as xs:string := 'Ps 11,111';
declare variable $SIGLUM-88 as xs:string := 'Ps 111,1';
declare variable $SIGLUM-89 as xs:string := 'Ps 1,1-111';
declare variable $SIGLUM-90 as xs:string := 'Ps 1,11-111';
declare variable $SIGLUM-91 as xs:string := 'Ps 1,111-5';
declare variable $SIGLUM-92 as xs:string := 'Ps 1,1. 111';
declare variable $SIGLUM-93 as xs:string := 'Ps 1,11. 111';
declare variable $SIGLUM-94 as xs:string := 'Ps 1,111. 3';
declare variable $SIGLUM-95 as xs:string := 'Ps 1,111-51. 71';
declare variable $SIGLUM-96 as xs:string := 'Ps 1,11-111. 71';
declare variable $SIGLUM-97 as xs:string := 'Ps 1,11-51. 111';

let $siglum-01-validation := bib:validate-siglum($SIGLUM-01)
let $siglum-02-validation := bib:validate-siglum($SIGLUM-02)
let $siglum-03-validation := bib:validate-siglum($SIGLUM-03)
let $siglum-04-validation := bib:validate-siglum($SIGLUM-04)
let $siglum-05-validation := bib:validate-siglum($SIGLUM-05)
let $siglum-06-validation := bib:validate-siglum($SIGLUM-06)
let $siglum-07-validation := bib:validate-siglum($SIGLUM-07)
let $siglum-08-validation := bib:validate-siglum($SIGLUM-08)
let $siglum-09-validation := bib:validate-siglum($SIGLUM-09)
let $siglum-10-validation := bib:validate-siglum($SIGLUM-10)
let $siglum-11-validation := bib:validate-siglum($SIGLUM-11)
let $siglum-12-validation := bib:validate-siglum($SIGLUM-12)
let $siglum-13-validation := bib:validate-siglum($SIGLUM-13)
let $siglum-14-validation := bib:validate-siglum($SIGLUM-14)
let $siglum-15-validation := bib:validate-siglum($SIGLUM-15)
let $siglum-16-validation := bib:validate-siglum($SIGLUM-16)
let $siglum-17-validation := bib:validate-siglum($SIGLUM-17)
let $siglum-18-validation := bib:validate-siglum($SIGLUM-18)
let $siglum-19-validation := bib:validate-siglum($SIGLUM-19)
let $siglum-20-validation := bib:validate-siglum($SIGLUM-20)
let $siglum-21-validation := bib:validate-siglum($SIGLUM-21)
let $siglum-22-validation := bib:validate-siglum($SIGLUM-22)
let $siglum-23-validation := bib:validate-siglum($SIGLUM-23)
let $siglum-24-validation := bib:validate-siglum($SIGLUM-24)
let $siglum-25-validation := bib:validate-siglum($SIGLUM-25)
let $siglum-26-validation := bib:validate-siglum($SIGLUM-26)
let $siglum-27-validation := bib:validate-siglum($SIGLUM-27)
let $siglum-28-validation := bib:validate-siglum($SIGLUM-28)
let $siglum-29-validation := bib:validate-siglum($SIGLUM-29)
let $siglum-30-validation := bib:validate-siglum($SIGLUM-30)
let $siglum-31-validation := bib:validate-siglum($SIGLUM-31)
let $siglum-32-validation := bib:validate-siglum($SIGLUM-32)
let $siglum-33-validation := bib:validate-siglum($SIGLUM-33)
let $siglum-34-validation := bib:validate-siglum($SIGLUM-34)
let $siglum-35-validation := bib:validate-siglum($SIGLUM-35)
let $siglum-36-validation := bib:validate-siglum($SIGLUM-36)
let $siglum-37-validation := bib:validate-siglum($SIGLUM-37)
let $siglum-38-validation := bib:validate-siglum($SIGLUM-38)
let $siglum-39-validation := bib:validate-siglum($SIGLUM-39)
let $siglum-40-validation := bib:validate-siglum($SIGLUM-40)
let $siglum-41-validation := bib:validate-siglum($SIGLUM-41)
let $siglum-42-validation := bib:validate-siglum($SIGLUM-42)
let $siglum-43-validation := bib:validate-siglum($SIGLUM-43)
let $siglum-44-validation := bib:validate-siglum($SIGLUM-44)
let $siglum-45-validation := bib:validate-siglum($SIGLUM-45)
let $siglum-46-validation := bib:validate-siglum($SIGLUM-46)
let $siglum-47-validation := bib:validate-siglum($SIGLUM-47)
let $siglum-48-validation := bib:validate-siglum($SIGLUM-48)
let $siglum-49-validation := bib:validate-siglum($SIGLUM-49)
let $siglum-50-validation := bib:validate-siglum($SIGLUM-50)
let $siglum-51-validation := bib:validate-siglum($SIGLUM-51)
let $siglum-52-validation := bib:validate-siglum($SIGLUM-52)
let $siglum-53-validation := bib:validate-siglum($SIGLUM-53)
let $siglum-54-validation := bib:validate-siglum($SIGLUM-54)
let $siglum-55-validation := bib:validate-siglum($SIGLUM-55)
let $siglum-56-validation := bib:validate-siglum($SIGLUM-56)
let $siglum-57-validation := bib:validate-siglum($SIGLUM-57)
let $siglum-58-validation := bib:validate-siglum($SIGLUM-58)
let $siglum-59-validation := bib:validate-siglum($SIGLUM-59)
let $siglum-60-validation := bib:validate-siglum($SIGLUM-60)
let $siglum-61-validation := bib:validate-siglum($SIGLUM-61)
let $siglum-62-validation := bib:validate-siglum($SIGLUM-62)
let $siglum-63-validation := bib:validate-siglum($SIGLUM-63)
let $siglum-64-validation := bib:validate-siglum($SIGLUM-64)
let $siglum-65-validation := bib:validate-siglum($SIGLUM-65)
let $siglum-66-validation := bib:validate-siglum($SIGLUM-66)
let $siglum-67-validation := bib:validate-siglum($SIGLUM-67)
let $siglum-68-validation := bib:validate-siglum($SIGLUM-68)
let $siglum-69-validation := bib:validate-siglum($SIGLUM-69)
let $siglum-70-validation := bib:validate-siglum($SIGLUM-70)
let $siglum-71-validation := bib:validate-siglum($SIGLUM-71)
let $siglum-72-validation := bib:validate-siglum($SIGLUM-72)
let $siglum-73-validation := bib:validate-siglum($SIGLUM-73)
let $siglum-74-validation := bib:validate-siglum($SIGLUM-74)
let $siglum-75-validation := bib:validate-siglum($SIGLUM-75)
let $siglum-76-validation := bib:validate-siglum($SIGLUM-76)
let $siglum-77-validation := bib:validate-siglum($SIGLUM-77)
let $siglum-78-validation := bib:validate-siglum($SIGLUM-78)
let $siglum-79-validation := bib:validate-siglum($SIGLUM-79)
let $siglum-80-validation := bib:validate-siglum($SIGLUM-80)
let $siglum-81-validation := bib:validate-siglum($SIGLUM-81)
let $siglum-82-validation := bib:validate-siglum($SIGLUM-82)
let $siglum-83-validation := bib:validate-siglum($SIGLUM-83)
let $siglum-84-validation := bib:validate-siglum($SIGLUM-84)
let $siglum-85-validation := bib:validate-siglum($SIGLUM-85)
let $siglum-86-validation := bib:validate-siglum($SIGLUM-86)
let $siglum-87-validation := bib:validate-siglum($SIGLUM-87)
let $siglum-88-validation := bib:validate-siglum($SIGLUM-88)
let $siglum-89-validation := bib:validate-siglum($SIGLUM-89)
let $siglum-90-validation := bib:validate-siglum($SIGLUM-90)
let $siglum-91-validation := bib:validate-siglum($SIGLUM-91)
let $siglum-92-validation := bib:validate-siglum($SIGLUM-92)
let $siglum-93-validation := bib:validate-siglum($SIGLUM-93)
let $siglum-94-validation := bib:validate-siglum($SIGLUM-94)
let $siglum-95-validation := bib:validate-siglum($SIGLUM-95)
let $siglum-96-validation := bib:validate-siglum($SIGLUM-96)
let $siglum-97-validation := bib:validate-siglum($SIGLUM-97)

return (
    test:assert-true($siglum-01-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-01),
    test:assert-false($siglum-02-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-02),
    test:assert-true($siglum-03-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-03),
    test:assert-true($siglum-04-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-04),
    test:assert-false($siglum-05-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-05),
    test:assert-false($siglum-06-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-06),
    test:assert-true($siglum-07-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-07),
    test:assert-true($siglum-08-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-08),
    test:assert-true($siglum-09-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-09),
    test:assert-false($siglum-10-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-10),
    test:assert-true($siglum-11-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-11),
    test:assert-true($siglum-12-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-12),
    test:assert-true($siglum-13-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-13),
    test:assert-false($siglum-14-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-14),
    test:assert-true($siglum-15-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-15),
    test:assert-true($siglum-16-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-16),
    test:assert-true($siglum-17-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-17),
    test:assert-true($siglum-18-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-18),
    test:assert-true($siglum-19-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-19),
    test:assert-true($siglum-20-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-20),
    test:assert-false($siglum-21-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-21),
    test:assert-false($siglum-22-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-22),
    test:assert-false($siglum-23-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-23),
    test:assert-false($siglum-24-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-24),
    test:assert-true($siglum-25-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-25),
    test:assert-false($siglum-26-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-26),
    test:assert-true($siglum-27-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-27),
    test:assert-false($siglum-28-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-28),
    test:assert-false($siglum-29-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-29),
    test:assert-false($siglum-30-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-30),
    test:assert-true($siglum-31-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-31),
    test:assert-false($siglum-32-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-32),
    test:assert-false($siglum-33-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-33),
    test:assert-false($siglum-34-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-34),
    test:assert-false($siglum-35-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-35),
    test:assert-true($siglum-36-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-36),
    test:assert-true($siglum-37-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-37),
    test:assert-true($siglum-38-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-38),
    test:assert-false($siglum-39-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-39),
    test:assert-true($siglum-40-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-40),
    test:assert-true($siglum-41-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-41),
    test:assert-false($siglum-42-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-42),
    test:assert-true($siglum-43-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-43),
    test:assert-true($siglum-44-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-44),
    test:assert-true($siglum-45-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-45),
    test:assert-true($siglum-46-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-46),
    test:assert-false($siglum-47-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-47),
    test:assert-true($siglum-48-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-48),
    test:assert-true($siglum-49-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-49),
    test:assert-true($siglum-50-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-50),
    test:assert-true($siglum-51-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-51),
    test:assert-false($siglum-52-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-52),
    test:assert-false($siglum-53-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-53),
    test:assert-false($siglum-54-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-54),
    test:assert-true($siglum-55-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-55),
    test:assert-true($siglum-56-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-56),
    test:assert-true($siglum-57-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-57),
    test:assert-false($siglum-58-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-58),
    test:assert-true($siglum-59-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-59),
    test:assert-false($siglum-60-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-60),
    test:assert-false($siglum-61-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-61),
    test:assert-false($siglum-62-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-62),
    test:assert-false($siglum-63-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-63),
    test:assert-true($siglum-64-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-64),
    test:assert-false($siglum-65-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-65),
    test:assert-true($siglum-66-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-66),
    test:assert-true($siglum-67-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-67),
    test:assert-true($siglum-68-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-68),
    test:assert-false($siglum-69-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-69),
    test:assert-false($siglum-70-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-70),
    test:assert-true($siglum-71-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-71),
    test:assert-false($siglum-72-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-72),
    test:assert-true($siglum-73-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-73),
    test:assert-true($siglum-74-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-74),
    test:assert-true($siglum-75-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-75),
    test:assert-true($siglum-76-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-76),
    test:assert-false($siglum-77-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-77),
    test:assert-true($siglum-78-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-78),
    test:assert-true($siglum-79-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-79),
    test:assert-true($siglum-80-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-80),
    test:assert-false($siglum-81-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-81),
    test:assert-true($siglum-82-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-82),
    test:assert-true($siglum-83-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-83),
    test:assert-true($siglum-84-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-84),
    test:assert-true($siglum-85-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-85),
    test:assert-true($siglum-86-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-86),
    test:assert-true($siglum-87-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-87),
    test:assert-true($siglum-88-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-88),
    test:assert-true($siglum-89-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-89),
    test:assert-true($siglum-90-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-90),
    test:assert-true($siglum-91-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-91),
    test:assert-true($siglum-92-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-92),
    test:assert-true($siglum-93-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-93),
    test:assert-true($siglum-94-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-94),
    test:assert-true($siglum-95-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-95),
    test:assert-true($siglum-96-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-96),
    test:assert-true($siglum-97-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-97)
)