# <span style="color: #4523d2">Créer une donnée à mettre en BDD</span> #
```
CREATE state.
ASSIGN 
    state.state = "sh"
    state.region = "moon"
    state.statename = "Shadow of the moon"
    .
on vérifie la modie avec :
FIND state WHERE state = "sh".
DISPLAY state.

// On peut fair eun UPDATE:
FIND state WHERE state = "sh".
UPDATE state.
```

**Une fenêtre s'ouvre et on peut modifier dedans les données, ensuite entrée.**

******************************************************************************

## Faire cette manip: 
```
FIND state WHERE state = "sh".
DISPLAY state.
PROMPT-FOR state.
ASSIGN state.
```

## Est équivalent à :
```
FIND state WHERE state = "sh".
UPDATE state.
```

********************************************************************************

## Suppression de la donnée créer ci-dessus:

```
FIND state WHERE state = "sh".
MESSAGE "etes-vous sûr?"
    VIEW-AS ALERT-BOX INFORMATION BUTTONS YES-NO
    UPDATE lchoice AS LOGICAL.

IF lchoice THEN DELETE state.
```

*******************************************************************************

## Code complet de création, update et suppression avec message:

```
CREATE customer.
ASSIGN 
    customer.NAME = "Usine"
    customer.salesrep = "lmgl"
    customer.country = "USA"
    customer.postalcode = "08512"
    customer.comments = "blablabla"
    .

MESSAGE "Creation faite" SKIP
        "On va le modifier "
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
 
FIND customer WHERE NAME = "Usine".
// UPDATE customer EXCEPT comments.
UPDATE custnum NAME country salesrep.

MESSAGE "Mise à jour faite"  SKIP
        "On va le supprimer "
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

MESSAGE "etes-vous sûr de vouloir le supprimer?"
    VIEW-AS ALERT-BOX INFORMATION BUTTONS YES-NO
    UPDATE lchoice AS LOGICAL.

IF lchoice THEN DELETE customer.
```

## Faire un UPDATE sans utiliser la fonction UPDATE:

```
FIND test WHERE testname ="test4".
DISPLAY test.
PROMPT-FOR testname.
ASSIGN testname.
```

## Supprimer des données:

**toutes les données de la table:**
```
FOR EACH test:
    DELETE test.
END.
```
**Une donnée de la table**
```
FIND test WHERE testname ="test4".
DELETE test.
```
