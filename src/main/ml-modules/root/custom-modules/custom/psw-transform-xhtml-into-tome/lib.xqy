xquery version "1.0-ml";

module namespace custom = "http://marklogic.com/data-hub/custom";

import module namespace json = "http://marklogic.com/xdmp/json" at "/MarkLogic/json/json.xqy";
import module namespace bib = "http://marklogic.com/holy/ml-modules/bible-utils" at "/libs/bible-utils.xqy";
import module namespace flow = "http://marklogic.com/holy/ml-modules/flow-utils" at "/libs/flow-utils.xqy";

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
    let $doc := if (xdmp:node-kind($content/value) eq "text") then xdmp:unquote($content/value) else $content/value

    let $tome-siglum := fn:tokenize($content/uri, "/")[3]
    let $source-uris :=
        for $uri in cts:uris((), (), cts:directory-query(fn:concat("/tome/", $tome-siglum, "/"), "infinity"))
        let $chapter := fn:tokenize($uri, "/")[5] => xs:int()
        order by $chapter
        return $uri

    let $headers := flow:create-headers($doc, $options, $source-uris)
    let $instance := create-instance($doc, $options, $tome-siglum, $source-uris)

    let $output-format := if (fn:empty(map:get($options, "outputFormat"))) then "json" else map:get($options, "outputFormat")

    let $envelope := flow:make-envelope($instance, $headers, (), $output-format)

    return $envelope
};

(:~
 : Creates instance
 :
 : @param $content      - the raw content
 : @param $options      - a map containing options
 : @param $source-uris  - a source-uris
 :
 :)
declare function custom:create-instance(
        $content as item()?,
        $options as map:map,
        $tome-siglum as xs:string,
        $source-uris as xs:string*
) as item()?
{
    let $output-format := if (fn:empty(map:get($options, "outputFormat"))) then "xml" else map:get($options, "outputFormat")
    let $tome-name := bib:retrieve-tome-name($tome-siglum)
    let $testament := bib:retrieve-testament($tome-siglum)
    let $first-chapter := bib:retrieve-first-chapter($tome-siglum)
    let $last-chapter := bib:retrieve-last-chapter($tome-siglum)
    let $pericopes := custom:extract-pericopes($content, $source-uris, $output-format)

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
        $content as item()*,
        $source-uris as xs:string*,
        $output-format as xs:string
)
{
(:    for $uri in $source-uris:)
(:    let $chapter-num := fn:tokenize($uri, "/")[5]:)


(:    for $verse in $content/x:body/x:span[@class = 'werset']:)
(:    let $number := $verse/preceding-sibling::x:sup[@class = 'werset-number'][1]/xs:string(.):)
(:    let $content := $verse/xs:string(.):)
(:    let $definitions := fn:distinct-values($verse/x:a[@class = 'definition']/@id/fn:string()):)
(:    let $dictionaries := fn:distinct-values($verse/x:a[@class = 'dictionary']/@id/fn:string()):)
(:    return:)
(:        if ($output-format eq 'xml'):)
(:        then:)
(:        :)(:            ( :)
(:            element bp:Pericope {:)
(:                element bp:title {$title},:)
(:                element bv:content {$content},:)
(:                element bv:supplements {:)
(:                    $definitions ! element bv:definition {.},:)
(:                    $dictionaries ! element bv:dictionary {.}:)
(:                }:)
(:            }:)
(:        :)(:            ) :)
(:        else:)
(:        :)(:            let $info := flow:get-info-node("BasicVerse", $source-version):)
(:            let $supplements := json:object():)
(:            => map:with("definitions", json:to-array($definitions)):)
(:            => map:with("dictionaries", json:to-array($dictionaries)):)
(:            let $verse := object-node {:)
(:            "number" : $number,:)
(:            "content" : $content,:)
(:            "supplements" : $supplements:)
(:            }:)
(:            return json:object():)
(:            :)(:            => map:with("info", $info):)
(:            => map:with("BasicVerse", $verse):)
};
