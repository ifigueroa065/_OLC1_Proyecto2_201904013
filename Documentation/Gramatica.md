:anger: GRAMÁTICA  :anger:
=================

##  :file_folder:  Index  
-  :file_folder: [Terminales](#terminales)
-  :file_folder:[No Terminales](#noterminales)
-  :file_folder: [Producciones](#producciones)

<div id='terminales'/>

## :open_file_folder: Terminales
   
   
   | **Name** | **REGEX** | 
   |-------|---------|
   |`ER_digit`  | [0-9]
   | `ER_letter`        |  [A-Za-z] 
   |`ER_simbols`       | [!-$]|[&-)]|\/|-|[<->]|@|[\[-\`]
   | `ER_multiline`     |  \<\!([^"!>"]|[\r|\f|\s|\t|\n])*\!\>  
   | `ER_commentline`    | \/\/.* 
   | `ER_strings`    | \"(\!|[\#-\»]|\s)*\"     
   | `ER_arrow`   | -(\s)*> 
   | `ER_id` | {ER_letter}({ER_letter}|{ER_letter}|{ER_digit}|_)+ 
   | `ER_special` | \\n|\\\"|\\\'
   | `ER_space`   |  [\r|\f|\s|\t|\n]
   
   
   | **Name** | **Symbol** | 
   |-------|---------|
   | `all`   |  CONJ  
   | `concat`  | .
   | `or` | \|
   | `kleene`   |  *  
   | `key_abre`  | {
   | `key_cierra` | } 
   | `comma`   |  ,  
   | `dottwo`  | :
   | `dotcomma` | ;
   | `positiva`   |  + 
   | `cerouno`  | ?
   | `guion` | ~
   

<div id='noterminales'/>

## :open_file_folder: No terminales

   | **NAME**    |    **NAME** 
   |---------------|----------------|
   |`ADDER`          | `SYMBOLITO`   
   | `EXTRA`   |   `GROUP`  
   |`SO`|  `UNARY`      
   | `CONTENT`        |  `INIT`       
   | `ALL` | `CHECK`     
   | `VALUE`        | `BIN` 
   | `EXPRESION`        |   `NOT` 


<div id='producciones'/>

## :open_file_folder: Producciones
`SO -> key_abre CONTENT key_cierra `

`CONTENT -> INIT percentage percentage percentage percentage CHECK  `


`INIT -> ALL INIT
                | EXPRESION INIT
                | ALL
                | EXPRESION `

`ALL ->  all dottwo ER_id:a ER_arrow NOT:b dotcomma `

`NOT ->  ER_letter:a guion ER_letter:b
         |ER_digit:a guion ER_digit:b
         |SYMBOLITO:a guion SYMBOLITO:b
         |GROUP:a`

`VALUE -> ER_letter:a             
|ER_digit:a        
|SYMBOLITO:a`

`BIN -> concat:a 
       |or:a`   

`UNARY  -> kleene:a
          |positiva:a
          |cerouno:a  `      


`SYMBOLITO -> ER_simbols :a              
|percentage:a          
|concat:a       
|or:a                   
|kleene:a              
|positiva:a             
|cerouno:a` 


`GROUP -> VALUE:a coma GROUP:b
         |VALUE:a` 

`EXPRESION -> ER_id:a ER_arrow E:b dotcomma`

`EXTRA ->BIN:a EXTRA:b EXTRA:c
|key_abre ER_strings:a key_cierra
|UNARY:a EXTRA:b
|ADDER:a`  

`ADDER -> ER_strings:a
|ER_special:a
|ER_letter:a
|ER_digit:a` 
           

`CHECK -> ER_id:a dottwo ER_strings:b dotcomma CHECK
|ER_id:a dottwo ER_strings:b dotcomma`