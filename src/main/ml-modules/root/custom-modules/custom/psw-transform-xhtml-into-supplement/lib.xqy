xquery version "1.0-ml";

module namespace custom = "http://marklogic.com/data-hub/custom";

import module namespace json = "http://marklogic.com/xdmp/json" at "/MarkLogic/json/json.xqy";
import module namespace flow = "http://marklogic.com/holy/ml-modules/flow-utils" at "/libs/flow-utils.xqy";
import module namespace hmc = "http://marklogic.com/holy/ml-modules/holy-management-constants" at "/constants/holy-management-constants.xqy";

declare namespace bs = "http://holy.arch.com/data/supplement/basic";
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
    let $card-num := flow:substring-between($content/uri, "/BasicChapter/Ag/", ".") => xs:int()
    let $output-format := if (fn:empty(map:get($options, "outputFormat"))) then "json" else map:get($options, "outputFormat")

    let $headers := flow:create-headers((), $options, "/tome/*.xml")
    let $instance := custom:create-instance($card-num, $output-format)

    let $envelope := flow:make-envelope($instance, $headers, (), $output-format)

    return $envelope
};

(:~
 : Creates instance
 :
 : @param $card-num - a cardinal number obtained from source uri
 : @param $options  - a map containing options
 :
 :)
declare function custom:create-instance(
        $card-number as xs:int,
        $output-format as xs:string
) as item()?
{
    let $source-uris :=
        for $uri in cts:uris((), (), cts:and-query((
            cts:collection-query(($hmc:XHTML-CONTENT-COLLECTION, $hmc:CURRENT-XHTML-CONTENT-VERSION)),
            cts:directory-query("/tome/", "infinity")
        )))
        let $chapter := fn:tokenize($uri, "/")[5]
        let $chapter := if ($chapter eq "Prolog") then 0 else xs:int($chapter)
        order by $chapter
        return $uri

    let $supplements :=
        if ($card-number eq 1)
        then custom:extract-dictionaries($source-uris, $output-format)
        else custom:extract-definitions($source-uris, $output-format)

    return if ($output-format = 'xml')
    then
    (:        ( :)
    (:            flow:get-info-element("BasicTome", $source-version),:)
        element bs:BasicSupplements {
            $supplements
        }
    (:        ) :)
    else
    (:        let $info := flow:get-info-node("BasicTome", $source-version):)
        json:object()
        (:        => map:with("info", $info):)
        => map:with("BasicSupplements", json:to-array($supplements))
};

declare function custom:extract-definitions
(
        $source-uris as xs:string*,
        $output-format as xs:string
)
{
    let $definition-nodes := $source-uris ! fn:doc(.)/x:body/child::x:div[@class eq 'definition-box']
    let $unique-definition-ids := fn:distinct-values($definition-nodes/@id)

    for $id in $unique-definition-ids
    let $definition-node := $definition-nodes[@id = $id][1]/child::node()[1]
    let $child-nodes := $definition-node/child::node()
    let $childs-count := fn:count($child-nodes)
    let $first-node-empty := fn:normalize-space($child-nodes[1]/xs:string(.)) eq ""
    let $first-node-txt-kind := xdmp:node-kind($child-nodes[1]) eq 'text'
    let $second-node-txt-kind := xdmp:node-kind($child-nodes[2]) eq 'text'
    let $definiendum :=
        if ($childs-count > 1 and $first-node-empty and fn:not($second-node-txt-kind))
        then $child-nodes[2]/xs:string(.) => flow:substring-before-if-contains($hmc:SUPP-SEP) => fn:normalize-space()
        else if ($childs-count > 1 and fn:not($first-node-empty) and fn:not($first-node-txt-kind))
        then $child-nodes[1]/xs:string(.) => flow:substring-before-if-contains($hmc:SUPP-SEP) => fn:normalize-space()
        else ()
    let $definiens :=
        if (fn:empty($definiendum))
        then $definition-node/xs:string(.)
        else fn:substring-after($definition-node/xs:string(.), $definiendum) => flow:substring-after-if-contains($hmc:SUPP-SEP) => fn:normalize-space()
    return
        if ($output-format eq 'xml')
        then
            element bs:definition {
                element bs:id {$id},
                if (fn:exists($definiendum)) then element bs:definiendum {$definiendum} else (),
                element bs:definiens {$definiens}
            }
        else
        (:            let $info := flow:get-info-node("BasicVerse", $source-version) :)
            let $definition := json:object()
            => map:with("id", $id)
            => map:with("definiens", $definiens)
            let $_ := if (fn:exists($definiendum)) then map:put($definition, "definiendum", $definiendum) else ()
            return json:object()
            (:            => map:with("info", $info) :)
            => map:with("definition", $definition)
};

declare function custom:extract-dictionaries
(
        $source-uris as xs:string*,
        $output-format as xs:string
)
{
    let $dictionary-nodes := $source-uris ! fn:doc(.)/x:body/child::x:div[@class eq 'dictionary-box']
    let $unique-dictionary-ids := fn:distinct-values($dictionary-nodes/@id)

    for $id in $unique-dictionary-ids
    let $dictionary-node := $dictionary-nodes[@id = $id][1]
    let $definiens := $dictionary-node/x:span[@class = 'entries'][1]/xs:string(.)
    let $definiendum := $dictionary-node/x:span[@class = 'entry-content'][1]/xs:string(.) => flow:substring-after-if-contains($hmc:SUPP-SEP) => fn:normalize-space()

    return
        if ($output-format eq 'xml')
        then
            (
                element bs:dictionary-entry {
                    element bs:id {$id},
                    if (fn:exists($definiendum)) then element bs:definiendum {$definiendum} else (),
                    element bs:definiens {$definiens}
                }
            )
        else
        (:            let $info := flow:get-info-node("BasicVerse", $source-version) :)
            let $dictionary-entry := json:object()
            => map:with("id", $id)
            => map:with("definiens", $definiens)
            let $_ := if (fn:exists($definiendum)) then map:put($dictionary-entry, "definiendum", $definiendum) else ()
            return json:object()
            (:            => map:with("info", $info) :)
            => map:with("dictionary-entry", $dictionary-entry)
};
