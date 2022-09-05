# <span style="color: #4523d2">Information sur les GLOBAL</span> #

```
DEFINE NEW GLOBAL SHARED
 VARIABLE **** AS CHARACTER
```
NEW pour première définition, on partage cette variable pour tout le programme.  

Si on rappel la variable plus tard, il suffi de supprimer le NEW, exemple:  
```
DEFINE GLOBAL SHARED
 VARIABLE **** AS CHARACTER
```
