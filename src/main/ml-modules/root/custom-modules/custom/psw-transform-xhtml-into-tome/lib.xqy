xquery version '1.0-ml';

module namespace custom = 'http://marklogic.com/data-hub/custom';

import module namespace json = 'http://marklogic.com/xdmp/json' at '/MarkLogic/json/json.xqy';
import module namespace dhf = 'http://marklogic.com/dhf' at '/data-hub/4/dhf.xqy';
import module namespace es = 'http://marklogic.com/entity-services' at '/MarkLogic/entity-services/entity-services.xqy';
import module namespace fc = "http://marklogic.com/holy/ml-modules/flow-constants" at "/constants/flow-constants.xqy";
import module namespace hhc = 'http://marklogic.com/holy/ml-modules/holy-hub-constants' at '/constants/holy-hub-constants.xqy';
import module namespace bib = 'http://marklogic.com/holy/ml-modules/bible-utils' at '/libs/bible-utils.xqy';
import module namespace flow = 'http://marklogic.com/holy/ml-modules/flow-utils' at '/libs/flow-utils.xqy';
import module namespace hh = 'http://marklogic.com/holy/ml-modules/holy-hub-utils' at '/libs/holy-hub-utils.xqy';

declare namespace x = 'http://www.w3.org/1999/xhtml';
declare namespace ch = 'http://holy.arch.com/holy-entities/chapter';
declare namespace v = 'http://holy.arch.com/holy-entities/verse';

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
    let $output-format := if (fn:empty(map:get($options, 'outputFormat'))) then 'json' else map:get($options, 'outputFormat')
    let $tome-siglum := fn:tokenize($content/uri, $fc:URI-SEP)[3]
    let $source-uris := flow:get-xhtml-source-uris()[fn:contains(., $tome-siglum)]

    let $headers := flow:create-headers($source-uris, $options)
    let $instance := custom:create-tome-instance($tome-siglum, $source-uris)

    let $envelope := dhf:make-envelope($instance, $headers, (), $output-format)

    return $envelope
};

(:~
 : Creates a map:map representing Tome model instance.
 :
 : @param $tome-siglum - a tome siglum
 : @param $source-uris - a source uri sequence
 :
 : @return a map:map instance with extracted data and metadata about the Tome instance.
 :)
declare function custom:create-tome-instance(
        $tome-siglum as xs:string,
        $source-uris as xs:string*
) as map:map
{
    let $tome-name := bib:retrieve-tome-name($tome-siglum)
    let $testament := bib:retrieve-testament($tome-siglum)
    let $first-chapter := bib:retrieve-first-chapter($tome-siglum)
    let $last-chapter := bib:retrieve-last-chapter($tome-siglum)
    let $pericopes := custom:extract-pericopes($source-uris, $testament, $tome-siglum, $first-chapter) => json:to-array()
    let $subtitles := ()

    let $model := json:object()
    => map:with($fc:DHF-TYPE, $fc:TOME-ENTITY)
    => map:with($fc:DHF-VERSION, $fc:TOME-VERSION)
    => map:with($fc:DHF-NS, $fc:TOME-NS-URI)
    => map:with($fc:DHF-NS-PREFIX, $fc:TOME-NS-PREFIX)
    => map:with($fc:SIGLUM, $tome-siglum)
    => map:with($fc:NAME, $tome-name)
    => map:with($fc:TESTAMENT, $testament)
    => map:with($fc:FIRST-CHAPTER, $first-chapter)
    => map:with($fc:LAST-CHAPTER, $last-chapter)
    => map:with($fc:PERICOPES, $pericopes)
    => map:with($fc:SUBTITLES, $subtitles)

    return $model
};

(:~
 : Creates a sequence of map:map instances representing Pericope model instances.
 :
 : @param $source-uris   - a source uri sequence
 : @param $testament     - a testament name
 : @param $tome-siglum   - a tome siglum
 : @param $first-chapter - a tome first chapter reference
 :
 : @return a sequence of map:map instances with extracted data and metadata about the Pericope instance.
 :)
declare function custom:extract-pericopes
(
        $source-uris as xs:string*,
        $testament as xs:string,
        $tome-siglum as xs:string,
        $first-chapter as xs:string
) as map:map*
{
    let $pericopes := hh:eval-in-db(function(){
        $source-uris ! fn:doc(.)/x:body/child::x:div[@class eq 'perykopa']
    }, $hhc:STAGING-DB-ID)

    for $pericope at $pos in $pericopes
    let $title := $pericope/xs:string(.) => fn:normalize-space()
    let $verse-nodes := $pericope/following-sibling::x:span[@class eq 'werset' and fn:not(. = $pericopes[$pos + 1]/following-sibling::x:span)]
    let $verse-refs :=
        for $v-node in $verse-nodes
        let $chapter-num := $v-node/preceding-sibling::x:span[@class eq 'chapter-number'][1]/xs:string(.) => flow:get-or-else($first-chapter)
        let $chapter-id := fn:concat($testament, $tome-siglum, $chapter-num) => flow:generate-unique-id()
        let $verse-number := $v-node/preceding-sibling::x:sup[@class = 'werset-number'][1]/xs:string(.)
        let $verse-content := $v-node/xs:string(.) => flow:clear-content()
        let $verse-id :=
            cts:search(/es:envelope/es:instance/ch:Chapter/ch:verses/v:Verse,
                    cts:and-query((
                        cts:directory-query($fc:CHAPTER-BASE-URI || $tome-siglum || $fc:URI-SEP),
                        cts:element-value-query(xs:QName("v:Chapter"), $chapter-id),
                        cts:element-value-query(xs:QName("v:number"), $verse-number),
                        cts:element-value-query(xs:QName("v:content"), $verse-content)
                    )),
                    "score-zero",
                    0.0
            )/v:id/xs:string(.)
        return flow:make-reference-object($fc:VERSE-ENTITY, $verse-id, $fc:VERSE-NS-PREFIX, $fc:VERSE-NS-URI)

    let $pericope-id := fn:concat($tome-siglum, map:get($verse-refs[1], '$ref'), map:get($verse-refs[fn:last()], '$ref')) => flow:generate-unique-id()

    let $model := json:object()
    => map:with($fc:DHF-TYPE, $fc:PERICOPE-ENTITY)
    => map:with($fc:DHF-VERSION, $fc:PERICOPE-VERSION)
    => map:with($fc:DHF-NS, $fc:PERICOPE-NS-URI)
    => map:with($fc:DHF-NS-PREFIX, $fc:PERICOPE-NS-PREFIX)
    => map:with($fc:ID, $pericope-id)
    => map:with($fc:TITLE, $title)
    => map:with($fc:TOME, $tome-siglum)
    => map:with($fc:VERSES, $verse-refs => json:to-array())
    return $model
};