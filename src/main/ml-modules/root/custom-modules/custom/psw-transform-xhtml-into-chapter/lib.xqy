xquery version "1.0-ml";

module namespace custom = "http://marklogic.com/data-hub/custom";

import module namespace json = "http://marklogic.com/xdmp/json" at "/MarkLogic/json/json.xqy";
import module namespace bib = "http://marklogic.com/holy/ml-modules/bible-utils" at "/libs/bible-utils.xqy";
import module namespace flow = "http://marklogic.com/holy/ml-modules/flow-utils" at "/libs/flow-utils.xqy";

declare namespace bch = "http://holy.arch.com/data/chapter/basic";
declare namespace bv = "http://holy.arch.com/data/verse/basic";
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

    let $headers := flow:create-headers($doc, $options, $content/uri)
    let $instance := create-instance($doc, $options, $content/uri)

    let $output-format := if (fn:empty(map:get($options, "outputFormat"))) then "xml" else map:get($options, "outputFormat")

    let $envelope := flow:make-envelope($instance, $headers, (), $output-format)

    return $envelope
};

(:~
 : Creates instance
 :
 : @param $content      - the raw content
 : @param $options      - a map containing options
 : @param $source-uri   - a source-uri
 :
 :)
declare function custom:create-instance(
        $content as item()?,
        $options as map:map,
        $source-uri as xs:string
)
{
    let $output-format := if (fn:empty(map:get($options, "outputFormat"))) then "xml" else map:get($options, "outputFormat")
    let $tome-siglum := fn:tokenize($source-uri, "/")[3]
    let $chapter-num := fn:tokenize($source-uri, "/")[5]
    let $source-version := fn:tokenize($source-uri, "/")[6]
    let $testament := bib:retrieve-testament($tome-siglum)
    let $verses := custom:extract-verses($content, $source-version, $output-format)

    return if ($output-format = 'xml')
    then
(:        ( :)
        (:            flow:get-info-element("BasicChapter", $source-version),:)
        element bch:BasicChapter {
            element bch:testament {$testament},
            element bch:tome {$tome-siglum},
            element bch:number {$chapter-num},
            element bch:verses {$verses}
        }
(:        ) :)
    else
(:        let $info := flow:get-info-node("BasicChapter", $source-version):)
        let $chapter := object-node {
        "testament" : $testament,
        "tome" : $tome-siglum,
        "number" : $chapter-num,
        "verses" : json:to-array($verses)
        }

        return json:object()
(:        => map:with("info", $info):)
        => map:with("BasicChapter", $chapter)
};

declare function custom:extract-verses
(
        $content as item()*,
        $source-version as xs:string,
        $output-format as xs:string
)
{
    for $verse in $content/x:body/x:span[@class = 'werset']
    let $number := $verse/preceding-sibling::x:sup[@class = 'werset-number'][1]/xs:string(.)
    let $content := $verse/xs:string(.)
    let $definitions := fn:distinct-values($verse/x:a[@class = 'definition']/@id/fn:string())
    let $dictionaries := fn:distinct-values($verse/x:a[@class = 'dictionary']/@id/fn:string())
    return
        if ($output-format eq 'xml')
        then
(:            ( :)
                element bv:Verse {
                    element bv:number {$number},
                    element bv:content {$content},
                    element bv:supplements {
                        $definitions ! element bv:definition {.},
                        $dictionaries ! element bv:dictionary {.}
                    }
                }
(:            ) :)
        else
(:            let $info := flow:get-info-node("BasicVerse", $source-version):)
            let $supplements := json:object()
            => map:with("definitions", json:to-array($definitions))
            => map:with("dictionaries", json:to-array($dictionaries))
            let $verse := object-node {
            "number" : $number,
            "content" : $content,
            "supplements" : $supplements
            }
            return json:object()
(:            => map:with("info", $info):)
            => map:with("BasicVerse", $verse)
};