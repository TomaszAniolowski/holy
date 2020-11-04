xquery version "1.0-ml";

module namespace hmc = "http://marklogic.com/holy/ml-modules/holy-management-constants";

declare variable $hmc:PISMOSWIETE-PL-BASE-URL as xs:string := "https://pismoswiete.pl";
declare variable $hmc:PISMOSWIETE-PL-API-URL as xs:string := $hmc:PISMOSWIETE-PL-BASE-URL || "/api";