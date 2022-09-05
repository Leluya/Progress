# <span style="color: #4523d2">LOCK </span>
Il existe 3 nivraux de LOCK:  
- NO-LOCK: je veux accéder à l'info, peut importe si elle sera modifier. (Lecture sale)   
- SHARE-LOCK: Donne moi l'enregistrement, mais je ne veux pas qu'elle soit en modification. (Lecture propre)    
- EXCLUSIVE-LOCK: Je veux m'approprié l'enregistrement et l'enregistrer. (Mise à jour)  

| Relation entre les LOCK  | NO-LOCK          | SHARE-LOCK | EXCLUSIVE-LOCK |
| :--------------- |:---------------:| -----:|-----:|
| **NO-LOCK**  |  <span style="color: #26B260"> V </span>       |  <span style="color: #26B260"> V </span> | <span style="color: #26B260"> V </span> |
| **SHARE-LOCK**  | <span style="color: #26B260"> V </span>            |  <span style="color: #26B260"> V </span> | <span style="color: #ff0000"> X </span> |
| **EXCLUSIVE-LOCK**  | <span style="color: #26B260"> V </span>         |   <span style="color: #ff0000"> X </span> | <span style="color: #ff0000"> X </span> |  

**Régle obligatoire, préciser le lock lors de l'éciture de notre code!!!**


Exemple, une personne veut UPDATE et l'autre DISPLAY une info, pour que cela fonctionne, il faut:
UPDATE
```
FOR FIRST customer SHARE-LOCK:
    UPDATE NAME.
    PAUSE.
END.
```

DYSPLAY
```
FOR FIRST customer NO-LOCK:
    DYSPLAY NAME.
    PAUSE.
END.
```
Code pour du changement de LOCK:
```
FIND FIRST state NO-LOCK.

FIND CURRENT state SHARE-LOCK.

FIND CURRENT state EXCLUSIVE-LOCK.
```
**CURRENT pour changer le LOCK et charger la mémoire.**

## Scope transaction plus long que le record:

Personne qui fait l'UPDATE

```
MESSAGE
    "transaction:" TRANSACTION
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

DO TRANSACTION:
        FIND FIRST salesrep NO-LOCK.
        DISPLAY repname.
    
       FOR EACH state
        WHERE state BEGINS "A":
        UPDATE statename
       END.
     
     FIND FIRST customer NO-LOCK.
     DISPLAY NAME.
     PAUSE.
    /* MESSAGE "pause"
         VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.   
     Plus ympa que PAUSE pour ce rappler que l'on est en pause.    */
END.
```
Personne qui voir les données
```
FOR EACH state SHARE-LOCK
    WHERE state BEGINS "A":
    DISPLAY statename.
END.
```

## Scope record plus long que la transaction:

Personne qui fait l'UPDATE
```
FOR EACH state
    WHERE state BEGINS "A":
    
    FIND FIRST salesrep NO-LOCK.
    DISPLAY repname.
    
    DO TRANSACTION:
        UPDATE statename.
    MESSAGE "pause"
         VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.
    
    FIND FIRST customer NO-LOCK.
    DISPLAY NAME.
    MESSAGE "pause"
         VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
END.
```
Personne qui voir les données
```
FOR EACH state SHARE-LOCK
    WHERE state BEGINS "A":
    DISPLAY statename.
END.