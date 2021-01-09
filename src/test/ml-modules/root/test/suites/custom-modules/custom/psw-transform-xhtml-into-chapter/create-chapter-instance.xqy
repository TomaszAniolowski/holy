xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace custom = "http://marklogic.com/data-hub/custom" at '/custom-modules/custom/psw-transform-xhtml-into-chapter/lib.xqy';
import module namespace json = "http://marklogic.com/xdmp/json" at "/MarkLogic/json/json.xqy";
import module namespace flow = "http://marklogic.com/holy/ml-modules/flow-utils" at "/libs/flow-utils.xqy";
import module namespace bc = "http://marklogic.com/holy/ml-modules/bible-constants" at "/constants/bible-constants.xqy";
import module namespace fc = "http://marklogic.com/holy/ml-modules/flow-constants" at "/constants/flow-constants.xqy";

declare variable $SOURCE-URI as xs:string := '/tome/Iz/chapter/10/v1.xml';
declare variable $SOURCE-DOC as document-node() := test:get-test-file('Iz-10-v1.xml', 'xml');
declare variable $TESTAMENT as xs:string := $bc:OLD-TESTAMENT;
declare variable $TOME-SIGLUM as xs:string := $bc:SIGLUM-IZ;
declare variable $CHAPTER-NUM as xs:string := '10';
declare variable $DICTIONARY-94-CONTENT := 'GNIEW BOŻY– zwrot wskazujący na to, że Bóg, będąc doskonale sprawiedliwy i święty, odrzuca wszystko, co sprzeciwia się świętości. Autorzy biblijni, opowiadając różne wydarzenia, używają zwrotu gniew Boga, aby uzmysłowić ludziom, jak wielkim złem jest grzech i nieposłuszeństwo wobec Bożego prawa. Zwrot ten ukazuje więc nie tyle dosłowną reakcję Boga na ludzkie działanie, ile ma być bodźcem do opamiętania się człowieka. W tym kontekście gniewu Boga nie można porównywać do ludzkiej reakcji gniewu, w której człowiek pod wpływem doznanego zła lub krzywdy przeżywa wzburzenie, a nawet pojawia się w nim chęć odwetu lub zemsty. Już w ST, w równym stopniu co gniew Boga, podkreślone jest Jego miłosierdzie (np. Ps 103,8nn). Idea ta jest także wyraźnie obecna w NT. Jezus, spotykając się z zatwardziałością ludzi, okazywał wzburzenie i gniew, które miały prowadzić do opamiętania się grzeszników (np. Mk 3,5; J 2,13-17). Istotą misji Jezusa było jednak bezgraniczne miłosierdzie, w którym wyraziła się miłość Boga do całego stworzenia (np. J 3,16; 12,47). Gniew Boży, szczególnie w nauczaniu Pawła Apostoła, odnosi się do końca czasów, kiedy Bóg sprawiedliwie osądzi każdego człowieka. Apostoł przestrzega, że nieposłuszeństwo Bogu ściąga na człowieka Jego gniew (np. Rz 1,18). Nadzieja ludzka polega na tym, że mocniejsza od Bożego gniewu jest Jego miłość, gdyż On sam jest miłością (1J 4,8). Rola Jezusa polega na wzięciu gniewu Bożego na siebie (np. Kol 1,20; 2,14), dlatego obawiać się gniewu Boga mogą jedynie ci, którzy nie chcą uwierzyć w Chrystusa i odrzucają Jego miłość. Zob. KARA BOŻA.';
declare variable $DEFINITION-6376-CONTENT := 'Kalno – w kronikach asyryjskich Kullania, prawdopodobnie miasto w północnej Syrii, na wschód od Antiochii, podbite przez Asyrię w 738 r. przed Chr.';
declare variable $DEFINITION-6377-CONTENT := 'Karkemisz – dawna stolica Chetytów, na prawym brzegu górnego Eufratu, ujarzmiona przez Tiglat-Pilesera, a zniszczona przez Sargona II w 717 r. przed Chr.';
declare variable $DICTIONARY-176-CONTENT := 'SAMARIA, SAMARYTANIE– miasto oraz górzysty region w środkowej Palestynie, który bierze swoją nazwę od miasta Samaria, wzniesionego w IX w. przed Chr. przez króla Omriego, który uczynił z niej stolicę Królestwa Północnego (Izraela). Miało ono duże znaczenie strategiczne, ponieważ było usytuowane na wysokim wzgórzu, z dala od głównych dróg i umożliwiało łatwy dostęp do Jerozolimy, Megiddo, dolin Jezreel i Jordanu, a także do doliny nadmorskiej. Samaria pozostała stolicą Królestwa Północnego do końca jego istnienia, czyli do roku 722 przed Chr., kiedy to zostało zdobyte przez Asyryjczyków. Pojawiło się tam wówczas wielu kolonistów mezopotamskich, którzy wymieszali się z rdzenną ludnością żydowską, tworząc specyficzną społeczność etniczną. Do ostrego konfliktu między Samarytanami a Żydami doszło po powrocie z przesiedlenia babilońskiego, kiedy Żydzi odrzucili ofertę pomocy Samarytan przy odbudowie świątyni. Powodem tej odmowy był fakt, że Samarytanie, z racji mocnych wpływów pogańskich, uważani byli przez Żydów za nieczystych. Wybudowali więc własne centrum kultu ze świątynią na górze Garizim i w ten sposób utworzyli odrębną społeczność religijną. Mimo wspólnego dziedzictwa historycznego Żydzi uważali ich za pogan, a ich kult za niezgodny z prawem. Samarytanie przestrzegali dokładnie Prawa Mojżeszowego, zachowywali ścisły monoteizm, ale za księgi święte uważali tylko Pięcioksiąg, odrzucając późniejszą tradycję żydowską, którą uznali za heretycką. W czasach NT miasto Samaria zostało odbudowane przez Heroda Wielkiego i na cześć cesarza Augusta nazwano je Sebaste. Jezus kilkakrotnie przemierzał okolicę Samarii (np. Łk 17,11; J 4,5.39). Na tych terenach Ewangelię głosili Filip, Piotr i Jan (Dz 8,1-25). Zob. IZRAEL.';
declare variable $DEFINITION-6380-CONTENT := 'Damaszek – stolica Syrii.';

