(:Par Xavier-L. Salvador:)
(:Cichier à placer dans le répertoire webapp:)
(:C'est une bibliothèque de fonction appelée par l'application:)
(:Par exemple en définissant une fois pour toute une fonction xls:template($contenu), on a créé un consturcteur de pages :)

module namespace  xls = "http://www.page.fr" ;

declare function xls:template($contenu) {
   <html>
    <head> 
     <link type="text/css" rel="stylesheet" href="/static/annuaire.css"/>
    </head>
    <body>
     <div id="header">Annuaire</div>
     <div id="menuLeft">
       <a class="bouton" href="/annuaireConsult">Consulter</a>
       <div id="google">
         <form action="google" method="post">
         <input type="text" name="req" placeholder="tapez la requête..."/>
         </form>
     </div>
     </div>
     <div id="contenu">
       {$contenu}
     </div>
    </body>
   </html>
};
