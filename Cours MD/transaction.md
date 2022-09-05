# TRANSACTIONS #

## Listing des transactions d'un programme:
On peut récupérer le listing des transactions via le code suivant:
```
COMPILE etrans1.p LISTING C:\OpenEdge\WRK\4GLE\Examples\etrans-listing.txt.
``` 
On a alors une liste des transactions du code demander.  
(Voir exemple de fichier dans le lien ci-dessus).  

On peut utiliser ce code dasn le ocde pour savoir si 'lon a une transaction:
``` 
MESSAGE "A transaction" (IF TRANSACTION THEN "IS" ELSE
    "IS NOT")"active in the outer REPEAT block," SKIP
    " before creating the Order" VIEW-AS ALERT-BOX.
``` 

## Passage de sous transaction en petite transaction:
Voici une transaction avec 2 sous transactions:
``` 
REPEAT :
    FIND NEXT customer.
    UPDATE NAME.
   
    REPEAT:
        FIND NEXT order 
            WHERE order.custnum = customer.custnum.
        UPDATE carrier.
    END.
END.
``` 
Si l'on échappe du programme, toutes les données rentrées sont perdu.

**Probléme, si on a un soucis on perd tout**, mieux vaut de 2 petite transactions. Comme cela, seule la derenière transaction est annulée. Dans ce cas, ce sont les UPDATE carrier que l'on perd, seul le UPDATE name est conservé en mémoire. 
``` 
REPEAT :
    DO TRANSACTION:
        FIND NEXT customer.
        UPDATE NAME.
    END.
   
    REPEAT:
        FIND NEXT order 
            WHERE order.custnum = customer.custnum.
        UPDATE carrier.
    END.
END.
``` 
Il faut éviter les intréractions avec les utilisateurs pour les transactions. On évite donc les SET si  on n'utilise pas des tables temporaire.
Remplace le SET par PROMPT-FOR puis ASSIGN, ce dernier sera dans la transaction:
```
PROMPT-FOR creditlimit.
DO TRANSACTION:
    ASSIGN creditlimit.
END
```
On utilisera pour éviter de géner tout le monde, l'utilisation d'une table temporaire, ce sont ses données temporaires qui seront transmise ensuite dans la BDD.