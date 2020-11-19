xquery version '1.0-ml';

(:~
 : The flow-utils.xqy library module contains many of useful functions with different aims.
 : The common nature of the functions is that they are dircetly related to the entities.
 : On the one hand it contains such functions as flow:create-headers() ot flow:make-reference-object()
 : that returns specific nodes that will be a part of es:envelope structure. On the other hand
 : it contains such functions as flow:substring-before-if-contains(), flow:get-or-else() or flow:clear-content()
 : that will be useful to build value of the entity properties.
 :)
module namespace flow = 'http://marklogic.com/holy/ml-modules/flow-utils';

import module namespace fc = 'http://marklogic.com/holy/ml-modules/flow-constants' at '/constants/flow-constants.xqy';
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

(:~
 : Creates headers for entity instance using parameters provided.
 :
 : @param $source-uris - the source uris of the instance
 : @param $options     - the options map
 :
 : @return the headers node accoring to the data format stored by options map
 :)
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
                element es:createdOn {$current-date-time},
                element es:sourceUris {
                    $source-uris ! element es:sourceUri {.}
                }
            }
        else
            object-node {
            'createdOn': $current-date-time,
            'sourceUris': array-node {$source-uris}
            }
};

(:~
 : Creates reference to the external entity instance.
 :
 : @param $type             - the type of the external entity
 : @param $ref              - the reference to the external entity instance (the primary key)
 : @param $namespace-prefix - the namespace prefix of the external entity
 : @param $namespace        - the namespace uri of the external entity
 :
 : @return the reference object
 :)
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
    => map:with('$namespacePrefix', $namespace-prefix)
    => map:with('$namespace', $namespace)

    return $reference
};

(:~
 : Generates md5 hash from the source value provided after removing the spaces and lower-casing.
 :
 : @param $source-value - the source value
 :
 : @return the unique id in form of the md5 hash
 :)
declare function flow:generate-unique-id(
        $source-value as xs:string
) as xs:string
{
    $source-value => fn:lower-case() => fn:replace(" ", "") => fn:normalize-space() => xdmp:md5()
};

(:~
 : Clears the content (of verse or pericope title) provided from possible mistakes using xqy3 library. Additionally
 : it normalizes output of the xqy3:clear-content() function.
 :
 : @param $content - the content of the verse or the pericope title
 :
 : @return the content without mistakes
 :)
declare function flow:clear-content(
        $content as xs:string
) as xs:string
{
    xqy3:clear-content($content) => fn:normalize-space()
};

(:~
 : Retrieves all uris of the xhtml source documents.
 :
 : @return the sequence of source xhtml document uris
 :)
declare function flow:get-xhtml-source-uris(
) as xs:string*
{
    let $func := function() {
        for $uri in cts:uris((), (), cts:and-query((
            cts:collection-query(($fc:XHTML-CONTENT-COLLECTION, $fc:CURRENT-XHTML-CONTENT-VERSION)),
            cts:directory-query("/tome/", "infinity")
        )))
        let $chapter := fn:tokenize($uri, "/")[5]
        let $chapter := if ($chapter eq "Prolog") then 0 else xs:int($chapter)
        order by $chapter
        return $uri
    }
    return hh:eval-in-db($func, $hhc:STAGING-DB-ID)
};

(:~
 : Returns the first parameter value if it is not empty and the second parameter value if the first parameter is empty.
 :
 : @param $optional    - the initial value
 : @param $alternative - the alternative value
 :
 : @return one of the non-empty value provided
 :)
declare function flow:get-or-else
(
        $optional as item()?,
        $alternative as item()
) as item()
{
    if ($optional) then $optional else $alternative
};

(:~
 : Returns roman equivalent of the integer value of the arabic numeral provided.
 :
 : @param $arabic-numeral - the integer value of the arabic numeral
 :
 : @return the string value of the roman numeral
 :)
declare function flow:get-roman-numeral-from-int(
        $arabic-numeral as xs:int
) as xs:string
{
    flow:get-roman-numeral(xs:string($arabic-numeral))
};

(:~
 : Returns roman equivalent of the string value of the arabic numeral provided.
 :
 : @param $arabic-numeral - the string value of the arabic numeral
 :
 : @return the string value of the roman numeral
 :)
declare function flow:get-roman-numeral(
        $arabic-numeral as xs:string
) as xs:string
{
    let $arabic-int := xs:int($arabic-numeral)
    return if ($arabic-int ge 0 and $arabic-int le 10)
    then map:get($roman-numerals, $arabic-numeral)
    else 'OUT_OF_RANGE'
};

(:~
 : Returns the fn:substring-before() function output if the $input parameter contains the $before parameter.
 : Otherwise it returns the $input parameter value.
 :
 : @param $input  - the source string value
 : @param $before - the before token
 :
 : @return the fn:substring-before() function output or the $input parameter value
 :)
declare function flow:substring-before-if-contains
(
        $input as xs:string,
        $before as xs:string
)
{
    if (fn:contains($input, $before))
    then fn:substring-before($input, $before)
    else $input
};

(:~
 : Returns the fn:substring-after() function output if the $input parameter contains the $after parameter.
 : Otherwise it returns the $input parameter value.
 :
 : @param $input - the source string value
 : @param $after - the after token
 :
 : @return the fn:substring-after() function output or the $input parameter value
 :)
declare function flow:substring-after-if-contains
(
        $input as xs:string,
        $after as xs:string
)
{
    if (fn:contains($input, $after))
    then fn:substring-after($input, $after)
    else $input
};

(:~
 : Returns the $input parameter part between the $after parameter value and the $before parameter value
 :
 : @param $input  - the source string value
 : @param $after  - the after token
 : @param $before - the before token
 :
 : @return the $input parameter part
 :)
declare function flow:substring-between
(
        $input as xs:string,
        $after as xs:string,
        $before as xs:string
)
{
    fn:substring-after($input, $after) => fn:substring-before($before)
};

