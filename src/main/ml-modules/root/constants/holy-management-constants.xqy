xquery version "1.0-ml";

module namespace hmc = "http://marklogic.com/holy/ml-modules/holy-management-constants";

declare variable $hmc:CURRENT-XHTML-CONTENT-VERSION as xs:string := "v1";

(: COLLECTIONS :)
declare variable $hmc:COLL-SEP as xs:string := "-";
declare variable $hmc:XHTML-CONTENT-COLLECTION as xs:string := "holy-chapter-xhtml-body";
declare variable $hmc:BASIC-DATA-COLLECTION as xs:string := "holy-basic-data";
declare variable $hmc:BASIC-CHAPTER-COLLECTION as xs:string := "basic-chapter";

declare variable $hmc:PISMOSWIETE-PL-BASE-URL as xs:string := "https://pismoswiete.pl";
declare variable $hmc:PISMOSWIETE-PL-API-URL as xs:string := $hmc:PISMOSWIETE-PL-BASE-URL || "/api";