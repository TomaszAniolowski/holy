xquery version "1.0-ml";

module namespace custom = "http://marklogic.com/data-hub/custom";

import module namespace json = "http://marklogic.com/xdmp/json" at "/MarkLogic/json/json.xqy";
import module namespace dhf = "http://marklogic.com/dhf" at "/data-hub/4/dhf.xqy";
import module namespace es = "http://marklogic.com/entity-services" at "/MarkLogic/entity-services/entity-services.xqy";
import module namespace flow = "http://marklogic.com/holy/ml-modules/flow-utils" at "/libs/flow-utils.xqy";
import module namespace fc = "http://marklogic.com/holy/ml-modules/flow-constants" at "/constants/flow-constants.xqy";
import module namespace hhc = 'http://marklogic.com/holy/ml-modules/holy-hub-constants' at '/constants/holy-hub-constants.xqy';
import module namespace hh = 'http://marklogic.com/holy/ml-modules/holy-hub-utils' at '/libs/holy-hub-utils.xqy';

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
    let $card-num := flow:substring-between($content/uri, "/Chapter/Ag/", ".") => xs:int()
    let $output-format := if (fn:empty(map:get($options, "outputFormat"))) then "json" else map:get($options, "outputFormat")

    let $headers := flow:create-headers("/tome/*.xml", $options)
    let $instance := custom:create-glossary-instance($card-num)

    let $envelope := dhf:make-envelope($instance, $headers, (), $output-format)

    return $envelope
};

(:~
 : Creates a map:map representing Glossary model instance.
 :
 : @param $card-number - a cardinal number indicating type of supplement to extract
 :
 : @return a map:map instance with extracted data and metadata about the Glossary instance.
 :)
declare function custom:create-glossary-instance(
        $card-number as xs:int
) as map:map
{

    let $supp-wrapper-name := if ($card-number eq 1) then $fc:DICTIONARY else $fc:DEFINITIONS
    let $supplements := if ($card-number eq 1) then custom:extract-dictionaries() else custom:extract-definitions()
    let $supplements := $supplements => json:to-array()

    let $model := json:object()
    => map:with($fc:DHF-TYPE, $fc:GLOSSARY-ENTITY)
    => map:with($fc:DHF-VERSION, $fc:GLOSSARY-VERSION)
    => map:with($fc:DHF-NS, $fc:GLOSSARY-NS-URI)
    => map:with($fc:DHF-NS-PREFIX, $fc:GLOSSARY-NS-PREFIX)
    => map:with($supp-wrapper-name, $supplements)

    return $model
};

(:~
 : Creates a sequence of map:map instances representing Supplement model instances of definition type.
 :
 : @return a sequence of map:map instances with extracted data and metadata about the Supplement instance.
 :)
declare function custom:extract-definitions
(
) as map:map*
{
    let $source-uris := flow:get-xhtml-source-uris()

    let $definition-unique-ids := map:map()
    let $definition-nodes := hh:eval-in-db(function(){
        $source-uris ! fn:doc(.)/x:body/child::x:div[@class eq 'definition-box']
    }, $hhc:STAGING-DB-ID)

    let $unique-origin-ids := fn:distinct-values($definition-nodes/@id)

    for $id in $unique-origin-ids
    let $definition-node := $definition-nodes[@id = $id][1]/child::node()[1]
    let $content := $definition-node/xs:string(.) => flow:clear-content()
    let $definition-unique-id := $content => flow:generate-unique-id()
    return if (map:contains($definition-unique-ids, $definition-unique-id))
    then ()
    else
        let $_ := map:put($definition-unique-ids, $definition-unique-id, fn:true())
        let $child-nodes := $definition-node/child::node()
        let $childs-count := fn:count($child-nodes)
        let $first-node-empty := fn:normalize-space($child-nodes[1]/xs:string(.)) eq ""
        let $first-node-txt-kind := xdmp:node-kind($child-nodes[1]) eq 'text'
        let $second-node-txt-kind := xdmp:node-kind($child-nodes[2]) eq 'text'
        let $definiendum :=
            if ($childs-count > 1 and $first-node-empty and fn:not($second-node-txt-kind))
            then $child-nodes[2]/xs:string(.) => flow:substring-before-if-contains($fc:SUPP-SEP) => flow:clear-content()
            else if ($childs-count > 1 and fn:not($first-node-empty) and fn:not($first-node-txt-kind))
            then $child-nodes[1]/xs:string(.) => flow:substring-before-if-contains($fc:SUPP-SEP) => flow:clear-content()
            else ()
        let $definiens := $definiendum ! (fn:substring-after($content, .) => flow:substring-after-if-contains($fc:SUPP-SEP) => flow:clear-content())
        let $model := json:object()
        => map:with($fc:DHF-TYPE, $fc:SUPPLEMENT-ENTITY)
        => map:with($fc:DHF-VERSION, $fc:SUPPLEMENT-VERSION)
        => map:with($fc:DHF-NS, $fc:SUPPLEMENT-NS-URI)
        => map:with($fc:DHF-NS-PREFIX, $fc:SUPPLEMENT-NS-PREFIX)
        => map:with($fc:ID, $definition-unique-id)
        => map:with($fc:TYPE, $fc:DEFINITION)
        => map:with($fc:CONTENT, $content)
        => es:optional($fc:DEFINIENDUM, $definiendum)
        => es:optional($fc:DEFINIENS, $definiens)

        return $model
};

(:~
 : Creates a sequence of map:map instances representing Supplement model instances of dictionary type.
 :
 : @return a sequence of map:map instances with extracted data and metadata about the Supplement instance.
 :)
declare function custom:extract-dictionaries
(
) as map:map*
{
    let $source-uris := flow:get-xhtml-source-uris()

    let $dictionary-unique-ids := map:map()
    let $dictionary-nodes := hh:eval-in-db(function(){
        $source-uris ! fn:doc(.)/x:body/child::x:div[@class eq 'dictionary-box']
    }, $hhc:STAGING-DB-ID)
    let $unique-oorigin-ids := fn:distinct-values($dictionary-nodes/@id)

    for $id in $unique-oorigin-ids
    let $dictionary-node := $dictionary-nodes[@id = $id][1]
    let $content := $dictionary-node/xs:string(.) => flow:clear-content()
    let $dictionary-unique-id := $content => flow:generate-unique-id()
    return if (map:contains($dictionary-unique-ids, $dictionary-unique-id))
    then ()
    else
        let $_ := map:put($dictionary-unique-ids, $dictionary-unique-id, fn:true())
        let $definiens := $dictionary-node/x:span[@class = 'entries'][1]/xs:string(.) => flow:clear-content()
        let $definiendum := $dictionary-node/x:span[@class = 'entry-content'][1]/xs:string(.) => flow:substring-after-if-contains($fc:SUPP-SEP) => flow:clear-content()

        let $model := json:object()
        => map:with($fc:DHF-TYPE, $fc:SUPPLEMENT-ENTITY)
        => map:with($fc:DHF-VERSION, $fc:SUPPLEMENT-VERSION)
        => map:with($fc:DHF-NS, $fc:SUPPLEMENT-NS-URI)
        => map:with($fc:DHF-NS-PREFIX, $fc:SUPPLEMENT-NS-PREFIX)
        => map:with($fc:ID, $dictionary-unique-id)
        => map:with($fc:TYPE, $fc:DICTIONARY)
        => map:with($fc:CONTENT, $content)
        => es:optional($fc:DEFINIENDUM, $definiendum)
        => es:optional($fc:DEFINIENS, $definiens)
        return $model
};
