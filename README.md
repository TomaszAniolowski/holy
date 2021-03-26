# Holy
The project showing the use of Data Hub Framework version 5 for data migration. 
The data source in this case is the website pismoswiete.pl with the content of the Bible. 
After starting the flow of individual entities (Tome, Chapter, Glossary), 
we get harmonized data stored in the database. 
Then, on port 8111, we can query the database using the /get-verses endpoint. 
In response, we get selected verses (determined by the siglum parameter) in JSON format.

## Prerequisites
* MarkLogic 10  
`https://docs.marklogic.com/guide/installation/procedures#id_28962`

* Gradle 4.10.2  
`https://gradle.org/releases/`

* Java 8  
`https://www.oracle.com/sg/java/technologies/javase/javase-jdk8-downloads.html`

## Installation
* Clone the repository  
`git clone https://github.com/TomaszAniolowski/holy.git`
* Initialize DHF project  
`gradle hubInit`
* Deploy app  
`gradle mlDeploy`

## Run flows
* Ingest raw data into the database (use your personal credentials to pismoswiete.pl)  
`gradle ingestXhtml '-Pusername=<username>' -Ppassword=<password> --no-daemon`
* Run Chapter flow  
`gradle hubRunFlow -PflowName=psw -PbatchSize=4 -PthreadCount=12 -PshowOptions=true '-Psteps="1"' '-PjobId="chapter-job"' -i`
* Run Chapter flow  
`gradle hubRunFlow -PflowName=psw -PbatchSize=4 -PthreadCount=12 -PshowOptions=true '-Psteps="2"' '-PjobId="tom-job"' -i`
* Run Chapter flow  
`gradle hubRunFlow -PflowName=psw -PbatchSize=4 -PthreadCount=12 -PshowOptions=true '-Psteps="3"' '-PjobId="glossary-job"' -i`

## Use /get-verses endpoint
* It accepts just one parameter: rs:siglum
* Examples of use:  
`http://localhost:8111/LATEST/resources/get-verses?rs:siglum=Rdz`  
`http://localhost:8111/LATEST/resources/get-verses?rs:siglum=Rdz_11`  
`http://localhost:8111/LATEST/resources/get-verses?rs:siglum=Rdz%2011`  
`http://localhost:8111/LATEST/resources/get-verses?rs:siglum=Rdz_11,1`  
`http://localhost:8111/LATEST/resources/get-verses?rs:siglum=Rdz_11,1n`  
`http://localhost:8111/LATEST/resources/get-verses?rs:siglum=Rdz_11,1nn`  
`http://localhost:8111/LATEST/resources/get-verses?rs:siglum=Rdz_11,1-3`  
`http://localhost:8111/LATEST/resources/get-verses?rs:siglum=Rdz_11-13`  
`http://localhost:8111/LATEST/resources/get-verses?rs:siglum=Rdz_11,2-3._5-6;_12,4;_15,7nn`

* Example of response body (rs:siglum=Iz_11,2-3._5-6;_12,4):
```json
{
   "tome": "Iz",
   "testament": "Old Testament",
   "chapters": [
     {
       "number": "11",
       "verses": [
         {
           "number": "2",
           "content": {
             "I": "Spocznie na nim duch Pana,",
             "II": "duch mądrości i rozumu,",
             "III": "duch rady i męstwa,",
             "IV": "duch znajomości i bojaźni Pana ."
           }
         },
         {
           "number": "3",
           "content": {
             "I": "Upodoba sobie bojaźń Pana .",
             "II": "Nie będzie sądził z pozorów",
             "III": "ani wyrokował według pogłosek,"
           }
         },
         {
           "number": "5",
           "content": {
             "I": "Sprawiedliwość będzie pasem na jego biodrach,",
             "II": "a wierność pasem na jego lędźwiach!"
           }
         },
         {
           "number": "6",
           "content": {
             "I": "Wtedy wilk będzie przebywał z owieczką,",
             "II": "pantera ułoży się obok koźlęcia,",
             "III": "cielę z lwem razem paść się będą,",
             "IV": "a mały chłopiec będzie je prowadził."
           }
         }
       ]
     },
     {
       "number": "12",
       "verses": [
         {
           "number": "4",
           "content": {
             "I": "W tym dniu tak będziecie mówili:",
             "II": "„Sławcie Pana, wzywajcie Jego imienia,",
             "III": "głoście Jego dzieła wśród narodów.",
             "IV": "Rozgłaszajcie, że Jego imię jest wzniosłe!"
           }
         }
       ]
     },
     {
       "number": "15",
       "verses": [
         {
           "number": "7",
           "content": {
             "I": "Dlatego swój dorobek",
             "II": "i wszystko, co zgromadzili,",
             "III": "przenoszą nad Potok Wierzbowy."
           }
         },
         {
           "number": "8",
           "content": {
             "I": "Tak! Krzyk obiega",
             "II": "granice Moabu.",
             "III": "Po Eglaim słychać jego lament,",
             "IV": "aż po Beer-Elim jego zawodzenie."
           }
         },
         {
           "number": "9",
           "content": {
             "I": "Wody Dimonu są pełne krwi,",
             "II": "gdyż dalsze klęski sprowadzam na Dimon,",
             "III": "lwa na uchodźców z Moabu",
             "IV": "i na ocalałych w kraju."
           }
         }
       ]
     }
   ]
 }
```