ON CHOOSE OF ExportPrenom IN FRAME DEFAULT-FRAME /* Export */
DO:
    DEFINE VARIABLE num AS INTEGER NO-UNDO.
    DEFINE VARIABLE num2 AS INTEGER NO-UNDO.
    
       /* On affiche le sablier */
      SESSION:SET-WAIT-STATE("general").
      
   OUTPUT TO VALUE ("C:\Temp\test_export_prenom.txt").
    PUT "début = "  NOW SKIP.
   FOR EACH CONTRAT EXCLUSIVE-LOCK
   WHERE CONTRAT.soc_code = "TLSA" :
       IF CONTRAT.Con_nom <> "" THEN 
       DO :
           PUT "CONTRAT.co_numero = " CONTRAT.Co_numero_contrat NOW  SKIP.
           FIND FIRST CONTACT WHERE CONTACT.Cli_Code = CONTRAT.Cli_Code 
           AND CONTACT.Con_nom = CONTRAT.Con_nom 
           AND CONTACT.Fon_code = CONTRAT.Fon_code NO-LOCK NO-ERROR. 
           IF AVAILABLE CONTACT THEN 
           DO :
               ASSIGN 
                   CONTRAT.Signataire1_prenom = CONTACT.Con_prenom 
                    num = num + 1. 
                .
           END. /* DO */
       END. /* IF CONTRAT.Con_nom*/
       
       IF CONTRAT.Co_signataire2 <> "" THEN 
       DO :
           FIND FIRST B_CONTACT WHERE B_CONTACT.Cli_Code = CONTRAT.Cli_Code 
           AND B_CONTACT.Con_nom = CONTRAT.Co_signataire2
           AND B_CONTACT.Fon_code = CONTRAT.Fon_code2 NO-LOCK NO-ERROR. 
           IF AVAILABLE B_CONTACT THEN 
           DO :
               ASSIGN 
                   CONTRAT.Signataire2_prenom = B_CONTACT.Con_prenom 
                    num2 = num2 + 1. 
                .  
           END. /* DO */  
       END.  /*IF CONTRAT.Co_signataire2*/
   END. /* FOR EACH CONTRAT */
   
 PUT "fin = " NOW SKIP.
 OUTPUT CLOSE.  
       
       MESSAGE "ok" num SKIP
        num2
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

END.

/************************************************** */
/* EXEMPLE DE CODE FOURNIT PAR MORGANNE */
/************************************************** */

EXPORT:

    OUTPUT TO VALUE("C:\Users\morgane.gastrin\Documents\Progress\POE\monFichier.csv").
    /*entêtes de colonnes*/
    PUT "titre1;titre2;titre3;...." SKIP.
    FOR EACH maTT:
          PUT madonnée1  ";" 
              madonnée2  ";"
              ...
        SKIP.	  
    
    END. /*FOR EACH MAtt*/
    
    OUTPUT CLOSE.
    /*OUvrir le fichier directement*/
    DOS SILENT VALUE("START C:\Users\morgane.gastrin\Documents\Progress\POE\monFichier.csv").
    
    MESSAGE "ok "
      VIEW-AS ALERT-BOX.
      
      
      
    PROCEDURE importFile :
    
    DEFINE VARIABLE c-File       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-NbColumn   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE madonnee1    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE madonnee2    AS CHARACTER   NO-UNDO.
    
    
    
    ASSIGN
        c-File = getFile("Sélectionner un fichier", "Fichier OBJ VENDEUR", "*.*", "")
        .
    IF c-File = "" THEN DO:
        RETURN.
    END.
    
    INPUT FROM VALUE(c-File).
    REPEAT:
        IMPORT DELIMITER ";"
            madonnee1
            madonnee2
            ...
            .
         CREATE tt_OBJ_VEND.
        ASSIGN   
          tt_donnee1                       = madonnee1                           
          tt_donnee2                           = madonnee2                   
          ...
          .
    END.
    
    
    FUNCTION getFile RETURNS CHARACTER
        ( pc-Title      AS CHARACTER,
        pc-Filter     AS CHARACTER,
        pc-FileSpec   AS CHARACTER,
        pc-InitialDir AS CHARACTER ) :
        /*------------------------------------------------------------------------------
          Purpose:  
            Notes:  
        ------------------------------------------------------------------------------*/
        /* Definitions */
        DEFINE VARIABLE c-File     AS CHARACTER NO-UNDO.
        DEFINE VARIABLE c-FileName AS CHARACTER NO-UNDO.
        DEFINE VARIABLE c-FilePath AS CHARACTER NO-UNDO.
        DEFINE VARIABLE i-Num      AS INTEGER   NO-UNDO.
        DEFINE VARIABLE l-Return   AS LOGICAL   NO-UNDO.
    
        SYSTEM-DIALOG GET-FILE c-FilePath
            TITLE       pc-Title
            FILTERS     pc-Filter pc-FileSpec
            INITIAL-DIR pc-InitialDir
            MUST-EXIST
            USE-FILENAME
            UPDATE l-Return.
      
        IF l-Return THEN 
        DO:
            /* On recherche si le FICHIER-TOTAL est dqn le propath */
            c-File = ENTRY( NUM-ENTRIES( c-FilePath, "\" ), c-FilePath, "\" ).
            IF SEARCH( c-File ) <> ? THEN RETURN c-File.
            /* On recherche dans le propath avec les dossiers */
            DO i-Num = NUM-ENTRIES( c-FilePath, "\" ) - 1 TO 1 BY -1:
                c-FileName = (IF c-FileName = "" THEN ENTRY( i-Num, c-FilePath, "\" ) ELSE ENTRY( i-Num, c-FilePath, "\" ) + "\" + c-FileName).
                IF SEARCH( c-FileName + "\" + c-File ) <> ? THEN RETURN c-FileName + "\" + c-File.
            END. /* DO i-Num */
            MESSAGE "Impossible de trouver le fichier dans le PROPATH"
                VIEW-AS ALERT-BOX WARNING BUTTONS OK.
        END.
        RETURN "".
    
    END FUNCTION.

/************************************************** */
/* EXEMPLE DE CODE AZZOUZ */
/************************************************** */

    ON CHOOSE OF importRD IN FRAME fMain /* Import DATA from RD */
    DO:

    DEFINE VARIABLE ProduitNum AS CHARACTER NO-UNDO.
    DEFINE VARIABLE produitNom AS CHARACTER NO-UNDO.
    DEFINE VARIABLE ProductRep AS CHARACTER NO-UNDO.
    DEFINE VARIABLE PrixVente AS CHARACTER NO-UNDO.    

        INPUT FROM VALUE("C:\temp\export_productRD.csv").
        REPEAT:
            IMPORT DELIMITER ";"
                ProduitNum
                produitNom
                ProductRep
                PrixVente
            .
            CREATE produits.
            ASSIGN   
            produits.produitNum  = INTEGER(produitNum)                       
            produits.produitNom   = produitNom
            produits.ProductRep = ProductRep
            produits.PrixVente  = INTEGER(PrixVente) . 
                        
            
        END.
    END.