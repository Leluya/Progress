# <span style="color: #4523d2">2eme JOURS de formation<span> #

##  Exmaple avec AND
```
FOR EACH _file
    WHERE _owner = "PUB"
        AND _tbl-type = "T":
    DISPLAY _file-name.
END.
```
## Si plusiseurs BDD, bien mettre le nom de la BDD, ex sports2000 et sports3000
```
FIND FIRST sports2000.Item.
DISPLAY
	sports2000.ItemName
	sports2000.Price
	sports2000.Weight.
```
**Très bonne écriture, mais lour à écrire.**

## Afficher sur une colonne plursoeurs info 
```
FIND Item 1.
DISPLAY Item WITH 1 COLUMN
```
**Possible de changer le nbre de colonne**

## Mettre EXCEPT pour ne pas avoir une pou plusiseurs info d'une table
```
FIND FIRST Item.
DISPLAY Item EXCEPT CatDescription.
```

## Pour utiliser FIND, il faut forcément une condition, FIND ne peut être seul, ex:
```
FIND Item.
DISPLAY Item WITH 1 COLUMN.
```
**Ici erreur, car FIND n'a pas de condition**

## exo manipulation sur REPEAT, FIND, DISPLAY
```
REPEAT:
    FIND NEXT salesRep.
        DISPLAY SalesRep RepName Region.
END.

FIND FIRST SalesRep
WHERE Region = "Central".
    DISPLAY SalesRep RepName Region.

REPEAT:
    FIND NEXT salesRep 
    WHERE Region = "Central" .
        DISPLAY SalesRep RepName Region.
END.
```

## FOR EACH avec conditions:
```
FOR EACH salesRep 
    WHERE salesrep > "DKP" 
        AND salesrep <= "KIK" 
        AND salesrep <> "HXM"
        OR Region < "F"
        :
    DISPLAY SalesRep RepName Region
	. 
END.
```

## La même avec une meilleur indentation
```
FOR EACH salesRep 
    WHERE salesrep > "DKP" 
        AND salesrep <= "KIK" 
        AND salesrep <> "HXM"
        OR Region < "F"
    :
    DISPLAY 
        SalesRep 
        RepName 
        Region
        . 
END.
```

## Utiliser CONTAINS, 3 exemples:
```
FOR EACH ITEM 
    WHERE ItemName CONTAINS "pol*" 
    :
    DISPLAY 
        ItemNum 
        ItemName 
        price
        . 
END.

FOR EACH ITEM 
    WHERE ItemName CONTAINS "pole ^ poles" 
    :
    DISPLAY 
        ItemNum 
        ItemName 
        price
        . 
END.

FOR EACH ITEM 
    WHERE ItemName CONTAINS "ball" 
    :
    DISPLAY 
        ItemNum 
        ItemName 
        price
        . 
END.
```

## Faire un tri par prix décroissant par exemple:
```
FOR EACH ITEM 
    WHERE ItemName CONTAINS "pol*"
    BY price DESCENDING
    :
    DISPLAY 
        ItemNum 
        ItemName 
        price
        . 
END.
```

## Autre ex de tries
```
FOR EACH ITEM
	BY category1BY itemName DESCENDING:
	DISPLAY itemnum itemname category1.
END.
```

## Enlever des doublouns
```
FOR EACH ITEM 
    BREAK BY category1
    :
    IF FIRST-OF(category1) 
    THEN DO:
        DISPLAY  category1.
    END.
END.
```