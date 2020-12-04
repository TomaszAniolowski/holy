xquery version "3.0";

(:~
 : The xqy-3-utils.xqy library module contains all functions
 : that will need version 3 of the xquery language. It is separate module
 : that shouldn't be imported directly by the step modules or the services.
 : It should be imported only by the other *-utils.xqy modules
 : to avoid the existence of multiple library modules with the similar purpose.
 :)
module namespace xqy3 = 'http://marklogic.com/holy/ml-modules/xqy-3-utils';

declare namespace xpf = "http://www.w3.org/2005/xpath-functions";
declare namespace xdmp = 'http://marklogic.com/xdmp';

declare variable $LETTERS-REGEX as xs:string := 'A-Za-zĄĆĘŁŃÓŚŹŻąćęłńóśźż';

(:~
 : Clears the content (of verse or pericope title) provided from possible mistakes.
 :
 : @param $content - the content of the verse or the pericope title
 :
 : @return the content without mistakes
 :)
declare function xqy3:clear-content(
        $content as xs:string
) as xs:string
{
    let $content := fn:replace($content, ' ,', ',')
    let $regex := '([' || $LETTERS-REGEX || '])(Pana|PANA)'
    let $analyze := fn:analyze-string($content, $regex)
    let $_ :=
        if (fn:empty($analyze/xpf:match))
        then ()
        else
            for $match in $analyze/xpf:match
            let $group-1 := $match/xpf:group[@nr = 1]/xs:string(.)
            let $group-2 := $match/xpf:group[@nr = 2]/xs:string(.)
            let $replace-pattern := fn:concat($group-1, $group-2)
            let $replace-replacement := fn:string-join(($group-1, $group-2), ' ')
            let $replaced-content := fn:replace($content, $replace-pattern, $replace-replacement)
            return xdmp:set($content, $replaced-content)
    return $content
};
