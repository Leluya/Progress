# <span style="color: #4523d2">Conception d'une BDD</span>

- Utiliser DataDictionnary. Une fois la BDD créer, on peut choisir CREATE dans Database afin de créer une autre BDD. Il y aura alors les 2 BDD dans le dictionnary.  

- Aller dans MANAGEMENT CONSOLE (**Bien fermer le DataDictionnary avant**), on ce log. On fait new, database (dans new).  

- Saisir les infos, nom, le chemin du fichier, le port, cocher Autostart database brocker et faire Submit.  

- Dans DataDigger, aller dans connextion, utiliser le **+** pour ajouter la BDD.

- On ouvre le DataDictionnary depuis le Datadigger pour pouvoir créer nos tables

- Pour les Fk (foreign Key) et Pk (Primary Key),  cela ce fait dans l'index. Bien cocher primaire et unique pour le Pk.

- Pour enregistrer, il faut commit la base. Dans Edit, Commit Transaction. 

- Trigger pour les Key, toujours attacher directement le code à la table.
Ex de Trigger:
```
ASSIGN SalesRep.SalesRepNum = NEXT-VALUE(NextSalesRepNum).
```

