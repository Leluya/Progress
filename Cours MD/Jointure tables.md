# <span style="color: #4523d2">COMMENT FAIRE DES JOINTURES EN PROGRESS </span>

## Jointure simple:
```
FOR EACH customer 
    WHERE custnum < 3
    , EACH order
    WHERE order.custnum = customer.custnum
    :
    DISPLAY 
        customer.custnum 
        ordernum 
        NAME FORMAT "x(20)" 
        carrier FORMAT "x(20)"
        .
END.
```

## autre façon de faire la jointure simple:
```
FOR EACH customer 
    WHERE custnum < 3
    , EACH order OF customer
    :
    DISPLAY 
        customer.custnum 
        ordernum 
        NAME FORMAT "x(20)" 
        carrier FORMAT "x(20)"
        .
END.
```

## avec 3 tables exemple:
```
FOR EACH customer 
    WHERE custnum < 3
    , EACH order OF customer
    , EACH orderline 
    WHERE orderline.ordernum = order.ordernum
    :
    DISPLAY 
        customer.custnum 
        order.ordernum
        linenum
        NAME FORMAT "x(16)" 
        carrier FORMAT "x(16)"
        .
END.
```

## Entre 4 tables:
```
FOR EACH customer 
    WHERE custnum < 3
    , EACH order OF customer
    , EACH orderline 
    WHERE orderline.ordernum = order.ordernum
    , EACH ITEM 
    WHERE ITEM.itemnum = orderline.itemnum
    :
    DISPLAY 
        customer.custnum 
        order.ordernum
        orderline.linenum
        itemname
        NAME FORMAT "x(16)" 
        carrier FORMAT "x(16)"
        .
END.
```

## Jointure sur une Query avec 3 tables, exemple:
```
DEFINE QUERY qCustOrder FOR customer, order, orderline.
OPEN QUERY qCustOrder 
    FOR EACH customer 
    WHERE customer.custnum <3
    , EACH order
    WHERE order.custnum = customer.custnum
    , EACH orderline
    WHERE orderline.ordernum = order.ordernum
    .


REPEAT :
    GET NEXT qCustOrder.
    IF QUERY-OFF-END("qCustOrder") THEN LEAVE.
    DISPLAY 
       customer.custnum 
       order.ordernum
       linenum
       NAME FORMAT "x(16)" 
       carrier FORMAT "x(16)"
       .
END.


CLOSE QUERY qCustOrder.
MESSAGE "c'est fini!"
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
```

## Nouvelle exemple de jointure avec une Query avec 4 tables:
```
DEFINE QUERY qCustOrder FOR customer, order, orderline, ITEM.
OPEN QUERY qCustOrder 
    FOR EACH customer 
    WHERE customer.custnum <3
    , EACH order
    WHERE order.custnum = customer.custnum
    , EACH orderline
    WHERE orderline.ordernum = order.ordernum
    , EACH ITEM 
    WHERE ITEM.itemnum = orderline.itemnum
    .


REPEAT :
    GET NEXT qCustOrder.
    IF QUERY-OFF-END("qCustOrder") THEN LEAVE.
    DISPLAY 
       customer.custnum 
       order.ordernum
       orderline.linenum
       itemname FORMAT "x(16)"
       NAME FORMAT "x(16)" 
       carrier FORMAT "x(16)"
       .
END.


CLOSE QUERY qCustOrder.
MESSAGE "c'est fini!"
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
```