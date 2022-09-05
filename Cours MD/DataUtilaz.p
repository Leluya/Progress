&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
/* Connected Databases 
          sports2000       PROGRESS
*/

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttClients NO-UNDO LIKE clients
       FIELD RowIdent AS ROWID
       INDEX RowIdent RowIdent.
DEFINE TEMP-TABLE ttfactures NO-UNDO LIKE factures
       FIELD RowIdent AS ROWID
       INDEX RowIdent RowIdent.
DEFINE TEMP-TABLE ttproduits NO-UNDO LIKE produits.
DEFINE TEMP-TABLE ttcommandes NO-UNDO LIKE commandes
       FIELD RowIdent AS ROWID
       INDEX RowIdent RowIdent
       .
DEFINE TEMP-TABLE ttcommandlignes NO-UNDO LIKE commandlignes
       FIELD RowIdent AS ROWID
       INDEX RowIdent RowIdent.
DEFINE TEMP-TABLE ttcommercial NO-UNDO LIKE commercial
       FIELD RowIdent AS ROWID
       INDEX RowIdent RowIdent.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : DataUtil.p
    Purpose     : Accesses database to retrieve, modify, and delete records. 

    Syntax      :

    Description : Used by user interface procedures to operate on the database.
                  Run persistently to acccess internal procedures.

    Author(s)   : Stan Swiercz 
    Created     : November 2000
                  Modified November 2003 - Bob Asbury
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: ttCustomer T "?" NO-UNDO Sports2000 Customer
      ADDITIONAL-FIELDS:
          FIELD RowIdent AS ROWID
          INDEX RowIdent RowIdent
      END-FIELDS.
      TABLE: ttInvoice T "?" NO-UNDO Sports2000 Invoice
      ADDITIONAL-FIELDS:
          FIELD RowIdent AS ROWID
          INDEX RowIdent RowIdent
      END-FIELDS.
      TABLE: ttItem T "?" NO-UNDO Sports2000 Item
      TABLE: ttOrder T "?" NO-UNDO Sports2000 Order
      ADDITIONAL-FIELDS:
          FIELD RowIdent AS ROWID
          INDEX RowIdent RowIdent
          
      END-FIELDS.
      TABLE: ttOrderLine T "?" NO-UNDO Sports2000 OrderLine
      ADDITIONAL-FIELDS:
          FIELD RowIdent AS ROWID
          INDEX RowIdent RowIdent
      END-FIELDS.
      TABLE: ttSalesrep T "?" NO-UNDO Sports2000 Salesrep
      ADDITIONAL-FIELDS:
          FIELD RowIdent AS ROWID
          INDEX RowIdent RowIdent
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* Shutdown when the user exits the application. */

