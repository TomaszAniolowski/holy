xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace custom = "http://marklogic.com/data-hub/custom" at '/custom-modules/custom/psw-transform-xhtml-into-chapter/lib.xqy';
import module namespace json = "http://marklogic.com/xdmp/json" at "/MarkLogic/json/json.xqy";
import module namespace fc = "http://marklogic.com/holy/ml-modules/flow-constants" at "/constants/flow-constants.xqy";

declare variable $SOURCE-URI as xs:string := '/tome/Ne/chapter/11/v1.xml';
declare variable $SOURCE-DOC as document-node() := test:get-test-file('Ne-11-v1.xml', 'xml');
declare variable $EXPECTED-CARD-NUM-MAP := map:new((
    map:entry('1', '1'), map:entry('2', '2'), map:entry('3b', '3'), map:entry('4a', '4'), map:entry('3a', '5'),
    map:entry('4b', '6'), map:entry('5', '7'), map:entry('6', '8'), map:entry('7', '9'), map:entry('8', '10'),
    map:entry('9', '11'), map:entry('10', '12'), map:entry('11', '13'), map:entry('12', '14'), map:entry('13', '15'),
    map:entry('14', '16'), map:entry('15', '17'), map:entry('16', '18'), map:entry('17', '19'), map:entry('18', '20'),
    map:entry('19', '21'), map:entry('20', '22'), map:entry('21', '23'), map:entry('22', '24'), map:entry('23', '25'),
    map:entry('24', '26'), map:entry('25', '27'), map:entry('26', '28'), map:entry('27', '29'), map:entry('28', '30'),
    map:entry('29', '31'), map:entry('30', '32'), map:entry('31', '33'), map:entry('32', '34'), map:entry('33', '35'),
    map:entry('34', '36'), map:entry('35', '37'), map:entry('36', '38')
));

let $chapter := custom:create-chapter-instance($SOURCE-URI, $SOURCE-DOC)
let $actual-verses := json:array-values(map:get($chapter, $fc:VERSES))

for $actual-verse in $actual-verses
let $actual-verse-number := map:get($actual-verse, $fc:NUMBER)
let $actual-verse-card-num := map:get($actual-verse, $fc:CARD-NUMBER)
let $expected-card-num := map:get($EXPECTED-CARD-NUM-MAP, $actual-verse-number)
return test:assert-equal($expected-card-num, $actual-verse-card-num, 'Wrong card-number assigned for verse with number ' || $actual-verse-number)