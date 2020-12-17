xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace http-utils = 'http://marklogic.com/holy/ml-modules/http-utils' at '/libs/http-utils.xqy';
import module namespace hhc = "http://marklogic.com/holy/ml-modules/holy-hub-constants" at "/constants/holy-hub-constants.xqy";

declare variable $PARAMS-CORRECT-1 as map:map := map:new(map:entry('rs:siglum', 'Rdz_1,1'));
declare variable $PARAMS-CORRECT-2 as map:map := map:new(map:entry('rs:siglum', 'Rdz_50,26'));
declare variable $PARAMS-CORRECT-3 as map:map := map:new(map:entry('rs:siglum', 'Iz_1,4'));
declare variable $PARAMS-NO-REF-1 as map:map := map:new(map:entry('rs:siglum', 'Rdz_1,32'));
declare variable $PARAMS-NO-REF-2 as map:map := map:new(map:entry('rs:siglum', 'Rdz_51,1'));
declare variable $PARAMS-NO-REF-3 as map:map := map:new(map:entry('rs:siglum', '1Rdz_1,1'));
declare variable $PARAMS-INCORRECT-SIGLUM as map:map := map:new(map:entry('rs:siglum', 'aaaaa'));
declare variable $PARAMS-NO-SIGLUM as map:map := map:new();

let $expected-response-correct-1-body := test:get-test-file('single-verse-Rdz-1-1.json', 'json')
let $expected-response-correct-2-body := test:get-test-file('single-verse-Rdz-50-26.json', 'json')
let $expected-response-correct-3-body := test:get-test-file('single-verse-Iz-1-4.json', 'json')
let $expected-response-no-ref-1-body := test:get-test-file('single-verse-Rdz-1-32.json', 'json')
let $expected-response-no-ref-2-body := test:get-test-file('single-verse-Rdz-51-1.json', 'json')
let $expected-response-no-ref-3-body := test:get-test-file('single-verse-1Rdz-1-1.json', 'json')
let $expected-response-incorrect-siglum-body := test:get-test-file('single-verse-aaaaa.json', 'json')
let $expected-response-no-siglum-body := test:get-test-file('single-verse-no-siglum.json', 'json')

let $response-correct-1 := http-utils:ml-resource-get($hhc:RESOURCES-GET-VERSES, $PARAMS-CORRECT-1)
let $response-correct-2 := http-utils:ml-resource-get($hhc:RESOURCES-GET-VERSES, $PARAMS-CORRECT-2)
let $response-correct-3 := http-utils:ml-resource-get($hhc:RESOURCES-GET-VERSES, $PARAMS-CORRECT-3)
let $response-no-ref-1 := http-utils:ml-resource-get($hhc:RESOURCES-GET-VERSES, $PARAMS-NO-REF-1)
let $response-no-ref-2 := http-utils:ml-resource-get($hhc:RESOURCES-GET-VERSES, $PARAMS-NO-REF-2)
let $response-no-ref-3 := http-utils:ml-resource-get($hhc:RESOURCES-GET-VERSES, $PARAMS-NO-REF-3)
let $response-incorrect-siglum := http-utils:ml-resource-get($hhc:RESOURCES-GET-VERSES, $PARAMS-INCORRECT-SIGLUM)
let $response-no-siglum := http-utils:ml-resource-get($hhc:RESOURCES-GET-VERSES, $PARAMS-NO-SIGLUM)

let $response-correct-1-code := http-utils:get-code($response-correct-1)
let $response-correct-2-code := http-utils:get-code($response-correct-2)
let $response-correct-3-code := http-utils:get-code($response-correct-3)
let $response-no-ref-1-code := http-utils:get-code($response-no-ref-1)
let $response-no-ref-2-code := http-utils:get-code($response-no-ref-2)
let $response-no-ref-3-code := http-utils:get-code($response-no-ref-3)
let $response-incorrect-siglum-code := http-utils:get-code($response-incorrect-siglum)
let $response-no-siglum-code := http-utils:get-code($response-no-siglum)

