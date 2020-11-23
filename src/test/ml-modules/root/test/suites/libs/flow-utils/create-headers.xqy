xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace flow = "http://marklogic.com/holy/ml-modules/flow-utils" at "/libs/flow-utils.xqy";

declare namespace es = 'http://marklogic.com/entity-services';

declare variable $SOURCE-URIS  as xs:string* := (
    '/tome/Rdz/chapter/1.xml',
    '/tome/Rdz/chapter/2.xml',
    '/tome/Kpł/chapter/1.xml',
    '/tome/Kpł/chapter/2.xml'
);

declare variable $OPTIONS-XML as map:map :=
    map:map()
    => map:with('dataFormat', 'xml');

declare variable $OPTIONS-JSON as map:map :=
    map:map()
    => map:with('dataFormat', 'json');

let $actual-xml-headers := flow:create-headers($SOURCE-URIS, $OPTIONS-XML)
let $actual-xml-source-uri-1 := $actual-xml-headers/es:sourceUris/child::node()[1]/xs:string(.)
let $actual-xml-source-uri-2 := $actual-xml-headers/es:sourceUris/child::node()[2]/xs:string(.)
let $actual-xml-source-uri-3 := $actual-xml-headers/es:sourceUris/child::node()[3]/xs:string(.)
let $actual-xml-source-uri-4 := $actual-xml-headers/es:sourceUris/child::node()[4]/xs:string(.)

let $actual-json-headers := flow:create-headers($SOURCE-URIS, $OPTIONS-JSON)
let $actual-json-source-uri-1 := $actual-json-headers/sourceUris[1]/fn:string(.)
let $actual-json-source-uri-2 := $actual-json-headers/sourceUris[2]/fn:string(.)
let $actual-json-source-uri-3 := $actual-json-headers/sourceUris[3]/fn:string(.)
let $actual-json-source-uri-4 := $actual-json-headers/sourceUris[4]/fn:string(.)

return (
    (:    XML HEADERS TEST CASES    :)
    test:assert-equal('element', xdmp:node-kind($actual-xml-headers), 'Incorrect node kind for xml headers'),
    test:assert-equal('element', xdmp:node-kind($actual-xml-headers/es:createdOn), 'Incorrect node kind for createdOn element'),
    test:assert-equal('element', xdmp:node-kind($actual-xml-headers/es:sourceUris), 'Incorrect node kind for sourceUris element'),
    test:assert-equal(2, fn:count($actual-xml-headers/child::node()), 'Incorrect number of child nodes for es:headers element'),
    test:assert-equal(1, fn:count($actual-xml-headers/es:createdOn/child::node()), 'Incorrect number of child nodes for es:createdOn element'),
    test:assert-equal(4, fn:count($actual-xml-headers/es:sourceUris/child::node()), 'Incorrect number of child nodes for es:sourceUris element'),
    test:assert-equal(fn:current-dateTime(), $actual-xml-headers/es:createdOn/xs:dateTime(.), 'Incorrect date time in es:createdOn element'),
    test:assert-equal('/tome/Rdz/chapter/1.xml', $actual-xml-source-uri-1, 'Difference in first xml source uri (actual: ' || $actual-xml-source-uri-1 || ')'),
    test:assert-equal('/tome/Rdz/chapter/2.xml', $actual-xml-source-uri-2, 'Difference in second xml source uri (actual: ' || $actual-xml-source-uri-2 || ')'),
    test:assert-equal('/tome/Kpł/chapter/1.xml', $actual-xml-source-uri-3, 'Difference in third xml source uri (actual: ' || $actual-xml-source-uri-3 || ')'),
    test:assert-equal('/tome/Kpł/chapter/2.xml', $actual-xml-source-uri-4, 'Difference in fourth xml source uri (actual: ' || $actual-xml-source-uri-4 || ')'),

    (:    JSON HEADERS TEST CASES    :)
    test:assert-equal('object', xdmp:node-kind($actual-json-headers), 'Incorrect node kind for json headers'),
    test:assert-equal('text', xdmp:node-kind($actual-json-headers/child::node()[1]), 'Incorrect node kind for createdOn node'),
    test:assert-equal('array', xdmp:node-kind($actual-json-headers/child::node()[2]), 'Incorrect node kind for sourceUris node'),
    test:assert-equal(2, fn:count($actual-json-headers/child::node()), 'Incorrect number of child nodes for headers object node'),
    test:assert-equal(0, fn:count($actual-json-headers/child::node()[1]/child::node()), 'Incorrect number of child nodes for createdOn node'),
    test:assert-equal(4, fn:count($actual-json-headers/child::node()[2]/child::node()), 'Incorrect number of child nodes for sourceUris node'),
    test:assert-equal(fn:current-dateTime(), $actual-json-headers/createdOn/xs:dateTime(.), 'Incorrect date time in createdOn node'),
    test:assert-equal('/tome/Rdz/chapter/1.xml', $actual-json-source-uri-1, 'Difference in first json source uri (actual: ' || $actual-json-source-uri-1 || ')'),
    test:assert-equal('/tome/Rdz/chapter/2.xml', $actual-json-source-uri-2, 'Difference in second json source uri (actual: ' || $actual-json-source-uri-2 || ')'),
    test:assert-equal('/tome/Kpł/chapter/1.xml', $actual-json-source-uri-3, 'Difference in third json source uri (actual: ' || $actual-json-source-uri-3 || ')'),
    test:assert-equal('/tome/Kpł/chapter/2.xml', $actual-json-source-uri-4, 'Difference in fourth json source uri (actual: ' || $actual-json-source-uri-4 || ')')
)
