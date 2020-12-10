xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace bib = "http://marklogic.com/holy/ml-modules/bible-utils" at "/libs/bible-utils.xqy";

declare variable $siglum-01 as xs:string := 'Rdz';
declare variable $siglum-02 as xs:string := 'Rdz; Wj';
declare variable $siglum-03 as xs:string := 'Rdz 1';
declare variable $siglum-04 as xs:string := 'Rdz 11';
declare variable $siglum-05 as xs:string := 'Rdz 112';
declare variable $siglum-06 as xs:string := 'Rdz 1,';
declare variable $siglum-07 as xs:string := 'Rdz 1,1';
declare variable $siglum-08 as xs:string := 'Rdz 1,1n';
declare variable $siglum-09 as xs:string := 'Rdz 1,1nn';
declare variable $siglum-10 as xs:string := 'Rdz 1,1nnn';
declare variable $siglum-11 as xs:string := 'Rdz 1,11';
declare variable $siglum-12 as xs:string := 'Rdz 1,11n';
declare variable $siglum-13 as xs:string := 'Rdz 1,11nn';
declare variable $siglum-14 as xs:string := 'Rdz 1,111';
declare variable $siglum-15 as xs:string := 'Rdz 11,1';
declare variable $siglum-16 as xs:string := 'Rdz 11,1n';
declare variable $siglum-17 as xs:string := 'Rdz 11,1nn';
declare variable $siglum-18 as xs:string := 'Rdz 11,11';
declare variable $siglum-19 as xs:string := 'Rdz 11,11n';
declare variable $siglum-20 as xs:string := 'Rdz 11,11nn';
declare variable $siglum-21 as xs:string := 'Rdz 11,11nnn';
declare variable $siglum-22 as xs:string := 'Rdz 11,111';
declare variable $siglum-23 as xs:string := 'Rdz 111,1';
declare variable $siglum-24 as xs:string := 'Rdz 1,1-';
declare variable $siglum-25 as xs:string := 'Rdz 1,1-5';
declare variable $siglum-26 as xs:string := 'Rdz 1,1-5n';
declare variable $siglum-27 as xs:string := 'Rdz 1,1-55';
declare variable $siglum-28 as xs:string := 'Rdz 1,1-55n';
declare variable $siglum-29 as xs:string := 'Rdz 1,1-555';
declare variable $siglum-30 as xs:string := 'Rdz 1,11-5n';
declare variable $siglum-31 as xs:string := 'Rdz 1,11-55';
declare variable $siglum-32 as xs:string := 'Rdz 1,11-55n';
declare variable $siglum-33 as xs:string := 'Rdz 1,11-555';
declare variable $siglum-34 as xs:string := 'Rdz 1,111-5';
declare variable $siglum-35 as xs:string := 'Rdz 1,1.';
declare variable $siglum-36 as xs:string := 'Rdz 1,1. 3';
declare variable $siglum-37 as xs:string := 'Rdz 1,1. 3n';
declare variable $siglum-38 as xs:string := 'Rdz 1,1. 3nn';
declare variable $siglum-39 as xs:string := 'Rdz 1,1. 3nnn';
declare variable $siglum-40 as xs:string := 'Rdz 1,1n. 3';
declare variable $siglum-41 as xs:string := 'Rdz 1,1nn. 3';
declare variable $siglum-42 as xs:string := 'Rdz 1,1nnn. 3';
declare variable $siglum-43 as xs:string := 'Rdz 1,1n. 3n';
declare variable $siglum-44 as xs:string := 'Rdz 1,1nn. 3nn';
declare variable $siglum-45 as xs:string := 'Rdz 1,1. 33';
declare variable $siglum-46 as xs:string := 'Rdz 1,1. 33n';
declare variable $siglum-47 as xs:string := 'Rdz 1,1. 333';
declare variable $siglum-48 as xs:string := 'Rdz 1,11. 3';
declare variable $siglum-49 as xs:string := 'Rdz 1,11. 3n';
declare variable $siglum-50 as xs:string := 'Rdz 1,11. 33';
declare variable $siglum-51 as xs:string := 'Rdz 1,11. 33n';
declare variable $siglum-52 as xs:string := 'Rdz 1,11. 333';
declare variable $siglum-53 as xs:string := 'Rdz 1,111. 3';
declare variable $siglum-54 as xs:string := 'Rdz 1,1-5.';
declare variable $siglum-55 as xs:string := 'Rdz 1,1-5. 7';
declare variable $siglum-56 as xs:string := 'Rdz 1,1-5. 7n';
declare variable $siglum-57 as xs:string := 'Rdz 1,11-51. 71';
declare variable $siglum-58 as xs:string := 'Rdz 1,11-51n. 71';
declare variable $siglum-59 as xs:string := 'Rdz 1,11-51. 71n';
declare variable $siglum-60 as xs:string := 'Rdz 1,111-51. 71';
declare variable $siglum-61 as xs:string := 'Rdz 1,11-511. 71';
declare variable $siglum-62 as xs:string := 'Rdz 1,11-51. 711';
declare variable $siglum-63 as xs:string := 'Rdz 1,1. 5-';
declare variable $siglum-64 as xs:string := 'Rdz 1,1. 5-7';
declare variable $siglum-65 as xs:string := 'Rdz 1,1-3. 5-';
declare variable $siglum-66 as xs:string := 'Rdz 1,1-3. 5-7';
declare variable $siglum-67 as xs:string := 'Rdz 1,1-3. 5-7. 9. 10-12. 15. 17. 19. 21-29';
declare variable $siglum-68 as xs:string := 'Rdz 1,1-3. 5-7. 9n. 10-12. 15n. 17. 19n. 21-29';
declare variable $siglum-69 as xs:string := 'Rdz 1; 2,5,7';
declare variable $siglum-70 as xs:string := 'Rdz 1; 2,';
declare variable $siglum-71 as xs:string := 'Rdz 1; 3; 5';
declare variable $siglum-72 as xs:string := 'Rdz 1. 3';
declare variable $siglum-73 as xs:string := 'Rdz 1,3; 3';
declare variable $siglum-74 as xs:string := 'Rdz 1,3; 3,4';
declare variable $siglum-75 as xs:string := 'Rdz 1,3; 3; 5; 10,5';
declare variable $siglum-76 as xs:string := 'Rdz 1-3';
declare variable $siglum-77 as xs:string := 'Rdz 1-3,5';
declare variable $siglum-78 as xs:string := 'Rdz 1-3; 5,8; 9-12';
declare variable $siglum-79 as xs:string := 'Rdz 1-3; 5,8; 9-12';
declare variable $siglum-80 as xs:string := 'Rdz 1-3; 5,7-8. 10n. 15-20; 9-12';
declare variable $siglum-81 as xs:string := 'Rdz 1-3; 5-7,8; 9-12';
declare variable $siglum-82 as xs:string := 'Rdz 1,2nn; 3,6nn';

