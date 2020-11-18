xquery version '1.0-ml';

module namespace flow = 'http://marklogic.com/holy/ml-modules/flow-utils';

import module namespace hmc = 'http://marklogic.com/holy/ml-modules/holy-management-constants' at '/constants/holy-management-constants.xqy';
import module namespace hhc = "http://marklogic.com/holy/ml-modules/holy-hub-constants" at "/constants/holy-hub-constants.xqy";
import module namespace hh = 'http://marklogic.com/holy/ml-modules/holy-hub-utils' at '/libs/holy-hub-utils.xqy';
import module namespace xqy3 = 'http://marklogic.com/holy/ml-modules/xqy-3-utils' at '/libs/xqy-3-utils.xqy';

declare namespace es = 'http://marklogic.com/entity-services';

declare variable $roman-numerals as map:map :=
    map:new()
    => map:with('1', 'I')
    => map:with('2', 'II')
    => map:with('3', 'III')
    => map:with('4', 'IV')
    => map:with('5', 'V')
    => map:with('6', 'VI')
    => map:with('7', 'VII')
    => map:with('8', 'VIII')
    => map:with('9', 'IX')
    => map:with('10', 'X');

declare function flow:get-roman-numeral-from-int(
        $arabic-numeral as xs:int
) as xs:string
{
    get-roman-numeral(xs:string($arabic-numeral))
};

declare function flow:get-roman-numeral(
        $arabic-numeral as xs:string
) as xs:string
{
    let $arabic-int := xs:int($arabic-numeral)
    return if ($arabic-int ge 0 and $arabic-int le 10)
    then map:get($roman-numerals, $arabic-numeral)
    else 'OUT_OF_RANGE'
};

declare function flow:generate-unique-id(
        $source-value as xs:string
) as xs:string
{
    $source-value => fn:lower-case() => fn:replace(" ", "") => fn:normalize-space() => xdmp:md5()
};

declare function flow:get-xhtml-source-uris(
) as xs:string*
{
    let $func := function() {
        for $uri in cts:uris((), (), cts:and-query((
            cts:collection-query(($hmc:XHTML-CONTENT-COLLECTION, $hmc:CURRENT-XHTML-CONTENT-VERSION)),
            cts:directory-query("/tome/", "infinity")
        )))
        let $chapter := fn:tokenize($uri, "/")[5]
        let $chapter := if ($chapter eq "Prolog") then 0 else xs:int($chapter)
        order by $chapter
        return $uri
    }
    return hh:eval-in-db($func, $hhc:STAGING-DB-ID)
};

declare function flow:clean-content(
    $content as xs:string
) as xs:string
{
    xqy3:clean-content($content) => fn:normalize-space()
};

declare function flow:make-envelope(
        $content as item()?,
        $headers as item()?,
        $triples as item()?,
        $output-format as xs:string
) as node()*
{
    if ($output-format = 'xml') then
        document {
            <envelope xmlns='http://marklogic.com/entity-services'>
                {$headers}
                <triples>{$triples}</triples>
                <instance>{$content}</instance>
            </envelope>
        }
    else
        let $envelope := json:object()
        => map:with('headers', $headers)
        => map:with('triples', $triples)
        => map:with('instance', $content)

        let $wrapper := json:object()
        => map:with('envelope', $envelope)
        return
            xdmp:to-json($wrapper)
};

(:~
 : Create Headers
 :
 : @param $content      - the raw content
 : @param $options      - a map containing options
 : @param $source-uris   - a source-uri
 :
 :)
(:declare function flow:create-headers( :)
(:        $content as item()?,:)
(:        $options as map:map,:)
(:        $source-uris as xs:string*:)
(:) as node()*:)
(:{ :)
(:    let $output-format := if (fn:empty(map:get($options, 'outputFormat'))) then 'xml' else map:get($options, 'outputFormat'):)
(:    let $current-date-time := fn:current-dateTime():)
(:    return:)
(:        if ($output-format eq 'xml'):)
(:        then:)
(:            element es:headers {:)
(:                element es:sourceUris {:)
(:                    $source-uris ! element es:sourceUri {.}:)
(:                },:)
(:                element es:createdOn {$current-date-time}:)
(:            }:)
(:        else:)
(:            object-node {:)
(:            'sourceUris': array-node {$source-uris},:)
(:            'createdOn': $current-date-time:)
(:            }:)
(:};:)

declare function flow:create-headers(
        $source-uris as xs:string*,
        $options as map:map
) as node()*
{
    let $output-format := if (fn:empty(map:get($options, 'dataFormat'))) then 'xml' else map:get($options, 'dataFormat')
    let $current-date-time := fn:current-dateTime()
    return
        if ($output-format eq 'xml')
        then
            element es:headers {
                element es:sourceUris {
                    $source-uris ! element es:sourceUri {.}
                },
                element es:createdOn {$current-date-time}
            }
        else
            object-node {
            'sourceUris': array-node {$source-uris},
            'createdOn': $current-date-time
            }
};

declare function flow:make-reference-object(
        $type as xs:string,
        $ref as xs:string,
        $namespace-prefix as xs:string,
        $namespace as xs:string
) as map:map
{
    let $reference := json:object()
    => map:with('$type', $type)
    => map:with('$ref', $ref)
    => map:with('$namespacePrefix', 'v')
    => map:with('$namespace', 'http://holy.arch.com/data/verse')

    return $reference
};

declare function flow:get-info-node(
        $title as xs:string,
        $version as xs:string
) as object-node()
{
    object-node {
    'title' : $title,
    'version' : $version
    }
};

declare function flow:get-info-element(
        $title as xs:string,
        $version as xs:string
) as element(es:info)
{
    element es:info {
        element es:title {$title},
        element es:version {$version}
    }
};

declare function flow:write(
        $id as xs:string,
        $envelope as item(),
        $options as map:map
) as empty-sequence()
{
    let $permissions := (xdmp:default-permissions(), xdmp:permission('data-hub-operator', 'read'), xdmp:permission('data-hub-operator', 'update'))
    let $collections := ($hmc:HOLY-DATA-DEFAULT-COLLS, map:get($options, 'entity'), map:get($options, 'custom-collections'))
    let $_ := xdmp:log("Writing " || $id || "with colls: " || $collections || ", and perms: " || $permissions, 'info')
    return xdmp:document-insert($id, $envelope, $permissions, $collections)
};

declare function flow:get-or-else
(
        $optional as item()?,
        $alternative as item()
)
{
    if ($optional) then $optional else $alternative
};

declare function flow:substring-between
(
        $source as xs:string,
        $after-token as xs:string,
        $before-token as xs:string
)
{
    fn:substring-after($source, $after-token) => fn:substring-before($before-token)
};

declare function flow:substring-before-if-contains
(
        $source as xs:string,
        $before-token as xs:string
)
{
    if (fn:contains($source, $before-token))
    then fn:substring-before($source, $before-token)
    else $source
};

declare function flow:substring-after-if-contains
(
        $source as xs:string,
        $after-token as xs:string
)
{
    if (fn:contains($source, $after-token))
    then fn:substring-after($source, $after-token)
    else $source
};

