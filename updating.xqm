(:Par Xavier-L. Salvador:)
(:Les fonctions d'écritures en base. Le fichier est à placer dans le webapp de Basex:)
module namespace page = 'http://mapage.com';

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
    
    let $validate := validate:xsd-info($entry,'fichClass.xsd')

     return 
       (:C'est ici qu'on insère le text sur le xsd si on le souhaite:)
       (: if ($validate='') then:)
      insert node $entry into db:open('annuaireTilde')/bdd
       (:else ET CHOISIR UNE ACTION:)
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
    let $validate := validate:xsd-info($entry,'fichClass.xsd')
    
     for $x in db:open('annuaireTilde')/bdd/entry[@id = $id]
      return 
       (:C'est ici qu'on insère le text sur le xsd si on le souhaite:)
       (: if ($validate='') then:)
       replace node $x with $entry 
       (:else CHOISIR UNE ACTION:)
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