SUBSCRIBE TO "Shutdown":U ANYWHERE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-DeleteCustomer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DeleteCustomer Procedure 
PROCEDURE DeleteCustomer :
/*------------------------------------------------------------------------------
  Purpose: Delete customer records from the database.    
  Parameters:  prRowIdent - RowID of the record to be deleted.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER prRowIdent AS ROWID NO-UNDO.
    
    FIND clients WHERE ROWID(clients) = prRowIdent EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE clients THEN 
    DO:
        DELETE Clients.
        RETURN.
    END.
    ELSE IF LOCKED (Clients) THEN
            RETURN "L'enregistrement est blocké.  Essayer plus tard.".
         ELSE
            RETURN "L'enregitrement a été supprimée!".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DeleteInvoice) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DeleteInvoice Procedure 
PROCEDURE DeleteInvoice :
/*------------------------------------------------------------------------------
  Purpose: Delete invoice records from the database.    
  Parameters:  prRowIdent - RowID of the record to be deleted.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER prRowIdent AS ROWID NO-UNDO.
    
    FIND factures WHERE ROWID(factures) = prRowIdent EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE factures THEN  
    DO:
        DELETE factures. 
        RETURN RETURN-VALUE.
    END.
    ELSE IF LOCKED (factures) THEN
            RETURN "L'enregistrement est blocké.  Essayer plus tard.".
         ELSE
            RETURN "The record has already been deleted!".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DeleteOrder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DeleteOrder Procedure 
PROCEDURE DeleteOrder :
/*------------------------------------------------------------------------------
  Purpose: Delete order records from the database.    
  Parameters:  prRowIdent - RowID of the record to be deleted.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER prRowIdent AS ROWID NO-UNDO.
    
    FIND commandes WHERE ROWID(commandes) = prRowIdent EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE commandes THEN  
    DO:
        DELETE commandes.
        RETURN.
    END.
    ELSE IF LOCKED (commandes) THEN
            RETURN "L'enregistrement est blocké.  Essayer plus tard.".
         ELSE
            RETURN "The record has already been deleted!".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DeleteOrderline) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DeleteOrderline Procedure 
PROCEDURE DeleteOrderline :
/*------------------------------------------------------------------------------
  Purpose: Delete OrderLine records from the database.    
  Parameters:  prRowIdent - RowID of the record to be deleted.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER prRowIdent AS ROWID NO-UNDO.
    
    FIND commandlignes WHERE ROWID(commandlignes) = prRowIdent EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE commandlignes THEN  
    DO:
        DELETE commandlignes.
        RETURN.
    END.
    ELSE IF LOCKED (commandlignes) THEN
            RETURN "L'enregistrement est blocké.  Essayer plus tard.".
         ELSE
            RETURN "The record has already been deleted!".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DeleteSalesrep) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DeleteSalesrep Procedure 
PROCEDURE DeleteSalesrep :
/*------------------------------------------------------------------------------
  Purpose: Delete salesrep records from the database.    
  Parameters:  prRowIdent - RowID of the record to be deleted.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER prRowIdent AS ROWID NO-UNDO.
    
    FIND commercial WHERE ROWID(commercial) = prRowIdent EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE commercial THEN  
    DO:
        DELETE commercial.
        RETURN.
    END.
    ELSE IF LOCKED (commercial) THEN
            RETURN "L'enregistrement est blocké.  Essayer plus tard.".
         ELSE
            RETURN "The record has already been deleted!".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GetCustData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetCustData Procedure 
PROCEDURE GetCustData :
/*------------------------------------------------------------------------------
  Purpose: Retrieve all the customer records and pass back to the calling 
            procedure.    
  Parameters:  ttCustomer - Temp-table used to pass records between procedures.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR ttClients.

    EMPTY TEMP-TABLE ttClients.
    
    FOR EACH clients NO-LOCK : 
        CREATE ttClients.
        BUFFER-COPY clients TO ttClients.
        ASSIGN ttClients.RowIdent = ROWID(Clients).
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GetCustRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetCustRecord Procedure 
PROCEDURE GetCustRecord :
/*------------------------------------------------------------------------------
  Purpose: Retrieve a specific customer record and pass it back to the calling 
            procedure.    
  Parameters:  
        ttCustomer - Temp-table used to pass record between procedures.
        prCustomerRow - RowID of the customer record to retrieve.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER TABLE FOR ttClients.
  DEFINE INPUT  PARAMETER prCustomerRow AS ROWID NO-UNDO.

  EMPTY TEMP-TABLE ttClients NO-ERROR.

  IF prCustomerRow <> ? THEN
      FIND clients WHERE ROWID(clients) = prCustomerRow NO-LOCK NO-ERROR.
  ELSE
      FIND LAST clients NO-LOCK NO-ERROR.  
  IF AVAILABLE clients THEN
  DO:
      CREATE ttclients.
      BUFFER-COPY clients TO ttClients.
      ASSIGN ttClients.RowIdent = ROWID(clients).
      RETURN.
  END.
  ELSE
      RETURN "l'enregistrement a été suprimée!".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GetInvoiceData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetInvoiceData Procedure 
PROCEDURE GetInvoiceData :
/*------------------------------------------------------------------------------
  Purpose: Retrieve all the invoice records and pass back to the calling 
            procedure.    
  Parameters:  ttInvoice - Temp-table used to pass records between procedures.
               piKeyValue - The customer number for which invoices are required.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR ttfactures.
    DEFINE INPUT  PARAMETER piKeyValue  AS INTEGER    NO-UNDO.

    EMPTY TEMP-TABLE ttfactures NO-ERROR.
    
    IF piKeyValue = ? THEN
        FOR EACH factures NO-LOCK: 
            CREATE ttfactures.
            BUFFER-COPY factures TO ttfactures.
            ASSIGN ttfactures.RowIdent = ROWID(factures).
        END.
    ELSE
        FOR EACH factures WHERE factures.clientNum = piKeyValue NO-LOCK: 
            CREATE ttfactures.
            BUFFER-COPY factures TO ttfactures.
            ASSIGN ttfactures.RowIdent = ROWID(factures).
        END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GetInvoiceRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetInvoiceRecord Procedure 
PROCEDURE GetInvoiceRecord :
/*------------------------------------------------------------------------------
  Purpose: Retrieve a specific invoice record and pass it back to the calling 
            procedure.    
  Parameters:  
        ttInvoice - Temp-table used to pass record between procedures.
        prowInvoiceRow - RowID of the record to retrieve.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER TABLE FOR ttfactures.
  DEFINE INPUT  PARAMETER prInvoiceRow AS ROWID NO-UNDO.

  EMPTY TEMP-TABLE ttfactures NO-ERROR.

  IF prInvoiceRow <> ? THEN
      FIND factures WHERE ROWID(factures) = prInvoiceRow NO-LOCK NO-ERROR.
  ELSE
      FIND LAST factures NO-LOCK NO-ERROR.  
  IF AVAILABLE factures THEN
  DO:
      CREATE ttfactures.
      BUFFER-COPY factures TO ttfactures.
      ASSIGN ttfactures.RowIdent = ROWID(factures).
      RETURN.
  END.
  ELSE
      RETURN "Record has been deleted!".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GetItemData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetItemData Procedure 
PROCEDURE GetItemData :
/*------------------------------------------------------------------------------
  Purpose: Retrieve all the item records and pass back to the calling 
            procedure.    
  Parameters:  ttItem - Temp-table used to pass records between procedures.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR ttproduits.

    EMPTY TEMP-TABLE ttproduits NO-ERROR.
    FOR EACH Item NO-LOCK: 
        CREATE ttproduits.
        BUFFER-COPY produits TO ttproduits.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GetNewLineNum) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetNewLineNum Procedure 
PROCEDURE GetNewLineNum :
/*------------------------------------------------------------------------------
  Purpose: Compute line number for new OrderLine    
  Parameters:  INPUT - piOrderNum = The OrderNum of the associated Order 
               OUTPUT - piLineNum = The generated Line Number
  Notes:  First Line Number is 1     
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER piOrderNum AS INTEGER    NO-UNDO.
    DEFINE OUTPUT  PARAMETER piLineNum AS INTEGER    NO-UNDO.
    FIND LAST commandlignes WHERE commandlignes.cmdnum = piOrderNum NO-LOCK NO-ERROR.
    IF AVAILABLE commandlignes THEN 
        piLineNum = commandlignes.cmdligneNum + 1.
    ELSE
        piLineNum = 1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GetOrderData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetOrderData Procedure 
PROCEDURE GetOrderData :
/*------------------------------------------------------------------------------
  Purpose: Retrieve all the order records and pass back to the calling 
            procedure.    
  Parameters:  ttOrder - Temp-table used to pass records between procedures.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR ttcommandes.

    EMPTY TEMP-TABLE ttcommandes NO-ERROR.

    FOR EACH commandes NO-LOCK: 
        CREATE ttcommandes.
        BUFFER-COPY commandes TO ttcommandes.
        ASSIGN ttcommandes.rowIdent = ROWID(commandes).
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GetOrderlineData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetOrderlineData Procedure 
PROCEDURE GetOrderlineData :
/*------------------------------------------------------------------------------
  Purpose: Retrieve the orderline records for a specific order and pass back 
            to the calling procedure.    
  Parameters:  ttOrderline - Temp-table used to pass records between procedures.
               piKeyValue - The OrderNum for which orderlines are required
  Notes: The procedure uses a query to find the orderlines for a specific
         order.     
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR ttcommandlignes.
    DEFINE INPUT  PARAMETER piKeyValue  AS INTEGER    NO-UNDO.

    EMPTY TEMP-TABLE ttcommandlignes NO-ERROR.

    FOR EACH commandlignes WHERE commandlignes.cmdNum = piKeyValue NO-LOCK: 
        CREATE ttcommandlignes.
        BUFFER-COPY commandlignes TO ttcommandlignes.
        ASSIGN ttcommandlignes.rowIdent = ROWID(commandlignes).
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GetOrderlineRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetOrderlineRecord Procedure 
PROCEDURE GetOrderlineRecord :
/*------------------------------------------------------------------------------
  Purpose: Retrieve a specific orderline record and pass it back to the calling 
            procedure.    
  Parameters:  
        ttOrderline - Temp-table used to pass record between procedures.
        prOrderlineRow - RowID of the record to retrieve.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER TABLE FOR ttcommandlignes.
  DEFINE INPUT  PARAMETER prOrderLineRow AS ROWID NO-UNDO.

  EMPTY TEMP-TABLE ttcommandlignes NO-ERROR.

  IF prOrderLineRow <> ? THEN
      FIND commandlignes WHERE ROWID(commandlignes) = prOrderLineRow NO-LOCK NO-ERROR.
  ELSE
      FIND LAST commandlignes NO-LOCK NO-ERROR.  
  IF AVAILABLE commandlignes THEN
  DO:
      CREATE ttcommandlignes.
      BUFFER-COPY commandlignes TO ttcommandlignes.
      ASSIGN ttcommandlignes.RowIdent = ROWID(commandlignes).
      RETURN.
  END.
  ELSE
      RETURN "Record has been deleted!".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GetOrderRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetOrderRecord Procedure 
PROCEDURE GetOrderRecord :
/*------------------------------------------------------------------------------
  Purpose: Retrieve a specific order record and pass it back to the calling 
            procedure.    
  Parameters:  
        ttOrder - Temp-table used to pass record between procedures.
        prOrderRow - RowID of the record to retrieve.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER TABLE FOR ttcommandes.
  DEFINE INPUT  PARAMETER prOrderRow AS ROWID NO-UNDO.

  EMPTY TEMP-TABLE ttcommandes NO-ERROR.

  IF prOrderRow <> ? THEN
      FIND commandes WHERE ROWID(commandes) = prOrderRow NO-LOCK NO-ERROR.
  ELSE
      FIND LAST commandes NO-LOCK NO-ERROR.  
  IF AVAILABLE commandes THEN
  DO:
      CREATE ttcommandes.
      BUFFER-COPY commandes TO ttcommandes.
      ASSIGN ttcommandes.RowIdent = ROWID(commandes).
      RETURN.
  END.
  ELSE
      RETURN "Record has been deleted!".           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GetRepData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetRepData Procedure 
PROCEDURE GetRepData :
/*------------------------------------------------------------------------------
  Purpose: Retrieve all the sales rep records and pass back to the calling 
            procedure.    
  Parameters:  ttSalesRep - Temp-table used to pass records between procedures.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR ttcommercial.

    EMPTY TEMP-TABLE ttcommercial NO-ERROR.

    FOR EACH commercial NO-LOCK: 
        CREATE ttcommercial.
        BUFFER-COPY commercial TO ttcommercial.
        ASSIGN ttcommercial.RowIdent = ROWID(commercial).
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GetRepRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetRepRecord Procedure 
PROCEDURE GetRepRecord :
/*------------------------------------------------------------------------------
  Purpose: Retrieve a specific sales rep record and pass it back to the calling 
            procedure.    
  Parameters:  
        ttSalesRep - Temp-table used to pass record between procedures.
        prSalesrepRow - RowID of the record to retrieve.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER TABLE FOR ttcommercial.
  DEFINE INPUT  PARAMETER prSalesRepRow AS ROWID NO-UNDO.

  EMPTY TEMP-TABLE ttcommercial NO-ERROR.

  IF prSalesRepRow <> ? THEN
      FIND commercial WHERE ROWID(commercial) = prSalesRepRow NO-LOCK NO-ERROR.
  ELSE
      FIND LAST commercial NO-LOCK NO-ERROR.  
  IF AVAILABLE commercial THEN
  DO:
      CREATE ttcommercial.
      BUFFER-COPY commercial TO ttcommercial.
      ASSIGN ttcommercial.RowIdent = ROWID(commercial).
      RETURN.
  END.
  ELSE
      RETURN "Record has been deleted!".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-SaveCustRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveCustRecord Procedure 
PROCEDURE SaveCustRecord :
/*------------------------------------------------------------------------------
  Purpose: Commit a customer record to the database.    
  Parameters:  
               ttCustomer - Temp-table used to pass record in to save and return
                            modified record to calling procedure.
               pcMode     - Identify whether this is a modified "Mod" or
                            new "New" record.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR  ttclients.
    DEFINE INPUT PARAMETER pcMode AS CHARACTER  NO-UNDO.

    FIND FIRST ttClients.
    DO TRANSACTION:
        IF pcMode = "New" THEN 
            CREATE Clients.
        ELSE
            FIND Clients WHERE ROWID(Clients) = ttClients.RowIdent 
                EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        /* Do the following for both new and modified records */
        IF AVAILABLE Clients THEN
            BUFFER-COPY ttClients EXCEPT RowIdent clientnum TO Clients.
        ELSE
            IF LOCKED (Clients) THEN
                RETURN "L'enregistrement est blocké.  Essayer plus tard.".
            ELSE 
                RETURN "Record has been deleted!".
    END. /* Transaction */
    FIND CURRENT Clients NO-LOCK.  /* Remove the lock */
    BUFFER-COPY Clients TO ttclients.
    ttClients.rowIdent = ROWID(Clients).
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-SaveInvoiceRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveInvoiceRecord Procedure 
PROCEDURE SaveInvoiceRecord :
/*------------------------------------------------------------------------------
  Purpose: Commit a invoice record to the database.    
  Parameters:  
               ttInvoice - Temp-table used to pass record in to save and return
                            modified record to calling procedure.
               pcMode     - Identify whether this is a modified "Mod" or
                            new "New" record.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR  ttfactures.
    DEFINE INPUT PARAMETER pcMode AS CHARACTER  NO-UNDO.

    FIND FIRST ttfactures.

    DO TRANSACTION:
        IF pcMode = "New":U THEN DO:
            IF CAN-FIND(factures WHERE factures.cmdNum = ttfactures.cmdNum) THEN
            DO:
                EMPTY TEMP-TABLE ttfactures.
                RETURN "Cannot duplicate invoice. Transaction aborted.".
            END.
            ELSE
                CREATE factures.
        END.
        ELSE
            FIND factures WHERE ROWID(factures) = ttfactures.RowIdent 
                EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        /* Do the following for both new and modified records */
        IF AVAILABLE factures THEN
            BUFFER-COPY ttfactures EXCEPT RowIdent factureNum TO factures.
        ELSE
            IF LOCKED (factures) THEN
                RETURN "Record is locked.  Try later.".
            ELSE 
                RETURN "Record has been deleted!".
    END. /* Transaction */
    FIND CURRENT factures NO-LOCK.
    BUFFER-COPY factures TO ttfactures.
    ttfactures.rowIdent = ROWID(factures).
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-SaveOrderlineRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveOrderlineRecord Procedure 
PROCEDURE SaveOrderlineRecord :
/*------------------------------------------------------------------------------
  Purpose: Commit a orderline record to the database.    
  Parameters:  
               ttOrderline - Temp-table used to pass record in to save and return
                            modified record to calling procedure.
               pcMode     - Identify whether this is a modified "Mod" or
                            new "New" record.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR  ttcommandlignes.
    DEFINE INPUT PARAMETER pcMode AS CHARACTER  NO-UNDO.

    FIND FIRST ttcommandlignes.
    DO TRANSACTION:
        IF pcMode = "New" THEN 
            CREATE commandlignes.
        ELSE
            FIND commandlignes WHERE ROWID(commandlignes) = ttcommandlignes.RowIdent 
                EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        /* Do the following for both new and modified records */
        IF AVAILABLE commandlignes THEN
            BUFFER-COPY ttcommandlignes EXCEPT RowIdent TO commandlignes.
        ELSE
            IF LOCKED (commandlignes) THEN
                RETURN "Record is locked.  Try later.".
            ELSE 
                RETURN "Record has been deleted!".
    END. /* Transaction */
    FIND CURRENT commandlignes NO-LOCK NO-ERROR.
    BUFFER-COPY commandlignes TO ttcommandlignes.
    ttcommandlignes.rowIdent = ROWID(commandlignes).
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-SaveOrderRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveOrderRecord Procedure 
PROCEDURE SaveOrderRecord :
/*------------------------------------------------------------------------------
  Purpose: Commit a order record to the database.    
  Parameters:  
               ttOrder - Temp-table used to pass record in to save and return
                            modified record to calling procedure.
               pcMode     - Identify whether this is a modified "Mod" or
                            new "New" record.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR  ttcommandes.
    DEFINE INPUT PARAMETER pcMode AS CHARACTER  NO-UNDO.

    FIND FIRST ttcommandes.
    DO TRANSACTION:
        IF pcMode = "New" THEN 
            CREATE Order.
        ELSE
            FIND commandes WHERE ROWID(commandes) = ttcommandes.RowIdent 
                EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        /* Do the following for both new and modified records */
        IF AVAILABLE commandes THEN
            BUFFER-COPY ttcommandes EXCEPT RowIdent cmdnum TO commandes.
        ELSE
            IF LOCKED (commandes) THEN
                RETURN "Record is locked.  Try later.".
            ELSE 
                RETURN "Record has been deleted!".
    END. /* Transaction */
    FIND CURRENT commandes NO-LOCK NO-ERROR.
    BUFFER-COPY commandes TO ttcommandes.
    ttcommandes.rowIdent = ROWID(commandes).
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-SaveRepRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveRepRecord Procedure 
PROCEDURE SaveRepRecord :
/*------------------------------------------------------------------------------
  Purpose: Commit a sales rep record to the database.    
  Parameters:  
               ttSalesrep - Temp-table used to pass record in to save and return
                            modified record to calling procedure.
               pcMode     - Identify whether this is a modified "Mod" or
                            new "New" record.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR  ttcommercial.
    DEFINE INPUT PARAMETER pcMode AS CHARACTER  NO-UNDO.

    FIND FIRST ttcommercial.
    DO TRANSACTION:
        IF pcMode = "New" THEN 
            CREATE commercial.
        ELSE
            FIND commercial WHERE ROWID(commercial) = ttcommercial.RowIdent 
                EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        /* Do the following for both new and modified records */
        IF AVAILABLE commercial THEN
            BUFFER-COPY ttcommercial EXCEPT RowIdent TO commercial.
        ELSE
            IF LOCKED (commercial) THEN
                RETURN "Record is locked.  Try later.".
            ELSE 
                RETURN "Record has been deleted!".
    END. /* Transaction */
    FIND CURRENT commercial NO-LOCK NO-ERROR.
    BUFFER-COPY commercial TO ttcommercial.
    ttcommercial.rowIdent = ROWID(commercial).
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Shutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Shutdown Procedure 
PROCEDURE Shutdown :
/*------------------------------------------------------------------------------
  Purpose: Delete the procedure from memory if it is running persistently.    
  Parameters:  <none>
  Notes: Normally executed in response to a Shutdown event.      
------------------------------------------------------------------------------*/
    IF THIS-PROCEDURE:PERSISTENT THEN
        DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

