xquery version "1.0-ml";

(:~
 : The bible-utils.xqy library module contains useful functions
 : that allows you to retrive information directly releted to the bible.
 : It contains e.g. function retrieving tome name basis on the tome siglum
 : or name of the testament that contains specific tome.
 :)
module namespace bib = "http://marklogic.com/holy/ml-modules/bible-utils";

import module namespace bc = "http://marklogic.com/holy/ml-modules/bible-constants" at "/constants/bible-constants.xqy";
import module namespace fc = "http://marklogic.com/holy/ml-modules/flow-constants" at "/constants/flow-constants.xqy";
import module namespace flow = "http://marklogic.com/holy/ml-modules/flow-utils" at "/libs/flow-utils.xqy";
import module namespace xqy3 = 'http://marklogic.com/holy/ml-modules/xqy-3-utils' at '/libs/xqy-3-utils.xqy';

declare namespace error = "http://marklogic.com/xdmp/error";
declare namespace bs = "http://marklogic.com/holy/ml-modules/bible-structure";
declare namespace es = 'http://marklogic.com/entity-services';
declare namespace ch = 'http://holy.arch.com/holy-entities/chapter';
declare namespace v = 'http://holy.arch.com/holy-entities/verse';

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
 : Retrives the last chapter for the tome provided.
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

(:~
 : Pulls the verse digit from verse number of the combined form (e.g. '1a')
 :
 : @param $verse-num - the verse number
 :
 : @return the digit part of verse number
 :)
declare function bib:pull-verse-digit-part(
        $verse-num as xs:string
) as xs:string
{
    xqy3:split-verse-num($verse-num)[fn:matches(., '\d')]
};

(:~
 : Verifies the correctness of the siglum provided.
 : It uses javascript module because marklogic regex tools return wrong values.
 :
 : @param $siglum - the bible siglum (e.g. 'Jdt 5,4-7')
 :
 : @return the boolean value representing the correctness of the siglum provided
 :)
declare function bib:validate-siglum(
        $siglum as xs:string
) as xs:boolean
{
    xdmp:invoke('/js/validate-siglum.sjs', map:entry("siglum", $siglum))
};

(:~
 : Interpretes a siglum provided and returns a map with references to specific tome, chapters and verses
 : (according to what the sigila contain)
 :
 : @param $siglum - the bible siglum (e.g. 'Jdt 5,4-7')
 :
 : @return the map:map storing bible references
 :)
