# <span style="color: #4523d2">Utilisation de l'AppBuilder</span>

La base, les plus utilisés:
- Window
- Dialog  
- Possible que l'on utilise Structured Procedure (boites à outils de procédure que l'on appel)
- Structured Include (on peut l'utiliser)
- Method Library
- SmartWindow
- SmartDialog

**<span style="color: #ff0000">ATTENTION!!</span>**  
Le **WAIT-FOR CLOSE** est un évenement auquel il ne faut pas toucher. Capture l'événement et décide de lancer le Trigger associer.  

## Pour les objets.
On peut leur donner des noms, qui seront des variables dans les codes qui régiront les objets. **Bien définir** ces noms avant de coder les objets, sinon, il faudra rechanger les variables dans le code!!


## Pour coder un bouton:

Exemple, afficher la selection du Browse en détails avec un bouton détail:  
```
DO:
  ASSIGN
    bouton:SCREEN-VALUE = state.statename
    .
END.
```
Selectionne le bouton et clique sur le crayon à côté de Run pour enregister le code du bouton.  

Exemple, un bouton enregistrer:
```  
DO:
    BtnEnregistrer:sensitive = false.
    BtnDetail:sensitive = true.
END.
```

Pour "grisé" un bouton pour bloquer l'utilisation et faire la mise à jour de la BDD + mise à jour du Browse(on repart sur le détail qui affiche et que l'utilisateur peut modifier).  
```
// Bouton détails
DO:
  ASSIGN
    bouton:SCREEN-VALUE = state.statename
    .
    BtnEnregistrer:sensitive = true.
    BtnDetail:sensitive = false.
END.

// Bouton enregistrer
DO:
    DO TRANSACTION:
        FIND CURRENT state EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF AVAILABLE state
        THEN DO:
            ASSIGN
                state.statename = bouton:SCREEN-VALUE
                state.state = bouton:SCREEN-VALUE
                state.region = bouton:SCREEN-VALUE
                .
        END.
    END.
    BtnEnregistrer:sensitive = false.
    BtnDetail:sensitive = true.
    {&OPEN-QUERY-BROWSE-3}
    .
    REPOSITION BROWSE-3 TO ROWID ROWID(state).
END.
```
Exemple avec Radio-set:
```
DO:
    ASSIGN radio-set-1. /* Prend valeur à l'écran et assigne à la valeur en mémoire, remplace le SREEN-VALUE */
    MESSAGE radio-set-1:SCREEN-VALUE
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    ASSIGN radio-set = 4.
    DISPLAY radio-set-1 WITH FRAME Dialog-Frame.
END.
```

Exercice pour faire la même chose que sur State mais avec Salesrape. <span style="color: #ff0000">Attention, bien mettre like la table de la BDD pour faire que les manipulations marche.</span>
- code du détail:
```
DO:
  ASSIGN
    finRegion = salesrep.region
    finName = salesrep.repname
    finSalesRape = salesrep.salesrep
    btnRegister:sensitive = TRUE
    btnDetail:sensitive = FALSE
    .
   DISPLAY
        finRegion
        finName
        finSalesRape
        WITH FRAME DEFAULT-FRAME.
END.
```
- code de enregistrer:
```
DO:
    DO TRANSACTION:
        FIND CURRENT salesrep EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF AVAILABLE salesrep
        THEN DO:
            ASSIGN 
                finName
                finSalesRape
                finRegion
                .
            ASSIGN
                salesrep.repname = finName
                salesrep.salesrep = finSalesRape
                salesrep.region = finRegion
                .
        END.
    END.
    btnRegister:sensitive = false.
    btnDetail:sensitive = true.
    {&OPEN-QUERY-BROWSE-3}
    .
    REPOSITION BROWSE-3 TO ROWID ROWID(salesrep).
    GET NEXT BROWSE-3
    BROWSE-3:SCROLL-TO-CURRENT-ROW().
    
END.
```
Exemple sur COMBOBOX pour avoir une liste depuis la BDD, on la crée dans une nouvelle procédure et on ajoute un **RUN** dans le **MAIN BLOCK**:
```
DEFINE VARIABLE mylist AS CHARACTER NO-UNDO.
mylist = "".
FOR EACH state NO-LOCK WHERE region = "west":
    ASSIGN mylist = mylist + "," + state.state.
END.
ASSIGN mylist = SUBSTRING(mylist,2).
ASSIGN combo-box-1:LIST-ITEMS IN FRAME dialog-frame = mylist.
```
Exo pouvoir avoir liste des jours en Anglais ou en Français:

- Solution avec IF:
```
DO:
   ASSIGN radio-set-4.
   IF radio-set-4 = 1 
   THEN DO: 
    select-6:LIST-ITEMS = "Lundi, Mardi, Mercredi, Jeudi, Vendredi, Samedi, Dimanche". 
   END.
   IF radio-set-4 = 2 
   THEN DO: 
    select-6:LIST-ITEMS = "Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday". 
   END.
END.
```

- Solution en cachant les listes:
```
DO:
    ASSIGN radio-set-4.
    CASE radio-set-4:
        WHEN 1
        THEN DO:
            ASSIGN
                selFrancais:VISIBLE = FALSE
                selFrancais:SENSITIVE = FALSE
                selEnglish:VISIBLE = TRUE
                selEnglish:SENSITIVE = TRUE
                .
        END.
        WHEN 2
        THEN DO:
            ASSIGN
                selFrancais:VISIBLE = TRUE
                selFrancais:SENSITIVE = TRUE
                selEnglish:VISIBLE = FALSE
                selEnglish:SENSITIVE = FALSE
                .
        END.
    END.
END.
```