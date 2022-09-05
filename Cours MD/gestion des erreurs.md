# <span style="color: #4523d2">Gestion des erreurs</span>

Code de départ:
```
REPEAT:
  PROMPT-FOR Customer.CustNum.
  FIND Customer USING CustNum.
  DISPLAY Customer 
    EXCEPT comments
    WITH 1 COLUMN.
END.
```
Si le numéro client n'existe pas, il plante.  

Avec l'ajout de NO-ERROR, cela fonctione mais nous avons une autre erreur.  
Il ne peut pas afficher les données, car cela n'existe pas.  
```
REPEAT:
  PROMPT-FOR Customer.CustNum.
  FIND Customer USING CustNum NO-ERROR.
  DISPLAY Customer 
    EXCEPT comments
    WITH 1 COLUMN.
END.
```

Si on ajoute, à la fin, il n'affiche plus d'erreur mais remplis avec des ?.
```
REPEAT:
  PROMPT-FOR Customer.CustNum.
  FIND Customer USING CustNum NO-ERROR.
  DISPLAY Customer 
    EXCEPT comments
    WITH 1 COLUMN
    NO-ERROR.
END.
```

## Façon de faire pour afficher les messages d'erreur avec les numéro de Progress:
```
DEFINE VARIABLE icount AS INTEGER NO-UNDO.
REPEAT:
  PROMPT-FOR Customer.CustNum.
  FIND Customer USING CustNum 
    NO-ERROR
    .
  
  IF NOT ERROR-STATUS:ERROR THEN
  DO:
     DISPLAY Customer 
    EXCEPT comments
    WITH 1 COLUMN
    .
  END.
  ELSE DO:
      DO icount = 1 TO ERROR-STATUS:NUM-MESSAGES:
      MESSAGE ERROR-STATUS:GET-MESSAGE(icount) SKIP
              ERROR-STATUS:GET-NUMBER(icount)
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.
  END.
END.
 ```

 ## Retry, relance sans nettoyer:
 ```
 REPEAT ON ERROR UNDO, RETRY:
  PROMPT-FOR Customer.CustNum.
  FIND Customer USING CustNum 
    // NO-ERROR
    .
  
 /* IF NOT ERROR-STATUS:ERROR THEN
  DO:
  */
     DISPLAY Customer 
    EXCEPT comments
    WITH 1 COLUMN
    .
  /* END. 
  ELSE DO:
      DO icount = 1 TO ERROR-STATUS:NUM-MESSAGES:
      MESSAGE ERROR-STATUS:GET-MESSAGE(icount) SKIP
              ERROR-STATUS:GET-NUMBER(icount)
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        END.
    END.
  */
 END. 
 ```
## Next, relance et nettoie
 ```
DEFINE VARIABLE icount AS INTEGER NO-UNDO.
REPEAT ON ERROR UNDO, NEXT:
  PROMPT-FOR Customer.CustNum.
  FIND Customer USING CustNum 
    // NO-ERROR
    .
  
 /* IF NOT ERROR-STATUS:ERROR THEN
  DO:
  */
     DISPLAY Customer 
    EXCEPT comments
    WITH 1 COLUMN
    .
  /* END. 
  ELSE DO:
      DO icount = 1 TO ERROR-STATUS:NUM-MESSAGES:
      MESSAGE ERROR-STATUS:GET-MESSAGE(icount) SKIP
              ERROR-STATUS:GET-NUMBER(icount)
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        END.
    END.
  */
 END. 
 ```
## Return, sort du programme
 ```
DEFINE VARIABLE icount AS INTEGER NO-UNDO.
REPEAT ON ERROR UNDO, RETURN:
  PROMPT-FOR Customer.CustNum.
  FIND Customer USING CustNum 
    // NO-ERROR
    .
  
 /* IF NOT ERROR-STATUS:ERROR THEN
  DO:
  */
     DISPLAY Customer 
    EXCEPT comments
    WITH 1 COLUMN
    .
  /* END. 
  ELSE DO:
      DO icount = 1 TO ERROR-STATUS:NUM-MESSAGES:
      MESSAGE ERROR-STATUS:GET-MESSAGE(icount) SKIP
              ERROR-STATUS:GET-NUMBER(icount)
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        END.
    END.
  */
 END. 
 ```

 ## Leave, sort du REPEAT et affiche le dernier message d'erreur 
 ```
 DEFINE VARIABLE icount AS INTEGER NO-UNDO.
REPEAT ON ERROR UNDO, LEAVE:
  PROMPT-FOR Customer.CustNum.
  FIND Customer USING CustNum 
    // NO-ERROR
    .
  
 /* IF NOT ERROR-STATUS:ERROR THEN
  DO:
  */
     DISPLAY Customer 
    EXCEPT comments
    WITH 1 COLUMN
    .
  /* END. 
  ELSE DO:
      DO icount = 1 TO ERROR-STATUS:NUM-MESSAGES:
      MESSAGE ERROR-STATUS:GET-MESSAGE(icount) SKIP
              ERROR-STATUS:GET-NUMBER(icount)
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        END.
    END.
  */
 END. 
  ```
