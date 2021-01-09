xquery version "1.0-ml";

module namespace custom = "http://marklogic.com/data-hub/custom";

import module namespace json = "http://marklogic.com/xdmp/json" at "/MarkLogic/json/json.xqy";
import module namespace dhf = "http://marklogic.com/dhf" at "/data-hub/4/dhf.xqy";
import module namespace es = "http://marklogic.com/entity-services" at "/MarkLogic/entity-services/entity-services.xqy";
import module namespace bc = "http://marklogic.com/holy/ml-modules/bible-constants" at "/constants/bible-constants.xqy";
import module namespace fc = "http://marklogic.com/holy/ml-modules/flow-constants" at "/constants/flow-constants.xqy";
import module namespace bib = "http://marklogic.com/holy/ml-modules/bible-utils" at "/libs/bible-utils.xqy";
import module namespace flow = "http://marklogic.com/holy/ml-modules/flow-utils" at "/libs/flow-utils.xqy";

declare namespace x = "http://www.w3.org/1999/xhtml";

(:~
 : Plugin Entry point
 :
 : @param $content - the raw content
 : @param $options - a map containing options
 :
 : @return es:envelope document node
 :)
declare function custom:main(
        $content as item()?,
        $options as map:map)
{
    let $doc := if (xdmp:node-kind($content/value) eq "text") then xdmp:unquote($content/value) else $content/value

    let $headers := flow:create-headers($content/uri, $options)
    let $instance := custom:create-chapter-instance($content/uri, $doc)

    let $output-format := if (fn:empty(map:get($options, "outputFormat"))) then "xml" else map:get($options, "outputFormat")

    let $envelope := dhf:make-envelope($instance, $headers, (), $output-format)

    return $envelope
};

(:~
 : Creates a map:map representing Chapter model instance.
 :
 : @param $source-uri - a source document uri
 : @param $source-doc - a source document
 :
 : @return a map:map instance with extracted data and metadata about the Chapter instance.
 :)
declare function custom:create-chapter-instance(
        $source-uri as xs:string,
        $source-doc as node()?
) as map:map
{
    let $tome-siglum := fn:tokenize($source-uri, $fc:URI-SEP)[3]
    let $chapter-num := fn:tokenize($source-uri, $fc:URI-SEP)[5]
    let $testament := bib:retrieve-testament($tome-siglum)
    let $id := fn:concat($testament, $tome-siglum, $chapter-num) => flow:generate-unique-id()
    let $verses := custom:extract-verses($source-doc, $testament, $tome-siglum, $chapter-num, $id) => json:to-array()

    let $model := json:object()
    => map:with($fc:DHF-TYPE, $fc:CHAPTER-ENTITY)
    => map:with($fc:DHF-VERSION, $fc:CHAPTER-VERSION)
    => map:with($fc:DHF-NS, $fc:CHAPTER-NS-URI)
    => map:with($fc:DHF-NS-PREFIX, $fc:CHAPTER-NS-PREFIX)
    => map:with($fc:ID, $id)
    => map:with($fc:TESTAMENT, $testament)
    => map:with($fc:TOME, $tome-siglum)
    => map:with($fc:NUMBER, $chapter-num)
    => map:with($fc:VERSES, $verses)

    return $model
};

(:~
 : Creates a sequence of map:map instances representing Verse model instances.
 :
 : @param $source-doc  - a source document
 : @param $testament   - a testament name
 : @param $tome-siglum - a tome siglum
 : @param $chapter-num - a chapter number
 : @param $chapter-id  - a chapter id
 :
 : @return a sequence of map:map instances with extracted data and metadata about the Verse instance.
 :)
