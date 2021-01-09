xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace bib = "http://marklogic.com/holy/ml-modules/bible-utils" at "/libs/bible-utils.xqy";

declare variable $SIGLUM-001 as xs:string := 'Rdz';
declare variable $SIGLUM-002 as xs:string := 'Rdz; Wj';
declare variable $SIGLUM-003 as xs:string := 'Rdz 1';
declare variable $SIGLUM-004 as xs:string := 'Rdz 11';
declare variable $SIGLUM-005 as xs:string := 'Rdz 111';
declare variable $SIGLUM-006 as xs:string := 'Rdz 1,';
declare variable $SIGLUM-007 as xs:string := 'Rdz 1,1';
declare variable $SIGLUM-008 as xs:string := 'Rdz 1,1n';
declare variable $SIGLUM-009 as xs:string := 'Rdz 1,1nn';
declare variable $SIGLUM-010 as xs:string := 'Rdz 1,1nnn';
declare variable $SIGLUM-011 as xs:string := 'Rdz 1,11';
declare variable $SIGLUM-012 as xs:string := 'Rdz 1,11n';
declare variable $SIGLUM-013 as xs:string := 'Rdz 1,11nn';
declare variable $SIGLUM-014 as xs:string := 'Rdz 1,111';
declare variable $SIGLUM-015 as xs:string := 'Rdz 11,1';
declare variable $SIGLUM-016 as xs:string := 'Rdz 11,1n';
declare variable $SIGLUM-017 as xs:string := 'Rdz 11,1nn';
declare variable $SIGLUM-018 as xs:string := 'Rdz 11,11';
declare variable $SIGLUM-019 as xs:string := 'Rdz 11,11n';
declare variable $SIGLUM-020 as xs:string := 'Rdz 11,11nn';
declare variable $SIGLUM-021 as xs:string := 'Rdz 11,11nnn';
declare variable $SIGLUM-022 as xs:string := 'Rdz 11,111';
declare variable $SIGLUM-023 as xs:string := 'Rdz 111,1';
declare variable $SIGLUM-024 as xs:string := 'Rdz 1,1-';
declare variable $SIGLUM-025 as xs:string := 'Rdz 1,1-5';
declare variable $SIGLUM-026 as xs:string := 'Rdz 1,1-5n';
declare variable $SIGLUM-027 as xs:string := 'Rdz 1,1-55';
declare variable $SIGLUM-028 as xs:string := 'Rdz 1,1-55n';
declare variable $SIGLUM-029 as xs:string := 'Rdz 1,1-555';
declare variable $SIGLUM-030 as xs:string := 'Rdz 1,11-5n';
declare variable $SIGLUM-031 as xs:string := 'Rdz 1,11-55';
declare variable $SIGLUM-032 as xs:string := 'Rdz 1,11-55n';
declare variable $SIGLUM-033 as xs:string := 'Rdz 1,11-555';
declare variable $SIGLUM-034 as xs:string := 'Rdz 1,111-5';
declare variable $SIGLUM-035 as xs:string := 'Rdz 1,1.';
declare variable $SIGLUM-036 as xs:string := 'Rdz 1,1. 3';
declare variable $SIGLUM-037 as xs:string := 'Rdz 1,1. 3n';
declare variable $SIGLUM-038 as xs:string := 'Rdz 1,1. 3nn';
declare variable $SIGLUM-039 as xs:string := 'Rdz 1,1. 3nnn';
declare variable $SIGLUM-040 as xs:string := 'Rdz 1,1n. 3';
declare variable $SIGLUM-041 as xs:string := 'Rdz 1,1nn. 3';
declare variable $SIGLUM-042 as xs:string := 'Rdz 1,1nnn. 3';
declare variable $SIGLUM-043 as xs:string := 'Rdz 1,1n. 3n';
declare variable $SIGLUM-044 as xs:string := 'Rdz 1,1nn. 3nn';
declare variable $SIGLUM-045 as xs:string := 'Rdz 1,1. 33';
declare variable $SIGLUM-046 as xs:string := 'Rdz 1,1. 33n';
declare variable $SIGLUM-047 as xs:string := 'Rdz 1,1. 333';
declare variable $SIGLUM-048 as xs:string := 'Rdz 1,11. 3';
declare variable $SIGLUM-049 as xs:string := 'Rdz 1,11. 3n';
declare variable $SIGLUM-050 as xs:string := 'Rdz 1,11. 33';
declare variable $SIGLUM-051 as xs:string := 'Rdz 1,11. 33n';
declare variable $SIGLUM-052 as xs:string := 'Rdz 1,11. 333';
declare variable $SIGLUM-053 as xs:string := 'Rdz 1,111. 3';
declare variable $SIGLUM-054 as xs:string := 'Rdz 1,1-5.';
declare variable $SIGLUM-055 as xs:string := 'Rdz 1,1-5. 7';
declare variable $SIGLUM-056 as xs:string := 'Rdz 1,1-5. 7n';
declare variable $SIGLUM-057 as xs:string := 'Rdz 1,11-51. 71';
declare variable $SIGLUM-058 as xs:string := 'Rdz 1,11-51n. 71';
declare variable $SIGLUM-059 as xs:string := 'Rdz 1,11-51. 71n';
declare variable $SIGLUM-060 as xs:string := 'Rdz 1,111-51. 71';
declare variable $SIGLUM-061 as xs:string := 'Rdz 1,11-511. 71';
declare variable $SIGLUM-062 as xs:string := 'Rdz 1,11-51. 711';
declare variable $SIGLUM-063 as xs:string := 'Rdz 1,1. 5-';
declare variable $SIGLUM-064 as xs:string := 'Rdz 1,1. 5-7';
declare variable $SIGLUM-065 as xs:string := 'Rdz 1,1-3. 5-';
declare variable $SIGLUM-066 as xs:string := 'Rdz 1,1-3. 5-7';
declare variable $SIGLUM-067 as xs:string := 'Rdz 1,1-3. 5-7. 9. 10-12. 15. 17. 19. 21-29';
declare variable $SIGLUM-068 as xs:string := 'Rdz 1,1-3. 5-7. 9n. 10-12. 15n. 17. 19n. 21-29';
declare variable $SIGLUM-069 as xs:string := 'Rdz 1; 2,5,7';
declare variable $SIGLUM-070 as xs:string := 'Rdz 1; 2,';
declare variable $SIGLUM-071 as xs:string := 'Rdz 1; 3; 5';
declare variable $SIGLUM-072 as xs:string := 'Rdz 1. 3';
declare variable $SIGLUM-073 as xs:string := 'Rdz 1,3; 3';
declare variable $SIGLUM-074 as xs:string := 'Rdz 1,3; 3,4';
declare variable $SIGLUM-075 as xs:string := 'Rdz 1,3; 3; 5; 10,5';
declare variable $SIGLUM-076 as xs:string := 'Rdz 1-3';
declare variable $SIGLUM-077 as xs:string := 'Rdz 1-3,5';
declare variable $SIGLUM-078 as xs:string := 'Rdz 1-3; 5,8; 9-12';
declare variable $SIGLUM-079 as xs:string := 'Rdz 1-3; 5,8; 9-12';
declare variable $SIGLUM-080 as xs:string := 'Rdz 1-3; 5,7-8. 10n. 15-20; 9-12';
declare variable $SIGLUM-081 as xs:string := 'Rdz 1-3; 5-7,8; 9-12';
declare variable $SIGLUM-082 as xs:string := 'Rdz 1,2nn; 3,6nn';
declare variable $SIGLUM-083 as xs:string := 'Syr Prolog';
declare variable $SIGLUM-084 as xs:string := 'Syr Prolog,3';
declare variable $SIGLUM-085 as xs:string := 'Ps 112';
declare variable $SIGLUM-086 as xs:string := 'Ps 1,111';
declare variable $SIGLUM-087 as xs:string := 'Ps 11,111';
declare variable $SIGLUM-088 as xs:string := 'Ps 111,1';
declare variable $SIGLUM-089 as xs:string := 'Ps 1,1-111';
declare variable $SIGLUM-090 as xs:string := 'Ps 1,11-111';
declare variable $SIGLUM-091 as xs:string := 'Ps 1,111-5';
declare variable $SIGLUM-092 as xs:string := 'Ps 1,1. 111';
declare variable $SIGLUM-093 as xs:string := 'Ps 1,11. 111';
declare variable $SIGLUM-094 as xs:string := 'Ps 1,111. 3';
declare variable $SIGLUM-095 as xs:string := 'Ps 1,111-51. 71';
declare variable $SIGLUM-096 as xs:string := 'Ps 1,11-111. 71';
declare variable $SIGLUM-097 as xs:string := 'Ps 1,11-51. 111';
declare variable $SIGLUM-098 as xs:string := 'Dn 3,111';
declare variable $SIGLUM-099 as xs:string := 'Dn 3,1-100';
declare variable $SIGLUM-100 as xs:string := 'Dn 3,11-100';
declare variable $SIGLUM-101 as xs:string := 'Dn 3,100-5';
declare variable $SIGLUM-102 as xs:string := 'Dn 3,1. 100';
declare variable $SIGLUM-103 as xs:string := 'Dn 3,11. 100';
declare variable $SIGLUM-104 as xs:string := 'Dn 3,100. 3';
declare variable $SIGLUM-105 as xs:string := 'Dn 3,100-51. 71';
declare variable $SIGLUM-106 as xs:string := 'Dn 3,11-100. 71';
declare variable $SIGLUM-107 as xs:string := 'Dn 3,11-51. 100';
declare variable $SIGLUM-108 as xs:string := 'Joz 1,1a';
declare variable $SIGLUM-109 as xs:string := 'Joz 1,1a. 1b';
declare variable $SIGLUM-110 as xs:string := 'Joz 1,1a-1c';
declare variable $SIGLUM-111 as xs:string := 'Joz 1,1-1c';
declare variable $SIGLUM-112 as xs:string := 'Joz 1,1a-1';
declare variable $SIGLUM-113 as xs:string := 'Ne 1,1a';
declare variable $SIGLUM-114 as xs:string := 'Ne 1,1a. 1b';
declare variable $SIGLUM-115 as xs:string := 'Ne 1,1a-1c';
declare variable $SIGLUM-116 as xs:string := 'Ne 1,1-1c';
declare variable $SIGLUM-117 as xs:string := 'Ne 1,1a-1';
declare variable $SIGLUM-118 as xs:string := 'Est 1,1a';
declare variable $SIGLUM-119 as xs:string := 'Est 1,1a. 1b';
declare variable $SIGLUM-120 as xs:string := 'Est 1,1a-1c';
declare variable $SIGLUM-121 as xs:string := 'Est 1,1-1c';
declare variable $SIGLUM-122 as xs:string := 'Est 1,1a-1';
declare variable $SIGLUM-123 as xs:string := 'Rdz Prolog';
declare variable $SIGLUM-124 as xs:string := 'Ps Prolog';
declare variable $SIGLUM-125 as xs:string := 'Dn Prolog';
declare variable $SIGLUM-126 as xs:string := 'Joz Prolog';
declare variable $SIGLUM-127 as xs:string := 'Ne Prolog';
declare variable $SIGLUM-128 as xs:string := 'Est Prolog';
declare variable $SIGLUM-129 as xs:string := 'Syr 111';
declare variable $SIGLUM-130 as xs:string := 'Dn 111';
declare variable $SIGLUM-131 as xs:string := 'Joz 111';
declare variable $SIGLUM-132 as xs:string := 'Ne 111';
declare variable $SIGLUM-133 as xs:string := 'Est 111';
declare variable $SIGLUM-134 as xs:string := 'Syr 1,111';
declare variable $SIGLUM-135 as xs:string := 'Joz 1,111';
declare variable $SIGLUM-136 as xs:string := 'Ne 1,111';
declare variable $SIGLUM-137 as xs:string := 'Est 1,111';