let $chapter := custom:create-chapter-instance($SOURCE-URI, $SOURCE-DOC)

let $expected-id := fn:concat($TESTAMENT, $TOME-SIGLUM, $CHAPTER-NUM) => flow:generate-unique-id()
let $expected-verses-count := 116
let $expected-verses-last-siglum := 34
let $expected-verse-4-III-id := fn:concat($TESTAMENT, $TOME-SIGLUM, $CHAPTER-NUM, '4', 'III') => flow:generate-unique-id()
let $expected-verse-8-II-id := fn:concat($TESTAMENT, $TOME-SIGLUM, $CHAPTER-NUM, '8', 'II') => flow:generate-unique-id()
let $expected-verse-9-I-id := fn:concat($TESTAMENT, $TOME-SIGLUM, $CHAPTER-NUM, '9', 'I') => flow:generate-unique-id()
let $expected-verse-9-III-id := fn:concat($TESTAMENT, $TOME-SIGLUM, $CHAPTER-NUM, '9', 'III') => flow:generate-unique-id()
let $expected-verse-4-III-supp-id := flow:generate-unique-id($DICTIONARY-94-CONTENT)
let $expected-verse-9-I-supp-id-1 := flow:generate-unique-id($DEFINITION-6376-CONTENT)
let $expected-verse-9-I-supp-id-2 := flow:generate-unique-id($DEFINITION-6377-CONTENT)
let $expected-verse-9-III-supp-id-1 := flow:generate-unique-id($DICTIONARY-176-CONTENT)
let $expected-verse-9-III-supp-id-2 := flow:generate-unique-id($DEFINITION-6380-CONTENT)

let $actual-verses := json:array-values(map:get($chapter, $fc:VERSES))
let $actual-verses-count := fn:count($actual-verses)
let $actual-verses-last-siglum := fn:max($actual-verses ! map:get(., $fc:NUMBER) => xs:int())
let $actual-verse-4-III := $actual-verses[map:get(., $fc:NUMBER) eq '4' and map:get(., $fc:SUB-NUMBER) eq 'III']
let $actual-verse-8-II := $actual-verses[map:get(., $fc:NUMBER) eq '8' and map:get(., $fc:SUB-NUMBER) eq 'II']
let $actual-verse-9-I := $actual-verses[map:get(., $fc:NUMBER) eq '9' and map:get(., $fc:SUB-NUMBER) eq 'I']
let $actual-verse-9-III := $actual-verses[map:get(., $fc:NUMBER) eq '9' and map:get(., $fc:SUB-NUMBER) eq 'III']
let $actual-verse-4-III-definitions := json:array-values(map:get($actual-verse-4-III, $fc:DEFINITIONS))
let $actual-verse-4-III-dictionary := json:array-values(map:get($actual-verse-4-III, $fc:DICTIONARY))
let $actual-verse-8-II-definitions := json:array-values(map:get($actual-verse-8-II, $fc:DEFINITIONS))
let $actual-verse-8-II-dictionary := json:array-values(map:get($actual-verse-8-II, $fc:DICTIONARY))
let $actual-verse-9-I-definitions := json:array-values(map:get($actual-verse-9-I, $fc:DEFINITIONS))
let $actual-verse-9-I-dictionary := json:array-values(map:get($actual-verse-9-I, $fc:DICTIONARY))
let $actual-verse-9-III-definitions := json:array-values(map:get($actual-verse-9-III, $fc:DEFINITIONS))
let $actual-verse-9-III-dictionary := json:array-values(map:get($actual-verse-9-III, $fc:DICTIONARY))

