xquery version "1.0-ml";

module namespace tdc = "http://marklogic.com/holy/test-data/constants";

import module namespace fc = "http://marklogic.com/holy/ml-modules/flow-constants" at "/constants/flow-constants.xqy";
import module namespace bc = "http://marklogic.com/holy/ml-modules/bible-constants" at "/constants/bible-constants.xqy";

declare variable $tdc:TEST-COLLECTION as xs:string := 'tome-step-test-collection';
declare variable $tdc:CHAPTER-ENTITY-URI as xs:string := $fc:CHAPTER-BASE-URI || $bc:SIGLUM-IZ || $fc:URI-SEP || '1.xml';