let $siglum-001-validation := bib:validate-siglum($SIGLUM-001)
let $siglum-002-validation := bib:validate-siglum($SIGLUM-002)
let $siglum-003-validation := bib:validate-siglum($SIGLUM-003)
let $siglum-004-validation := bib:validate-siglum($SIGLUM-004)
let $siglum-005-validation := bib:validate-siglum($SIGLUM-005)
let $siglum-006-validation := bib:validate-siglum($SIGLUM-006)
let $siglum-007-validation := bib:validate-siglum($SIGLUM-007)
let $siglum-008-validation := bib:validate-siglum($SIGLUM-008)
let $siglum-009-validation := bib:validate-siglum($SIGLUM-009)
let $siglum-010-validation := bib:validate-siglum($SIGLUM-010)
let $siglum-011-validation := bib:validate-siglum($SIGLUM-011)
let $siglum-012-validation := bib:validate-siglum($SIGLUM-012)
let $siglum-013-validation := bib:validate-siglum($SIGLUM-013)
let $siglum-014-validation := bib:validate-siglum($SIGLUM-014)
let $siglum-015-validation := bib:validate-siglum($SIGLUM-015)
let $siglum-016-validation := bib:validate-siglum($SIGLUM-016)
let $siglum-017-validation := bib:validate-siglum($SIGLUM-017)
let $siglum-018-validation := bib:validate-siglum($SIGLUM-018)
let $siglum-019-validation := bib:validate-siglum($SIGLUM-019)
let $siglum-020-validation := bib:validate-siglum($SIGLUM-020)
let $siglum-021-validation := bib:validate-siglum($SIGLUM-021)
let $siglum-022-validation := bib:validate-siglum($SIGLUM-022)
let $siglum-023-validation := bib:validate-siglum($SIGLUM-023)
let $siglum-024-validation := bib:validate-siglum($SIGLUM-024)
let $siglum-025-validation := bib:validate-siglum($SIGLUM-025)
let $siglum-026-validation := bib:validate-siglum($SIGLUM-026)
let $siglum-027-validation := bib:validate-siglum($SIGLUM-027)
let $siglum-028-validation := bib:validate-siglum($SIGLUM-028)
let $siglum-029-validation := bib:validate-siglum($SIGLUM-029)
let $siglum-030-validation := bib:validate-siglum($SIGLUM-030)
let $siglum-031-validation := bib:validate-siglum($SIGLUM-031)
let $siglum-032-validation := bib:validate-siglum($SIGLUM-032)
let $siglum-033-validation := bib:validate-siglum($SIGLUM-033)
let $siglum-034-validation := bib:validate-siglum($SIGLUM-034)
let $siglum-035-validation := bib:validate-siglum($SIGLUM-035)
let $siglum-036-validation := bib:validate-siglum($SIGLUM-036)
let $siglum-037-validation := bib:validate-siglum($SIGLUM-037)
let $siglum-038-validation := bib:validate-siglum($SIGLUM-038)
let $siglum-039-validation := bib:validate-siglum($SIGLUM-039)
let $siglum-040-validation := bib:validate-siglum($SIGLUM-040)
let $siglum-041-validation := bib:validate-siglum($SIGLUM-041)
let $siglum-042-validation := bib:validate-siglum($SIGLUM-042)
let $siglum-043-validation := bib:validate-siglum($SIGLUM-043)
let $siglum-044-validation := bib:validate-siglum($SIGLUM-044)
let $siglum-045-validation := bib:validate-siglum($SIGLUM-045)
let $siglum-046-validation := bib:validate-siglum($SIGLUM-046)
let $siglum-047-validation := bib:validate-siglum($SIGLUM-047)
let $siglum-048-validation := bib:validate-siglum($SIGLUM-048)
let $siglum-049-validation := bib:validate-siglum($SIGLUM-049)
let $siglum-050-validation := bib:validate-siglum($SIGLUM-050)
let $siglum-051-validation := bib:validate-siglum($SIGLUM-051)
let $siglum-052-validation := bib:validate-siglum($SIGLUM-052)
let $siglum-053-validation := bib:validate-siglum($SIGLUM-053)
let $siglum-054-validation := bib:validate-siglum($SIGLUM-054)
let $siglum-055-validation := bib:validate-siglum($SIGLUM-055)
let $siglum-056-validation := bib:validate-siglum($SIGLUM-056)
let $siglum-057-validation := bib:validate-siglum($SIGLUM-057)
let $siglum-058-validation := bib:validate-siglum($SIGLUM-058)
let $siglum-059-validation := bib:validate-siglum($SIGLUM-059)
let $siglum-060-validation := bib:validate-siglum($SIGLUM-060)
let $siglum-061-validation := bib:validate-siglum($SIGLUM-061)
let $siglum-062-validation := bib:validate-siglum($SIGLUM-062)
let $siglum-063-validation := bib:validate-siglum($SIGLUM-063)
let $siglum-064-validation := bib:validate-siglum($SIGLUM-064)
let $siglum-065-validation := bib:validate-siglum($SIGLUM-065)
let $siglum-066-validation := bib:validate-siglum($SIGLUM-066)
let $siglum-067-validation := bib:validate-siglum($SIGLUM-067)
let $siglum-068-validation := bib:validate-siglum($SIGLUM-068)
let $siglum-069-validation := bib:validate-siglum($SIGLUM-069)
let $siglum-070-validation := bib:validate-siglum($SIGLUM-070)
let $siglum-071-validation := bib:validate-siglum($SIGLUM-071)
let $siglum-072-validation := bib:validate-siglum($SIGLUM-072)
let $siglum-073-validation := bib:validate-siglum($SIGLUM-073)
let $siglum-074-validation := bib:validate-siglum($SIGLUM-074)
let $siglum-075-validation := bib:validate-siglum($SIGLUM-075)
let $siglum-076-validation := bib:validate-siglum($SIGLUM-076)
let $siglum-077-validation := bib:validate-siglum($SIGLUM-077)
let $siglum-078-validation := bib:validate-siglum($SIGLUM-078)
let $siglum-079-validation := bib:validate-siglum($SIGLUM-079)
let $siglum-080-validation := bib:validate-siglum($SIGLUM-080)
let $siglum-081-validation := bib:validate-siglum($SIGLUM-081)
let $siglum-082-validation := bib:validate-siglum($SIGLUM-082)
let $siglum-083-validation := bib:validate-siglum($SIGLUM-083)
let $siglum-084-validation := bib:validate-siglum($SIGLUM-084)
let $siglum-085-validation := bib:validate-siglum($SIGLUM-085)
let $siglum-086-validation := bib:validate-siglum($SIGLUM-086)
let $siglum-087-validation := bib:validate-siglum($SIGLUM-087)
let $siglum-088-validation := bib:validate-siglum($SIGLUM-088)
let $siglum-089-validation := bib:validate-siglum($SIGLUM-089)
let $siglum-090-validation := bib:validate-siglum($SIGLUM-090)
let $siglum-091-validation := bib:validate-siglum($SIGLUM-091)
let $siglum-092-validation := bib:validate-siglum($SIGLUM-092)
let $siglum-093-validation := bib:validate-siglum($SIGLUM-093)
let $siglum-094-validation := bib:validate-siglum($SIGLUM-094)
let $siglum-095-validation := bib:validate-siglum($SIGLUM-095)
let $siglum-096-validation := bib:validate-siglum($SIGLUM-096)
let $siglum-097-validation := bib:validate-siglum($SIGLUM-097)
let $siglum-098-validation := bib:validate-siglum($SIGLUM-098)
let $siglum-099-validation := bib:validate-siglum($SIGLUM-099)
let $siglum-100-validation := bib:validate-siglum($SIGLUM-100)
let $siglum-101-validation := bib:validate-siglum($SIGLUM-101)
let $siglum-102-validation := bib:validate-siglum($SIGLUM-102)
let $siglum-103-validation := bib:validate-siglum($SIGLUM-103)
let $siglum-104-validation := bib:validate-siglum($SIGLUM-104)
let $siglum-105-validation := bib:validate-siglum($SIGLUM-105)
let $siglum-106-validation := bib:validate-siglum($SIGLUM-106)
let $siglum-107-validation := bib:validate-siglum($SIGLUM-107)
let $siglum-108-validation := bib:validate-siglum($SIGLUM-108)
let $siglum-109-validation := bib:validate-siglum($SIGLUM-109)
let $siglum-110-validation := bib:validate-siglum($SIGLUM-110)
let $siglum-111-validation := bib:validate-siglum($SIGLUM-111)
let $siglum-112-validation := bib:validate-siglum($SIGLUM-112)
let $siglum-113-validation := bib:validate-siglum($SIGLUM-113)
let $siglum-114-validation := bib:validate-siglum($SIGLUM-114)
let $siglum-115-validation := bib:validate-siglum($SIGLUM-115)
let $siglum-116-validation := bib:validate-siglum($SIGLUM-116)
let $siglum-117-validation := bib:validate-siglum($SIGLUM-117)
let $siglum-118-validation := bib:validate-siglum($SIGLUM-118)
let $siglum-119-validation := bib:validate-siglum($SIGLUM-119)
let $siglum-120-validation := bib:validate-siglum($SIGLUM-120)
let $siglum-121-validation := bib:validate-siglum($SIGLUM-121)
let $siglum-122-validation := bib:validate-siglum($SIGLUM-122)
let $siglum-123-validation := bib:validate-siglum($SIGLUM-123)
let $siglum-124-validation := bib:validate-siglum($SIGLUM-124)
let $siglum-125-validation := bib:validate-siglum($SIGLUM-125)
let $siglum-126-validation := bib:validate-siglum($SIGLUM-126)
let $siglum-127-validation := bib:validate-siglum($SIGLUM-127)
let $siglum-128-validation := bib:validate-siglum($SIGLUM-128)
let $siglum-129-validation := bib:validate-siglum($SIGLUM-129)
let $siglum-130-validation := bib:validate-siglum($SIGLUM-130)
let $siglum-131-validation := bib:validate-siglum($SIGLUM-131)
let $siglum-132-validation := bib:validate-siglum($SIGLUM-132)
let $siglum-133-validation := bib:validate-siglum($SIGLUM-133)
let $siglum-134-validation := bib:validate-siglum($SIGLUM-134)
let $siglum-135-validation := bib:validate-siglum($SIGLUM-135)
let $siglum-136-validation := bib:validate-siglum($SIGLUM-136)
let $siglum-137-validation := bib:validate-siglum($SIGLUM-137)

