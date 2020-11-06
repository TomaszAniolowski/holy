xquery version "1.0-ml";

module namespace bib = "http://marklogic.com/holy/ml-modules/bible-utils";

import module namespace bc = "http://marklogic.com/holy/ml-modules/bible-constants" at "/constants/bible-constants.xqy";

declare namespace bs = "http://marklogic.com/holy/ml-modules/bible-structure";

declare function bib:retrieve-testament(
    $tome-siglum as xs:string
) as xs:string
{
    let $bs-tst-name := $bc:BIBLE-STRUCTURE/bs:bible/child::node()[bs:tome/bs:siglum = $tome-siglum] => fn:local-name()
    return
        if ($bs-tst-name = 'old-testament')
        then $bc:OLD-TESTAMENT
        else $bc:NEW-TESTAMENT
};

declare function bib:retrieve-tome-name(
        $tome-siglum as xs:string
) as xs:string
{
    $bc:BIBLE-STRUCTURE/bs:bible/child::node()/bs:tome[bs:siglum = $tome-siglum]/bs:name/xs:string(.)
};

declare function bib:retrieve-first-chapter(
        $tome-siglum as xs:string
) as xs:string
{
    $bc:BIBLE-STRUCTURE/bs:bible/child::node()/bs:tome[bs:siglum = $tome-siglum]/bs:first-chapter/xs:string(.)
};

declare function bib:retrieve-last-chapter(
        $tome-siglum as xs:string
) as xs:string
{
    $bc:BIBLE-STRUCTURE/bs:bible/child::node()/bs:tome[bs:siglum = $tome-siglum]/bs:last-chapter/xs:string(.)
};