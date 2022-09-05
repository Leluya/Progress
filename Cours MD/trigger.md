# <span style="color: #4523d2">Etape de création d'un TRIGGER</span> #

## Créer une table
## Ajouter des champs
## Créer une séquences pour le futur trigger

Voici le code pour le TRIGGER:
```
TRIGGER PROCEDURE FOR CREATE OF test.

/* Automaticly Increment Test Number using Nextestnum Sequence */

ASSIGN test.testnum = NEXT-VALUE(Nextestnum).
```

## Créer le trigger dans la table **PAS DANS LES CHAMPS**
## Enregistrer le trigger
## Lancer un essai, puis un autre pour vérifier le saut de PU

```
CREATE test.
ASSIGN 
    testname = "test4"
    .
DISPLAY test.
```