declare function bib:interpret-siglum(
        $siglum as xs:string
) as map:map
{
    try {
        let $_VALIDATE_SIGLUM := if (bib:validate-siglum($siglum) => fn:not()) then fn:error((), "Invalid siglum") else ()

        let $tome := fn:tokenize($siglum, ' ')[1]
        let $interpretation := map:new(map:entry('tome', $tome))
        let $chapters := map:new()

        let $siglum-refs := fn:substring-after($siglum, $tome || ' ') => fn:tokenize('; ')
        let $chapter-refs :=
            for $chapter-ref in ($siglum-refs ! flow:substring-before-if-contains(., ','))
            return if (fn:contains($chapter-ref, '-') => fn:not())
            then
                let $_VALIDATE_CH_NUMBER := if (fn:not(bib:check-chapter($tome, $chapter-ref))) then fn:error((), 'Chapter not found [' || $tome || ' ' || $chapter-ref || ']') else ()
                return $chapter-ref
            else
                let $from := fn:substring-before($chapter-ref, '-')
                let $to := fn:substring-after($chapter-ref, '-')
                let $_VALIDATE_CH_NUMBER := if (fn:not(bib:check-chapter($tome, $from))) then fn:error((), 'Chapter not found [' || $tome || ' ' || $from || ']') else ()
                let $_VALIDATE_CH_NUMBER := if (fn:not(bib:check-chapter($tome, $to))) then fn:error((), 'Chapter not found [' || $tome || ' ' || $to || ']') else ()
                let $from := if ($from eq 'Prolog') then 0 else xs:int($from)
                let $to := xs:int($to)
                let $_VALIDATE_CH_RANGE := if ($from eq $to or $to lt $from) then fn:error((), 'Invalid chapter range') else ()
                return ($from to $to) ! xs:string(.)

        let $_VALIDATE_CH_OVERLAPPING := if (fn:count($chapter-refs) ne fn:count(fn:distinct-values($chapter-refs))) then fn:error((), 'Chapters overlap') else ()

        let $_ALL_CH_VERSES :=
            for $siglum-ref in $siglum-refs[fn:not(fn:contains(., ','))]
            return if (fn:not(fn:contains($siglum-ref, '-')))
            then map:put($chapters, $siglum-ref, '_all')
            else
                let $from := fn:substring-before($siglum-ref, '-')
                let $from := if ($from eq 'Prolog') then 0 else xs:int($from)
                let $to := fn:substring-after($siglum-ref, '-') => xs:int()
                return if ($from ne 0)
                then ($from to $to) ! map:put($chapters, xs:string(.), '_all')
                else ('Prolog', 1 to $to) ! map:put($chapters, xs:string(.), '_all')

        let $_CH_SPECIFIC_VERSES :=
            for $siglum-ref in $siglum-refs[fn:contains(., ',')]
            let $chapter := fn:substring-before($siglum-ref, ',')
            let $verse-refs := fn:substring-after($siglum-ref, $chapter || ',') => fn:tokenize('. ')
            for $verse-ref in $verse-refs
            return
                if (fn:not(fn:contains($verse-ref, '-')) and fn:contains($verse-ref, 'n'))
                then
                    if ($tome eq $bc:SIGLUM-EST and
                            ($chapter eq '1' and fn:starts-with($verse-ref, '1n')) or
                            ($chapter eq '4' and fn:starts-with($verse-ref, '17n')) or
                            ($chapter eq '8' and fn:starts-with($verse-ref, '12n')))
                    then
                        let $num-part := fn:substring-before($verse-ref, 'n')
                        return if (fn:contains($verse-ref, 'nnn'))
                        then map:put($chapters, $chapter, (map:get($chapters, $chapter), $num-part || 'n', $num-part || 'o', $num-part || 'p'))
                        else if (fn:contains($verse-ref, 'nn'))
                        then map:put($chapters, $chapter, (map:get($chapters, $chapter), $num-part || 'n', $num-part || 'o'))
                        else map:put($chapters, $chapter, (map:get($chapters, $chapter), $num-part || 'n'))
                    else
                        let $from-verse-num := fn:substring-before($verse-ref, 'n')
                        let $from-verse := bib:find-verse($tome, $chapter, $from-verse-num)
                        let $_VALIDATE_V_NUMBER := if (fn:empty($from-verse)) then fn:error((), 'Verse not found [' || bib:construct-verse-siglum($tome, $chapter, $from-verse-num) || ']') else ()
                        let $from-verse-card-num := $from-verse/v:card-number/xs:int(.)
                        let $to-verse-card-num := if (fn:contains($verse-ref, 'nn')) then $from-verse-card-num + 2 else $from-verse-card-num + 1
                        let $to-verse := bib:find-verse-by-card-num($tome, $chapter, $to-verse-card-num)
                        let $_VALIDATE_V_NUMBER := if (fn:empty($to-verse)) then fn:error((), 'Verse not found [' || bib:construct-verse-siglum($tome, $chapter, $verse-ref) || ']') else ()
                        let $previous-refs := map:get($chapters, $chapter)
                        let $new-refs := ($from-verse-card-num to $to-verse-card-num) ! bib:find-verse-by-card-num($tome, $chapter, .)/v:number/xs:string(.)
                        return map:put($chapters, $chapter, ($previous-refs, $new-refs))
                else if (fn:contains($verse-ref, '-'))
                then
                    let $from-verse-num := fn:substring-before($verse-ref, '-')
                    let $to-verse-num := fn:substring-after($verse-ref, '-')
                    let $_VALIDATE_V_RANGE := if ($from-verse-num eq $to-verse-num) then fn:error((), 'Invalid verse range') else ()
                    let $from-verse := bib:find-verse($tome, $chapter, $from-verse-num)
                    let $_VALIDATE_V_NUMBER := if (fn:empty($from-verse)) then fn:error((), 'Verse not found [' || bib:construct-verse-siglum($tome, $chapter, $from-verse-num) || ']') else ()
                    let $from-verse-card-num := $from-verse/v:card-number/xs:int(.)
                    let $to-verse := bib:find-verse($tome, $chapter, $to-verse-num)
                    let $_VALIDATE_V_NUMBER := if (fn:empty($to-verse)) then fn:error((), 'Verse not found [' || bib:construct-verse-siglum($tome, $chapter, $to-verse-num) || ']') else ()
                    let $to-verse-card-num := $to-verse/v:card-number/xs:int(.)
                    let $_VALIDATE_V_RANGE := if ($to-verse-card-num lt $from-verse-card-num) then fn:error((), 'Invalid verse range') else ()
                    let $previous-refs := map:get($chapters, $chapter)
                    let $new-refs := ($from-verse-card-num to $to-verse-card-num) ! bib:find-verse-by-card-num($tome, $chapter, .)/v:number/xs:string(.)
                    return map:put($chapters, $chapter, ($previous-refs, $new-refs))
                else
                    let $verse := bib:find-verse($tome, $chapter, $verse-ref)
                    let $_VALIDATE_V_NUMBER := if (fn:empty($verse)) then fn:error((), 'Verse not found [' || bib:construct-verse-siglum($tome, $chapter, $verse-ref) || ']') else ()
                    return map:put($chapters, $chapter, (map:get($chapters, $chapter), $verse-ref))

        let $_VALIDATE_V_OVERLAPPING :=
            for $chapter in map:keys($chapters)
            let $verses := map:get($chapters, $chapter)
            return if (fn:count($verses) ne fn:count(fn:distinct-values($verses))) then fn:error((), 'Verses overlap') else ()

        let $_COMPLETE_CHAPTERS :=
            if (fn:exists(map:keys($chapters)))
            then ()
            else
                let $last-chapter := bib:retrieve-last-chapter($tome)
                let $chapter-nums := (1 to xs:int($last-chapter)) ! xs:string(.)
                let $chapter-nums := (($tome[. eq $bc:SIGLUM-SYR] ! 'Prolog'), $chapter-nums)
                return $chapter-nums ! map:put($chapters, ., '_all')

        let $_PUT_CHAPTERS := map:put($interpretation, 'chapters', $chapters)
        return $interpretation
    } catch ($ex) {
        map:new(map:entry($siglum, $ex/error:message/xs:string(.)))
    }
};

