(:Par Xavier-Laurent Salvador:)
(:Interface de connexion et de suivi d'utilisateurs via session:id():)

module namespace  page = "http://www.page.fr";
import module namespace xls = 'http://www.page.fr' at 'index.xqm';


declare
 %rest:path("/annuaire/enregistrement")
 %output:method("xhtml")
 function page:enregistre()
 {
  xls:templateLogin(
    <form name="record" method="POST" action="/recorduser">
    <p>Saissez vos informations pour accéder à mon annuaire: </p>
     <p><label>Nom</label><input type="text" name="nom"/></p>
     <p><label>Login</label><input type="text" name="login"/></p>
     <p><label>Mot de passe</label><input type="password" name="password"/></p>
     <p><input type="submit"/></p>
    </form>
 )
};

declare
 %rest:path("/login")
 %output:method("xhtml")
 function page:login()
 {
   xls:templateLogin(
     <form name="login" method="POST" action="/testlogin">
     <h1>Login</h1>
      <p><label>Login</label><input type="text" name="login"/></p>
      <p><label>Mot de passe</label><input type="password" name="password"/></p>
      <p><input class="bouton" type="submit" value="SE CONNECTER"/></p>
      <p><a class="bouton" href="/annuaire/enregistrement">Créer un compte</a></p>
     </form>
   )
 };
 
 declare
 %rest:path("/adminUsers")
 %output:method("xhtml")
 function page:admin()
 {
  xls:template(
   <table class="bluetable">
    <th>Nom</th>
    <th>Level</th>
    <th>Action</th>{
   if ($xls:testadmin)
   then
   for $x in db:open('Tilde_utilisateurs')/bdd/entry
    return 
     <tr><td>{$x/login}</td><td>{$x/level}</td><td><a href="/delusers/{data($x/@id)}">Supprimer</a></td></tr>  
    else
    "Vous n'êtes pas administrateur"
  }
  </table>
  )
 };
