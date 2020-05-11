module namespace  page = "http://www.page.fr";
import module namespace hw = 'http://www.page.fr' at 'index.xqm';
(:Nom: Hu:)
(:Prénom: Wei:)
(:Faculté: M2 Traitement automatique de la langue:)

declare    (:une:)
  %rest:path("/Historia")
  %output:method("xhtml")
  function page:Historia() 
  {
    <html>
      <head>
      <link type="text/css" rel="stylesheet" href="/static/historia.css"/>
      </head> 
      <body>
       <div id="header">Historia</div>
       <div id="menuLeft" >
        <a class="bouton" href="/HistoriaConsult">Consultez</a>  
         <div id="google"> 
            <form id="Historia" method="POST" action="updateHistoria"> 
              <p><label>Div2:</label><input type="text" name="Div2" placeholder="saisissez votre donnée1 ..."/></p>
              <p><label>Div1:</label><input type="text" name="Div1" placeholder="saisissez votre donnée2..."/></p>
              <p><label>Div4:</label><input type="text" name="Div4" placeholder=":"/></p>
              <p><label>Div3:</label><input type="text" name="Div3" placeholder="saisissez votre Titre..."/></p>
              <p><label>Text:</label><input type="text" name="Text" placeholder="saisissez votre article..."/></p>
              <p><label>ID:</label><input type="text" name="ID" placeholder="saisissez le numéro"/></p>
            <input class="bouton" type="submit"/>
            </form> 
            <h3>votre identifiant de session est {session:id()}</h3> (:afficher des mot de pass correct chaque navigateur est diffirent:)
           </div>
          </div>
         <div id="contenu">
         </div>
         
       </body>
    </html>
  };
  
  
  
declare
  %updating
  %rest:path("/updateHistoria")
  %rest:POST
  %rest:query-param("Div2","{$Div2}","")
  %rest:query-param("Div1","{$Div1}","")
  %rest:query-param("Div4","{$Div4}","")
  %rest:query-param("Div3","{$Div3}","")
  %rest:query-param("Text","{$Text}","")
  %rest:query-param("ID","{$ID}","")
  %output:method("xhtml")
  function page:update($Div2, $Div1, $Div4, $Div3, $Text, $ID)
  {
    let $RECORD :=
      <RECORD date="{current-dateTime()}">
      <Div2>{$Div2}</Div2>
      <Div1>{$Div1}</Div1>
      <Div4>{$Div4}</Div4>
      <Div3>{$Div3}</Div3>
      <Text>{$Text}</Text>
      <ID>{$ID}</ID>
      </RECORD>
    
    let $validate := validate:xsd-info($RECORD,'/Users/apple/Downloads/basex/appAnnuaireXqM2/historia.xsd')
      
    return 
    
      insert node $RECORD into db:open('HistoriaSchlastica')/RECORDS
    ,
    update:output (web:redirect('/Historia'))
    
}; 
   
declare (:deuxième:)
  %rest:path("/HistoriaConsult")
  %output:method("xhtml")
  function page:HistoriaConsult()
  {   
    <html>
      <head>
        <link type="text/css" rel="stylesheet" href="/static/historia.css"/>
       </head>
      <body>
        <div id="header">Historia</div>
        <div id="menuLeft"><a href="/Historia">Retour</a></div>
        <div id="contenu">
      {
        for $x in db:open('HistoriaSchlastica')/RECORDS /RECORD
        return
        <div class="RECORD">
        <div class="date">{data($x/@date)}</div>
        <div class="id">{data($x/@id)}</div>
          <div class="Div2">{$x/Div2}</div>
          <div class="Div1">{$x/Div1}</div>
          <div class="Div4">{$x/Div4}</div>
          <div class="Div3">{$x/Div3}</div>
          <div class="Text">{$x/Text}</div>
          <div class="Text">{$x/ID}</div>
          <div id="menuFloat">
          <div><a class="bouton" href="/HistoriaCorrect/{data($x/@id)}">Corriger</a></div>
          {if (session:id()="node0vf26s7tannye17nw5ldi7kbda0") then
          <div><a class="bouton" href="/HistoriaDelete/{data($x/@id)}">Effacer</a></div>
          
          else "vous n'êtes pas administrateur"
      } 
          
        ------------------------------ -------
          <br/>
          </div>        
         </div>      
      }            
    </div>
    </body>
    </html>     
  };


