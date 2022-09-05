/* On repart du code du Trigger pour rédiger le script, 
on enléve les messages d'erreur et on crée un code pour lancer le run */

TRIGGER Procedure FOR Delete OF Customer.

/* Variable Definitions */

DEFINE VARIABLE answer AS LOGICAL.

/* Customer record cannot be deleted if outstanding invoices are found */

FIND FIRST invoice OF customer NO-ERROR.
IF AVAILABLE invoice THEN DO:
   IF invoice.amount <= invoice.totalpaid + invoice.adjustment THEN DO:
      FIND FIRST order OF customer NO-ERROR.
      IF NOT AVAILABLE order THEN DO:
         RETURN.
      END.   
      ELSE DO:
       RETURN  ERROR"Open orders exist for Customer " + STRING(customer.custnum) +  
       ".  Cannot delete.".     
      END.
   END.
   ELSE DO:
      RETURN ERROR "Outstanding Unpaid Invoice Exists " + STRING(customer.custnum) +  
      ".  Cannot delete.".
   END.
END.   
ELSE DO:
   FIND FIRST order OF customer NO-ERROR.
   IF NOT AVAILABLE order THEN DO:
      RETURN.
   END.   
   ELSE DO:
      RETURN ERROR "Open orders exist for Customer " + STRING(customer.custnum) +  
      ".  Cannot delete.".
   END.
END.      

/*******************************************************************************************/

// Code à lancer dans Procedure
FOR EACH customer:
    DELETE customer NO-ERROR. // NO-ERROR si erreur, si le dev qui gére dans le code qui suit, pas progress
    IF ERROR-STATUS:ERROR THEN // ERROR = y or n, si soucis, il ne fait qu'afficher les messages d'erreur mais on ne peut rien faire
    DO:
        message
            RETURN-VALUE
            view-as alert-box. 
    END.
END.

/*******************************************************************************************/

// Code pour Script
OUTPUT TO "c:\openedge\wrk\monlog.txt".

FOR EACH customer:
    DELETE customer NO-ERROR. 
    IF ERROR-STATUS:ERROR THEN
    DO:
       PUT UNFORMATTED RETURN-VALUE SKIP.
    END.
END.
OUTPUT CLOSE.
// récupére un fichier texte avec toutes les données qui ne peuvent pas être effacer.
