xquery version "1.0-ml";

(:~
 : The bible-utils.xqy library module contains useful functions
 : that allows you to retrive information directly releted to the bible.
 : It contains e.g. function retrieving tome name basis on the tome siglum
 : or name of the testament that contains specific tome.
 :)
module namespace bib = "http://marklogic.com/holy/ml-modules/bible-utils";

import module namespace bc = "http://marklogic.com/holy/ml-modules/bible-constants" at "/constants/bible-constants.xqy";

declare namespace bs = "http://marklogic.com/holy/ml-modules/bible-structure";

(:~
 : Retrives name of the testament containing the tome provided.
 :
 : @param $tome-siglum - the tome siglum (e.g. 'Jdt')
 :
 : @return the testament name (constant value: 'Old Testament' or 'New Testament')
 :)
declare function bib:retrieve-testament(
        $tome-siglum as xs:string
) as xs:string
{
    $bc:BIBLE-STRUCTURE/bs:bible/bs:testament[bs:tome/bs:siglum = $tome-siglum]/@name/fn:string(.)
};

(:~
 : Retrives the tome name basis on the tome siglum provided.
 :
 : @param $tome-siglum - the tome siglum (e.g. 'Jdt')
 :
 : @return the tome name (e.g. 'Księga Judyty')
 :)
declare function bib:retrieve-tome-name(
        $tome-siglum as xs:string
) as xs:string
{
    $bc:BIBLE-STRUCTURE/bs:bible/bs:testament/bs:tome[bs:siglum = $tome-siglum]/bs:name/xs:string(.)
};

(:~
 : Retrives the first chapter for the tome provided.
 :
 : @param $tome-siglum - the tome siglum (e.g. 'Jdt')
 :
 : @return the string value of the tome first chapter (possible values: '1' or 'Prolog')
 :)
declare function bib:retrieve-first-chapter(
        $tome-siglum as xs:string
) as xs:string
{
    $bc:BIBLE-STRUCTURE/bs:bible/bs:testament/bs:tome[bs:siglum = $tome-siglum]/bs:first-chapter/xs:string(.)
};

(:~
 : Retrives the last chapter for the tome provided
 :
 : @param $tome-siglum - the tome siglum (e.g. 'Jdt')
 :
 : @return the string value of the tome last chapter
 :)
declare function bib:retrieve-last-chapter(
        $tome-siglum as xs:string
) as xs:string
{
    $bc:BIBLE-STRUCTURE/bs:bible/bs:testament/bs:tome[bs:siglum = $tome-siglum]/bs:last-chapter/xs:string(.)
};