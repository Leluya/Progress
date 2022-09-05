# <span style="color: #4523d2"> Fonction ROWID</span> #

```
DEFINE VARIABLE rRecord AS ROWID       NO-UNDO.

FIND FIRST state.
DISPLAY state WITH 1 COLUMN.
PAUSE.
rRecord = ROWID(state).

FIND  LAST state.
DISPLAY state WITH 1 COLUMN.
PAUSE.
FIND state WHERE ROWID(state) = rRecord.
DISPLAY state WITH 1 COLUMN.
```