return (
    (: CHAPTER TESTS :)
    test:assert-equal($fc:CHAPTER-ENTITY, map:get($chapter, $fc:DHF-TYPE), 'Wrong chapter entity type name.'),
    test:assert-equal($fc:CHAPTER-VERSION, map:get($chapter, $fc:DHF-VERSION), 'Wrong chapter entity version.'),
    test:assert-equal($fc:CHAPTER-NS-URI, map:get($chapter, $fc:DHF-NS), 'Wrong chapter entity namespace uri.'),
    test:assert-equal($fc:CHAPTER-NS-PREFIX, map:get($chapter, $fc:DHF-NS-PREFIX), 'Wrong chapter entity namespace prefix.'),
    test:assert-equal($expected-id, map:get($chapter, $fc:ID), 'Wrong chapter id.'),
    test:assert-equal($TESTAMENT, map:get($chapter, $fc:TESTAMENT), 'Wrong chapter testament.'),
    test:assert-equal($TOME-SIGLUM, map:get($chapter, $fc:TOME), 'Wrong chapter tome siglum.'),
    test:assert-equal($CHAPTER-NUM, map:get($chapter, $fc:NUMBER), 'Wrong chapter number.'),
    test:assert-equal($expected-verses-count, $actual-verses-count, 'Wrong verses count.'),
    test:assert-equal($expected-verses-last-siglum, $actual-verses-last-siglum, 'Wrong verses last siglum.'),

    (: VERSES GENERAL TESTS :)
    ($actual-verse-4-III, $actual-verse-8-II, $actual-verse-9-I, $actual-verse-9-III) ! (
        test:assert-equal($fc:VERSE-ENTITY, map:get(., $fc:DHF-TYPE), 'Wrong verse entity type name.'),
        test:assert-equal($fc:VERSE-VERSION, map:get(., $fc:DHF-VERSION), 'Wrong verse entity version.'),
        test:assert-equal($fc:VERSE-NS-URI, map:get(., $fc:DHF-NS), 'Wrong verse entity namespace uri.'),
        test:assert-equal($fc:VERSE-NS-PREFIX, map:get(., $fc:DHF-NS-PREFIX), 'Wrong verse entity namespace prefix.'),

        (: CHAPTER REFERENCE TESTS :)
        test:assert-equal($fc:CHAPTER-ENTITY, map:get(., $fc:CHAPTER) => map:get($fc:DHF-TYPE), 'Wrong chapter reference type.'),
        test:assert-equal($expected-id, map:get(., $fc:CHAPTER) => map:get($fc:DHF-REF), 'Wrong chapter reference id.'),
        test:assert-equal($fc:CHAPTER-NS-PREFIX, map:get(., $fc:CHAPTER) => map:get($fc:DHF-NS-PREFIX), 'Wrong chapter reference namespace prefix.'),
        test:assert-equal($fc:CHAPTER-NS-URI, map:get(., $fc:CHAPTER) => map:get($fc:DHF-NS), 'Wrong chapter reference namespace uri.'),

        (: SUPPLEMENT REFERENCES TESTS :)
        (json:array-values(map:get(., $fc:DEFINITIONS)), json:array-values(map:get(., $fc:DICTIONARY))) ! (
            test:assert-equal($fc:SUPPLEMENT-ENTITY, map:get(., $fc:DHF-TYPE), 'Wrong supplement reference type.'),
            test:assert-equal($fc:SUPPLEMENT-NS-PREFIX, map:get(., $fc:DHF-NS-PREFIX), 'Wrong supplement reference namespace prefix.'),
            test:assert-equal($fc:SUPPLEMENT-NS-URI, map:get(., $fc:DHF-NS), 'Wrong supplement reference namespace uri.')
        )
    ),

    (: VERSE 4 III TESTS :)
    test:assert-equal($expected-verse-4-III-id, map:get($actual-verse-4-III, $fc:ID), 'Wrong verse id (Iz 10,4[III]).'),
    test:assert-equal('4', map:get($actual-verse-4-III, $fc:CARD-NUMBER), 'Wrong verse card-number (Iz 10,4[III]).'),
    test:assert-equal('4', map:get($actual-verse-4-III, $fc:NUMBER), 'Wrong verse number (Iz 10,4[III]).'),
    test:assert-equal('III', map:get($actual-verse-4-III, $fc:SUB-NUMBER), 'Wrong verse sub number (Iz 10,4[III]).'),
    test:assert-equal('Mimo to Jego gniew nie ustaje', map:get($actual-verse-4-III, $fc:CONTENT), 'Wrong verse content (Iz 10,4[III])'),
    test:assert-not-exists($actual-verse-4-III-definitions, 'There should be no definitions for verse Iz 10,4[III].'),
    test:assert-equal(1, fn:count($actual-verse-4-III-dictionary), 'There should be only 1 dictionary entry for verse Iz 10,4[III]'),
    test:assert-equal($expected-verse-4-III-supp-id, map:get($actual-verse-4-III-dictionary, $fc:DHF-REF), 'Wrong dictionary id for verse Iz 10,4[III]'),

    (: VERSE 8 II TESTS :)
    test:assert-equal($expected-verse-8-II-id, map:get($actual-verse-8-II, $fc:ID), 'Wrong verse id (Iz 10,8[II]).'),
    test:assert-equal('8', map:get($actual-verse-8-II, $fc:CARD-NUMBER), 'Wrong verse card-number (Iz 10,8[II]).'),
    test:assert-equal('8', map:get($actual-verse-8-II, $fc:NUMBER), 'Wrong verse number (Iz 10,8[II]).'),
    test:assert-equal('II', map:get($actual-verse-8-II, $fc:SUB-NUMBER), 'Wrong verse content (Iz 10,8[II])'),
    test:assert-equal('„Czyż moi wodzowie nie są równi królom?', map:get($actual-verse-8-II, $fc:CONTENT), 'Wrong verse content (Iz 10,8[II])'),
    test:assert-not-exists($actual-verse-8-II-definitions, 'There should be no definitions for verse Iz 10,8[II].'),
    test:assert-not-exists($actual-verse-8-II-dictionary, 'There should be no dictionary for verse Iz 10,8[II].'),

    (: VERSE 9 I TESTS :)
    test:assert-equal($expected-verse-9-I-id, map:get($actual-verse-9-I, $fc:ID), 'Wrong verse id (Iz 10,9[I]).'),
    test:assert-equal('9', map:get($actual-verse-9-I, $fc:CARD-NUMBER), 'Wrong verse card-number (Iz 10,9[I]).'),
    test:assert-equal('9', map:get($actual-verse-9-I, $fc:NUMBER), 'Wrong verse number (Iz 10,9[I]).'),
    test:assert-equal('I', map:get($actual-verse-9-I, $fc:SUB-NUMBER), 'Wrong verse sub number (Iz 10,9[I]).'),
    test:assert-equal('Czyż Kalno nie jest jak Karkemisz,', map:get($actual-verse-9-I, $fc:CONTENT), 'Wrong verse content (Iz 10,9[I])'),
    test:assert-equal(2, fn:count($actual-verse-9-I-definitions), 'There should be 2 definitions for verse Iz 10,9[I]'),
    test:assert-true($expected-verse-9-I-supp-id-1 = ($actual-verse-9-I-definitions ! map:get(., $fc:DHF-REF)), 'Wrong definition 1 id for verse Iz 10,9[I]'),
    test:assert-true($expected-verse-9-I-supp-id-2 = ($actual-verse-9-I-definitions ! map:get(., $fc:DHF-REF)), 'Wrong definition 2 id for verse Iz 10,9[I]'),
    test:assert-not-exists($actual-verse-9-I-dictionary, 'There should be no dictionary for verse Iz 10,9[I].'),

    (: VERSE 9 III TESTS :)
    test:assert-equal($expected-verse-9-III-id, map:get($actual-verse-9-III, $fc:ID), 'Wrong verse id (Iz 10,9[III]).'),
    test:assert-equal('9', map:get($actual-verse-9-III, $fc:CARD-NUMBER), 'Wrong verse card-number (Iz 10,9[III]).'),
    test:assert-equal('9', map:get($actual-verse-9-III, $fc:NUMBER), 'Wrong verse number (Iz 10,9[III]).'),
    test:assert-equal('III', map:get($actual-verse-9-III, $fc:SUB-NUMBER), 'Wrong verse sub number (Iz 10,9[III]).'),
    test:assert-equal('a Samaria do Damaszku?', map:get($actual-verse-9-III, $fc:CONTENT), 'Wrong verse content (Iz 10,9[III])'),
    test:assert-equal(1, fn:count($actual-verse-9-III-definitions), 'There should be only 1 definition for verse Iz 10,9[III]'),
    test:assert-equal($expected-verse-9-III-supp-id-2, map:get($actual-verse-9-III-definitions, $fc:DHF-REF), 'Wrong definition id for verse Iz 10,9[III]'),
    test:assert-equal(1, fn:count($actual-verse-9-III-dictionary), 'There should be only 1 dictionary entry for verse Iz 10,9[III]'),
    test:assert-equal($expected-verse-9-III-supp-id-1, map:get($actual-verse-9-III-dictionary, $fc:DHF-REF), 'Wrong dictionary id for verse Iz 10,9[III]')
)