xquery version "1.0-ml";

import module namespace hh = "http://marklogic.com/holy/ml-modules/holy-hub-utils" at "/libs/holy-hub-utils.xqy";
import module namespace hhc = "http://marklogic.com/holy/ml-modules/holy-hub-constants" at "/constants/holy-hub-constants.xqy";
import module namespace tdc = "http://marklogic.com/holy/test-data/constants" at "test-data/constants.xqy";

hh:eval-in-db(function(){
    xdmp:document-insert($tdc:TEST-DOC-URI, $tdc:TEST-DOC-ROOT, $tdc:TEST-DOC-OPTIONS)
}, $hhc:STAGING-DB-ID)
