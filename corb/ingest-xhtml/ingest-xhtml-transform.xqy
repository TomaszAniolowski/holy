xquery version "1.0-ml";

import module namespace hmc = "http://marklogic.com/holy/ml-modules/holy-management-constants" at "/constants/holy-management-constants.xqy";

declare namespace xhtml = "http://www.w3.org/1999/xhtml";
declare namespace ins = "xdmp:document-insert";

declare variable $URI external;
declare variable $SESSION-ID external;

declare variable $doc-options as element(ins:options) :=
    <options xmlns="xdmp:document-insert">
        <permissions>{xdmp:default-permissions()}</permissions>
        <collections>{
            <collection>holy-chapter-xhtml-body</collection>,
            xdmp:default-collections() ! <collection>{.}</collection>
        }</collections>
    </options>;

declare function local:get-chapter-html-body(
        $url as xs:string
) as element(xhtml:body)
{
    let $resp :=
        xdmp:http-get($url,
                <options xmlns="xdmp:http">
                    <headers>
                        <Cookie>{fn:concat("PHPSESSID=", $SESSION-ID)}</Cookie>
                    </headers>
                    <verify-cert>false</verify-cert>
                </options>
        )[2] => xdmp:from-json()

    let $html := map:get($resp, "data") => map:get("chapter") => map:get("content")
    let $body := xdmp:tidy($html)[2]/xhtml:html/xhtml:body
    return $body
};

let $doc-uri := fn:substring-after($URI, $hmc:PISMOSWIETE-PL-API-URL) || "/" || $hmc:CURRENT-HTML-CONTENT-VERSION
let $doc-root := local:get-chapter-html-body($URI)
return xdmp:document-insert($doc-uri, $doc-root, $doc-options)