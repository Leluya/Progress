# <span style="color: #4523d2">3eme Jours</span> #

## utilisation de variable ex simple:
```
DEFINE VARIABLE cPhone AS CHARACTER NO-UNDO.
DEFINE VARIABLE lYes AS LOGICAL NO-UNDO.
DEFINE VARIABLE iNumber AS INTEGER NO-UNDO.
DISPLAY cPhone lYes iNumber.
```

## Exemple pour definir un chiffre en décimal et le format
```
DEFINE VARIABLE dVar AS DECIMAL NO-UNDO.

dVar = 123456.123456789.

DISPLAY dVar.
PAUSE.
DISPLAY dVar FORMAT ">>>>>>.999999999".
PAUSE.
DISPLAY dVar FORMAT "99999999.999999".
PAUSE.
DISPLAY dVar FORMAT ">>>>>>>>.999999999".
PAUSE.
DISPLAY dVar FORMAT ">>>>>>.".
PAUSE.
DISPLAY dVar FORMAT ">>>>.999999999".
PAUSE. 
```

## manipulation sur les dates
```
DEFINE VARIABLE dtBirthdate AS DATE  NO-UNDO.
DEFINE VARIABLE iAge AS INTEGER     NO-UNDO.

// dtBirthdate = DATE(07, 11, 1983). en donnant la date de naissance
UPDATE dtBirthdate FORMAT "99/99/9999".   // en saisissant la date de naissance

MESSAGE "vous aurez à la fin de l'année " YEAR(TODAY) - YEAR(dtBirthdate) "ans"
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
```

## Calcul de reste de congés en semaine et jours avec un modulo
```
FOR EACH employee:
    DISPLAY 
        empnum                                      LABEL "No Employé" 
        VacationDaysLeft                            LABEL "jours de congés"
        INTEGER (TRUNCATE(VacationDaysLeft / 5,0))  LABEL "semaines"
        VacationDaysLeft MODULO 5                   LABEL "jours"
        .
END.
```

## Exemple avec TRUNCATE, ROUND et INTEGER pour redonner le chiffre définit
```
DEFINE VARIABLE dTest AS DECIMAL FORMAT "999.9999" NO-UNDO 
    INITIAL "350.9875" .

 MESSAGE 
    "Original value: " dTest            SKIP
    "Integer: "        INTEGER(dTest)   SKIP
    "Round: "          ROUND(dTest, 0)  SKIP
    "Truncate: "       TRUNCATE(dTest, 0)
     VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
```

## Concatenation avec + ou utilisation de SUBSTITUTE, ex:
```
DEFINE VARIABLE cFullName AS CHARACTER   NO-UNDO
    FORMAT "x(32)".
DEFINE VARIABLE cFirstName AS CHARACTER   NO-UNDO
    INITIAL "Alexandre".
DEFINE VARIABLE cMiddleInitial AS CHARACTER   NO-UNDO
    INITIAL "L".
DEFINE VARIABLE cLastName AS CHARACTER   NO-UNDO
    INITIAL "Grand".


cFullName = SUBSTITUTE("&1 &2 &3",cFirstName, cMiddleInitial, cLastName ).

DISPLAY cFullName. // FORMAT "x(32)" dans le display
```

## Passer en majuscule et minuscule
```
FOR EACH Customer:
    DISPLAY
        NAME
        CAPS(customer.NAME) LABEL "Majuscule" FORMAT "x(20)"
        LC(customer.NAME) LABEL "Minuscule" FORMAT "x(20)"
        .
END.
```

## **Les substring avec les espaces !!**
```
DEFINE VARIABLE cMyString AS CHARACTER  FORMAT "x(10)" NO-UNDO .
DEFINE VARIABLE cMyString2 AS CHARACTER  FORMAT "x(10)" NO-UNDO .

cMyString = " ABCDEFG  ".
cMyString2 = TRIM(cMyString) .

MESSAGE 
    "*" cMyString "*" SKIP
    "Longueur cMyString:" LENGTH(cMyString) SKIP 
    "Extraction:" SUBSTRING(cMyString,3,4) SKIP
    "*" cMyString2 "*" SKIP
    "Utilisation de Trim:" SUBSTRING(cMyString2,3,4)
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
```