let $siglum-01-validation := bib:validate-siglum($siglum-01)
let $siglum-02-validation := bib:validate-siglum($siglum-02)
let $siglum-03-validation := bib:validate-siglum($siglum-03)
let $siglum-04-validation := bib:validate-siglum($siglum-04)
let $siglum-05-validation := bib:validate-siglum($siglum-05)
let $siglum-06-validation := bib:validate-siglum($siglum-06)
let $siglum-07-validation := bib:validate-siglum($siglum-07)
let $siglum-08-validation := bib:validate-siglum($siglum-08)
let $siglum-09-validation := bib:validate-siglum($siglum-09)
let $siglum-10-validation := bib:validate-siglum($siglum-10)
let $siglum-11-validation := bib:validate-siglum($siglum-11)
let $siglum-12-validation := bib:validate-siglum($siglum-12)
let $siglum-13-validation := bib:validate-siglum($siglum-13)
let $siglum-14-validation := bib:validate-siglum($siglum-14)
let $siglum-15-validation := bib:validate-siglum($siglum-15)
let $siglum-16-validation := bib:validate-siglum($siglum-16)
let $siglum-17-validation := bib:validate-siglum($siglum-17)
let $siglum-18-validation := bib:validate-siglum($siglum-18)
let $siglum-19-validation := bib:validate-siglum($siglum-19)
let $siglum-20-validation := bib:validate-siglum($siglum-20)
let $siglum-21-validation := bib:validate-siglum($siglum-21)
let $siglum-22-validation := bib:validate-siglum($siglum-22)
let $siglum-23-validation := bib:validate-siglum($siglum-23)
let $siglum-24-validation := bib:validate-siglum($siglum-24)
let $siglum-25-validation := bib:validate-siglum($siglum-25)
let $siglum-26-validation := bib:validate-siglum($siglum-26)
let $siglum-27-validation := bib:validate-siglum($siglum-27)
let $siglum-28-validation := bib:validate-siglum($siglum-28)
let $siglum-29-validation := bib:validate-siglum($siglum-29)
let $siglum-30-validation := bib:validate-siglum($siglum-30)
let $siglum-31-validation := bib:validate-siglum($siglum-31)
let $siglum-32-validation := bib:validate-siglum($siglum-32)
let $siglum-33-validation := bib:validate-siglum($siglum-33)
let $siglum-34-validation := bib:validate-siglum($siglum-34)
let $siglum-35-validation := bib:validate-siglum($siglum-35)
let $siglum-36-validation := bib:validate-siglum($siglum-36)
let $siglum-37-validation := bib:validate-siglum($siglum-37)
let $siglum-38-validation := bib:validate-siglum($siglum-38)
let $siglum-39-validation := bib:validate-siglum($siglum-39)
let $siglum-40-validation := bib:validate-siglum($siglum-40)
let $siglum-41-validation := bib:validate-siglum($siglum-41)
let $siglum-42-validation := bib:validate-siglum($siglum-42)
let $siglum-43-validation := bib:validate-siglum($siglum-43)
let $siglum-44-validation := bib:validate-siglum($siglum-44)
let $siglum-45-validation := bib:validate-siglum($siglum-45)
let $siglum-46-validation := bib:validate-siglum($siglum-46)
let $siglum-47-validation := bib:validate-siglum($siglum-47)
let $siglum-48-validation := bib:validate-siglum($siglum-48)
let $siglum-49-validation := bib:validate-siglum($siglum-49)
let $siglum-50-validation := bib:validate-siglum($siglum-50)
let $siglum-51-validation := bib:validate-siglum($siglum-51)
let $siglum-52-validation := bib:validate-siglum($siglum-52)
let $siglum-53-validation := bib:validate-siglum($siglum-53)
let $siglum-54-validation := bib:validate-siglum($siglum-54)
let $siglum-55-validation := bib:validate-siglum($siglum-55)
let $siglum-56-validation := bib:validate-siglum($siglum-56)
let $siglum-57-validation := bib:validate-siglum($siglum-57)
let $siglum-58-validation := bib:validate-siglum($siglum-58)
let $siglum-59-validation := bib:validate-siglum($siglum-59)
let $siglum-60-validation := bib:validate-siglum($siglum-60)
let $siglum-61-validation := bib:validate-siglum($siglum-61)
let $siglum-62-validation := bib:validate-siglum($siglum-62)
let $siglum-63-validation := bib:validate-siglum($siglum-63)
let $siglum-64-validation := bib:validate-siglum($siglum-64)
let $siglum-65-validation := bib:validate-siglum($siglum-65)
let $siglum-66-validation := bib:validate-siglum($siglum-66)
let $siglum-67-validation := bib:validate-siglum($siglum-67)
let $siglum-68-validation := bib:validate-siglum($siglum-68)
let $siglum-69-validation := bib:validate-siglum($siglum-69)
let $siglum-70-validation := bib:validate-siglum($siglum-70)
let $siglum-71-validation := bib:validate-siglum($siglum-71)
let $siglum-72-validation := bib:validate-siglum($siglum-72)
let $siglum-73-validation := bib:validate-siglum($siglum-73)
let $siglum-74-validation := bib:validate-siglum($siglum-74)
let $siglum-75-validation := bib:validate-siglum($siglum-75)
let $siglum-76-validation := bib:validate-siglum($siglum-76)
let $siglum-77-validation := bib:validate-siglum($siglum-77)
let $siglum-78-validation := bib:validate-siglum($siglum-78)
let $siglum-79-validation := bib:validate-siglum($siglum-79)
let $siglum-80-validation := bib:validate-siglum($siglum-80)
let $siglum-81-validation := bib:validate-siglum($siglum-81)
let $siglum-82-validation := bib:validate-siglum($siglum-82)

