/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lvlchoice AS LOGICAL     NO-UNDO.
DO WITH FRAME frmstate:
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
                finState:SENSITIVE = TRUE
                finStatename:SENSITIVE = TRUE
                finRegion:SENSITIVE = TRUE
                .
            ASSIGN
                finState = ""
                finStatename = ""
                finRegion = ""
                .
            DISPLAY 
                finState
                finStatename
                finRegion
                WITH FRAME frmState
                .
        END. /* Read Record */
        
        WHEN "Delete" THEN
        DO:
            MESSAGE "Voulez-vous supprimer cet état: " + state.statename + " ?"
                VIEW-AS ALERT-BOX INFORMATION BUTTONS YES-NO
                UPDATE lvlchoice.
            IF lvlchoice THEN
            DO:
                FIND CURRENT state EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
                IF AVAILABLE state
                THEN DO:
                    DELETE state.
                END.
                ELSE DO:
                    IF LOCKED state
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
                {&OPEN-QUERY-brwstate}
                .
                APPLY "VALUE-CHANGED" TO BROWSE BrwState.
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
                finState:SENSITIVE = FALSE
                finStatename:SENSITIVE = FALSE
                finRegion:SENSITIVE = FALSE
                .
            APPLY "VALUE-CHANGED" TO BROWSE brwstate.                
        END.
        WHEN "SaveNew"
        THEN DO:
            ASSIGN
                finstate
                finstatename
                finregion
                .
            FIND FIRST state WHERE state.state = finstate NO-LOCK NO-ERROR.
            IF AVAILABLE state
            THEN DO:
                MESSAGE "Un etat avec le code: " + finstate + " existe déjà!"
                    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
                UNDO, LEAVE.
            END.
            ELSE DO:
                CREATE state.
                ASSIGN 
                    state.state = finstate
                    state.statename = finstatename
                    state.region = finregion
                    .
                {&OPEN-QUERY-brwstate}
                FIND state WHERE state.state = finstate NO-LOCK.
                REPOSITION brwstate TO ROWID ROWID(state).
                brwstate:GET-REPOSITIONED-ROW().
                ASSIGN 
                    BtnAjouter:LABEL = "Ajouter"
                    BtnModifier:SENSITIVE = TRUE
                    BtnModifier:VISIBLE = TRUE
                    BtnSupprimer:SENSITIVE = TRUE
                    BtnSupprimer:VISIBLE = TRUE
                    BtnCancel:SENSITIVE = FALSE
                    BtnCancel:VISIBLE = FALSE
                    finState:SENSITIVE = FALSE
                    finStatename:SENSITIVE = FALSE
                    finRegion:SENSITIVE = FALSE
                    .
                lvcmode = "read".
            END.
        END. /* Save New record */

        WHEN "SaveUpdate"
        THEN DO:
            ASSIGN
                finstate
                finstatename
                finregion
                .
            FIND FIRST state WHERE state.state = finstate EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
            IF AVAILABLE state
            THEN DO:
                ASSIGN 
                    state.state = finstate
                    state.statename = finstatename
                    state.region = finregion
                    .
                {&OPEN-QUERY-brwstate}
                FIND state WHERE state.state = finstate NO-LOCK.
                REPOSITION brwstate TO ROWID ROWID(state).
                brwstate:GET-REPOSITIONED-ROW().
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
                    {&OPEN-QUERY-brwstate}
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
                finState:SENSITIVE = FALSE
                finStatename:SENSITIVE = FALSE
                finRegion:SENSITIVE = FALSE
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
                finStatename:SENSITIVE = TRUE
                finRegion:SENSITIVE = TRUE
                .
        END.

    END CASE.
END.
END PROCEDURE.
