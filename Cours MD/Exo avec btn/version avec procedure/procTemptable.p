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
                finFirstName:SENSITIVE = TRUE
                finLastName:SENSITIVE = TRUE
                finEmail:SENSITIVE = TRUE
                finPhone:SENSITIVE = TRUE
                finFax:SENSITIVE = TRUE
                .
            ASSIGN
                finSalesRepNum = ?
                finFirstName = ""
                finLastName = ""
                finEmail = ""
                finPhone = ""
                finFax = ""
                .
            DISPLAY 
                finSalesRepNum
                finFirstName
                finLastName
                finEmail
                finPhone
                finFax
                .
                   

        END. /* Read Record */
        
        WHEN "Delete" THEN
        DO:
            MESSAGE "Voulez-vous supprimer ce commercial: " + ttSalesRep.FirstName + " " + ttSalesRep.LastName + " ?"
                VIEW-AS ALERT-BOX INFORMATION BUTTONS YES-NO
                UPDATE lvlchoice.
            IF lvlchoice THEN
            DO:
                FIND CURRENT ttSalesRep EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
                IF AVAILABLE ttSalesRep
                THEN DO:
                    FIND SalesRep WHERE SalesRep.SalesRepNum = ttSalesRep.SalesRepNum.
                    DELETE SalesRep NO-ERROR.
                    DELETE ttSalesRep.
                    
                    IF ERROR-STATUS:ERROR THEN
                    DO:
                        MESSAGE RETURN-VALUE
                            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
                    END.   
                END.
                ELSE DO:
                    IF LOCKED ttSalesRep
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

                {&OPEN-QUERY-brwSalesRep}
                
                APPLY "VALUE-CHANGED" TO BROWSE BrwSalesRep.
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
                finFirstName:SENSITIVE = FALSE
                finLastName:SENSITIVE = FALSE
                finEmail:SENSITIVE = FALSE
                finPhone:SENSITIVE = FALSE
                finFax:SENSITIVE = FALSE
                .
            APPLY "VALUE-CHANGED" TO BROWSE BrwSalesRep.                
        END.
        WHEN "SaveNew"
        THEN DO:
            ASSIGN
                finFirstName
                finLastName
                finEmail
                finPhone
                finFax
                .
                
            CREATE SalesRep.
            
            ASSIGN 
                SalesRep.FirstName = finFirstName
                SalesRep.LastName = finLastName
                SalesRep.Email = finEmail
                SalesRep.Phone = finPhone
                SalesRep.Fax = finFax
                finSalesRepNum = SalesRep.SalesRepNum
                .

            CREATE ttSalesRep.
            BUFFER-COPY SalesRep TO ttSalesRep.
               
            DISPLAY finsalesRepNum.
                
            {&OPEN-QUERY-BrwSalesRep}
            FIND ttSalesRep WHERE ttSalesRep.SalesRepNum = finSalesRepNum NO-LOCK.
            REPOSITION BrwSalesRep TO ROWID ROWID(ttSalesRep).
            BrwSalesRep:GET-REPOSITIONED-ROW().
            
            ASSIGN 
                BtnAjouter:LABEL = "Ajouter"
                BtnModifier:SENSITIVE = TRUE
                BtnModifier:VISIBLE = TRUE
                BtnSupprimer:SENSITIVE = TRUE
                BtnSupprimer:VISIBLE = TRUE
                BtnCancel:SENSITIVE = FALSE
                BtnCancel:VISIBLE = FALSE
                finFirstName:SENSITIVE = FALSE
                finLastName:SENSITIVE = FALSE
                finEmail:SENSITIVE = FALSE
                finPhone:SENSITIVE = FALSE
                finFax:SENSITIVE = FALSE
                .
            
            lvcmode = "read".
        END. /* Save New record */

        WHEN "SaveUpdate"
        THEN DO:
            ASSIGN
                finFirstName
                finLastName
                finEmail
                finPhone
                finFax
                .
            FIND FIRST ttSalesRep WHERE ttSalesRep.SalesrepNum = finSalesrepNum EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
            IF AVAILABLE ttSalesRep
            THEN DO:
                ASSIGN 
                    ttSalesRep.FirstName = finFirstName
                    ttSalesRep.LastName = finLastName
                    ttSalesRep.Email = finEmail
                    ttSalesRep.Phone = finPhone
                    ttSalesRep.Fax = finFax
                    .
                 FIND SalesRep WHERE SalesRep.SalesRepNum = ttSalesRep.SalesRepNum.
                 CREATE SalesRep.
                 ASSIGN
                    SalesRep.FirstName = ttSalesRep.FirstName
                    SalesRep.LastName = ttSalesRep.LastName
                    SalesRep.Email = ttSalesRep.Email
                    SalesRep.Phone = ttSalesRep.Phone
                    SalesRep.Fax = ttSalesRep.Fax
                    .
   
                {&OPEN-QUERY-BrwSalesRep}
                FIND ttSalesRep WHERE ttSalesRep.SalesRepNum = finSalesRepNum NO-LOCK.
                REPOSITION BrwSalesRep TO ROWID ROWID(ttSalesRep).
                BrwSalesRep:GET-REPOSITIONED-ROW().

            END.

            ELSE DO:
                IF LOCKED ttSalesRep
                THEN DO:
                    MESSAGE "L'enregistrement est en cours d'utilisation." SKIP
                        "Essayez à nouveau plus tard."
                        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
                END.
                ELSE DO:
                    MESSAGE "Cet enregistrement à été supprimé par ailleur!"
                        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
                    {&OPEN-QUERY-BrwSalesRep}
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
                finFirstName:SENSITIVE = FALSE
                finLastName:SENSITIVE = FALSE
                finEmail:SENSITIVE = FALSE
                finPhone:SENSITIVE = FALSE
                finFax:SENSITIVE = FALSE
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
                finFirstName:SENSITIVE = TRUE
                finLastName:SENSITIVE = TRUE
                finEmail:SENSITIVE = TRUE
                finPhone:SENSITIVE = TRUE
                finFax:SENSITIVE = TRUE
                .
        END.
        

    END CASE. 

END.

END PROCEDURE.