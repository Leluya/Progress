# REVISIONS

### Afficher la liste des clients qui ont leurs commande "shipped"
```
FOR EACH customer
    , EACH order OF customer
/* ou
    EACH order
    WHERE order.custnum =customer.custnum
    and orderstatus = "shipped"
*/
    WHERE orderstatus MATCHES "shipped"
    :
    DISPLAY customer.NAME FORMAT "x(20 )"
        customer.custnum
        ordernum
        orderstatus
        .
END.
```

### même chose en inversant order et customer dans le code et ajout de tris:
```
FOR EACH order
    WHERE orderstatus = "shipped"
    , EACH customer
    WHERE customer.custnum = order.custnum
    BY order.custnum 
    BY ordernum
    :
    DISPLAY customer.NAME FORMAT "x(20)"
        customer.custnum 
        ordernum
        orderstatus
        .
END.
```

### Toutes les commandes partilly shipped de chaque client:
```
FOR EACH order
    WHERE orderstatus = "partially shipped"
    , EACH customer
    WHERE customer.custnum = order.custnum
    BY order.custnum BY ordernum
    :
    DISPLAY customer.NAME FORMAT "x(20)"
        customer.custnum 
        ordernum
        orderstatus
        .
END.
```

### Toutes les factures non payées par mes clients, qui est le commercial:
```
FOR EACH invoice
    WHERE not(amount + shipcharge <= totalpaid)
    , EACH customer
    WHERE customer.custnum = invoice.custnum
    ,EACH  salesrep     
    WHERE salesrep.salesrep = customer.salesrep
    BY salesrep
    :
    DISPLAY  invoicenum
        amount
        customer.NAME FORMAT "x(20)"
        salesrep.Repname FORMAT "x(20)"
        phone FORMAT "x(16)"
        amount + shipcharge - totalpaid LABEL "Reste à payer"
        . 
END.
```
**Version avec variable :**
```
DEFINE VARIABLE mywarning AS CHARACTER   NO-UNDO.
DEFINE VARIABLE mycounter AS INTEGER     NO-UNDO.
DEFINE VARIABLE mythreshold AS INTEGER     NO-UNDO.

mythreshold = 4000.
mycounter = 0.
FOR EACH invoice
    WHERE not(amount + shipcharge <= totalpaid)
    , EACH customer
    WHERE customer.custnum = invoice.custnum
    ,EACH  salesrep 
    WHERE salesrep.salesrep = customer.salesrep
    BY salesrep
    :
    IF (amount + shipcharge - totalpaid > mythreshold) 
        THEN DO: 
            mywarning = "URGENT".
            mycounter = mycounter + 1.
        END.
        ELSE mywarning = "".
    
    DISPLAY  invoicenum
        amount
        customer.NAME FORMAT "x(20)"
        salesrep.Repname FORMAT "x(16)"
        phone FORMAT "x(16)"
        amount + shipcharge - totalpaid LABEL "Reste à payer"
        mywarning
        .                
END.
MESSAGE "il reste" mycounter "Facture avec montant >" mythreshold "à payer!!!"
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
```

**Version pour récupérer un fichier texte des infos lisible sur excel**
```
DEFINE VARIABLE mywarning AS CHARACTER   NO-UNDO.
DEFINE VARIABLE mycounter AS INTEGER     NO-UNDO.
DEFINE VARIABLE mythreshold AS INTEGER     NO-UNDO.

mythreshold = 4000.
mycounter = 0.
OUTPUT TO c:\temp\invoicereport.txt.
PUT UNFORMATTED  
        "Num Facture"  ";"
        "Montant"  ";"
        "Client" ";"
        "Commercial" ";"
        "Telephone" ";"
        "reste à payer" ";"
        "message"  SKIP
        .            
FOR EACH invoice
    WHERE not(amount + shipcharge <= totalpaid)
    , EACH customer
    WHERE customer.custnum = invoice.custnum
    ,EACH  salesrep 
    WHERE salesrep.salesrep = customer.salesrep
    BY salesrep
    :
    IF (amount + shipcharge - totalpaid > mythreshold) 
        THEN DO: 
            mywarning = "URGENT".
            mycounter = mycounter + 1.
        END.
        ELSE mywarning = "".
    
    PUT UNFORMATTED  invoicenum  ";"
        amount  ";"
        TRIM (customer.NAME) ";"
        TRIM (salesrep.Repname) ";"
        TRIM (phone) ";"
        amount + shipcharge - totalpaid ";"
        mywarning  SKIP
        .                
END.
MESSAGE "il reste" mycounter "Facture avec montant >" mythreshold "à payer!!!"
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
```

**Même solution mais on remplace avec ASSIGN et crée une variable pour le séparateur**
```
DEFINE VARIABLE mywarning AS CHARACTER   NO-UNDO.
DEFINE VARIABLE mycounter AS INTEGER     NO-UNDO.
DEFINE VARIABLE mythreshold AS INTEGER     NO-UNDO.
DEFINE VARIABLE mysep AS CHARACTER   NO-UNDO.

ASSIGN
    mythreshold = 4000
    mycounter = 0
    mysep = ";"
    .
OUTPUT TO c:\temp\invoicereport.txt.
PUT UNFORMATTED  
        "Num Facture"  mysep
        "Montant"  mysep
        "Client" mysep
        "Commercial" mysep
        "Telephone" mysep
        "reste à payer" mysep
        "message"  SKIP
        .            
FOR EACH invoice
    WHERE not(amount + shipcharge <= totalpaid)
    , EACH customer
    WHERE customer.custnum = invoice.custnum
    ,EACH  salesrep 
    WHERE salesrep.salesrep = customer.salesrep
    BY salesrep
    :
    IF (amount + shipcharge - totalpaid > mythreshold) 
        THEN DO:
            ASSIGN 
            mywarning = "URGENT"
            mycounter = mycounter + 1
            .
        END.
        ELSE mywarning = "".
    
    PUT UNFORMATTED  invoicenum  mysep
        amount  mysep
        TRIM (customer.NAME) mysep
        TRIM (salesrep.Repname) mysep
        TRIM (phone) mysep
        amount + shipcharge - totalpaid mysep
        mywarning  SKIP
        .                
END.
MESSAGE "il reste" mycounter "Facture avec montant >" mythreshold "à payer!!!"
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
```