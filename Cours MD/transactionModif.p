// eRunTrans.p version original:
REPEAT:
  PROMPT-FOR Customer.CustNum.
  FIND Customer USING CustNum.
  DISPLAY Name FORMAT "x(20)" SalesRep CreditLimit FORMAT ">>,>>9". 
  SET CreditLimit.
  MESSAGE "Do you want to do order processing?" VIEW-AS ALERT-BOX
           QUESTION BUTTONS YES-NO UPDATE lAnswer AS LOGICAL.
  IF lAnswer THEN DO:
     RUN eUpdOrder.p(BUFFER Customer).
  END.
END.

// On modifie le code pour un aspect plus sécurisant 
// en ajoutant une transaction et en modifiant le SEET en PROMPT-FOR & ASSIGN
// eRunTrans.p version plus sur:
 REPEAT:
    PROMPT-FOR Customer.CustNum.
    FIND Customer USING CustNum.
    DISPLAY Name FORMAT "x(20)" SalesRep CreditLimit FORMAT ">>,>>9". 
    PROMPT-FOR CreditLimit.
    DO TRANSACTION:
        ASSIGN CreditLimit.
    END.
    MESSAGE "Do you want to do order processing?" VIEW-AS ALERT-BOX
             QUESTION BUTTONS YES-NO UPDATE lAnswer AS LOGICAL.
    IF lAnswer THEN DO:
       RUN eUpdOrder.p(BUFFER Customer).
    END.
  END.


///////////////////////////////////////////////////////////////////////////

// eUpdOrder.p version original:
DEFINE PARAMETER BUFFER Customer FOR Customer.
DEFINE VARIABLE iItem AS INTEGER NO-UNDO.
FOR EACH Order OF Customer:
    DISPLAY Order.CustNum Order.Ordernum Carrier.
    SET Carrier.
    FOR EACH OrderLine OF Order:
        ASSIGN OrderLine.ItemNum = 0 Qty = 0.
        DISPLAY LineNum. 
        SET OrderLine.ItemNum Qty.
        FIND ITEM WHERE OrderLine.ItemNum = ITEM.ItemNum.
        ASSIGN Orderline.Price = ITEM.Price.
        DISPLAY Item.Price LABEL "Unit price" 
                Qty * ITEM.Price LABEL "Total price".
    END.
END.

// On modifie le code pour un aspect plus sécurisant 
// en ajoutant une transaction et en modifiant le SEET en PROMPT-FOR & ASSIGN
// eUpdOrder.p version plus sur:
DEFINE PARAMETER BUFFER Customer FOR Customer.
DEFINE VARIABLE iItem AS INTEGER NO-UNDO.
FOR EACH Order OF Customer:
    DISPLAY Order.CustNum Order.Ordernum Carrier.
    PROMPT-FOR Carrier.
    DO TRANSACTION:
        ASSIGN Carrier.
    END.
    FOR EACH OrderLine OF Order:
        ASSIGN OrderLine.ItemNum = 0 Qty = 0.
        DISPLAY LineNum.
        PROMPT-FOR OrderLine.ItemNum Qty.
        DO TRANSACTION:
            ASSIGN OrderLine.ItemNum Qty.
        END. 
        FIND ITEM WHERE OrderLine.ItemNum = ITEM.ItemNum.
        ASSIGN Orderline.Price = ITEM.Price.
        DISPLAY Item.Price LABEL "Unit price" 
                Qty * ITEM.Price LABEL "Total price".
    END.
END.