## Utilisation d'ENTRY, NUM-ENTRIES, LOOKUP, voici 2 ex:
```
DEFINE VARIABLE cList AS CHARACTER INITIAL
    "A,B,C,D,E,F,G,H,I,J,K" NO-UNDO.
 
MESSAGE 
    LOOKUP("c", cList) SKIP
    ENTRY(3, cList) SKIP
    NUM-ENTRIES(cList)
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

    
DEFINE VARIABLE cList AS CHARACTER   NO-UNDO.
cList = "Nord, Sud, Est, Ouest".

MESSAGE 
    NUM-ENTRIES(cList) SKIP(2)
    LOOKUP("Nord", cList) SKIP
    ENTRY(3, cList) SKIP
    LOOKUP("Ouest", cList) SKIP
    ENTRY(1, cList) 
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
```

## Utilisation de REPLACE
```
DEFINE VARIABLE cList AS CHARACTER   NO-UNDO.
cList = "Nord$Sud$Est$Ouest".

cList = REPLACE("Nord$Sud$Est$Ouest", "$", "," ).

MESSAGE 
    NUM-ENTRIES(cList) SKIP(2)
    LOOKUP("Nord", cList) SKIP
    ENTRY(3, cList) SKIP
    LOOKUP("Ouest", cList) SKIP
    ENTRY(1, cList) 
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
```
**Si separateur spéciaux, sans utiliser le REPLACE, on fait ça:**

```
DEFINE VARIABLE cList AS CHARACTER   NO-UNDO.
cList = "Nord¤Sud¤Est¤Ouest".

MESSAGE 
    NUM-ENTRIES(cList, "¤") SKIP(2)
    LOOKUP("Nord", cList, "¤") SKIP
    ENTRY(3, cList, "¤") SKIP
    LOOKUP("Ouest", cList, "¤") SKIP
    ENTRY(1, cList, "¤") 
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
```

## remplacer autrement 
```
DEFINE VARIABLE cList AS CHARACTER   NO-UNDO.
ASSIGN 
    cList = "Nord¤Sud¤Est¤Ouest"
    ENTRY( LOOKUP("Nord", cList, "¤"),cList, "¤") = "North"
    ENTRY( LOOKUP("Sud", cList, "¤"),cList, "¤") = "South"
    ENTRY( LOOKUP("Est", cList, "¤"),cList, "¤") = "East"
    ENTRY( LOOKUP("Ouest", cList, "¤"),cList, "¤") = "West"
    .

MESSAGE 
    NUM-ENTRIES(cList, "¤") SKIP(2)
    LOOKUP("Nord", cList, "¤") SKIP
    ENTRY(3, cList, "¤") SKIP
    LOOKUP("Ouest", cList, "¤") SKIP
    ENTRY(1, cList, "¤") 
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
```

## exo cdouble tableau et changement de langue
```
DEFINE VARIABLE ix AS INTEGER NO-UNDO.
DEFINE VARIABLE cList AS CHARACTER   NO-UNDO
    INITIAL "Nord, Sud, Est, Ouest"
    . 
DEFINE VARIABLE cList2 AS CHARACTER   NO-UNDO
    INITIAL "North, South, East, West"
    .
    
    
MESSAGE cList
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

REPEAT ix = 1 TO NUM-ENTRIES(cList):
    DISPLAY 
        ENTRY(ix, cList) LABEL "Original"
        ENTRY(ix, cList2) LABEL "Remplacé"
        .
END.
    
MESSAGE cList2
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
```
**autre façon**
```
DEFINE VARIABLE ix AS INTEGER NO-UNDO.
DEFINE VARIABLE cList AS CHARACTER   NO-UNDO
    INITIAL "Nord, Sud, Est, Ouest"
    . 
DEFINE VARIABLE cChange AS CHARACTER   NO-UNDO.
        
MESSAGE cList
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

REPEAT ix = 1 TO NUM-ENTRIES(cList):
    cChange = ENTRY(ix, cList). 
    CASE ENTRY(ix, cList):
        WHEN "Nord" THEN ENTRY(ix, cList) = "North".
        WHEN "Sud" THEN ENTRY(ix, cList) = "South".
        WHEN "Est" THEN ENTRY(ix, cList) = "East".
        WHEN "Ouest" THEN ENTRY(ix, cList) = "West".
       END CASE.
       DISPLAY
        cChange LABEL "Original" FORMAT "x(12)"
        ENTRY(ix, cList) LABEL "Traduction" FORMAT "x(12)".
END.
    
MESSAGE cList
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
```

