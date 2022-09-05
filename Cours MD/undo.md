# <span style="color: #4523d2">UNDO</span> #

le NO-UNDO des variables permet de garder en mémoire la variable.  
Si cela plante, on aura l'info de la ligne qui a planté.  

Sinon, on aura la dernière ligne validé, ce n'est pas la même chose.  

```
DEFINE VARIABLE icount  AS INTEGER NO-UNDO.

REPEAT :
    icount = icount +1.
    FIND NEXT customer.
    UPDATE NAME.
END.
```