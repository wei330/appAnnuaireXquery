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
