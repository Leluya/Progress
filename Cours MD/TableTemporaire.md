# <span style="color: #4523d2">Les Tables Temporaires</span>

## Exemple créaton d'une base temporaire:

```
DEFINE TEMP-TABLE tt-state
    FIELD state AS CHARACTER FORMAT "x(20)" 
    FIELD statename AS CHARACTER FORMAT "x(20)"
    FIELD region AS CHARACTER FORMAT "x(8)"
    INDEX state IS PRIMARY UNIQUE  state
    .
```
autre écriture de table plus rapide:
```
DEFINE TEMP-TABLE tt-state LIKE state.
```
On peut ajouter des colones en plus avec le FIELD.  

Ecriture pour garder seuelemnt les colones que l'on veut:
```
DEFINE TEMP-TABLE tt-stable
    FIELD state LIKE state.state
    FIELD region LIKE state.region
    INDEX state IS PRIMARY UNIQUE  state
    .
```
ensuite on remplit la table:
```
FOR EACH state:
    CREATE tt-state.
    //ou // BUFFER-COPY state TO tt-state.
    ASSIGN 
        tt-state.state = state.state
        tt-state.statename = state.statename
        tt-state.region = state.region
        .
END.

FOR EACH tt-state:
    DISPLAY tt-state.state.
END.
```
Vider une table temporaire:
```
EMPTY TEMP-TABLE tt-state.
```

## Assigner une variable en colonne (copie les propriétés d'une colonne):
```
DEFINE VARIABLE mystate LIKE state.state    NO-UNDO.

FIND FIRST state.
ASSIGN mystate = state.state.
DISPLAY mystate state.state.
```
## Trigger d'une suppression avec demande de confirmation.
```
DO:
    DEFINE VARIABLE lvlchoice AS LOGICAL NO-UNDO.
    MESSAGE "Voulez-vous supprimer cet enregistrement?"
        VIEW-AS ALERT-BOX INFORMATIOn BUTTON YES-NO
        UPDATE lvlchoice.
    IF lvlchoice THEN
    DO:
        /* je supprime */
    END/
    ELSE DO:
    /* je ne fais rien */
    END.
END.
```

## ROW-LEAVE pour faire un push des données de la table temporaire dans la BDD
**D'abord, on crée une TT dans la procédure:**
```
FOR EACH item:
    CREATE tt-item.
    BUFFER-COPY item TO tt-item.

END.
```
**Puis on peut venir créer la sauvegarde**
```
DO:
    DO TRANSACTION:
        FIND ITEM EXCLUSIVE-LOCK WHERE ITEM.itemnum = tt-item.itemnum.
        IF AVAILABLE ITEM THEN
        DO:
            ASSIGN ITEM.itemname = tt-item.itemnum.
        END.
        ELSE DO:
            MESSAGE "J'ai pas envie de modifier"
                VIEW-AS ALERT-BOX INFORMATION BUTTON OK.
        END.        
    END.
END.
```