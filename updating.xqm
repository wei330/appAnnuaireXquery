(:Par Xavier-L. Salvador:)
(:Les fonctions d'écritures en base. Le fichier est à placer dans le webapp de Basex:)
module namespace page = 'http://mapage.com';
import module namespace xls = 'http://www.page.fr' at 'index.xqm';

declare
 %updating
 %rest:path("/updateAnnuaire")
 %rest:POST
 %rest:query-param("nom","{$nom}","")
 %rest:query-param("prenom","{$prenom}","")
 %rest:query-param("adresse","{$adresse}","")
 %output:method("xhtml")
 function page:update($nom, $prenom, $adresse)
 {
   let $entry := 
    <entry date="{current-dateTime()}">
     <nom>{$nom}</nom>
     <prenom>{$prenom}</prenom>
     <adresse>{$adresse}</adresse>
    </entry>
    
    let $validate := validate:xsd-info($entry,'/Users/xavier/basex9TILDE/fichClass.xsd')

     return 

      insert node $entry into db:open('annuaireTilde')/bdd
   
    ,
    update:output(web:redirect('/annuaire')) (:db:output:)
};



declare
 %updating
 %rest:path("/updateEntryAnnuaire")
 %rest:POST
 %rest:query-param("nom","{$nom}","")
 %rest:query-param("prenom","{$prenom}","")
 %rest:query-param("adresse","{$adresse}","")
 %rest:query-param("id","{$id}","")
 %output:method("xhtml")
 function page:updateEntry($id,$nom, $prenom, $adresse)
 {
   let $entry := 
    <entry id="{$id}" date="{current-dateTime()}">
     <nom>{$nom}</nom>
     <prenom>{$prenom}</prenom>
     <adresse>{$adresse}</adresse>
    </entry>
    
     for $x in db:open('annuaireTilde')/bdd/entry[@id = $id]
      return 
       replace node $x with $entry 
   
    ,
    update:output(web:redirect('/annuaire')) (:db:output:)
};

declare
 %updating
 %rest:path("/annuaireDelete/{$id}")
 %output:method("xhtml")
 function page:updateEntry($id)
 {
   
     for $x in db:open('annuaireTilde')/bdd/entry[@id = $id]
      return 
      delete node $x 
    ,
    update:output(web:redirect('/annuaire')) (:db:output:)
};

declare
 %updating
 %rest:path("/annuaireDelete/{$id}")
 %output:method("xhtml")
 function page:updatEntry($id)
 {
   
     for $x in db:open('annuaireTilde')/bdd/entry[@id = $id]
      return 
      delete node $x 
    ,
    update:output(web:redirect('/annuaire')) (:db:output:)
};

declare
 %updating
 %rest:path("/recorduser")
 %rest:POST
 %rest:query-param("nom","{$nom}","")
 %rest:query-param("login","{$login}","")
 %rest:query-param("password","{$password}","")
 %output:method("xhtml")
 function page:recorduser($nom,$login,$password)
 {
   
   let $id := 
    if (db:open('Tilde_utilisateurs')/bdd/entry)
     then
      xs:integer(db:open('Tilde_utilisateurs')/bdd/entry[last()]/@id) + 1
     else 1
   
   let $entry :=
    <entry id="{$id}">
     <date>{current-dateTime()}</date>
     <nom>{$nom}</nom>
     <login>{$login}</login>
     <motdepasse>{crypto:hmac($xls:crypto, $password, 'md5', 'hex')}</motdepasse>
     <level>user</level>
     <sessionid>{session:id()}</sessionid>
    </entry> 
    return
     insert node $entry into db:open('Tilde_utilisateurs')/bdd
     ,
       update:output(web:redirect('/annuaire'))

};

declare
 %updating
 %rest:path("/testlogin")
 %rest:POST
 %rest:query-param("login","{$login}","")
 %rest:query-param("password","{$password}","")
 %output:method("xhtml")
 function page:testlogin($login,$password)
 {
    if (db:open('Tilde_utilisateurs')/bdd/entry[nom=$login][motdepasse=crypto:hmac($xls:crypto, $password, 'md5', 'hex')])
     then
      replace value of node 
        db:open('Tilde_utilisateurs')/bdd/entry[nom=$login][motdepasse=crypto:hmac($xls:crypto, $password, 'md5', 'hex')]/sessionid 
         with session:id()
     else
       insert node 
        <erreur>
         <date>{current-dateTime()}</date>
         <login>{$login}</login>
         <password>{$password}</password>
        </erreur>
       into db:open('Tilde_erreurs')/bdd
       ,
       update:output(web:redirect('/annuaire'))
};

declare
 %updating
 %rest:path("/logout")
 function page:logout(){
   replace value of node
    db:open('Tilde_utilisateurs')//sessionid[. = session:id()]
     with ''
     ,
      update:output(web:redirect('/annuaire'))
 };

declare
 %updating
 %rest:path("/delusers/{$id}")
  function page:deluser($id){
    delete node
    db:open('Tilde_utilisateurs')/bdd/entry[@id=$id][not(@id=1)]
     ,
    update:output(web:redirect('/annuaire'))
  };
