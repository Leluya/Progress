# <span style="color: #4523d2">UTILISATION DE QUERY</span> #

## Première query:
```
DEFINE QUERY qState FOR state.
OPEN QUERY qState FOR EACH state WHERE region = "west".

REPEAT:
    GET NEXT qState.
    IF NOT AVAILABLE state THEN LEAVE.
    ELSE DISPLAY state. // pas obliger le ELSE mais pour la propreté il vaut mieux le garder
END.
MESSAGE "c'est fini!"
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
```

### autre solution:
```
DEFINE QUERY qState FOR state.
OPEN QUERY qState FOR EACH state WHERE region = "west".

REPEAT :
    GET NEXT qState.
    IF QUERY-OFF-END("qState") THEN LEAVE.
    DISPLAY state.
END.


CLOSE QUERY qState.
MESSAGE "c'est fini!"
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
```

## exemple d'une autre QUERY
```
DEFINE QUERY qCust FOR customer.
OPEN QUERY qCust FOR EACH customer WHERE NAME BEGINS "a".


REPEAT :
    GET NEXT qCust.
    IF QUERY-OFF-END("qCust") THEN LEAVE.
    DISPLAY custNum NAME.
END.


CLOSE QUERY qCust.
MESSAGE "c'est fini!"
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
```