### Supprimer le message d'erreur. Ici pas de custnum 23 et lance le RETRY sans message d'erreur.
```
REPEAT ON ERROR UNDO, RETRY:
  PROMPT-FOR Customer.CustNum.
  FIND Customer USING CustNum NO-ERROR.
  IF AVAILABLE customer 
  THEN
    DISPLAY custnum NAME.
   ELSE UNDO, RETRY.
END.
```
**Avec notre message d'erreur**
```
REPEAT ON ERROR UNDO, RETRY:
  PROMPT-FOR Customer.CustNum.
  FIND Customer USING CustNum NO-ERROR.
  IF AVAILABLE customer 
  THEN
    DISPLAY custnum NAME.
   ELSE DO:
        MESSAGE "le client" custnum:SCREEN-VALUE "n'éxiste pas"
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        UNDO, RETRY.
   END.
END.
```
**Même code avec une variable**
```
DEFINE VARIABLE myCustnum AS INTEGER       NO-UNDO.

REPEAT ON ERROR UNDO, RETRY:
  PROMPT-FOR Customer.CustNum.
  myCustnum = INTEGER(customer.custnum:SCREEN-VALUE).
  FIND Customer USING CustNum NO-ERROR.
  IF AVAILABLE customer 
  THEN
    DISPLAY custnum NAME.
   ELSE DO:
    MESSAGE "le client" myCustnum "n'éxiste pas"
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        UNDO, RETRY.
   END.
END.
```

### On garde le même code mais on utilise ERROR-STATUS:ERROR
```
DEFINE VARIABLE myCustnum AS INTEGER       NO-UNDO.

REPEAT ON ERROR UNDO, RETRY:
  PROMPT-FOR Customer.CustNum.
  myCustnum = INTEGER(customer.custnum:SCREEN-VALUE).
  FIND Customer USING CustNum NO-ERROR.
  IF ERROR-STATUS:ERROR 
  THEN DO:
        MESSAGE "le client" myCustnum "n'éxiste pas"
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        UNDO, RETRY.
  END.
  ELSE DO:
    DISPLAY custnum NAME.
   END.
END.
```

**Exo avec la table state**
```
REPEAT ON ERROR UNDO, RETRY:
  PROMPT-FOR state.state.
  FIND state USING state NO-ERROR.
/*
  if available state
  then display state.
  else do:
    MESSAGE "l'état" state:SCREEN-VALUE "n'éxiste pas"
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        UNDO, RETRY.
  END.
*/
  IF ERROR-STATUS:ERROR 
  THEN DO:
        MESSAGE "l'état" state:SCREEN-VALUE "n'éxiste pas"
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        UNDO, RETRY.
  END.
  ELSE DO:
    DISPLAY statename state.
   END.
END.
```

## Gestion des erreurs avec l'appel à erreur d'un sous prog:

sous prog (fichier sousprog.p dans 4GLE):
```
DEFINE INPUT PARAMETER mystate AS CHARACTER NO-UNDO.

FIND state WHERE state.state = mystate NO-ERROR.

if available state
  then display state.
  ELSE DO:
    RETURN ERROR "l'état " + mystate + " n'éxiste pas".
  END.
```
prog (fichier prog.p dans 4GLE):
```
DEFINE VARIABLE mystate AS CHARACTER   NO-UNDO.

REPEAT ON ERROR UNDO, RETRY:
    UPDATE mystate.
    RUN sousprog.p (mystate) NO-ERROR.
IF ERROR-STATUS:ERROR
THEN DO:
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
     UNDO, RETRY.
END.
    

END.
MESSAGE "fin"
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
```
### Exemple d'un block contenant un block avec error:
```
DEFINE VARIABLE lchoice AS LOGICAL     NO-UNDO.

monBlock1:
REPEAT:
    monBlock2:
    REPEAT ON ERROR UNDO, LEAVE:
        PROMPT-FOR state.state.
        FIND FIRST state USING state.state.
        DISPLAY state.
    END.
    MESSAGE "Apres block2"
        VIEW-AS ALERT-BOX INFORMATION BUTTONS YES-NO
        UPDATE lchoice.
    IF lchoice THEN
    DO:
        LEAVE.    
    END.
    
END.
MESSAGE "Apres block1"
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
```
### Obtenir le numéro de l'erreur dans le message:
```
DEFINE INPUT PARAMETER mystate AS CHARACTER NO-UNDO.
DEFINE VARIABLE icount AS INTEGER     NO-UNDO.

FIND state WHERE state.state = mystate NO-ERROR.

if available state
  then display state.
  ELSE DO icount = 1 TO ERROR-STATUS:NUM-MESSAGES:
    MESSAGE ERROR-STATUS:GET-NUMBER(icount)
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  END.
```

### Faire retour error avec des chiffres en progamme Progress pur sans les fonctions qui existent:

sousprog:
```
DEFINE INPUT PARAMETER mystate AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER myrecord AS CHARACTER NO-UNDO.

FIND state WHERE state.state = mystate NO-ERROR.

IF AVAILABLE state
THEN DO:
  myrecord = "0".
  display state.
  RETURN "".
END.
ELSE DO:
  myrecord = "1".
  RETURN "Cet état " + mystate + " n'existe pas".
END.
```

prog:
```
DEFINE VARIABLE mystate AS CHARACTER   NO-UNDO.
DEFINE VARIABLE myrecord AS CHARACTER     NO-UNDO.

REPEAT ON ERROR UNDO, RETRY:
    UPDATE mystate.
    RUN sousprog.p (INPUT mystate, OUTPUT myrecord)
    .
    IF myrecord <> "0"
    THEN DO:
        MESSAGE RETURN-VALUE SKIP
            myrecord
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.
    ELSE DO:
        MESSAGE myrecord
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.
END.
```