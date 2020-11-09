xquery version "1.0-ml";

module namespace custom = "http://marklogic.com/data-hub/custom";

import module namespace json = "http://marklogic.com/xdmp/json" at "/MarkLogic/json/json.xqy";
import module namespace bib = "http://marklogic.com/holy/ml-modules/bible-utils" at "/libs/bible-utils.xqy";
import module namespace flow = "http://marklogic.com/holy/ml-modules/flow-utils" at "/libs/flow-utils.xqy";
import module namespace hmc = "http://marklogic.com/holy/ml-modules/holy-management-constants" at "/constants/holy-management-constants.xqy";

declare namespace bt = "http://holy.arch.com/data/tome/basic";
declare namespace bp = "http://holy.arch.com/data/pericope/basic";
declare namespace x = "http://www.w3.org/1999/xhtml";

(:~
 : Plugin Entry point
 :
 : @param $content     - the raw content
 : @param $options     - a map containing options
 :
 :)
declare function custom:main(
        $content as item()?,
        $options as map:map)
{
    let $output-format := if (fn:empty(map:get($options, "outputFormat"))) then "json" else map:get($options, "outputFormat")
    let $tome-siglum := fn:tokenize($content/uri, "/")[3]
    let $source-uris :=
        for $uri in cts:uris((), (), cts:and-query((
            cts:collection-query(($hmc:XHTML-CONTENT-COLLECTION, $hmc:CURRENT-XHTML-CONTENT-VERSION)),
            cts:directory-query(fn:concat("/tome/", $tome-siglum, "/"), "infinity")
        )))
        let $chapter := fn:tokenize($uri, "/")[5]
        let $chapter := if ($chapter eq "Prolog") then 0 else xs:int($chapter)
        order by $chapter
        return $uri

    let $headers := flow:create-headers((), $options, $source-uris)
    let $instance := create-instance($output-format, $tome-siglum, $source-uris)

    let $envelope := flow:make-envelope($instance, $headers, (), $output-format)

    return $envelope
};

(:~
 : Creates instance
 :
 : @param $output-format - an output format ('xml' or 'json')
 : @param $tome-siglum   - a tome siglum
 : @param $source-uris   - a source-uris
 :
 :)
declare function custom:create-instance(
        $output-format as xs:string,
        $tome-siglum as xs:string,
        $source-uris as xs:string*
) as item()?
{
    let $tome-name := bib:retrieve-tome-name($tome-siglum)
    let $testament := bib:retrieve-testament($tome-siglum)
    let $first-chapter := bib:retrieve-first-chapter($tome-siglum)
    let $last-chapter := bib:retrieve-last-chapter($tome-siglum)
    let $pericopes := custom:extract-pericopes($first-chapter, $source-uris, $output-format)

    return if ($output-format = 'xml')
    then
    (:        ( :)
    (:            flow:get-info-element("BasicTome", $source-version),:)
        element bt:BasicTome {
            element bt:siglum {$tome-siglum},
            element bt:name {$tome-name},
            element bt:testament {$testament},
            element bt:first-chapter {$first-chapter},
            element bt:last-chapter {$last-chapter},
            element bt:pericopes {$pericopes}
        }
    (:        ) :)
    else
    (:        let $info := flow:get-info-node("BasicTome", $source-version):)
        let $tome := object-node {
        "siglum" : $tome-siglum,
        "name" : $tome-name,
        "testament" : $testament,
        "firstChapter" : $first-chapter,
        "lastChapter" : $last-chapter,
        "pericopes" : json:to-array($pericopes)
        }

        return json:object()
        (:        => map:with("info", $info):)
        => map:with("BasicTome", $tome)
};

declare function custom:extract-pericopes
(
        $first-chapter as xs:string,
        $source-uris as xs:string*,
        $output-format as xs:string
)
{
    let $combined-tome := <x:body>{$source-uris ! fn:doc(.)/x:body/child::element()}</x:body>
    let $pericopes := $combined-tome/x:div[@class eq 'perykopa']
    for $pericope at $pos in $pericopes
    let $title := $pericope/xs:string(.) => fn:normalize-space()
    let $verse-nodes := $pericope/following-sibling::x:span[@class eq 'werset' and fn:not(. = $pericopes[$pos + 1]/following-sibling::x:span)]
    let $verses := $verse-nodes !
    object-node {
    "chapter": ./preceding-sibling::x:span[@class eq 'chapter-number'][1]/xs:string(.) => flow:get-or-else($first-chapter),
    "number": ./preceding-sibling::x:sup[@class eq 'werset-number'][1]/xs:string(.),
    "content": ./xs:string(.) => fn:normalize-space()
    }

    return
        if ($output-format eq 'xml')
        then
            (
                element bp:Pericope {
                    element bp:title {$title},
                    element bp:verses {
                        $verses !
                        element bp:verse {
                            element bp:chapter {./chapter},
                            element bp:number {./number},
                            element bp:content {./content}
                        }
                    }
                }
            )
        else
        (:            let $info := flow:get-info-node("BasicVerse", $source-version) :)
            let $pericope := object-node {
            "title" : $title,
            "verses" : json:to-array($verses)
            }
            return json:object()
            (:            => map:with("info", $info) :)
            => map:with("BasicPericope", $pericope)
};
