DO:
    ASSIGN
      lvcmode = "Lecture"
      BtnAjouter:LABEL = "Ajouter"
      BtnModifier:SENSITIVE = TRUE
      BtnModifier:VISIBLE = TRUE
      BtnDelete:SENSITIVE = TRUE
      BtnDelete:VISIBLE = TRUE
      BtnCancel:VISIBLE = FALSE
      BtnCancel:VISIBLE = FALSE
      finsalesrep:SENSITIVE = FALSE
      finregion:SENSITIVE = FALSE
      finrepname:SENSITIVE = FALSE
      .
      
     APPLY "VALUE-CHANGED" TO BROWSE brwSalesrep.
     
END.

