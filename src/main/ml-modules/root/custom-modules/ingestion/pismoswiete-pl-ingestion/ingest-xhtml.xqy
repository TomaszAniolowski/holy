xquery version "1.0-ml";

import module namespace utils = "http://marklogic.com/holy/ml-modules/holy-utils" at "/libs/holy-utils.xqy";
import module namespace bc = "http://marklogic.com/holy/ml-modules/bible-constants" at "/constants/bible-constants.xqy";

declare namespace bs = "http://marklogic.com/holy/ml-modules/bible-structure";

declare variable $uris external;         (: An array of one or more URIs being processed. :)
declare variable $content external;      (: An array of objects that represent each document being processed. :)
declare variable $options external;      (: The Options object passed to the step by Data Hub. :)
declare variable $flowName external;     (: The name of the flow being processed. :)
declare variable $stepNumber external;   (: The index of the step within the flow being processed. The stepNumber of the first step is 1. :)
declare variable $step external;         (: The step definition object. :)
declare variable $database external;     (: The target database. :)

let $sessiond-id := map:get($options)

let $urls :=
    for $tome in $bc:BIBLE-STRUCTURE/bs:bible//bs:tome
    let $siglum := tome/bs:siglum/xs:string(.)
    let $first-chapter := tome/bs:first-chapter/xs:string(.)
    let $last-chapter := tome/bs:last-chapter/xs:string(.)
    let $urls := (
        if ($siglum eq $bc:SIGLUM-SYR) then fn:concat("https://pismoswiete.pl/api/tome/", $siglum, "/chapter/", $first-chapter) else (),
        for $number in (1 to $last-chapter)
        return fn:concat("https://pismoswiete.pl/api/tome/", $siglum, "/chapter/", $number)
    )

let $resp := xdmp:http-get("https://pismoswiete.pl/api/tome/Kpł/chapter/1",
        <options xmlns="xdmp:http">
            <headers>
                <Cookie>PHPSESSID=ef3691c9aadd55d4ac98c210f3899ae5</Cookie>
            </headers>
            <verify-cert>false</verify-cert>
        </options>
)[2]
let $resp := xdmp:from-json($resp)

let $html := map:get($resp, "data") => map:get("chapter") => map:get("content")
let $body := xdmp:tidy($html)[2]/html:html/html:body
for $w in $body/html:sup[@class = 'werset-number']
let $num := $w/xs:string(.)
let $verse := $w/following-sibling::html:span[1]/xs:string(.)
return fn:concat($num, ". ", $verse)