xquery version "1.0-ml";

import module namespace test = "http://marklogic.com/test" at "/test/test-helper.xqy";
import module namespace hhc = "http://marklogic.com/holy/ml-modules/holy-hub-constants" at "/constants/holy-hub-constants.xqy";
import module namespace tdc = "http://marklogic.com/holy/test-data/constants" at "test-data/constants.xqy";

(
    test:load-test-file('Chapter-Est-1.xml', xdmp:database($hhc:CURRENT-DB-NAME), $tdc:CHAPTER-EST-01-URI, xdmp:default-permissions(), $tdc:TEST-COLLECTION),
    test:load-test-file('Chapter-Est-4.xml', xdmp:database($hhc:CURRENT-DB-NAME), $tdc:CHAPTER-EST-04-URI, xdmp:default-permissions(), $tdc:TEST-COLLECTION),
    test:load-test-file('Chapter-Est-10.xml', xdmp:database($hhc:CURRENT-DB-NAME),$tdc:CHAPTER-EST-10-URI, xdmp:default-permissions(), $tdc:TEST-COLLECTION),
    test:load-test-file('Chapter-Ne-3.xml', xdmp:database($hhc:CURRENT-DB-NAME), $tdc:CHAPTER-NE-03-URI, xdmp:default-permissions(), $tdc:TEST-COLLECTION),
    test:load-test-file('Chapter-Ne-11.xml', xdmp:database($hhc:CURRENT-DB-NAME), $tdc:CHAPTER-NE-11-URI, xdmp:default-permissions(), $tdc:TEST-COLLECTION),
    test:load-test-file('Chapter-Rdz-1.xml', xdmp:database($hhc:CURRENT-DB-NAME), $tdc:CHAPTER-RDZ-01-URI, xdmp:default-permissions(), $tdc:TEST-COLLECTION),
    test:load-test-file('Chapter-Rdz-2.xml', xdmp:database($hhc:CURRENT-DB-NAME), $tdc:CHAPTER-RDZ-02-URI, xdmp:default-permissions(), $tdc:TEST-COLLECTION),
    test:load-test-file('Chapter-Rdz-3.xml', xdmp:database($hhc:CURRENT-DB-NAME), $tdc:CHAPTER-RDZ-03-URI, xdmp:default-permissions(), $tdc:TEST-COLLECTION),
    test:load-test-file('Chapter-Rdz-5.xml', xdmp:database($hhc:CURRENT-DB-NAME), $tdc:CHAPTER-RDZ-05-URI, xdmp:default-permissions(), $tdc:TEST-COLLECTION),
    test:load-test-file('Chapter-Rdz-8.xml', xdmp:database($hhc:CURRENT-DB-NAME), $tdc:CHAPTER-RDZ-08-URI, xdmp:default-permissions(), $tdc:TEST-COLLECTION),
    test:load-test-file('Chapter-Rdz-10.xml', xdmp:database($hhc:CURRENT-DB-NAME), $tdc:CHAPTER-RDZ-10-URI, xdmp:default-permissions(), $tdc:TEST-COLLECTION),
    test:load-test-file('Chapter-Syr-1.xml', xdmp:database($hhc:CURRENT-DB-NAME), $tdc:CHAPTER-SYR-1-URI, xdmp:default-permissions(), $tdc:TEST-COLLECTION),
    test:load-test-file('Chapter-Syr-2.xml', xdmp:database($hhc:CURRENT-DB-NAME), $tdc:CHAPTER-SYR-2-URI, xdmp:default-permissions(), $tdc:TEST-COLLECTION),
    test:load-test-file('Chapter-Syr-3.xml', xdmp:database($hhc:CURRENT-DB-NAME), $tdc:CHAPTER-SYR-3-URI, xdmp:default-permissions(), $tdc:TEST-COLLECTION),
    test:load-test-file('Chapter-Syr-Prolog.xml', xdmp:database($hhc:CURRENT-DB-NAME), $tdc:CHAPTER-SYR-PROLOG-URI, xdmp:default-permissions(), $tdc:TEST-COLLECTION)
)