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
                         