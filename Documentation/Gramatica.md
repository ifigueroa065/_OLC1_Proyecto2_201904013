:seedling: GRAMÁTICA  :seedling:
=================

##  :file_folder:  Index  
-  :file_folder: [Terminales](#terminales)
-  :file_folder:[No Terminales](#noterminales)
-  :file_folder: [Producciones](#producciones)

<div id='terminales'/>

## :open_file_folder: Terminales
   
   
   | **Name** | **value** | **Name** | **value** | 
   |-------|---------|-------|---------|
   | `PARABRIR` | (  | `PARCIERRE` | )
   | `COABRIR` | [  | `CORCIERRE` | ]
   | `LLAVABRIR` | { | `LLAVCIERRE` | }
   | `PUNTOCOMA` | ; | `COMA` | ,
   |`ESPACIOS`  | \s+  | `INT`     |  int
   | `COM DE UNA LINEA`        |  `\ / \ /.*`| `DOUBLE`    | double
   |`COM MULTILINEA`       | ` \ /\*([^"!>"]|[\r|\f|\s|\t|\n])*\*\/ ` | `BOOLEAN`    | boolean 
   | `STRING`     |  string | `CHAR`   | char
   | `TRUE`    | true | `FALSE` | false
   | `NEW`    | new  | `VOID` | void
   | `PRINT`   | print | `PRINTLN`   |  println
   | `TOLOWER` | tolower  | `RETURN` | return
   | `TOUPPER` | toupper | `ROUND`   |  round
   | `LENGTH`     |  lenght | `TYPEOF`   | typeof
   | `TOSTRING`    | tostring | `TOCHARARRAY` | tochararray
   | `MAIN`    | Main  | `IF` | if
   | `ELSE`   | else | `SWITCH`   |  switch
   | `CASE` | case  | `DEFAULT` | default
   | `BREAK` | break | `FOR`   |  for
   | `WHILE`   | while | `DO`   |  do
   | `CONTINUE` | continue  | `MAS` | +
   | `MUL` | *  | `EXP` | ^
   | `DIV` | /  | `MOD` | %
   | `IGUAL` | ==  | `DESIGUAL` | !=
   | `MENORIGUAL` | <=  | `MAYORIGUAL` | >=
   | `MENOR` | <  | `MAYOR` | >
   | `ASIGNAR` | =  | `TERNARIO` | ?
   | `DOSPUNTOS` | :  | `OR` | or
   | `AND` | &&  | `NOT` | !
   | `CARÁCTER` | regexcaracter  | `DOBLE` | [0-9]+("."[0-9]+)
   | `ENTERO` | [0-9]+  | `ID` | ([a-zA-Z_])([a-zA-Z0-9_])*
   | `PARABRIR` | (  | `PARCIERRE` | )




   
   
   

<div id='noterminales'/>

## :open_file_folder: No terminales

   | **NAME**    |    **NAME** |    **NAME** |    **NAME** 
   |---------------|----------------|---------------|----------------|
   | `IF`        |  `SWITCH`       | `CASES` | `CASO`     
   | `DEFAULT`        | `WHILE` | `DOWHILE`        |   `FOR` 
   |`DVAR`          | `AVAR`    | `RETURN`   |   `BREAK`  
   |`CONTINUE`|  `PRINT`      | `UPPER`        |  `LOWER` 
   |`SO`          | `SENTENCIAS`   | `DVARIABLES`   |   `SENTENCIA`  
   |`LISTAID`|  `AVARIABLES`      | `AARREGLOS`        |  `DARREGLOS`       
   | `UDIMENSION` | `BDIMENSION`     | `LISTAVALORES`        | `VALORES` 
   | `DMETODO`        |   `DFUNCION`  |`PARAMETRO`          | `PARAMETRO`   
   | `LLAMADA`   |   `LLAMADAS`  |`INSTRUCCIONES`|  `INSTRUCCIÓN`      
   | `ROUND` | `LENGTH`     | `TYPEOF`        | `TOSTRING` 
   | `TOCHAR`        |   `MAIN` | `ENTRADAS` | `TIPO`     
   | `PRIMITIVO`        | `EXPRESION` | `.` | `.`     
   







<div id='producciones'/>

## :open_file_folder: Producciones
`SO -> SENTENCIAS  `

`SENTENCIAS -> SENTENCIAS SENTENCIA
 | SENTENCIA`
 
`SENTENCIA -> DVARIABLES
 | DARREGLOS
 | DMETODO
 | DFUNCION
 | RUN
 | error puntocoma`
 
`DVARIABLES::= TIPO LISTAID asignar EXPRESION puntocoma
 | TIPO LISTAID puntocoma`
 
`LISTAID::= LISTAID coma identificador
 | identificador`
 
`AVARIABLES::= identificador asignar EXPRESION puntocoma`

`AARREGLOS::= identificador corA EXPRESION corC asignar EXPRESION puntocoma
| identificador corA EXPRESION corC corA EXPRESION corC asignar EXPRESION
puntocoma`

`DARREGLOS::= UDIMENSION`

`UDIMENSION::= TIPO identificador corA corC asignar new TIPO corA EXPRESION
corC puntocoma
 | TIPO identificador corA corC asignar corA LISTAVALORES corC puntocoma
 | TIPO identificador corA corC asignar EXPRESION puntocoma`
 
`BDIMENSION::= TIPO identificador corA corC corA corC asignar new TIPO corA
EXPRESION corC corA EXPRESION corC puntocoma
 | TIPO identificador corA corC corA corC asignar corA VALORES corC puntocoma`
 
`LISTAVALORES::= LISTAVALORES coma PRIMITIVO
 | PRIMITIVO`
 
`VALORES::= VALORES coma corA LISTAVALORES corC
 | corA LISTAVALORES corC`

`DMETODO::= identificador parA parC llavA INSTRUCCIONES llavC
 |identificador parA parC dospuntos void llavA INSTRUCCIONES llavC
 | identificador parA PARAMETROS parC llavA INSTRUCCIONES llavC
 |identificador parA PARAMETROS parC dospuntos void llavA INSTRUCCIONES
llavC`

`DFUNCION::= identificador parA parC dospuntos TIPO llavA INSTRUCCIONES llavC
|identificador parA PARAMETROS parC dospuntos TIPO llavA INSTRUCCIONES llavC`

`PARAMETROS::= PARAMETROS coma PARAMETRO {
 | PARAMETRO`

`PARAMETRO::= TIPO identificador`

`LLAMADA::= identificador parA parC puntocoma
 | identificador parA ENTRADAS parC puntocoma`
 
`LLAMADAS::= identificador parA parC
 | identificador parA ENTRADAS parC`
 
`INSTRUCCIONES::= INSTRUCCIONES INSTRUCCION
 | INSTRUCCION`
 
`INSTRUCCION::= DVARIABLES
 | AVARIABLES
 | DARREGLOS
 | AARREGLOS
 | RETURN
 | LLAMADA
 | PRINT
 | IF
 | SWITCH
 | BREAK
 | CONTINUE
 | WHILE
 | DOWHILE
 | FOR
 | error puntocoma`

`IF::= if parA EXPRESION parC llavA INSTRUCCIONES llavC
 | if parA EXPRESION parC llavA INSTRUCCIONES llavC else llavA INSTRUCCIONES
llavC
|if parA EXPRESION parC llavA INSTRUCCIONES llavC else IF`

`SWITCH::= switch parA EXPRESION parC llavA CASES DEFAULT llavC`

`CASES::= CASES CASO
 | CASO`
 
`CASO::= case EXPRESION dospuntos INSTRUCCIONES`

`DEFAULT::= default dospuntos INSTRUCCIONES`

`WHILE::= while parA EXPRESION parC llavA INSTRUCCIONES llavC`

`DOWHILE::= do llavA INSTRUCCIONES llavC while parA EXPRESION parC
puntocoma`

`FOR::= for parA DVAR puntocoma EXPRESION puntocoma AVAR parC llavA
INSTRUCCIONES llavC
| for parA AVAR puntocoma EXPRESION puntocoma AVAR parC llavA
INSTRUCCIONES llavC`

`DVAR::= TIPO LISTAID asignar EXPRESION`

`AVAR::= identificador asignar EXPRESION`

`RETURN::= return puntocoma
 | return EXPRESION puntocoma`
 
`BREAK::= break puntocoma`

`CONTINUE::= continue puntocoma`

`PRINT::= print parA EXPRESION parC puntocoma
 | println parA EXPRESION parC puntocoma`
 
`UPPER::= toUpper parA EXPRESION parC`

`LOWER::= toLower parA EXPRESION parC`

`ROUND::= round parA EXPRESION parC`

`LENGTH::= length parA EXPRESION parC`

`TYPEOF::= typeof parA EXPRESION parC`

`TOSTRING::= tostring parA EXPRESION parC`

`TOCHAR::= tochar parA EXPRESION parC`

`RUN::= run identificador parA parC puntocoma
 | run identificador parA ENTRADAS parC puntocoma`
 
`ENTRADAS::= ENTRADAS coma EXPRESION
 | EXPRESION`
 
`TIPO::= int
 | double
 | boolean
 | char
 | string`
 
`PRIMITIVO::= entero
 | doble
 | true
 | false
 | texto
 | caracter
 | identificador`
 
`EXPRESION::= EXPRESION mas EXPRESION
 | EXPRESION menos EXPRESION
 | EXPRESION mul EXPRESION
 | EXPRESION div EXPRESION
 | EXPRESION mod EXPRESION
 | EXPRESION exp EXPRESION
 | menos EXPRESION %prec umenos
 | parA EXPRESION parC
 | EXPRESION igual EXPRESION
 | EXPRESION desigual EXPRESION
 | EXPRESION menor EXPRESION
 | EXPRESION menorIgual EXPRESION
 | EXPRESION mayor EXPRESION
 | EXPRESION mayorIgual EXPRESION
 | EXPRESION or EXPRESION
 | EXPRESION and EXPRESION
 | not EXPRESION
 | EXPRESION ternario EXPRESION dospuntos EXPRESION
 | entero
 | doble
 | true
 | false
 | texto
 | caracter
 | identificador
 | parA TIPO parC EXPRESION
 | EXPRESION mas mas
 | EXPRESION menos menos
 | identificador corA EXPRESION corC
 | identificador corA EXPRESION corC corA EXPRESION corC
 | LLAMADAS
 | UPPER
 | LOWER
 | ROUND
 | LENGTH
 | TYPEOF
 | TOSTRING
 | TOCHAR`