declare function custom:extract-verses
(
        $source-doc as node(),
        $testament as xs:string,
        $tome-siglum as xs:string,
        $chapter-num as xs:string,
        $chapter-id as xs:string
) as map:map*
{
    let $chapter := flow:make-reference-object($fc:CHAPTER-ENTITY, $chapter-id, $fc:CHAPTER-NS-PREFIX, $fc:CHAPTER-NS-URI)

    let $current-cardinal-number := 0
    let $verse-sub-numbers := map:map()
    for $verse in $source-doc/x:body/x:span[@class = 'werset']
    let $number := $verse/preceding-sibling::x:sup[@class = 'werset-number'][1]/xs:string(.) => fn:normalize-space()
    let $number := custom:clear-exceptional-verse-number($tome-siglum, $chapter-num, $number)
    let $sub-number := fn:count(map:get($verse-sub-numbers, $number)) + 1
    let $sub-number := flow:get-roman-numeral-from-int($sub-number)
    let $_ := if ($sub-number eq 'I') then xdmp:set($current-cardinal-number, ($current-cardinal-number + 1)) else ()
    let $_ := map:put($verse-sub-numbers, $number, (map:get($verse-sub-numbers, $number), $sub-number))
    let $verse-id := fn:concat($testament, $tome-siglum, $chapter-num, $number, $sub-number) => flow:generate-unique-id()

    let $content := $verse/xs:string(.) => flow:clear-content()
    let $definition-origin-ids := fn:distinct-values($verse/x:a[@class = 'definition']/@data-target-id/fn:string())
    let $dictionary-origin-ids := fn:distinct-values($verse/x:a[@class = 'dictionary']/@data-target-id/fn:string())

    let $definition-nodes := $source-doc/x:body/child::x:div[@class eq 'definition-box']
    let $dictionary-nodes := $source-doc/x:body/child::x:div[@class eq 'dictionary-box']
    let $definition-holy-ids :=
        for $definition-id in $definition-origin-ids
        let $definition-value := $definition-nodes[@id = $definition-id][1]/xs:string(.)
        return $definition-value => flow:clear-content() => flow:generate-unique-id()
    let $dictionary-holy-ids :=
        for $dictionary-id in $dictionary-origin-ids
        let $dictionary-value := $dictionary-nodes[@id = $dictionary-id][1]/xs:string(.)
        return $dictionary-value => flow:clear-content() => flow:generate-unique-id()
    let $definitions := json:to-array($definition-holy-ids ! flow:make-reference-object($fc:SUPPLEMENT-ENTITY, ., $fc:SUPPLEMENT-NS-PREFIX, $fc:SUPPLEMENT-NS-URI))
    let $dictionary := json:to-array($dictionary-holy-ids ! flow:make-reference-object($fc:SUPPLEMENT-ENTITY, ., $fc:SUPPLEMENT-NS-PREFIX, $fc:SUPPLEMENT-NS-URI))

    let $model := json:object()
    => map:with($fc:DHF-TYPE, $fc:VERSE-ENTITY)
    => map:with($fc:DHF-VERSION, $fc:VERSE-VERSION)
    => map:with($fc:DHF-NS, $fc:VERSE-NS-URI)
    => map:with($fc:DHF-NS-PREFIX, $fc:VERSE-NS-PREFIX)
    => map:with($fc:ID, $verse-id)
    => map:with($fc:CARD-NUMBER, xs:string($current-cardinal-number))
    => map:with($fc:NUMBER, $number)
    => map:with($fc:SUB-NUMBER, $sub-number)
    => map:with($fc:CHAPTER, $chapter)
    => map:with($fc:CONTENT, $content)
    => es:optional($fc:DEFINITIONS, $definitions)
    => es:optional($fc:DICTIONARY, $dictionary)

    return $model
};

(:~
 : Clears exceptional mistakes in source data verse numbers.
 :
 : Here is the list of exceptional mistakes:
 : - 1Sm 17,47I
 : - Ps 75,11„
 : - Łk 24,12 (with space at the end)
 :
 : @param $tome-siglum   - a tome siglum
 : @param $chapter-num   - a chapter number
 : @param $verse-number  - a verse number
 :
 : @return a clean verse number
 :)
declare private function custom:clear-exceptional-verse-number
(
        $tome-siglum as xs:string,
        $chapter-num as xs:string,
        $verse-number as xs:string
)
{
    if ($tome-siglum eq $bc:SIGLUM-SM-1 and $chapter-num eq '17' and $verse-number eq '47I')
    then '47'
    else if ($tome-siglum = $bc:SIGLUM-PS and $chapter-num eq '75' and $verse-number eq '11„')
    then '11'
    else $verse-number
};