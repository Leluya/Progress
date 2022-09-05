    REPEAT:
        IMPORT product NO-ERROR.
        IF NOT ERROR-STATUS:ERROR THEN
          DO:
            FOR EACH Product:
            icount = icount + 1.
            FIND NEXT Product.
            MESSAGE "Vous avez ajouté : " + STRING(icount) + "nouveau(x) produit(s)"
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
          END.
        END.
        ELSE DO:
            MESSAGE "Il n'y a pas de nouveau(x) produit(s)!"
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK. 
        END.
    END.