return (
    test:assert-true($siglum-01-validation, 'Wrong validation verification for a siglum ' || $siglum-01),
    test:assert-false($siglum-02-validation, 'Wrong validation verification for a siglum ' || $siglum-02),
    test:assert-true($siglum-03-validation, 'Wrong validation verification for a siglum ' || $siglum-03),
    test:assert-true($siglum-04-validation, 'Wrong validation verification for a siglum ' || $siglum-04),
    test:assert-false($siglum-05-validation, 'Wrong validation verification for a siglum ' || $siglum-05),
    test:assert-false($siglum-06-validation, 'Wrong validation verification for a siglum ' || $siglum-06),
    test:assert-true($siglum-07-validation, 'Wrong validation verification for a siglum ' || $siglum-07),
    test:assert-true($siglum-08-validation, 'Wrong validation verification for a siglum ' || $siglum-08),
    test:assert-true($siglum-09-validation, 'Wrong validation verification for a siglum ' || $siglum-09),
    test:assert-false($siglum-10-validation, 'Wrong validation verification for a siglum ' || $siglum-10),
    test:assert-true($siglum-11-validation, 'Wrong validation verification for a siglum ' || $siglum-11),
    test:assert-true($siglum-12-validation, 'Wrong validation verification for a siglum ' || $siglum-12),
    test:assert-true($siglum-13-validation, 'Wrong validation verification for a siglum ' || $siglum-13),
    test:assert-false($siglum-14-validation, 'Wrong validation verification for a siglum ' || $siglum-14),
    test:assert-true($siglum-15-validation, 'Wrong validation verification for a siglum ' || $siglum-15),
    test:assert-true($siglum-16-validation, 'Wrong validation verification for a siglum ' || $siglum-16),
    test:assert-true($siglum-17-validation, 'Wrong validation verification for a siglum ' || $siglum-17),
    test:assert-true($siglum-18-validation, 'Wrong validation verification for a siglum ' || $siglum-18),
    test:assert-true($siglum-19-validation, 'Wrong validation verification for a siglum ' || $siglum-19),
    test:assert-true($siglum-20-validation, 'Wrong validation verification for a siglum ' || $siglum-20),
    test:assert-false($siglum-21-validation, 'Wrong validation verification for a siglum ' || $siglum-21),
    test:assert-false($siglum-22-validation, 'Wrong validation verification for a siglum ' || $siglum-22),
    test:assert-false($siglum-23-validation, 'Wrong validation verification for a siglum ' || $siglum-23),
    test:assert-false($siglum-24-validation, 'Wrong validation verification for a siglum ' || $siglum-24),
    test:assert-true($siglum-25-validation, 'Wrong validation verification for a siglum ' || $siglum-25),
    test:assert-false($siglum-26-validation, 'Wrong validation verification for a siglum ' || $siglum-26),
    test:assert-true($siglum-27-validation, 'Wrong validation verification for a siglum ' || $siglum-27),
    test:assert-false($siglum-28-validation, 'Wrong validation verification for a siglum ' || $siglum-28),
    test:assert-false($siglum-29-validation, 'Wrong validation verification for a siglum ' || $siglum-29),
    test:assert-false($siglum-30-validation, 'Wrong validation verification for a siglum ' || $siglum-30),
    test:assert-true($siglum-31-validation, 'Wrong validation verification for a siglum ' || $siglum-31),
    test:assert-false($siglum-32-validation, 'Wrong validation verification for a siglum ' || $siglum-32),
    test:assert-false($siglum-33-validation, 'Wrong validation verification for a siglum ' || $siglum-33),
    test:assert-false($siglum-34-validation, 'Wrong validation verification for a siglum ' || $siglum-34),
    test:assert-false($siglum-35-validation, 'Wrong validation verification for a siglum ' || $siglum-35),
    test:assert-true($siglum-36-validation, 'Wrong validation verification for a siglum ' || $siglum-36),
    test:assert-true($siglum-37-validation, 'Wrong validation verification for a siglum ' || $siglum-37),
    test:assert-true($siglum-38-validation, 'Wrong validation verification for a siglum ' || $siglum-38),
    test:assert-false($siglum-39-validation, 'Wrong validation verification for a siglum ' || $siglum-39),
    test:assert-true($siglum-40-validation, 'Wrong validation verification for a siglum ' || $siglum-40),
    test:assert-true($siglum-41-validation, 'Wrong validation verification for a siglum ' || $siglum-41),
    test:assert-false($siglum-42-validation, 'Wrong validation verification for a siglum ' || $siglum-42),
    test:assert-true($siglum-43-validation, 'Wrong validation verification for a siglum ' || $siglum-43),
    test:assert-true($siglum-44-validation, 'Wrong validation verification for a siglum ' || $siglum-44),
    test:assert-true($siglum-45-validation, 'Wrong validation verification for a siglum ' || $siglum-45),
    test:assert-true($siglum-46-validation, 'Wrong validation verification for a siglum ' || $siglum-46),
    test:assert-false($siglum-47-validation, 'Wrong validation verification for a siglum ' || $siglum-47),
    test:assert-true($siglum-48-validation, 'Wrong validation verification for a siglum ' || $siglum-48),
    test:assert-true($siglum-49-validation, 'Wrong validation verification for a siglum ' || $siglum-49),
    test:assert-true($siglum-50-validation, 'Wrong validation verification for a siglum ' || $siglum-50),
    test:assert-true($siglum-51-validation, 'Wrong validation verification for a siglum ' || $siglum-51),
    test:assert-false($siglum-52-validation, 'Wrong validation verification for a siglum ' || $siglum-52),
    test:assert-false($siglum-53-validation, 'Wrong validation verification for a siglum ' || $siglum-53),
    test:assert-false($siglum-54-validation, 'Wrong validation verification for a siglum ' || $siglum-54),
    test:assert-true($siglum-55-validation, 'Wrong validation verification for a siglum ' || $siglum-55),
    test:assert-true($siglum-56-validation, 'Wrong validation verification for a siglum ' || $siglum-56),
    test:assert-true($siglum-57-validation, 'Wrong validation verification for a siglum ' || $siglum-57),
    test:assert-false($siglum-58-validation, 'Wrong validation verification for a siglum ' || $siglum-58),
    test:assert-true($siglum-59-validation, 'Wrong validation verification for a siglum ' || $siglum-59),
    test:assert-false($siglum-60-validation, 'Wrong validation verification for a siglum ' || $siglum-60),
    test:assert-false($siglum-61-validation, 'Wrong validation verification for a siglum ' || $siglum-61),
    test:assert-false($siglum-62-validation, 'Wrong validation verification for a siglum ' || $siglum-62),
    test:assert-false($siglum-63-validation, 'Wrong validation verification for a siglum ' || $siglum-63),
    test:assert-true($siglum-64-validation, 'Wrong validation verification for a siglum ' || $siglum-64),
    test:assert-false($siglum-65-validation, 'Wrong validation verification for a siglum ' || $siglum-65),
    test:assert-true($siglum-66-validation, 'Wrong validation verification for a siglum ' || $siglum-66),
    test:assert-true($siglum-67-validation, 'Wrong validation verification for a siglum ' || $siglum-67),
    test:assert-true($siglum-68-validation, 'Wrong validation verification for a siglum ' || $siglum-68),
    test:assert-false($siglum-69-validation, 'Wrong validation verification for a siglum ' || $siglum-69),
    test:assert-false($siglum-70-validation, 'Wrong validation verification for a siglum ' || $siglum-70),
    test:assert-true($siglum-71-validation, 'Wrong validation verification for a siglum ' || $siglum-71),
    test:assert-false($siglum-72-validation, 'Wrong validation verification for a siglum ' || $siglum-72),
    test:assert-true($siglum-73-validation, 'Wrong validation verification for a siglum ' || $siglum-73),
    test:assert-true($siglum-74-validation, 'Wrong validation verification for a siglum ' || $siglum-74),
    test:assert-true($siglum-75-validation, 'Wrong validation verification for a siglum ' || $siglum-75),
    test:assert-true($siglum-76-validation, 'Wrong validation verification for a siglum ' || $siglum-76),
    test:assert-false($siglum-77-validation, 'Wrong validation verification for a siglum ' || $siglum-77),
    test:assert-true($siglum-78-validation, 'Wrong validation verification for a siglum ' || $siglum-78),
    test:assert-true($siglum-79-validation, 'Wrong validation verification for a siglum ' || $siglum-79),
    test:assert-true($siglum-80-validation, 'Wrong validation verification for a siglum ' || $siglum-80),
    test:assert-false($siglum-81-validation, 'Wrong validation verification for a siglum ' || $siglum-81),
    test:assert-true($siglum-82-validation, 'Wrong validation verification for a siglum ' || $siglum-82)
)