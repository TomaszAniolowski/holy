xquery version "1.0-ml";

module namespace bib = "http://marklogic.com/holy/ml-modules/bible-utils";

import module namespace bc = "http://marklogic.com/holy/ml-modules/bible-constants" at "/constants/bible-constants.xqy";

declare namespace bs = "http://marklogic.com/holy/ml-modules/bible-structure";

declare function bib:determine-testament(
    $tome-siglum as xs:string
) as xs:string
{
    let $bs-tst-name := $bc:BIBLE-STRUCTURE/bs:bible/child::node()[bs:tome/bs:siglum = $tome-siglum] => fn:local-name()
    return
        if ($bs-tst-name = 'old-testament')
        then $bc:OLD-TESTAMENT
        else $bc:NEW-TESTAMENT
};