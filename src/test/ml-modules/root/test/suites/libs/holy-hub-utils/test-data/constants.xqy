xquery version "1.0-ml";

module namespace tdc = "http://marklogic.com/holy/test-data/constants";

declare namespace ins = "xdmp:document-insert";

declare variable $tdc:TEST-COLLECTION as xs:string := 'holy-hub-utils-test-collection';
declare variable $tdc:TEST-DOC-URI as xs:string := '/test/holy-hub-utils/root.xml';
declare variable $tdc:TEST-DOC-ROOT as element(tdc:root) :=
    <tdc:root>
        <tdc:child>1</tdc:child>
        <tdc:child>2</tdc:child>
        <tdc:child>3</tdc:child>
    </tdc:root>;

declare variable $tdc:TEST-DOC-OPTIONS as element(ins:options) :=
    <ins:options>
        <ins:permissions>{xdmp:default-permissions()}</ins:permissions>
        <ins:collections>
            <ins:collection>{$tdc:TEST-COLLECTION}</ins:collection>
        </ins:collections>
    </ins:options>;