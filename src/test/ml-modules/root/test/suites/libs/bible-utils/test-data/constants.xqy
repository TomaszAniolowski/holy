xquery version "1.0-ml";

module namespace tdc = "http://marklogic.com/holy/test-data/constants";

import module namespace fc = "http://marklogic.com/holy/ml-modules/flow-constants" at "/constants/flow-constants.xqy";
import module namespace bc = "http://marklogic.com/holy/ml-modules/bible-constants" at "/constants/bible-constants.xqy";

declare variable $tdc:TEST-COLLECTION as xs:string := 'bible-utils-test-collection';
declare variable $tdc:CHAPTER-EST-01-URI as xs:string := $fc:CHAPTER-BASE-URI || $bc:SIGLUM-EST || $fc:URI-SEP || '1.xml';
declare variable $tdc:CHAPTER-EST-04-URI as xs:string := $fc:CHAPTER-BASE-URI || $bc:SIGLUM-EST || $fc:URI-SEP || '4.xml';
declare variable $tdc:CHAPTER-EST-10-URI as xs:string := $fc:CHAPTER-BASE-URI || $bc:SIGLUM-EST || $fc:URI-SEP || '10.xml';
declare variable $tdc:CHAPTER-NE-03-URI as xs:string := $fc:CHAPTER-BASE-URI || $bc:SIGLUM-NE || $fc:URI-SEP || '3.xml';
declare variable $tdc:CHAPTER-NE-11-URI as xs:string := $fc:CHAPTER-BASE-URI || $bc:SIGLUM-NE || $fc:URI-SEP || '11.xml';
declare variable $tdc:CHAPTER-RDZ-01-URI as xs:string := $fc:CHAPTER-BASE-URI || $bc:SIGLUM-RDZ || $fc:URI-SEP || '1.xml';
declare variable $tdc:CHAPTER-RDZ-02-URI as xs:string := $fc:CHAPTER-BASE-URI || $bc:SIGLUM-RDZ || $fc:URI-SEP || '2.xml';
declare variable $tdc:CHAPTER-RDZ-03-URI as xs:string := $fc:CHAPTER-BASE-URI || $bc:SIGLUM-RDZ || $fc:URI-SEP || '3.xml';
declare variable $tdc:CHAPTER-RDZ-05-URI as xs:string := $fc:CHAPTER-BASE-URI || $bc:SIGLUM-RDZ || $fc:URI-SEP || '5.xml';
declare variable $tdc:CHAPTER-RDZ-08-URI as xs:string := $fc:CHAPTER-BASE-URI || $bc:SIGLUM-RDZ || $fc:URI-SEP || '8.xml';
declare variable $tdc:CHAPTER-RDZ-10-URI as xs:string := $fc:CHAPTER-BASE-URI || $bc:SIGLUM-RDZ || $fc:URI-SEP || '10.xml';
declare variable $tdc:CHAPTER-SYR-1-URI as xs:string := $fc:CHAPTER-BASE-URI || $bc:SIGLUM-SYR || $fc:URI-SEP || '1.xml';
declare variable $tdc:CHAPTER-SYR-2-URI as xs:string := $fc:CHAPTER-BASE-URI || $bc:SIGLUM-SYR || $fc:URI-SEP || '2.xml';
declare variable $tdc:CHAPTER-SYR-3-URI as xs:string := $fc:CHAPTER-BASE-URI || $bc:SIGLUM-SYR || $fc:URI-SEP || '3.xml';
declare variable $tdc:CHAPTER-SYR-PROLOG-URI as xs:string := $fc:CHAPTER-BASE-URI || $bc:SIGLUM-SYR || $fc:URI-SEP || 'Prolog.xml';