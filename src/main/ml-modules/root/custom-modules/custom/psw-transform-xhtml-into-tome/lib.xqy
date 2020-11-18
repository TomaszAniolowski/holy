xquery version '1.0-ml';

module namespace custom = 'http://marklogic.com/data-hub/custom';

import module namespace json = 'http://marklogic.com/xdmp/json' at '/MarkLogic/json/json.xqy';
import module namespace dhf = 'http://marklogic.com/dhf' at '/data-hub/4/dhf.xqy';
import module namespace es = 'http://marklogic.com/entity-services' at '/MarkLogic/entity-services/entity-services.xqy';
import module namespace bib = 'http://marklogic.com/holy/ml-modules/bible-utils' at '/libs/bible-utils.xqy';
import module namespace hh = 'http://marklogic.com/holy/ml-modules/holy-hub-utils' at '/libs/holy-hub-utils.xqy';
import module namespace flow = 'http://marklogic.com/holy/ml-modules/flow-utils' at '/libs/flow-utils.xqy';
import module namespace hhc = 'http://marklogic.com/holy/ml-modules/holy-hub-constants' at '/constants/holy-hub-constants.xqy';
import module namespace hmc = 'http://marklogic.com/holy/ml-modules/holy-management-constants' at '/constants/holy-management-constants.xqy';

declare namespace t = 'http://holy.arch.com/data/tome';
declare namespace p = 'http://holy.arch.com/data/pericope';
declare namespace ch = 'http://holy.arch.com/data/chapter';
declare namespace v = 'http://holy.arch.com/data/verse';
declare namespace x = 'http://www.w3.org/1999/xhtml';

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
    let $output-format := if (fn:empty(map:get($options, 'outputFormat'))) then 'json' else map:get($options, 'outputFormat')
    let $tome-siglum := fn:tokenize($content/uri, '/')[3]
    let $source-uris := flow:get-xhtml-source-uris()[fn:contains(., $tome-siglum)]

    let $headers := flow:create-headers($source-uris, $options)
    let $instance := custom:create-instance($tome-siglum, $source-uris)

    let $envelope := dhf:make-envelope($instance, $headers, (), $output-format)

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
        $tome-siglum as xs:string,
        $source-uris as xs:string*
) as map:map
{
    let $tome-name := bib:retrieve-tome-name($tome-siglum)
    let $testament := bib:retrieve-testament($tome-siglum)
    let $first-chapter := bib:retrieve-first-chapter($tome-siglum)
    let $last-chapter := bib:retrieve-last-chapter($tome-siglum)
    let $pericopes := custom:extract-pericopes($source-uris, $first-chapter, $testament, $tome-siglum) => json:to-array()
    let $subtitles := ()

    let $model := json:object()
    => map:with('$type', 'Tome')
    => map:with('$version', '1.0.0')
    => map:with('$namespace', 'http://holy.arch.com/data/tome')
    => map:with('$namespacePrefix', 't')
    => map:with('siglum', $tome-siglum)
    => map:with('name', $tome-name)
    => map:with('testament', $testament)
    => map:with('first-chapter', $first-chapter)
    => map:with('last-chapter', $last-chapter)
    => map:with('pericopes', $pericopes)
    => map:with('subtitles', $subtitles)

    return $model
};

declare function custom:extract-pericopes
(
        $source-uris as xs:string*,
        $first-chapter as xs:string,
        $testament as xs:string,
        $tome-siglum as xs:string
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
        let $verse-content := $v-node/xs:string(.) => flow:clean-content()
        let $verse-id :=
            cts:search(/es:envelope/es:instance/ch:Chapter/ch:verses/v:Verse,
                cts:and-query((
                        cts:directory-query("/Chapter/" || $tome-siglum || "/"),
                        cts:element-value-query(xs:QName("v:Chapter"), $chapter-id),
                        cts:element-value-query(xs:QName("v:number"), $verse-number),
                        cts:element-value-query(xs:QName("v:content"), $verse-content)
                )),
                "score-zero",
                0.0
            )/v:id/xs:string(.)
        return flow:make-reference-object('Verse', $verse-id, 'p', 'http://holy.arch.com/data/pericope')

    let $pericope-id := fn:concat($tome-siglum, map:get($verse-refs[1], '$ref'), map:get($verse-refs[fn:last()], '$ref')) => flow:generate-unique-id()

    let $model := json:object()
    => map:with('$type', 'Pericope')
    => map:with('$version', '1.0.0')
    => map:with('$namespace', 'http://holy.arch.com/data/pericope')
    => map:with('$namespacePrefix', 'p')
    => map:with('id', $pericope-id)
    => map:with('title', $title)
    => map:with('tome', $tome-siglum)
    => map:with('verses', $verse-refs => json:to-array())
    return $model
};