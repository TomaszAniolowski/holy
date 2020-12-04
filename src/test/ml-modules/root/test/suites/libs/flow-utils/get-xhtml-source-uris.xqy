xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace flow = "http://marklogic.com/holy/ml-modules/flow-utils" at "/libs/flow-utils.xqy";
import module namespace bc = "http://marklogic.com/holy/ml-modules/bible-constants" at "/constants/bible-constants.xqy";
import module namespace fc = "http://marklogic.com/holy/ml-modules/flow-constants" at "/constants/flow-constants.xqy";

declare namespace bs = "http://marklogic.com/holy/ml-modules/bible-structure";

let $expected-uris :=
    for $tome in $bc:BIBLE-STRUCTURE/bs:bible/bs:testament/bs:tome
    let $siglum := $tome/bs:siglum/xs:string(.)
    let $has-prolog := $tome/bs:first-chapter/xs:string(.) eq 'Prolog'
    let $last-chapter := $tome/bs:last-chapter/xs:int(.)
    let $range := 1 to $last-chapter
    return (
        if($has-prolog) then fn:concat($fc:XHTML-DATA-BASE-URI, $siglum, '/chapter/Prolog/', $fc:CURRENT-XHTML-CONTENT-VERSION, '.xml') else (),
        $range ! fn:concat($fc:XHTML-DATA-BASE-URI, $siglum, '/chapter/', ., '/', $fc:CURRENT-XHTML-CONTENT-VERSION, '.xml')
    )
let $actual-uris := flow:get-xhtml-source-uris()
return (
    test:assert-equal(fn:count($expected-uris), fn:count($actual-uris), 'Different uris count'),
    $expected-uris ! test:assert-true($actual-uris eq ., 'Uri ' || . || ' was not collected by flow:get-xhtml-source-uris() function')
)