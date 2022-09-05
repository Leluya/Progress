DO:
    &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
      &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
        RUN dispatch IN THIS-PROCEDURE ('exit').
      &ELSE
        RUN exitObject.
      &ENDIF
    &ELSE
        APPLY "CLOSE":U TO THIS-PROCEDURE.
    &ENDIF
  END.