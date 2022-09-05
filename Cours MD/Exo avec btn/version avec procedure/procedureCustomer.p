/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lvlchoice AS LOGICAL     NO-UNDO.
DO WITH FRAME default-frame:
    CASE lvcmode:
        
        WHEN "Add"
        THEN DO:
            ASSIGN 
                BtnAjouter:LABEL = "Enregistrer"
                BtnModifier:SENSITIVE = FALSE
                BtnModifier:VISIBLE = FALSE
                BtnSupprimer:SENSITIVE = FALSE
                BtnSupprimer:VISIBLE = FALSE
                BtnCancel:SENSITIVE = TRUE
                BtnCancel:VISIBLE = TRUE
                fincustnum:SENSITIVE = FALSE
                finname:SENSITIVE = TRUE
                fincontact:SENSITIVE = TRUE
                finsalesrep:SENSITIVE = TRUE
                .
            ASSIGN
                fincustnum = INTEGER("")
                finname = ""
                fincontact = ""
                finsalesrep = ""
                .
            DISPLAY 
                fincustnum
                finname
                fincontact
                finsalesrep
                WITH FRAME default-frame
                .
        END. /* Read Record */
        
        WHEN "Delete" THEN
        DO:
            MESSAGE "Voulez-vous supprimer cet état: " + customer.NAME + "?"
                VIEW-AS ALERT-BOX INFORMATION BUTTONS YES-NO
                UPDATE lvlchoice.
            IF lvlchoice THEN
            DO:
                FIND CURRENT customer EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
                IF AVAILABLE customer
                THEN DO:
                    DELETE customer.
                END.
                ELSE DO:
                    IF LOCKED customer
                    THEN DO:
                        MESSAGE "L'enregistrement est en cours d'utilisation." SKIP
                            "Essayez à nouveau plus tard."
                            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
                    END.
                    ELSE DO:
                        MESSAGE "Cet enregistrement à déjà été supprimé!"
                            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
                    END.
                END.
                {&OPEN-QUERY-brwcustomer}
                .
                APPLY "VALUE-CHANGED" TO BROWSE brwcustomer.
            END.
            ELSE DO:
                /* je ne fais rien */
            END.
            lvcmode = "read".
        END.

        WHEN "Read" THEN
        DO:
            ASSIGN 
                BtnAjouter:LABEL = "Ajouter"
                BtnModifier:SENSITIVE = TRUE
                BtnModifier:VISIBLE = TRUE
                BtnSupprimer:SENSITIVE = TRUE
                BtnSupprimer:VISIBLE = TRUE
                BtnCancel:SENSITIVE = FALSE
                BtnCancel:VISIBLE = FALSE
                fincustnum:SENSITIVE = FALSE
                finname:SENSITIVE = FALSE
                fincontact:SENSITIVE = FALSE
                finsalesrep:SENSITIVE = FALSE
                .
            APPLY "VALUE-CHANGED" TO BROWSE brwcustomer.                
        END.
        WHEN "SaveNew"
        THEN DO:
            ASSIGN
                fincustnum
                finname
                fincontact
                finsalesrep
                .
            
                CREATE customer.
                ASSIGN 
                    // customer.custnum = fincustnum
                    customer.NAME = finname
                    customer.contact = fincontact
                    .
                {&OPEN-QUERY-brwcustomer}
                FIND customer WHERE customer.NAME = finname NO-LOCK.
                REPOSITION brwcustomer TO ROWID ROWID(customer).
                brwcustomer:GET-REPOSITIONED-ROW().
                ASSIGN 
                    BtnAjouter:LABEL = "Ajouter"
                    BtnModifier:SENSITIVE = TRUE
                    BtnModifier:VISIBLE = TRUE
                    BtnSupprimer:SENSITIVE = TRUE
                    BtnSupprimer:VISIBLE = TRUE
                    BtnCancel:SENSITIVE = FALSE
                    BtnCancel:VISIBLE = FALSE
                    fincustnum:SENSITIVE = FALSE
                    finname:SENSITIVE = FALSE
                    fincontact:SENSITIVE = FALSE
                    finsalesrep:SENSITIVE = FALSE
                    .
                lvcmode = "read".
            
        END. /* Save New record */

        WHEN "SaveUpdate"
        THEN DO:
            ASSIGN
                fincustnum
                finname
                fincontact
                finsalesrep
                .
            FIND FIRST customer WHERE customer.custnum = fincustnum EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
            IF AVAILABLE customer
            THEN DO:
                ASSIGN 
                    customer.custnum = fincustnum
                    customer.NAME = finname
                    customer.contact = fincontact
                    customer.salesrep = finsalesrep
                    .
                {&OPEN-QUERY-brwcustomer}
                FIND customer WHERE customer.custnum = fincustnum NO-LOCK.
                REPOSITION brwcustomer TO ROWID ROWID(customer).
                brwcustomer:GET-REPOSITIONED-ROW().
            END.
            ELSE DO:
                IF LOCKED customer
                THEN DO:
                    MESSAGE "L'enregistrement est en cours d'utilisation." SKIP
                        "Essayez à nouveau plus tard."
                        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
                END.
                ELSE DO:
                    MESSAGE "Cet enregistrement à été supprimé par ailleur!"
                        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
                    {&OPEN-QUERY-brwcustomer}
                END.
            END.
            ASSIGN 
                BtnAjouter:LABEL = "Ajouter"
                BtnModifier:SENSITIVE = TRUE
                BtnModifier:VISIBLE = TRUE
                BtnSupprimer:SENSITIVE = TRUE
                BtnSupprimer:VISIBLE = TRUE
                BtnCancel:SENSITIVE = FALSE
                BtnCancel:VISIBLE = FALSE
                fincustnum:SENSITIVE = FALSE
                finname:SENSITIVE = FALSE
                fincontact:SENSITIVE = FALSE
                finsalesrep:SENSITIVE = FALSE
                .
            lvcmode = "read".
        END. /* Save Updated record */
        
        WHEN "Update" THEN
        DO:
            ASSIGN 
                BtnAjouter:LABEL = "Enregistrer"
                BtnModifier:SENSITIVE = FALSE
                BtnModifier:VISIBLE = FALSE
                BtnSupprimer:SENSITIVE = FALSE
                BtnSupprimer:VISIBLE = FALSE
                BtnCancel:SENSITIVE = TRUE
                BtnCancel:VISIBLE = TRUE
                finname:SENSITIVE = TRUE
                fincontact:SENSITIVE = TRUE
                finsalesrep:SENSITIVE = TRUE
                .
        END.

    END CASE.
END.
END PROCEDURE.

WHERE order.custnum = customer.custnum NO-LOCK INDEXED-REPOSITION