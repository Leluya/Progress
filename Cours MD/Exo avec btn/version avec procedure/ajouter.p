DO:
    CASE lvcmode:
        WHEN "read"
        THEN DO:
            lvcmode = "add".
            RUN GestionState.
        END.
        WHEN "update"
        THEN DO:
            lvcmode = "saveupdate".
            RUN GestionState.           
        END.
        WHEN "add"
        THEN DO:
            lvcmode = "savenew".
            RUN GestionState. 
        END.
    END CASE.
END.