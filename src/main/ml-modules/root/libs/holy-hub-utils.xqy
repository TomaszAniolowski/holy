xquery version "1.0-ml";

module namespace hh = "http://marklogic.com/holy/ml-modules/holy-hub-utils";

declare function hh:read-from-db(
    $file-path as xs:string,
    $database-id as xs:unsignedLong
)
{
    hh:eval-in-db(function() {fn:doc($file-path)}, $database-id)
};

declare function hh:eval-in-db(
    $function as function() as item()*,
    $database-id as xs:unsignedLong
)
{
    xdmp:invoke-function(
        $function,
        <options xmlns="xdmp:eval">
            <database>{$database-id}</database>
            <commit>auto</commit>
            <update>auto</update>
        </options>
    )
};
