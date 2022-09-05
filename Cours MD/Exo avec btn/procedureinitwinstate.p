lvcmode = "Lecture".
RUN enable_UI.

BtnCancel:VISIBLE IN FRAME default-frame = FALSE.
BtnCancel:SENSITIVE IN FRAME default-frame = FALSE.

APPLY "VALUE-CHANGED" TO BROWSE brwSalesrep.