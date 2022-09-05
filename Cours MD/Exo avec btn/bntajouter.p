DO:
    
    CASE lvcmode: 
        WHEN "Lecture" 
        THEN DO:

         ASSIGN
          lvcmode = "Ajouter"
          BtnAjouter:LABEL = "Enregistrer"
          BtnModifier:SENSITIVE = FALSE
          BtnModifier:VISIBLE = FALSE
          BtnDelete:SENSITIVE = FALSE
          BtnDelete:VISIBLE = FALSE
          BtnCancel:VISIBLE = TRUE
          BtnCancel:SENSITIVE = TRUE
          finsalesrep:SENSITIVE = TRUE
          finregion:SENSITIVE = TRUE
          finrepname:SENSITIVE = TRUE
          .
          
         ASSIGN
            finsalesrep = ""
            finregion = ""
            finrepname = ""
            .
            
          DISPLAY 
            finsalesrep 
            finregion
            finrepname
            WITH FRAME default-frame
            .         
    END. /* Lecture */
    WHEN "Modification"
    THEN DO:
         ASSIGN
            finsalesrep 
            finregion
            finrepname
            .
        FIND FIRST salesrep WHERE salesrep.salesrep = finsalesrep NO-LOCK NO-ERROR.
        IF AVAILABLE salesrep
        THEN DO:
            ASSIGN
                salesrep.region = finregion
                salesrep.repname = finrepname
                salesrep.salesrep = finsalesrep
                .
                
            {&OPEN-QUERY-brwsalesrep} 
            FIND salesrep WHERE salesrep.salesrep = finsalesrep NO-LOCK.
            REPOSITION brwsalesrep TO ROWID ROWID(salesrep).
            brwsalesrep:GET-REPOSITIONED-ROW().
            ASSIGN
              lvcmode = "Lecture"
              BtnAjouter:LABEL = "Ajouter"
              BtnModifier:SENSITIVE = TRUE
              BtnModifier:VISIBLE = TRUE
              BtnDelete:SENSITIVE = TRUE
              BtnDelete:VISIBLE = TRUE
              BtnCancel:VISIBLE = FALSE
              BtnCancel:SENSITIVE = FALSE
              finsalesrep:SENSITIVE = FALSE
              finregion:SENSITIVE = FALSE
              finrepname:SENSITIVE = FALSE
              .
               END.
             ELSE DO:
                IF LOCKED state
                THEN DO:
                    MESSAGE "L'enregistrement est en cours d'utilisation." SKIP
                        "Essayez à nouveau plus tard."
                        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
                END.
                ELSE DO:
                    MESSAGE "Cet enregistrement à été supprimé par ailleur!"
                        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
                END.
    END.
    END. /* Modification */
     WHEN "Ajouter"
    THEN DO:
        ASSIGN
            finsalesrep 
            finregion
            finrepname
            .
        FIND FIRST salesrep WHERE salesrep.salesrep = finsalesrep NO-LOCK NO-ERROR.
        IF AVAILABLE salesrep
        THEN DO:
             MESSAGE "Un Salesrep avec le code: " + finsalesrep + " existe déjà"
                 VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
             UNDO, LEAVE.
        END.
        ELSE DO:
            CREATE salesrep.
            ASSIGN
                salesrep.region = finregion
                salesrep.repname = finrepname
                salesrep.salesrep = finsalesrep
                lvcmode = "Lecture"
                .
                
            {&OPEN-QUERY-brwsalesrep} 
            FIND salesrep WHERE salesrep.salesrep = finsalesrep NO-LOCK.
            REPOSITION brwsalesrep TO ROWID ROWID(salesrep).
            brwsalesrep:GET-REPOSITIONED-ROW().
            ASSIGN
              lvcmode = "Lecture"
              BtnAjouter:LABEL = "Ajouter"
              BtnModifier:SENSITIVE = TRUE
              BtnModifier:VISIBLE = TRUE
              BtnDelete:SENSITIVE = TRUE
              BtnDelete:VISIBLE = TRUE
              BtnCancel:VISIBLE = FALSE
              BtnCancel:SENSITIVE = FALSE
              finsalesrep:SENSITIVE = FALSE
              finregion:SENSITIVE = FALSE
              finrepname:SENSITIVE = FALSE
              .
        END.
        
                        
    END.  /* Ajouter */
    END CASE.
    
END.