declare (:troisième:)
  %rest:path("/HistoriaCorrect/{$id}")
  %output:method("xhtml")
  function page:HistoriaCorrect($id)
  {
   <html>
      <head>
      <link type="text/css" rel="stylesheet" href="/static/historia.css"/>
      </head> 
      
      <body>
        <div id="header"></div>
        <div id="menuLeft"><a class="bouton" href="/HistoriaConsult">Consultez</a></div>
        <div id="contenu">
        
        <form method="POST" action="/updateRecordHistoria">
         <p><label>Div2:</label><input type="text" name="Div2" value="{db:open('HistoriaSchlastica')/RECORDS/RECORD[@id=$id/Div2]}"/></p>
          <p><label>Div1:</label><input type="text" name="Div1" value="{db:open('HistoriaSchlastica')/RECORDS/RECORD[@id=$id/Div1]}"/></p>
          <p><label>Div4:</label><input type="text" name="Div4" value="{db:open('HistoriaSchlastica')/RECORDS/RECORD[@id=$id/Div4]}"/></p>
          <p><label>Div3:</label><input type="text" name="Div3" value="{db:open('HistoriaSchlastica')/RECORDS/RECORD[@id=$id/Div3]}"/></p>
          <p><label>Text:</label><input type="text" name="Text" value="{db:open('HistoriaSchlastica')/RECORDS/RECORD[@id=$id/Text]}"/></p>
           <p><label>ID:</label><input type="text" name="ID" value="{db:open('HistoriaSchlastica')/RECORDS/RECORD[@id=$id/ID]}"/></p>
           <input type='hidden' name="id" value="{$id}"/>
           <input class="bouton" type="submit"/>            
         </form>      
        </div>
      </body>
    </html>
};
   
   
   
   
declare
  %updating
  %rest:path("/updateRecordHistoria")
  %rest:POST
  %rest:query-param("Div2","{$Div2}","")
  %rest:query-param("Div1","{$Div1}","")
  %rest:query-param("Div4","{$Div4}","")
  %rest:query-param("Div3","{$Div3}","")
  %rest:query-param("Text","{$Text}","")
  %rest:query-param("Text","{$ID}","")
  %rest:query-param("id","{$id}","")
  %output:method("xhtml")
  function page:updateRecord($id, $Div2, $Div1, $Div4, $Div3, $Text, $ID)
  {
    let $RECORD :=
    
    <RECORD id="{id}" date="{current-dateTime()}">
      <Div2>{$Div2}</Div2>
      <Div1>{$Div1}</Div1>
      <Div4>{$Div4}</Div4>
      <Div3>{$Div3}</Div3>
      <Text>{$Text}</Text>
      <Text>{$ID}</Text>
    </RECORD>
   for $x in db:open('HistoriaSchlastica')/RECORDS/RECORD[@id = $id]
     return 
        replace node $x with $RECORD
        
   ,
   update:output(web:redirect('/Historia')) 
}; 
   
   
declare
  %updating
  %rest:path("/HistoriaDelete/{$id}")
  %output:method("xhtml")
  function page:updateRecord($id)
  {
   
   for $x in db:open('HistoriaSchlastica')/RECORDS/RECORD[@id = $id]
     return 
        delete node $x     
   ,
   update:output(web:redirect('/Historia')) 

};   
     
   
declare   (:quatième:)
  %rest:path("/")
  %output:method("xhtml")
  function page:home()  
  {
    <html>
        <head>
        </head>
        <body>
            <h1>Historia</h1>    
        </body>
    </html> 
  };
  
  
  
declare (:cinquième:)
  %rest:path("/google")
  %rest:POST
  %rest:query-param("req","{$req}","")
   function page:google($req)  
  {
    for $x in db:open("HistoriaSchlastica")/RECORDS/RECORD
    [.//text() contains text {$req} using case insensitive using fuzzy]
    return
    $x
  }; 
