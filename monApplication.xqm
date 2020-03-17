(:pas Xavier-Laurent Salvador:)
(:Ce finchier est à placer dans webapp:)
(:Il met en action les URL d'ajout, de consultation, de modification et de recherche dans la base:)

module namespace  page = "http://www.page.fr";
import module namespace xls = 'http://www.page.fr' at 'index.xqm';

declare
 %rest:path("/annuaire")
 %output:method("xhtml")
 function page:annuaire()
 {
  xls:template(
       <form id="annuaire" method="POST" action="updateAnnuaire">
         <p><label>Nom:</label><input type="text" name="nom" placeholder="Tapez votre nom..."/></p>
         <p><label>Prénom:</label><input type="text" name="prenom" placeholder="Tapez votre prénom..."/></p>
         <p><label>Adresse:</label><input type="text" name="adresse" placeholder="Tapez votre adresse..."/></p>
         <input class="bouton" type="submit"/>
       </form>
)
 };


declare
 %rest:path("/annuaireConsult")
 %output:method("xhtml")
 function page:annuaireConsult()
 {
   xls:template(
        for $x in db:open('annuaireTilde')/bdd/entry
        return
         <div class="entry">
          <div class="date">{data($x/@date)}</div>
          <div class="id">{data($x/@id)}</div>
          <div class="nom">{$x/nom}</div>
          <div class="prenom">{$x/prenom}</div>
          <div class="adresse">{$x/adresse}</div>
          <div id="menuFloat">
          <div><a class="bouton" href="/annuaireCorrect/{data($x/@id)}">Corriger</a></div>
          {if (session:id()="node05rbbticumxm81lpvoxnqw1yz90") then
          <div><a class="bouton" href="/annuaireDelete/{data($x/@id)}">Effacer</a></div>
          else "vous n'êtes pas administrateur"}
          </div>
         </div>
     )
 };

declare
 %rest:path("/annuaireCorrect/{$id}")
 %output:method("xhtml")
 function page:annuaireCorrect($id)
 {
  xls:template(
     
     <form method="POST" action="/updateEntryAnnuaire">
       <p><label>Nom:</label><input type="text" name="nom" value="{db:open('annuaireTilde')/bdd/entry[@id=$id]/nom}"/></p>
       <p><label>Prénom:</label><input type="text" name="prenom" value="{db:open('annuaireTilde')/bdd/entry[@id=$id]/prenom}"/></p>
       <p><label>Adresse:</label><input type="text" name="adresse" value="{db:open('annuaireTilde')/bdd/entry[@id=$id]/adresse}"/></p>
       <input type="hidden" name="id" value="{$id}"/>
         <input class="bouton" type="submit"/>
     </form>
)
};
    

declare
 %rest:path("/")
 %output:method("xhtml")
 function page:home()
 {
xls:template(
     <p><h1>Coucou</h1>
     <p><img width="50" src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Tim_Berners-Lee_closeup.jpg/260px-Tim_Berners-Lee_closeup.jpg"/> Le réveil matin a sonné beaucoup trop tôt. <a href="/monlien">Il faut essayer de faire un lien</a>.</p>
  <p>Êtes-vous <a href="/bienvenue/copain">pour</a> ou êtes-vous <a href="/bienvenue/cretin">contre</a> ?</p></p>
)
 };
 
declare
 %rest:path("/google")
 %rest:POST
 %rest:query-param("req","{$req}","")
 %output:method("xhtml")
 function page:google($req)
 {
   xls:template(
   for $x in db:open('annuaireTilde')/bdd/entry
   [.//text() contains text {$req} using case insensitive using fuzzy]
    return 
     $x)
 };


