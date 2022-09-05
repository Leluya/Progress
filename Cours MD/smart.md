# <span style="color: #4523d2">SMART OBJECT</span> #

Faire la Window de Order avec une liason OrderLine, le folder(smart folder) doit être mit après le browser. On régle l'ordre des pages dans les propriétés du folder.  

Pointer sur le numéro de client :
```
DEFINE VARIABLE c-Where AS CHARACTER NO-UNDO.   
c-Where    = "CUSTOMER.custNum = " + QUOTER( ipi-custNum ).
DYNAMIC-FUNCTION('setQueryWhere' IN h_d-Customer, c-Where).
DYNAMIC-FUNCTION('openQuery' IN h_d-Customer).
```           
            
Récupérer des données du sdo dans la window :
``` 
DEFINE VARIABLE c-custnum AS CHARACTER NO-UNDO.
c-custnum = DYNAMIC-FUNCTION('columnValue' IN h_d-Customer,"Custnum").
``` 

Rafraichir la dernière ligne traitée du browser :
``` 
Dans le browser : DYNAMIC-FUNCTION('openQuery' IN h-Source).
RUN refreshRow IN DYNAMIC-FUNCTION('getDataSource').
``` 