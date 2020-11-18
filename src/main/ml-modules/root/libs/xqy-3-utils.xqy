xquery version "3.0";

module namespace xqy3 = 'http://marklogic.com/holy/ml-modules/xqy-3-utils';

declare namespace xpf = "http://www.w3.org/2005/xpath-functions";
declare namespace xdmp = 'http://marklogic.com/xdmp';

declare function xqy3:clean-content(
    $content as xs:string
) as xs:string
{
    let $content := fn:replace($content, ' ,', ',')
    let $analyze := fn:analyze-string($content, '([aąbcćdeęfghijklłmnńoóprsśtuvwxyzźż])(Pana|PANA)')
    let $_ :=
        if (fn:empty($analyze/xpf:match))
        then ()
        else
            for $match in $analyze/xpf:match
            let $group-1 := $match/xpf:group[@nr=1]/xs:string(.)
            let $group-2 := $match/xpf:group[@nr=2]/xs:string(.)
            let $replace-pattern := fn:concat($group-1, $group-2)
            let $replace-replacement := fn:string-join(($group-1, $group-2), ' ')
            let $replaced-content := fn:replace($content, $replace-pattern, $replace-replacement)
            return xdmp:set($content, $replaced-content)
    return $content
};