return (
    test:assert-true($siglum-001-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-001),
    test:assert-false($siglum-002-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-002),
    test:assert-true($siglum-003-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-003),
    test:assert-true($siglum-004-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-004),
    test:assert-false($siglum-005-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-005),
    test:assert-false($siglum-006-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-006),
    test:assert-true($siglum-007-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-007),
    test:assert-true($siglum-008-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-008),
    test:assert-true($siglum-009-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-009),
    test:assert-false($siglum-010-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-010),
    test:assert-true($siglum-011-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-011),
    test:assert-true($siglum-012-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-012),
    test:assert-true($siglum-013-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-013),
    test:assert-false($siglum-014-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-014),
    test:assert-true($siglum-015-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-015),
    test:assert-true($siglum-016-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-016),
    test:assert-true($siglum-017-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-017),
    test:assert-true($siglum-018-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-018),
    test:assert-true($siglum-019-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-019),
    test:assert-true($siglum-020-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-020),
    test:assert-false($siglum-021-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-021),
    test:assert-false($siglum-022-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-022),
    test:assert-false($siglum-023-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-023),
    test:assert-false($siglum-024-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-024),
    test:assert-true($siglum-025-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-025),
    test:assert-false($siglum-026-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-026),
    test:assert-true($siglum-027-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-027),
    test:assert-false($siglum-028-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-028),
    test:assert-false($siglum-029-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-029),
    test:assert-false($siglum-030-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-030),
    test:assert-true($siglum-031-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-031),
    test:assert-false($siglum-032-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-032),
    test:assert-false($siglum-033-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-033),
    test:assert-false($siglum-034-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-034),
    test:assert-false($siglum-035-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-035),
    test:assert-true($siglum-036-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-036),
    test:assert-true($siglum-037-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-037),
    test:assert-true($siglum-038-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-038),
    test:assert-false($siglum-039-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-039),
    test:assert-true($siglum-040-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-040),
    test:assert-true($siglum-041-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-041),
    test:assert-false($siglum-042-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-042),
    test:assert-true($siglum-043-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-043),
    test:assert-true($siglum-044-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-044),
    test:assert-true($siglum-045-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-045),
    test:assert-true($siglum-046-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-046),
    test:assert-false($siglum-047-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-047),
    test:assert-true($siglum-048-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-048),
    test:assert-true($siglum-049-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-049),
    test:assert-true($siglum-050-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-050),
    test:assert-true($siglum-051-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-051),
    test:assert-false($siglum-052-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-052),
    test:assert-false($siglum-053-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-053),
    test:assert-false($siglum-054-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-054),
    test:assert-true($siglum-055-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-055),
    test:assert-true($siglum-056-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-056),
    test:assert-true($siglum-057-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-057),
    test:assert-false($siglum-058-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-058),
    test:assert-true($siglum-059-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-059),
    test:assert-false($siglum-060-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-060),
    test:assert-false($siglum-061-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-061),
    test:assert-false($siglum-062-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-062),
    test:assert-false($siglum-063-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-063),
    test:assert-true($siglum-064-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-064),
    test:assert-false($siglum-065-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-065),
    test:assert-true($siglum-066-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-066),
    test:assert-true($siglum-067-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-067),
    test:assert-true($siglum-068-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-068),
    test:assert-false($siglum-069-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-069),
    test:assert-false($siglum-070-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-070),
    test:assert-true($siglum-071-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-071),
    test:assert-false($siglum-072-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-072),
    test:assert-true($siglum-073-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-073),
    test:assert-true($siglum-074-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-074),
    test:assert-true($siglum-075-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-075),
    test:assert-true($siglum-076-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-076),
    test:assert-false($siglum-077-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-077),
    test:assert-true($siglum-078-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-078),
    test:assert-true($siglum-079-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-079),
    test:assert-true($siglum-080-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-080),
    test:assert-false($siglum-081-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-081),
    test:assert-true($siglum-082-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-082),
    test:assert-true($siglum-083-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-083),
    test:assert-true($siglum-084-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-084),
    test:assert-true($siglum-085-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-085),
    test:assert-true($siglum-086-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-086),
    test:assert-true($siglum-087-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-087),
    test:assert-true($siglum-088-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-088),
    test:assert-true($siglum-089-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-089),
    test:assert-true($siglum-090-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-090),
    test:assert-true($siglum-091-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-091),
    test:assert-true($siglum-092-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-092),
    test:assert-true($siglum-093-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-093),
    test:assert-true($siglum-094-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-094),
    test:assert-true($siglum-095-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-095),
    test:assert-true($siglum-096-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-096),
    test:assert-true($siglum-097-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-097),
    test:assert-true($siglum-098-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-098),
    test:assert-true($siglum-099-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-099),
    test:assert-true($siglum-100-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-100),
    test:assert-true($siglum-101-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-101),
    test:assert-true($siglum-102-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-102),
    test:assert-true($siglum-103-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-103),
    test:assert-true($siglum-104-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-104),
    test:assert-true($siglum-105-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-105),
    test:assert-true($siglum-106-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-106),
    test:assert-true($siglum-107-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-107),
    test:assert-true($siglum-108-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-108),
    test:assert-true($siglum-109-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-109),
    test:assert-true($siglum-110-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-110),
    test:assert-true($siglum-111-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-111),
    test:assert-true($siglum-112-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-112),
    test:assert-true($siglum-113-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-113),
    test:assert-true($siglum-114-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-114),
    test:assert-true($siglum-115-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-115),
    test:assert-true($siglum-116-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-116),
    test:assert-true($siglum-117-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-117),
    test:assert-true($siglum-118-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-118),
    test:assert-true($siglum-119-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-119),
    test:assert-true($siglum-120-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-120),
    test:assert-true($siglum-121-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-121),
    test:assert-true($siglum-122-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-122),
    test:assert-false($siglum-123-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-123),
    test:assert-false($siglum-124-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-124),
    test:assert-false($siglum-125-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-125),
    test:assert-false($siglum-126-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-126),
    test:assert-false($siglum-127-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-127),
    test:assert-false($siglum-128-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-128),
    test:assert-false($siglum-129-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-129),
    test:assert-false($siglum-130-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-130),
    test:assert-false($siglum-131-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-131),
    test:assert-false($siglum-132-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-132),
    test:assert-false($siglum-133-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-133),
    test:assert-false($siglum-134-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-134),
    test:assert-false($siglum-135-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-135),
    test:assert-false($siglum-136-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-136),
    test:assert-false($siglum-137-validation, 'Wrong validation verification for a siglum ' || $SIGLUM-137)
)