let $response-correct-1-message := http-utils:get-message($response-correct-1)
let $response-correct-2-message := http-utils:get-message($response-correct-2)
let $response-correct-3-message := http-utils:get-message($response-correct-3)
let $response-no-ref-1-message := http-utils:get-message($response-no-ref-1)
let $response-no-ref-2-message := http-utils:get-message($response-no-ref-2)
let $response-no-ref-3-message := http-utils:get-message($response-no-ref-3)
let $response-incorrect-siglum-message := http-utils:get-message($response-incorrect-siglum)
let $response-no-siglum-message := http-utils:get-message($response-no-siglum)

let $actual-response-correct-1-body := http-utils:get-body($response-correct-1)
let $actual-response-correct-2-body := http-utils:get-body($response-correct-2)
let $actual-response-correct-3-body := http-utils:get-body($response-correct-3)
let $actual-response-no-ref-1-body := http-utils:get-body($response-no-ref-1)
let $actual-response-no-ref-2-body := http-utils:get-body($response-no-ref-2)
let $actual-response-no-ref-3-body := http-utils:get-body($response-no-ref-3)
let $actual-response-incorrect-siglum-body := http-utils:get-body($response-incorrect-siglum)
let $actual-response-no-siglum-body := http-utils:get-body($response-no-siglum)

return (
    test:assert-equal(200, $response-correct-1-code, 'Incorrect response code for rs:sigla=Rdz_1,1'),
    test:assert-equal(200, $response-correct-2-code, 'Incorrect response code for rs:sigla=Rdz_50,26'),
    test:assert-equal(200, $response-correct-3-code, 'Incorrect response code for rs:sigla=Iz_1,4'),
    test:assert-equal(404, $response-no-ref-1-code, 'Incorrect response code for rs:sigla=Rdz_1,32'),
    test:assert-equal(404, $response-no-ref-2-code, 'Incorrect response code for rs:sigla=Rdz_51,1'),
    test:assert-equal(400, $response-no-ref-3-code, 'Incorrect response code for rs:sigla=1Rdz_1,1'),
    test:assert-equal(400, $response-incorrect-siglum-code, 'Incorrect response code for rs:sigla=aaaaa'),
    test:assert-equal(400, $response-no-siglum-code, 'Incorrect response code for no siglum'),

    test:assert-equal('OK', $response-correct-1-message, 'Incorrect response message for rs:sigla=Rdz_1,1'),
    test:assert-equal('OK', $response-correct-2-message, 'Incorrect response message for rs:sigla=Rdz_50,26'),
    test:assert-equal('OK', $response-correct-3-message, 'Incorrect response message for rs:sigla=Iz_1,4'),
    test:assert-equal('Not Found', $response-no-ref-1-message, 'Incorrect response message for rs:sigla=Rdz_1,32'),
    test:assert-equal('Not Found', $response-no-ref-2-message, 'Incorrect response message for rs:sigla=Rdz_51,1'),
    test:assert-equal('Bad Request', $response-no-ref-3-message, 'Incorrect response message for rs:sigla=1Rdz_1,1'),
    test:assert-equal('Bad Request', $response-incorrect-siglum-message, 'Incorrect response message for rs:sigla=aaaaa'),
    test:assert-equal('Bad Request', $response-no-siglum-message, 'Incorrect response message for no siglum'),

    test:assert-equal-json($expected-response-correct-1-body, $actual-response-correct-1-body, 'Different response bodies for rs:siglum=Rdz_1,1'),
    test:assert-equal-json($expected-response-correct-2-body, $actual-response-correct-2-body, 'Different response bodies for rs:siglum=Rdz_50,26'),
    test:assert-equal-json($expected-response-correct-3-body, $actual-response-correct-3-body, 'Different response bodies for rs:siglum=Iz_1,4'),
    test:assert-equal-json($expected-response-no-ref-1-body, $actual-response-no-ref-1-body, 'Different response bodies for rs:siglum=Rdz_1,32'),
    test:assert-equal-json($expected-response-no-ref-2-body, $actual-response-no-ref-2-body, 'Different response bodies for rs:siglum=Rdz_51,1'),
    test:assert-equal-json($expected-response-no-ref-3-body, $actual-response-no-ref-3-body, 'Different response bodies for rs:siglum=1Rdz_1,1'),
    test:assert-equal-json($expected-response-incorrect-siglum-body, $actual-response-incorrect-siglum-body, 'Different response bodies for rs:siglum=aaaaa'),
    test:assert-equal-json($expected-response-no-siglum-body, $actual-response-no-siglum-body, 'Different response bodies for no siglum')
)