xquery version "1.0-ml";

(:~
 : The holy-hub-utils.xqy library module contains useful functions to dealing with the holy hub.
 : It contains e.g. hh:eval-in-db() function that will evaluete function privded in the specific database.
 :)
module namespace hh = "http://marklogic.com/holy/ml-modules/holy-hub-utils";

(:~
 : Returns document node basis on the uri provided in the context of the database provided.
 :
 : @param $uri         - the uri document to read
 : @param $database-id - the database id
 :
 : @return the document node
 :)
declare function hh:read-from-db(
        $uri as xs:string,
        $database-id as xs:unsignedLong
) as document-node()
{
    hh:eval-in-db(function() {fn:doc($uri)}, $database-id)
};

(:~
 : Evaluates the function provided in context of the database provided.
 :
 : @param $function    - the function returning sequence of items
 : @param $database-id - the database id
 :
 : @return the output of the funciton provided
 :)
declare function hh:eval-in-db(
        $function as function() as item()*,
        $database-id as xs:unsignedLong
) as item()*
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
