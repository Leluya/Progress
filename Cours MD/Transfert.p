USING Progress.Json.ObjectModel.JsonObject.

DEFINE TEMP-TABLE ttProduct
    FIELD ProductName AS CHAR
    FIELD Weight AS INT
    FIELD MinQty AS INT
    FIELD Price AS INT
    .
/* 
DEFINE TEMP-TABLE notes
    FIELD invoice_note         AS CHARACTER
    FIELD apply_invoice_note   AS CHARACTER
    FIELD apply_reference      AS CHARACTER.*/

DEFINE VARIABLE oJson        AS JsonObject NO-UNDO. 
DEFINE VARIABLE oJsonProduct AS JsonObject NO-UNDO. 
// DEFINE VARIABLE oJsonNotes   AS JsonObject NO-UNDO. 

DEFINE VARIABLE jSon_string  AS CHARACTER  NO-UNDO.

/* Création d'un enregistrement dans la temp-tables */
CREATE ttProduct.
    ttProduct.ProductName = Product.ProductName
    ttProduct.MinQty = Product.MinQty
    ttProduct.Weight = Product.Weight
    ttProduct.Price = Product.Price
    .

/*CREATE notes.
ASSIGN notes.invoice_note       = "note from PROGRESSS"
       notes.apply_invoice_note = "apply note"
       notes.apply_reference    = "apply reference".*/

/* Création d'un nouveau JsonObjects */
oJson        = NEW JsonObject().
oJsonProduct = NEW JsonObject().
// oJsonNotes   = NEW JsonObject().

/* Ajout de la table Product */
oJson:Add("product", oJsonInvoice).
oJsonProduct:READ(TEMP-TABLE ttProduct:HANDLE).

/* 
/* Add the Notes table */
oJson:Add("notes", oJsonNotes).
oJsonNotes:READ(TEMP-TABLE notes:HANDLE).
*/

/* Write the JSON string to a character variable */
oJson:Write(jSon_string,TRUE). 

MESSAGE STRING(jSon_string) VIEW-AS ALERT-BOX.

/**************************************************************************/
/* Autre méthode using JsonArray instead JsonObject for the temp-tables: */
/**************************************************************************/

    USING Progress.Json.ObjectModel.JsonObject.
    USING Progress.Json.ObjectModel.JsonArray . 
    DEFINE VARIABLE oJson AS JsonObject NO-UNDO.
    /* Definition du JsonArray */
    DEFINE VARIABLE aJsonProduct AS JsonArray NO-UNDO.

    DEFINE TEMP-TABLE ttProduct
        FIELD ProductName AS CHAR
        FIELD Weight AS INT
        FIELD MinQty AS INT
        FIELD Price AS INT
        .

    /* Création du nouveau JsonObjects */
    oJson = NEW JsonObject().
    
    /* Création du nouveau JsonArrays */
    aJsonProduct = NEW JsonArray().

    CREATE ttProduct.
    ASSIGN 
        ttProduct.ProductName = "ProductName # 1"
        ttProduct.Weight = "Weight # 2"
        ttProduct.MinQty = "MinQty # 3"
        ttProduct.Price = "Price # 4"
        .
        
    CREATE ttProduct.
    ASSIGN 
        ttProduct.ProductName = "Field # 1 - 1"
        ttProduct.Weight = "Field # 1 - 2"
        ttProduct.MinQty = "MinQty # 1 - 3"
        ttProduct.Price = "Price # 1 - 4"
        .

    oJson:Add("ttProduct", aJsonTable).
    aJsonTable:READ(TEMP-TABLE ttProduct:HANDLE).

    DEF STREAM st1.

    OUTPUT STREAM st1 TO "C:\OpenEdge\WRK\ProjetTechnique POE\Telechargement\productValence.txt".
    oJson:writeStream("ST1",YES).
    OUTPUT STREAM st1 CLOSE.