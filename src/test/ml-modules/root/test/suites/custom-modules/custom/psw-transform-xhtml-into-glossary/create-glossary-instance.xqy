xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace custom = "http://marklogic.com/data-hub/custom" at '/custom-modules/custom/psw-transform-xhtml-into-glossary/lib.xqy';
import module namespace json = "http://marklogic.com/xdmp/json" at "/MarkLogic/json/json.xqy";
import module namespace flow = "http://marklogic.com/holy/ml-modules/flow-utils" at "/libs/flow-utils.xqy";
import module namespace fc = "http://marklogic.com/holy/ml-modules/flow-constants" at "/constants/flow-constants.xqy";

let $glossary-1 := custom:create-glossary-instance(1)
let $glossary-2 := custom:create-glossary-instance(2)

(:let $model := json:object():)
(:=> map:with($fc:DHF-TYPE, $fc:SUPPLEMENT-ENTITY):)
(:=> map:with($fc:DHF-VERSION, $fc:SUPPLEMENT-VERSION):)
(:=> map:with($fc:DHF-NS, $fc:SUPPLEMENT-NS-URI):)
(:=> map:with($fc:DHF-NS-PREFIX, $fc:SUPPLEMENT-NS-PREFIX):)
(:=> map:with($fc:ID, $definition-unique-id):)
(:=> map:with($fc:TYPE, $fc:DEFINITION):)
(:=> map:with($fc:CONTENT, $content):)
(:=> es:optional($fc:DEFINIENDUM, $definiendum):)
(:=> es:optional($fc:DEFINIENS, $definiens):)

let $from := 1
let $to := 10
let $dictionary := json:array-values(map:get($glossary-1, $fc:DICTIONARY))[$from to $to]
let $definition := json:array-values(map:get($glossary-2, $fc:DEFINITIONS))[$from to $to]

return (
    ($glossary-1, $glossary-2) ! (
        test:assert-equal($fc:GLOSSARY-ENTITY, map:get(., $fc:DHF-TYPE), 'Wrong glossary entity type name.'),
        test:assert-equal($fc:GLOSSARY-VERSION, map:get(., $fc:DHF-VERSION), 'Wrong glossary entity version.'),
        test:assert-equal($fc:GLOSSARY-NS-URI, map:get(., $fc:DHF-NS), 'Wrong glossary entity namespace uri.'),
        test:assert-equal($fc:GLOSSARY-NS-PREFIX, map:get(., $fc:DHF-NS-PREFIX), 'Wrong glossary entity namespace prefix.')
    ),
    test:assert-not-exists(map:get($glossary-1, $fc:DEFINITIONS), 'There should be no definitions.'),
    test:assert-exists(map:get($glossary-1, $fc:DICTIONARY), 'There should be dictionary.'),
    test:assert-not-exists(map:get($glossary-2, $fc:DICTIONARY), 'There should be no dictionaries.'),
    test:assert-exists(map:get($glossary-2, $fc:DEFINITIONS), 'There should be definitions.'),

    for $i in ($from to $to)
    return (
        test:assert-equal($fc:DICTIONARY, map:get($dictionary[$i], $fc:TYPE), 'Wrong supplement type in dictionary.'),
        test:assert-equal($fc:DEFINITION, map:get($definition[$i], $fc:TYPE), 'Wrong supplement type in definition.'),

        ($dictionary[$i], $definition[$i]) ! (
            test:assert-equal($fc:SUPPLEMENT-ENTITY, map:get(., $fc:DHF-TYPE), 'Wrong supplement entity type name.'),
            test:assert-equal($fc:SUPPLEMENT-VERSION, map:get(., $fc:DHF-VERSION), 'Wrong supplement entity version.'),
            test:assert-equal($fc:SUPPLEMENT-NS-URI, map:get(., $fc:DHF-NS), 'Wrong supplement entity namespace uri.'),
            test:assert-equal($fc:SUPPLEMENT-NS-PREFIX, map:get(., $fc:DHF-NS-PREFIX), 'Wrong supplement entity namespace prefix.'),
            test:assert-exists(map:get(., $fc:CONTENT), map:get(., $fc:TYPE) || ' should contain a content.'),
            test:assert-equal(map:get(., $fc:CONTENT) => flow:generate-unique-id(), map:get(., $fc:ID), map:get(., $fc:TYPE) || ' ID must be equal md5 of the lower-cased content without spaces.')
        ),

        ($dictionary[$i], $definition[$i])[fn:exists(map:get(., $fc:DEFINIENDUM))] ! (
            test:assert-exists(map:get(., $fc:DEFINIENS), 'Every ' || map:get(., $fc:TYPE) || ' that contains definiendum must contain definiens also.'),
            test:assert-true(map:get(., $fc:CONTENT) => fn:contains(map:get(., $fc:DEFINIENDUM)), 'Supplement content must contain a definiendum value.')
        ),

        ($dictionary[$i], $definition[$i])[fn:exists(map:get(., $fc:DEFINIENS))] ! (
            test:assert-exists(map:get(., $fc:DEFINIENDUM), 'Every ' || map:get(., $fc:TYPE) || ' that contains definiens must contain definiendum also.'),
            test:assert-true(map:get(., $fc:CONTENT) => fn:contains(map:get(., $fc:DEFINIENS)), 'Supplement content must contain a definiens value.')
        )
    )
)