(:~
 : Verifies if a chapter exists basis on the tome siglum and chapter number provided.
 :
 : @param $tome    - the tome siglum (e.g. 'Jdt')
 : @param $chapter - the chapter number
 :
 : @return the xs:boolean value representing a chapter verification
 :)
declare private function bib:check-chapter
(
    $tome as xs:string,
    $chapter as xs:string
) as xs:boolean
{
    fn:doc-available($fc:CHAPTER-BASE-URI || $tome || $fc:URI-SEP || $chapter || '.xml')
};

(:~
 : Constructs the verse siglum from parameters provided.
 :
 : @param $tome    - the tome siglum (e.g. 'Jdt')
 : @param $chapter - the chapter number
 : @param $verse   - the verse number
 :
 : @return the verse siglum
 :)
declare private function bib:construct-verse-siglum
(
        $tome as xs:string,
        $chapter as xs:string,
        $verse as xs:string
) as xs:string
{
    $tome || ' ' || $chapter || ','  || $verse
};

(:~
 : Finds verse basis on the tome siglum, chapter number and verse number.
 :
 : @param $tome    - the tome siglum (e.g. 'Jdt')
 : @param $chapter - the chapter number
 : @param $verse   - the verse number
 :
 : @return the v:Verse entity if it exists, empty sequence otherwise
 :)
declare private function bib:find-verse
(
        $tome as xs:string,
        $chapter as xs:string,
        $verse as xs:string
) as element(v:Verse)?
{
    cts:search(/es:envelope/es:instance/ch:Chapter/ch:verses/v:Verse,
            cts:and-query((
                cts:document-query($fc:CHAPTER-BASE-URI || $tome || '/' || $chapter || '.xml'),
                cts:element-value-query(xs:QName('v:number'), $verse),
                cts:element-value-query(xs:QName('v:sub-number'), 'I')
            )),
            'score-zero',
            0.0
    )
};

(:~
 : Finds verse basis on the tome siglum, chapter number and verse cardinal number.
 :
 : @param $tome    - the tome siglum (e.g. 'Jdt')
 : @param $chapter - the chapter number
 : @param $verse   - the verse cardinal number
 :
 : @return the v:Verse entity if it exists, empty sequence otherwise
 :)
declare private function bib:find-verse-by-card-num
(
        $tome as xs:string,
        $chapter as xs:string,
        $verse-card-num as xs:int
) as element(v:Verse)?
{
    cts:search(/es:envelope/es:instance/ch:Chapter/ch:verses/v:Verse,
            cts:and-query((
                cts:document-query($fc:CHAPTER-BASE-URI || $tome || '/' || $chapter || '.xml'),
                cts:element-value-query(xs:QName('v:card-number'), xs:string($verse-card-num)),
                cts:element-value-query(xs:QName('v:sub-number'), 'I')
            )),
            'score-zero',
            0.0
    )
};