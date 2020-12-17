xquery version "1.0-ml";

(:~
 :
 :)
module namespace http-utils = "http://marklogic.com/holy/ml-modules/http-utils";

declare namespace http = 'xdmp:http';

declare private variable $DEFAULT-OPTIONS as element(http:options) :=
    <options xmlns="xdmp:http">
        <authentication method="basic">
            <username>admin</username>
            <password>admin</password>
        </authentication>
    </options>;

declare function http-utils:ml-resource-get
(
        $resource as xs:string,
        $parameters as map:map
) as item()*
{
    xdmp:http-get(http-utils:resource-uri($resource, $parameters), $DEFAULT-OPTIONS)
};

declare function http-utils:get-code
(
        $response as item()*
)
{
    $response[1]/http:code/xs:int(.)
};

declare function http-utils:get-message
(
        $response as item()*
)
{
    $response[1]/http:message/xs:string(.)
};

declare function http-utils:get-body
(
        $response as item()*
)
{
    $response[2]
};

declare private function http-utils:resource-uri
(
        $resource as xs:string,
        $parameters as map:map
)
{
    http-utils:build-uri('http://localhost:8111/LATEST/resources/' || $resource, $parameters)
};

declare private function http-utils:build-uri
(
        $endpoint as xs:string,
        $parameters as map:map
)
{
    let $parameters := fn:string-join((map:keys($parameters) ! (. || '=' || fn:encode-for-uri(map:get($parameters, .)))), '&amp;')
    return $endpoint || '?' || $parameters
};