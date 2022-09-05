DO:
   DO:
    DEFINE VARIABLE lvlchoice AS LOGICAL NO-UNDO.
    MESSAGE "Voulez-vous supprimer " + salesrep.salesrep + "de cet enregistrement?"
        VIEW-AS ALERT-BOX INFORMATIOn BUTTON YES-NO
        UPDATE lvlchoice.
    IF lvlchoice THEN
    DO:
        FIND CURRENT salesrep EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF AVAILABLE salesrep 
        THEN DO:
            DELETE salesrep.
        END.
        ELSE DO:
            IF LOCKED salesrep
            THEN DO:
                MESSAGE "L'enregistrement est en cours d'utilisation" SKIP
                "Essayez ultérieurement!"
                    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
            END.
            ELSE DO:
                MESSAGE "Cet enregistrement à déjà été supprimé!"
                    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
            END.
        END.
        {&OPEN-QUERY-brwsalesrep}
    END.
    ELSE DO:
        /* je ne fais rien */
    END.
END.
END.