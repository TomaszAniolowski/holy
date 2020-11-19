xquery version '1.0-ml';

(:~
 : The flow-constants.xqy library module contains constants
 : releted to the flow, e.g. entity types and document collections.
 :)
module namespace fc = 'http://marklogic.com/holy/ml-modules/flow-constants';

(: ENTITY NAMES :)
declare variable $fc:CHAPTER-ENTITY as xs:string := 'Chapter';
declare variable $fc:VERSE-ENTITY as xs:string := 'Verse';
declare variable $fc:TOME-ENTITY as xs:string := 'Tome';
declare variable $fc:PERICOPE-ENTITY as xs:string := 'Pericope';
declare variable $fc:SUBTITLE-ENTITY as xs:string := 'Subtitle';
declare variable $fc:GLOSSARY-ENTITY as xs:string := 'Glossary';
declare variable $fc:SUPPLEMENT-ENTITY as xs:string := 'Supplement';

(: VERSIONS :)
declare variable $fc:CURRENT-XHTML-CONTENT-VERSION as xs:string := 'v1';
declare variable $fc:ENTITY-VERSION-1-0-0 as xs:string := '1.0.0';
declare variable $fc:CHAPTER-VERSION as xs:string := $fc:ENTITY-VERSION-1-0-0;
declare variable $fc:VERSE-VERSION as xs:string := $fc:ENTITY-VERSION-1-0-0;
declare variable $fc:TOME-VERSION as xs:string := $fc:ENTITY-VERSION-1-0-0;
declare variable $fc:PERICOPE-VERSION as xs:string := $fc:ENTITY-VERSION-1-0-0;
declare variable $fc:SUBTITLE-VERSION as xs:string := $fc:ENTITY-VERSION-1-0-0;
declare variable $fc:GLOSSARY-VERSION as xs:string := $fc:ENTITY-VERSION-1-0-0;
declare variable $fc:SUPPLEMENT-VERSION as xs:string := $fc:ENTITY-VERSION-1-0-0;

(: ENTITY NAMESPACE URIS :)
declare variable $fc:ENTITIES-NS-BASE-URI as xs:string := 'http://holy.arch.com/holy-entities/';
declare variable $fc:CHAPTER-NS-URI as xs:string := $fc:ENTITIES-NS-BASE-URI || fn:lower-case($fc:CHAPTER-ENTITY);
declare variable $fc:VERSE-NS-URI as xs:string := $fc:ENTITIES-NS-BASE-URI || fn:lower-case($fc:VERSE-ENTITY);
declare variable $fc:TOME-NS-URI as xs:string := $fc:ENTITIES-NS-BASE-URI || fn:lower-case($fc:TOME-ENTITY);
declare variable $fc:PERICOPE-NS-URI as xs:string := $fc:ENTITIES-NS-BASE-URI || fn:lower-case($fc:PERICOPE-ENTITY);
declare variable $fc:SUBTITLE-NS-URI as xs:string := $fc:ENTITIES-NS-BASE-URI || fn:lower-case($fc:SUBTITLE-ENTITY);
declare variable $fc:GLOSSARY-NS-URI as xs:string := $fc:ENTITIES-NS-BASE-URI || fn:lower-case($fc:GLOSSARY-ENTITY);
declare variable $fc:SUPPLEMENT-NS-URI as xs:string := $fc:ENTITIES-NS-BASE-URI || fn:lower-case($fc:SUPPLEMENT-ENTITY);

(: ENTITY NAMESPACE PREFIX :)
declare variable $fc:CHAPTER-NS-PREFIX as xs:string := 'ch';
declare variable $fc:VERSE-NS-PREFIX as xs:string := 'v';
declare variable $fc:TOME-NS-PREFIX as xs:string := 't';
declare variable $fc:PERICOPE-NS-PREFIX as xs:string := 'p';
declare variable $fc:SUBTITLE-NS-PREFIX as xs:string := 'st';
declare variable $fc:GLOSSARY-NS-PREFIX as xs:string := 'gloss';
declare variable $fc:SUPPLEMENT-NS-PREFIX as xs:string := 'supp';

(: ENTITY BASE URIS :)
declare variable $fc:XHTML-DATA-BASE-URI as xs:string := '/tome/';
declare variable $fc:CHAPTER-BASE-URI as xs:string := '/Chapter/';
declare variable $fc:TOME-BASE-URI as xs:string := '/Tome/';
declare variable $fc:GLOSSARY-BASE-URI as xs:string := '/Glossary/';

(: ENTITY PARAMETERS :)
declare variable $fc:DHF-TYPE as xs:string := '$type';
declare variable $fc:DHF-VERSION as xs:string := '$version';
declare variable $fc:DHF-NS as xs:string := '$namespace';
declare variable $fc:DHF-NS-PREFIX as xs:string := '$namespacePrefix';
declare variable $fc:DHF-REF as xs:string := '$ref';

declare variable $fc:TESTAMENT as xs:string := 'testament';
declare variable $fc:TOME as xs:string := 'tome';
declare variable $fc:CHAPTER as xs:string := 'chapter';
declare variable $fc:VERSES as xs:string := 'verses';
declare variable $fc:PERICOPES as xs:string := 'pericopes';
declare variable $fc:SUBTITLES as xs:string := 'subtitles';
declare variable $fc:DEFINITION as xs:string := 'definition';
declare variable $fc:DEFINITIONS as xs:string := 'definitions';
declare variable $fc:DICTIONARY as xs:string := 'dictionary';

declare variable $fc:ID as xs:string := 'id';
declare variable $fc:SIGLUM as xs:string := 'siglum';
declare variable $fc:TYPE as xs:string := 'type';
declare variable $fc:NAME as xs:string := 'name';
declare variable $fc:TITLE as xs:string := 'title';
declare variable $fc:NUMBER as xs:string := 'number';
declare variable $fc:SUB-NUMBER as xs:string := 'sub-number';
declare variable $fc:CONTENT as xs:string := 'content';
declare variable $fc:DEFINIENDUM as xs:string := 'definiendum';
declare variable $fc:DEFINIENS as xs:string := 'definiens';
declare variable $fc:FIRST-CHAPTER as xs:string := 'first-chapter';
declare variable $fc:LAST-CHAPTER as xs:string := 'last-chapter';

(: SEPARATORS :)
declare variable $fc:URI-SEP as xs:string := '/';
declare variable $fc:COLL-SEP as xs:string := '-'; (: it is different than $fc:SUPP-SEP :)
declare variable $fc:SUPP-SEP as xs:string := '–'; (: it is different than $fc:COLL-SEP :)

(: COLLECTIONS :)
declare variable $fc:LATEST-COLLECTION as xs:string := 'latest';
declare variable $fc:XHTML-CONTENT-COLLECTION as xs:string := 'holy-chapter-xhtml-body';
declare variable $fc:HOLY-DATA-COLLECTION as xs:string := 'holy-data';
declare variable $fc:BASIC-DATA-COLLECTION as xs:string := 'holy-basic-data';
declare variable $fc:BASIC-CHAPTER-COLLECTION as xs:string := 'basic-chapter';
declare variable $fc:HOLY-DATA-DEFAULT-COLLS as xs:string* := (xdmp:default-collections(), $fc:HOLY-DATA-COLLECTION, $fc:CURRENT-XHTML-CONTENT-VERSION, $fc:LATEST-COLLECTION);

declare variable $fc:PISMOSWIETE-PL-BASE-URL as xs:string := 'https://pismoswiete.pl';
declare variable $fc:PISMOSWIETE-PL-API-URL as xs:string := $fc:PISMOSWIETE-PL-BASE-URL || '/api';