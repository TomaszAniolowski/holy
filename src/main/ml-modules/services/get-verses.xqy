xquery version "1.0-ml";

module namespace verses = "http://marklogic.com/rest-api/resource/get-verses";

import module namespace fc = 'http://marklogic.com/holy/ml-modules/flow-constants' at '/constants/flow-constants.xqy';
import module namespace bib = "http://marklogic.com/holy/ml-modules/bible-utils" at "/libs/bible-utils.xqy";
import module namespace flow = "http://marklogic.com/holy/ml-modules/flow-utils" at "/libs/flow-utils.xqy";

declare namespace es = 'http://marklogic.com/entity-services';
declare namespace ch = 'http://holy.arch.com/holy-entities/chapter';
declare namespace v = 'http://holy.arch.com/holy-entities/verse';

declare private variable $VERSE-REF-SEP as xs:string := '-';

declare function verses:get(
        $context as map:map,
        $params as map:map
) as document-node()
{
    let $response :=
        if (fn:not(map:contains($params, 'siglum')))
        then verses:invalid-siglum($context, (), 'No siglum')
        else
            let $siglum := verses:prepare-siglum(map:get($params, 'siglum'))
            let $is-correct := bib:validate-siglum($siglum)

            return if (fn:not($is-correct))
            then verses:invalid-siglum($context, $siglum)
            else verses:response($context, $siglum)
    return xdmp:to-json($response)
};

declare private function verses:response(
        $context as map:map,
        $siglum as xs:string
) as json:object
{
    let $siglum-interpretation := bib:interpret-siglum($siglum)
    let $interpretation-error := map:get($siglum-interpretation, $siglum)
    return if (fn:exists($interpretation-error))
    then verses:invalid-siglum($context, $siglum, $interpretation-error)
    else
        let $tome := map:get($siglum-interpretation, 'tome')
        let $interpretation-chapters := map:get($siglum-interpretation, 'chapters')
        let $testament := bib:retrieve-testament($tome)
        let $chapter-numbers := map:keys($interpretation-chapters)

        let $chapters :=
            cts:search(/es:envelope/es:instance/ch:Chapter,
                    cts:and-query((
                        cts:directory-query($fc:CHAPTER-BASE-URI || $tome || '/', 'infinity'),
                        cts:element-value-query(xs:QName('ch:number'), $chapter-numbers)
                    )),
                    'score-zero',
                    0.0
            )

        let $chapters-map := map:new()
        let $_ :=
            for $chapter-number in $chapter-numbers
            let $verse-numbers := map:get($interpretation-chapters, $chapter-number)
            let $verse-numbers := if ($verse-numbers eq '_all') then fn:distinct-values($chapters[ch:number eq $chapter-number]/ch:verses/v:Verse/v:number) else $verse-numbers
            let $verses-map := map:new()
            let $_ :=
                for $verse-number in $verse-numbers
                let $verse-ref := ()
                let $sub-verses-map := map:new()
                let $_ :=
                    for $sub-verse in $chapters[ch:number eq $chapter-number]/ch:verses/v:Verse[v:number eq $verse-number]
                    let $card-number := $sub-verse/v:card-number/xs:string(.)
                    let $_ := if (fn:empty($verse-ref)) then xdmp:set($verse-ref, $card-number || $VERSE-REF-SEP || $verse-number) else ()
                    let $verse-sub-number := $sub-verse/v:sub-number/xs:string(.)
                    let $content := $sub-verse/v:content/xs:string(.)
                    return map:put($sub-verses-map, $verse-sub-number, $content)
                return map:put($verses-map, $verse-ref, $sub-verses-map)
            return map:put($chapters-map, $chapter-number, $verses-map)
        return verses:complete-response($context, $testament, $tome, $chapters-map)
};

declare private function verses:complete-response(
        $context as map:map,
        $testament as xs:string,
        $tome as xs:string,
        $chapters-map as map:map
) as json:object
{
    let $_ := map:put($context, 'output-status', (200, 'OK'))

    let $chapters :=
        for $chapter-number in map:keys($chapters-map)
        let $verse-refs := map:get($chapters-map, $chapter-number)
        let $verses :=
            for $verse-ref in map:keys($verse-refs)
            let $sub-verse-map := map:get($verse-refs, $verse-ref)
            let $verse-card-num := fn:substring-before($verse-ref, $VERSE-REF-SEP) => xs:int()
            let $verse-number := fn:substring-after($verse-ref, $VERSE-REF-SEP)
            order by $verse-card-num
            return verses:verse-object($verse-number, $sub-verse-map)
        let $chapter-card-num := if ($chapter-number eq 'Prolog') then 0 else xs:int($chapter-number)
        order by $chapter-card-num
        return verses:chapter-object($chapter-number, $verses)

    return verses:response-object($testament, $tome, $chapters)
};

declare private function verses:response-object(
        $testament as xs:string,
        $tome as xs:string,
        $chapters as json:object*
) as json:object
{
    json:object()
    => map:with('tome', $tome)
    => map:with('testament', $testament)
    => map:with('chapters', json:to-array($chapters))
};

declare private function verses:chapter-object(
        $chapter-number as xs:string,
        $verses as json:object*
) as json:object
{
    json:object()
    => map:with('number', $chapter-number)
    => map:with('verses', json:to-array($verses))
};

declare private function verses:verse-object(
        $verse-number as xs:string,
        $sub-verse-map as map:map?
) as json:object
{
    let $content := map:new((
        for $i in (1 to fn:count(map:keys($sub-verse-map)))
        let $sub-num := flow:get-roman-numeral-from-int($i)
        let $content := map:get($sub-verse-map, $sub-num)
        return map:entry($sub-num, $content)
    ))
    return json:object()
    => map:with('number', $verse-number)
    => map:with('content', $content)
};

declare private function verses:prepare-siglum(
        $siglum as xs:string*
) as xs:string
{
    let $siglum := $siglum ! fn:replace(., "_", " ")
    return if (fn:count($siglum) le 1)
    then $siglum
    else
        let $tome-sigla := fn:distinct-values($siglum ! fn:substring-before(., ' '))
        return if (fn:count($tome-sigla) eq 1)
        then $tome-sigla || ' ' || fn:string-join(($siglum ! fn:substring-after(., $tome-sigla || ' ')), '; ')
        else fn:string-join($siglum, '; ')
};

declare private function verses:invalid-siglum(
        $context as map:map,
        $siglum as xs:string
) as json:object
{
    verses:invalid-siglum($context, $siglum, ())
};

declare private function verses:invalid-siglum(
        $context as map:map,
        $siglum as xs:string?,
        $details as xs:string?
) as json:object
{
    let $output-status := if (fn:contains($details, 'not found')) then (404, 'Not Found') else (400, 'Bad Request')
    let $_ := map:put($context, 'output-status', $output-status)
    let $siglum := if (fn:empty($siglum)) then '' else $siglum
    let $message := if (fn:empty($details)) then 'Invalid siglum' else 'Invalid siglum (' || $details || ')'
    return json:object()
    => map:with($siglum, $message)
};