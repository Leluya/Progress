/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lvlchoice AS LOGICAL     NO-UNDO.
DO WITH FRAME frmcustomer:
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
                finname:SENSITIVE = TRUE
                finAddress:SENSITIVE = TRUE
                finAddress2:SENSITIVE = TRUE
                FinPostalCode:SENSITIVE = TRUE
                FinCity:SENSITIVE = TRUE
                FinState:SENSITIVE = TRUE
                FinCountry:SENSITIVE = TRUE
                FinContact:SENSITIVE = TRUE
                FinEmailAddress:SENSITIVE = TRUE
                FinSalesRep:SENSITIVE = TRUE
                FinTerms:SENSITIVE = TRUE
                FinDiscount:SENSITIVE = TRUE
                FinBalance:SENSITIVE = TRUE
                FinCreditLimit:SENSITIVE = TRUE
                FinPhone:SENSITIVE = TRUE
                FinFax:SENSITIVE = TRUE
                EdtComments:SENSITIVE = TRUE
                .
            ASSIGN
                fincustnum = ?
                finname = ""
                finAddress = ""
                finAddress2 = ""
                FinPostalCode = ""
                FinCity = ""
                FinState = ""
                FinCountry = ""
                FinContact = ""
                FinEmailAddress = ""
                FinSalesRep = ""
                FinTerms = ""
                FinDiscount = 0
                FinBalance = 0
                FinCreditLimit = 0
                FinPhone = ""
                FinFax = ""
                EdtComments = ""
                .
            DISPLAY 
                fincustnum
                finname
                finAddress
                finAddress2
                FinPostalCode
                FinCity
                FinState
                FinCountry
                FinContact
                FinEmailAddress
                FinSalesRep
                FinTerms
                FinDiscount
                FinBalance
                FinCreditLimit
                FinPhone
                FinFax
                EdtComments
                .
        END. /* Read Record */
        
        WHEN "Delete" THEN
        DO:
            MESSAGE "Voulez-vous supprimer ce client: " + STRING(customer.custnum) + " ?"
                VIEW-AS ALERT-BOX INFORMATION BUTTONS YES-NO
                UPDATE lvlchoice.
            IF lvlchoice THEN
            DO:
                FIND CURRENT customer EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
                IF AVAILABLE customer
                THEN DO:
                    DELETE customer NO-ERROR.
                    IF ERROR-STATUS:ERROR THEN
                    DO:
                        MESSAGE RETURN-VALUE
                            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
                    END.
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
                APPLY "VALUE-CHANGED" TO BROWSE Brwcustomer.
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
                finname:SENSITIVE = FALSE
                finAddress:SENSITIVE = FALSE
                finAddress2:SENSITIVE = FALSE
                FinPostalCode:SENSITIVE = FALSE
                FinCity:SENSITIVE = FALSE
                FinState:SENSITIVE = FALSE
                FinCountry:SENSITIVE = FALSE
                FinContact:SENSITIVE = FALSE
                FinEmailAddress:SENSITIVE = FALSE
                FinSalesRep:SENSITIVE = FALSE
                FinTerms:SENSITIVE = FALSE
                FinDiscount:SENSITIVE = FALSE
                FinBalance:SENSITIVE = FALSE
                FinCreditLimit:SENSITIVE = FALSE
                FinPhone:SENSITIVE = FALSE
                FinFax:SENSITIVE = FALSE
                EdtComments:SENSITIVE = FALSE
                .
            APPLY "VALUE-CHANGED" TO BROWSE Brwcustomer.                
        END.
        WHEN "SaveNew"
        THEN DO:
            ASSIGN
                finname
                finAddress
                finAddress2
                FinPostalCode
                FinCity
                FinState
                FinCountry
                FinContact
                FinEmailAddress
                FinSalesRep
                FinTerms
                FinDiscount
                FinBalance
                FinCreditLimit
                FinPhone
                FinFax
                EdtComments
                .
            CREATE customer.
            ASSIGN 
                customer.name = finname
                customer.Address = finAddress
                customer.Address2 = finAddress2
                customer.PostalCode = FinPostalCode
                customer.City = FinCity
                customer.State = FinState
                customer.Country = FinCountry
                customer.Contact = FinContact
                customer.EmailAddress = FinEmailAddress
                customer.SalesRep = FinSalesRep
                customer.Terms = FinTerms
                customer.Discount = FinDiscount
                customer.Balance = FinBalance
                customer.CreditLimit = FinCreditLimit
                customer.Phone = FinPhone
                customer.Fax = FinFax
                customer.Comments = EdtComments
                fincustnum = customer.custnum
                .
            DISPLAY fincustnum.
            {&OPEN-QUERY-Brwcustomer}
            FIND customer WHERE customer.custnum = fincustnum NO-LOCK.
            REPOSITION Brwcustomer TO ROWID ROWID(customer).
            Brwcustomer:GET-REPOSITIONED-ROW().
            ASSIGN 
                BtnAjouter:LABEL = "Ajouter"
                BtnModifier:SENSITIVE = TRUE
                BtnModifier:VISIBLE = TRUE
                BtnSupprimer:SENSITIVE = TRUE
                BtnSupprimer:VISIBLE = TRUE
                BtnCancel:SENSITIVE = FALSE
                BtnCancel:VISIBLE = FALSE
                finname:SENSITIVE = FALSE
                finAddress:SENSITIVE = FALSE
                finAddress2:SENSITIVE = FALSE
                FinPostalCode:SENSITIVE = FALSE
                FinCity:SENSITIVE = FALSE
                FinState:SENSITIVE = FALSE
                FinCountry:SENSITIVE = FALSE
                FinContact:SENSITIVE = FALSE
                FinEmailAddress:SENSITIVE = FALSE
                FinSalesRep:SENSITIVE = FALSE
                FinTerms:SENSITIVE = FALSE
                FinDiscount:SENSITIVE = FALSE
                FinBalance:SENSITIVE = FALSE
                FinCreditLimit:SENSITIVE = FALSE
                FinPhone:SENSITIVE = FALSE
                FinFax:SENSITIVE = FALSE
                EdtComments:SENSITIVE = FALSE
                .
            lvcmode = "read".
        END. /* Save New record */

        WHEN "SaveUpdate"
        THEN DO:
            ASSIGN
                finname
                finAddress
                finAddress2
                FinPostalCode
                FinCity
                FinState
                FinCountry
                FinContact
                FinEmailAddress
                FinSalesRep
                FinTerms
                FinDiscount
                FinBalance
                FinCreditLimit
                FinPhone
                FinFax
                EdtComments
                .
            FIND FIRST Customer WHERE Customer.custnum = fincustnum EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
            IF AVAILABLE Customer
            THEN DO:
                ASSIGN 
                    customer.name = finname
                    customer.Address = finAddress
                    customer.Address2 = finAddress2
                    customer.PostalCode = FinPostalCode
                    customer.City = FinCity
                    customer.State = FinState
                    customer.Country = FinCountry
                    customer.Contact = FinContact
                    customer.EmailAddress = FinEmailAddress
                    customer.SalesRep = FinSalesRep
                    customer.Terms = FinTerms
                    customer.Discount = FinDiscount
                    customer.Balance = FinBalance
                    customer.CreditLimit = FinCreditLimit
                    customer.Phone = FinPhone
                    customer.Fax = FinFax
                    customer.Comments = EdtComments
                    .
                {&OPEN-QUERY-Brwcustomer}
                FIND customer WHERE customer.custnum = fincustnum NO-LOCK.
                REPOSITION Brwcustomer TO ROWID ROWID(customer).
                Brwcustomer:GET-REPOSITIONED-ROW().
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
                    {&OPEN-QUERY-Brwcustomer}
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
                finname:SENSITIVE = FALSE
                finAddress:SENSITIVE = FALSE
                finAddress2:SENSITIVE = FALSE
                FinPostalCode:SENSITIVE = FALSE
                FinCity:SENSITIVE = FALSE
                FinState:SENSITIVE = FALSE
                FinCountry:SENSITIVE = FALSE
                FinContact:SENSITIVE = FALSE
                FinEmailAddress:SENSITIVE = FALSE
                FinSalesRep:SENSITIVE = FALSE
                FinTerms:SENSITIVE = FALSE
                FinDiscount:SENSITIVE = FALSE
                FinBalance:SENSITIVE = FALSE
                FinCreditLimit:SENSITIVE = FALSE
                FinPhone:SENSITIVE = FALSE
                FinFax:SENSITIVE = FALSE
                EdtComments:SENSITIVE = FALSE
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
                finAddress:SENSITIVE = TRUE
                finAddress2:SENSITIVE = TRUE
                FinPostalCode:SENSITIVE = TRUE
                FinCity:SENSITIVE = TRUE
                FinState:SENSITIVE = TRUE
                FinCountry:SENSITIVE = TRUE
                FinContact:SENSITIVE = TRUE
                FinEmailAddress:SENSITIVE = TRUE
                FinSalesRep:SENSITIVE = TRUE
                FinTerms:SENSITIVE = TRUE
                FinDiscount:SENSITIVE = TRUE
                FinBalance:SENSITIVE = TRUE
                FinCreditLimit:SENSITIVE = TRUE
                FinPhone:SENSITIVE = TRUE
                FinFax:SENSITIVE = TRUE
                EdtComments:SENSITIVE = TRUE
                .
        END.

    END CASE.
END.
END PROCEDURE.