## Assigner un booléen sur dif de calcul pour crédit
```
DEFINE VARIABLE lcreditstatus AS LOGICAL 
    FORMAT "good,/declined" 
    LABEL "Credit Status"   
    NO-UNDO.

FOR EACH customer:
    IF CreditLimit - Balance <= 800 THEN  lcreditstatus = FALSE.
    ELSE lcreditstatus = TRUE.
        
    DISPLAY 
        custNum 
        CreditLimit 
        Balance
        CreditLimit - Balance LABEL  "Avail. Credit"
        lcreditstatus
        .
END.
```

**ou avec ecriture compléte de IF THEN ELSE**
```
DEFINE VARIABLE lcreditstatus AS LOGICAL 
    FORMAT "good,/declined" 
    LABEL "Credit Status"   
    NO-UNDO.

FOR EACH customer:
    IF CreditLimit - Balance <= 800 
    THEN DO:  
        lcreditstatus = FALSE.
    END.
    ELSE DO: 
        lcreditstatus = TRUE.
    END.
        
    DISPLAY 
        custNum 
        CreditLimit 
        Balance
        CreditLimit - Balance LABEL  "Avail. Credit"
        lcreditstatus
        .
END.
```
ou plus simple
```
FOR EACH customer:
     
    DISPLAY 
        custNum 
        CreditLimit 
        Balance
        CreditLimit - Balance LABEL  "Avail. Credit"
        NOT(CreditLimit - Balance <= 800) LABEL "Credit Status" FORMAT "Good/Declined" 
        .
END.
```

## exemple détaillé avec IF THEN ELSE:
```
IF YEAR(TODAY) = 2021
THEN DO:
    MESSAGE "2021"
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    
END.
ELSE IF YEAR(TODAY) = 2020
THEN DO:
    MESSAGE "2020"
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
END.
ELSE DO:
    MESSAGE "???!!!"
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
END.
```

## Récup boutton
```
DEFINE VARIABLE ichoice AS LOGICAL     NO-UNDO.

MESSAGE "coucou"
    VIEW-AS ALERT-BOX INFORMATION BUTTONS YES-NO-CANCEL.
    
CASE ichoice:
    WHEN TRUE THEN /* Yes */ DO:
    MESSAGE "Yes"
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.
        WHEN TRUE THEN /* No */ DO:
    MESSAGE "No"
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.
        WHEN TRUE THEN /* Cancel */ DO:
    MESSAGE "Cancel"
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.
END CASE.
```

##  DO...WHILE
```
DEFINE VARIABLE lChoice AS LOGICAL INITIAL TRUE    NO-UNDO.

DO WHILE lChoice:
    MESSAGE "On continue ?"
        VIEW-AS ALERT-BOX INFORMATION BUTTONS YES-NO.
        UPDATE lChoice.
END.
```

## les différentes boucles que l'on peut afficher à l'écran
```
DO icount = 1 TO 5:
    DISPLAY icount.
    PAUSE.
END.
```
```
REPEAT icount = 1 TO 5:
    DISPLAY icount.
    PAUSE.
END.
```
```
FOR EACH customer
    WHERE custNum <= 5
    :
    DISPLAY custNum.
END.
```