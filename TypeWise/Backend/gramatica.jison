/* Análisis Léxico */
%lex

%options case-insensitive         
%x string
%%

/*Ignorar*/
\s+                                            {}      //Espacios en blanco
\/\/.*                                         {}      //Comentario unilinea
\/\*([^"!>"]|[\r|\f|\s|\t|\n])*\*\/            {}      //Comentario multilinea

/*Declaración de Palabras Reservadas*/

"int"                       return 'int';
"double"                    return 'double';
"boolean"                   return 'boolean';
"char"                      return 'char';
"string"                    return 'string';
"true"                      return 'true';
"false"                     return 'false';
"new"                       return 'new';
"void"                      return 'void';
"print"                     return 'print';
"println"                   return 'println';
"return"                    return 'return';
"toLower"                   return 'toLower';
"toUpper"                   return 'toUpper';
"round"                     return 'round';
"length"                    return 'length';
"typeof"                    return 'typeof';
"tostring"                  return 'tostring';
"tochararray"               return 'tochar';
"run"                       return 'run';
"if"                        return 'if';
"else"                      return 'else';
"switch"                    return 'switch';
"case"                      return 'case';
"default"                   return 'default';
"break"                     return 'break';
"for"                       return 'for';
"while"                     return 'while';
"do"                        return 'do';
"continue"                  return 'continue';

/*Caraácteres básicos*/        
"+"                         return 'mas';
"-"                         return 'menos';
"*"                         return 'mul';
"/"                         return 'div';
"^"                         return 'exp';
"%"                         return 'mod';
"=="                        return 'igual';
"!="                        return 'desigual';
"<="                        return 'menorIgual';
">="                        return 'mayorIgual';
"<"                         return 'menor';
">"                         return 'mayor';
"="                         return 'asignar';
":"                         return 'dospuntos';
"?"                         return 'ternario';
"||"                        return 'or';
"&&"                        return 'and';
"!"                         return 'not';
"("                         return 'parA';
")"                         return 'parC';
"["                         return 'corA';
"]"                         return 'corC';
"{"                         return 'llavA';
"}"                         return 'llavC'; 
";"                         return 'puntocoma';
","                         return 'coma';

//Basado en https://gerhobbelt.github.io/jison/docs/#lexical-analysis
//Separación de Cadenas
["]                             {cadena= "";        this.pushState("string");}
<string>[^"\\]+                 {cadena += yytext;}
<string>"\\\""                  {cadena += "\"";}
<string>"\\n"                   {cadena += "\n";}
<string>\s                      {cadena += " ";}
<string>"\\t"                   {cadena += "\t";}
<string>"\\\\"                  {cadena += "\\";}
<string>"\\\'"                  {cadena += "\'";}
<string>["]                     {yytext=cadena; this.popState(); return 'texto';}

//Separación de Caracteres
\'("\n"|"\\\\"|"\t"|"\r"|\\\'|\\\"|.)\'   return 'caracter';

//Regex
[0-9]+("."[0-9]+)        return 'doble';
[0-9]+                    return 'entero';               
([a-zA-Z_])([a-zA-Z0-9_])*   return 'identificador';  

/*Fin de la cadena*/
<<EOF>>                     return 'EOF';

/*Manejo de Errores*/
.                           {
                                lista.add("Léxico", "Caracter Inesperado: " + yytext, yylloc.first_line, yylloc.first_column  + 1);

                            };

/lex

%{
        //Importes
        var ListaErrores = require("./recursos/errores/ListaErrores");
        var ListaSimbolos = require("./recursos/datos/ListaSimbolos");
        var ListaMetodos = require("./recursos/datos/ListaMetodos");
        const TIPO_OPERACION = require('./recursos/enum/TipoOperacion');
        const TIPO_VALOR = require('./recursos/enum/TipoValor');
        const TIPO_DATO = require('./recursos/enum/TipoDato');
        const INSTRUCCION = require('./recursos/instruccion/Instruccion');

        //Instrucciones
        var lista = new ListaErrores();
        var simbolos = new ListaSimbolos();
        var metodos = new ListaMetodos();

%}


%right 'or'
%right 'and'
%right 'not'
%left 'igual' 'desigual' 'menor' 'menorIgual' 'mayor' 'mayorIgual'
%left 'mas' 'menos'
%left 'mul' 'div' 'mod'
%nonassoc 'exp'
%left UMENOS
%left 'dospuntos' 'ternario'
%right 'parA' 'parC'
%start INICIO

%%

INICIO: SENTENCIAS EOF
        {       
             //Objeto de Salida
             var salida = {
                lerrores: lista,
                instrucciones: $1,
                lsimbolos: simbolos,
                lmetodos: metodos
             }
             //Reiniciar la lista de Errores
             lista = new ListaErrores();
             simbolos = new ListaSimbolos();
             metodos = new ListaMetodos();
             return salida;
        }
;         

SENTENCIAS: SENTENCIAS SENTENCIA
        {
                //Insertar a la lista de instrucciones
                $1.push($2); 
                //Retornar la lista de instrucciones
                $$=$1
        }

        | SENTENCIA
        {
                //Lista de Instrucciones
                $$ = [$1];
        }
;

SENTENCIA: DVARIABLES
        {
                $$ = $1;
        }
        | DARREGLOS
        {
                $$ = $1;
        }
        | DMETODO
        {
                $$ = $1;
        }
        | DFUNCION
        {
                $$ = $1;
        }
        | RUN
        {
                $$ = $1;
        }
        | error puntocoma
        {
                lista.add("Sintáctico", "Token Inesperado " + $1 , @1.first_line, @1.first_column + 1);
        }
;

//Declaracion de Variables ----------------------------------------------------------------------

DVARIABLES: TIPO LISTAID asignar EXPRESION puntocoma
        {
                $$= INSTRUCCION.declaracionv($1, $2, $4, this._$.first_line, this._$.first_column+1)
        }
        | TIPO LISTAID puntocoma
        {
                $$= INSTRUCCION.declaracionv($1, $2, null, this._$.first_line, this._$.first_column+1);
        }
;

LISTAID:  LISTAID coma identificador
        {
                $1.push($3); 
                $$=$1;
        }

        | identificador 
        {
                $$ = [$1];
        }

;
//Asignacion de Valores-------------------------------------------------------------------
AVARIABLES: identificador asignar EXPRESION puntocoma
        {
               $$ = INSTRUCCION.asignacionv($1,$3, this._$.first_line, this._$.first_column+1); 
        }
;

//Asignacion de Arreglos-------------------------------------------------------------------
AARREGLOS: identificador corA EXPRESION corC asignar EXPRESION puntocoma
        {
                $$ = INSTRUCCION.asignarv($1, $3, null, $6,  this._$.first_line, this._$.first_column+1);
        }
        | identificador corA EXPRESION corC corA EXPRESION corC asignar EXPRESION puntocoma
        {
                $$ = INSTRUCCION.asignarv($1, $3, $6, $9, this._$.first_line, this._$.first_column+1);
        }
;
//Declaracion de Arreglos -----------------------------------------------------------------------------
DARREGLOS: UDIMENSION
        {
                $$=$1;
        }
        | BDIMENSION
        {
                $$=$1;
        }
;

UDIMENSION: TIPO identificador corA corC asignar new TIPO corA EXPRESION corC puntocoma
        {
                $$= INSTRUCCION.declaraciona1($1, $2, $7, $9, null,this._$.first_line, this._$.first_column+1)
        }
        | TIPO identificador corA corC asignar corA LISTAVALORES corC puntocoma
        {
                $$= INSTRUCCION.declaraciona2(1, $1, $2, $7, null, this._$.first_line, this._$.first_column+1);
        }
        | TIPO identificador corA corC asignar EXPRESION puntocoma
        {
                $$= INSTRUCCION.declaraciona3(1, $1, $2, $6, null, this._$.first_line, this._$.first_column+1);
        }
;

BDIMENSION: TIPO identificador corA corC corA corC asignar new TIPO corA EXPRESION corC corA EXPRESION corC puntocoma
        {
                $$= INSTRUCCION.declaraciona1($1, $2, $9, $11, $14, this._$.first_line, this._$.first_column+1)
        }
        | TIPO identificador corA corC corA corC asignar corA VALORES corC puntocoma
        {
                $$= INSTRUCCION.declaraciona2(2, $1, $2, $9, this._$.first_line, this._$.first_column+1);
        }
        
;

LISTAVALORES: LISTAVALORES coma PRIMITIVO
        {
                $1.push($3); 
                $$=$1;
        }
        | PRIMITIVO
        {
                $$ = [$1];
        }
;

VALORES: VALORES coma corA LISTAVALORES corC
        {
                $1.push($4); 
                $$=$1;
        }
        | corA LISTAVALORES corC
        {
                $$ = [$2];
        }
;
//Declarar Metodos----------------------------------------------------------------------------
DMETODO: identificador parA parC llavA INSTRUCCIONES llavC 
        {
                $$ = INSTRUCCION.dmetodo($1, null, $5, this._$.first_line, this._$.first_column+1)
        }
        |identificador parA parC dospuntos void llavA INSTRUCCIONES llavC
        {
                $$ = INSTRUCCION.dmetodo($1, null, $7, this._$.first_line, this._$.first_column+1)
        }
        | identificador parA PARAMETROS parC llavA INSTRUCCIONES llavC 
        {
                $$ = INSTRUCCION.dmetodo($1, $3, $6, this._$.first_line, this._$.first_column+1)
        }
        |identificador parA PARAMETROS parC dospuntos void llavA INSTRUCCIONES llavC
        {
                $$ = INSTRUCCION.dmetodo($1, $3, $8, this._$.first_line, this._$.first_column+1)
        }
;

//Declarar Funciones----------------------------------------------------------------------------
DFUNCION: identificador parA parC dospuntos TIPO llavA INSTRUCCIONES llavC
        {
                $$ = INSTRUCCION.dfuncion($1, null, $5, $7, this._$.first_line, this._$.first_column+1)
        }
        |identificador parA PARAMETROS parC dospuntos TIPO llavA INSTRUCCIONES llavC
        {
                $$ = INSTRUCCION.dfuncion($1, $3, $6, $8, this._$.first_line, this._$.first_column+1)
        }
;

PARAMETROS: PARAMETROS coma PARAMETRO {
                $1.push($3); 
                $$=$1
        }
        | PARAMETRO 
        {
                $$=[$1]
        }
;

PARAMETRO: TIPO identificador 
        {
                $$= INSTRUCCION.declaracionp($1, $2, null, this._$.first_line, this._$.first_column+1)
        }
;

//LLamadas--------------------------------------------------------------------------------
LLAMADA:        identificador parA parC puntocoma 
                {
                        $$= INSTRUCCION.llamada($1, null, this._$.first_line, this._$.first_column+1)
                }
                | identificador parA ENTRADAS parC puntocoma {
                        $$= INSTRUCCION.llamada($1, $3, this._$.first_line, this._$.first_column+1)
                }
;

//Obtener un retorno (usado paa expresiones)-------------------------------------------------------
LLAMADAS:        identificador parA parC 
                {
                        $$= INSTRUCCION.llamadaa($1, null, this._$.first_line, this._$.first_column+1)
                }
                | identificador parA ENTRADAS parC {
                        $$= INSTRUCCION.llamadaa($1, $3, this._$.first_line, this._$.first_column+1)
                }
;
//Instrucciones---------------------------------------------------------------------------
INSTRUCCIONES: INSTRUCCIONES INSTRUCCION
        {
                //Insertar a la lista de instrucciones
                $1.push($2); 
                //Retornar la lista de instrucciones
                $$=$1
        }

        | INSTRUCCION
        {
                //Lista de Instrucciones
                $$ = [$1];
        }
;

INSTRUCCION: DVARIABLES
        {
                $$ = $1;
        }
        | AVARIABLES
        {
                $$ = $1;
        }
        | DARREGLOS
        {
                $$ = $1;
        }
        | AARREGLOS
        {
                $$ = $1;
        }
        | RETURN
        {
                $$ = $1;
        }
        | LLAMADA
        {
                $$ = $1;
        }
        | PRINT
        {
                $$ = $1;
        }
        | IF
        {
                $$ = $1;
        }
        | SWITCH
        {
                $$ = $1;
        }
        | BREAK
        {
                $$ = $1;
        }
        | CONTINUE
        {
                $$ = $1;
        }
        | WHILE
        {
                $$ = $1;
        }
        | DOWHILE
        {
                $$ = $1;
        }
        | FOR
        {
                $$ = $1;
        }
        | error puntocoma
        {
                lista.add("Sintáctico", "Token Inesperado " + $1 , @1.first_line, @1.first_column + 1);
        }
;
//IF------------------------------------------------------------------------------------------
IF: if parA EXPRESION parC llavA INSTRUCCIONES llavC 
        {
                $$ = INSTRUCCION.si($3, $6, null, this._$.first_line, this._$.first_column+1)
        }
        |if parA EXPRESION parC llavA INSTRUCCIONES llavC else llavA INSTRUCCIONES llavC 
        {
                $$ = INSTRUCCION.si($3, $6, $10, this._$.first_line, this._$.first_column+1)
        }
        |if parA EXPRESION parC llavA INSTRUCCIONES llavC else IF 
        {
                $$ = INSTRUCCION.si($3, $6, $9, this._$.first_line, this._$.first_column+1)
        }
;

//Switch------------------------------------------------------------------------------------------
SWITCH: switch parA EXPRESION parC llavA CASES DEFAULT llavC 
        {
                $$ = INSTRUCCION.switch($3, $6, $7, this._$.first_line, this._$.first_column+1)
        }
        | switch parA EXPRESION parC llavA CASES llavC 
        {
                $$ = INSTRUCCION.switch($3, $6, null, this._$.first_line, this._$.first_column+1)
        }
;

CASES:  CASES CASO
        {
                $1.push($2); 
                $$=$1;
        }
        
        | CASO
        {
                $$ = [$1];
        }
;

CASO: case EXPRESION dospuntos INSTRUCCIONES
        {
                $$ = INSTRUCCION.case($2, $4, this._$.first_line, this._$.first_column+1)
        }
;
        
DEFAULT:  default dospuntos INSTRUCCIONES
        {
                 $$ = INSTRUCCION.default(null, $3, this._$.first_line, this._$.first_column+1)
        }
;

//While------------------------------------------------------------------------------------------
WHILE: while parA EXPRESION parC llavA INSTRUCCIONES llavC 
        {
                $$ = INSTRUCCION.while($3, $6, this._$.first_line, this._$.first_column+1)
        }
;
//Do While------------------------------------------------------------------------------------------
DOWHILE: do llavA INSTRUCCIONES llavC while parA EXPRESION parC puntocoma
        {
                $$ = INSTRUCCION.dowhile($7, $3, this._$.first_line, this._$.first_column+1)
        }
;

//Do While------------------------------------------------------------------------------------------
FOR: for parA DVAR puntocoma EXPRESION puntocoma AVAR parC llavA INSTRUCCIONES llavC
        {
               $$ = INSTRUCCION.for($3, $5, $7, $10, this._$.first_line, this._$.first_column+1)
        }
        | for parA AVAR puntocoma EXPRESION puntocoma AVAR parC llavA INSTRUCCIONES llavC
        {
                $$ = INSTRUCCION.for($3, $5, $7, $10, this._$.first_line, this._$.first_column+1)
        }
;

DVAR:  TIPO LISTAID asignar EXPRESION
        {
                $$= INSTRUCCION.declaracionv($1, $2, $4, this._$.first_line, this._$.first_column+1);
        }
;

AVAR: identificador asignar EXPRESION 
        {
               $$ = INSTRUCCION.asignacionv($1,$3, this._$.first_line, this._$.first_column+1); 
        }
;
//Funcion Return---------------------------------------------------------------------------------------
RETURN: return puntocoma 
        {
                $$= INSTRUCCION.return(null, this._$.first_line, this._$.first_column+1)
        }
        | return EXPRESION puntocoma 
        {
                $$= INSTRUCCION.return($2, this._$.first_line, this._$.first_column+1)
        }
;

//Funcion Break---------------------------------------------------------------------------------------
BREAK: break puntocoma 
        {
                $$= INSTRUCCION.break(this._$.first_line, this._$.first_column+1)
        }
;
//Funcion Continue---------------------------------------------------------------------------------------
CONTINUE: continue puntocoma 
        {
                $$= INSTRUCCION.continue(this._$.first_line, this._$.first_column+1)
        }
;
//Funcion Print---------------------------------------------------------------------------------------
PRINT: print parA EXPRESION parC puntocoma
        {
                $$= INSTRUCCION.print($3, this._$.first_line, this._$.first_column+1)
        }
        | println parA EXPRESION parC puntocoma
        {
                $$= INSTRUCCION.println($3, this._$.first_line, this._$.first_column+1)
        }
; 

//Funcion Upper---------------------------------------------------------------------------------------
UPPER: toUpper parA EXPRESION parC 
        {
                $$= INSTRUCCION.upper($3, this._$.first_line, this._$.first_column+1)
        }
;

//Funcion Lower---------------------------------------------------------------------------------------
LOWER: toLower parA EXPRESION parC 
        {
                $$= INSTRUCCION.lower($3, this._$.first_line, this._$.first_column+1)
        }
;

//Funcion Round---------------------------------------------------------------------------------------
ROUND: round parA EXPRESION parC 
        {
                $$= INSTRUCCION.round($3, this._$.first_line, this._$.first_column+1)
        }
;

//Funcion Lenth---------------------------------------------------------------------------------------
LENGTH: length parA EXPRESION parC 
        {
                $$= INSTRUCCION.length($3, this._$.first_line, this._$.first_column+1)
        }
;

//Funcion TypeOf---------------------------------------------------------------------------------------
TYPEOF: typeof parA EXPRESION parC 
        {
                $$= INSTRUCCION.typeof($3, this._$.first_line, this._$.first_column+1)
        }
;

//Funcion toString---------------------------------------------------------------------------------------
TOSTRING: tostring parA EXPRESION parC 
        {
                $$= INSTRUCCION.tostring($3, this._$.first_line, this._$.first_column+1)
        }
;

//Funcion toString---------------------------------------------------------------------------------------
TOCHAR: tochar parA EXPRESION parC 
        {
                $$= INSTRUCCION.tochar($3, this._$.first_line, this._$.first_column+1)
        }
;

//Funcion Run---------------------------------------------------------------------------------------
RUN: run identificador parA parC puntocoma
        {
                $$= INSTRUCCION.run($2, null, this._$.first_line, this._$.first_column+1)
        }
        | run identificador parA ENTRADAS parC puntocoma 
        {
                $$= INSTRUCCION.run($2, $4, this._$.first_line, this._$.first_column+1)
        }
; 

ENTRADAS: ENTRADAS coma EXPRESION 
        {
                $1.push($3); 
                $$=$1
        }
        | EXPRESION 
        {
                $$=[$1]
        }
;

//Tipos-----------------------------------------------------------------------------------
TIPO: int       {$$ = TIPO_DATO.INT}
    | double    {$$ = TIPO_DATO.DOUBLE}
    | boolean   {$$ = TIPO_DATO.BOOLEAN}
    | char      {$$ = TIPO_DATO.CHAR}
    | string    {$$ = TIPO_DATO.STRING}
;

//Valores Primitivos-----------------------------------------------------------------------------------
PRIMITIVO: entero
        {
                $$ = INSTRUCCION.valor(Number($1), TIPO_VALOR.INT, this._$.first_line, this._$.first_column+1);
        }
        | doble
        {
                $$ = INSTRUCCION.valor(Number($1), TIPO_VALOR.DOUBLE, this._$.first_line, this._$.first_column+1);
        }
        | true
        {
                $$ = INSTRUCCION.valor($1, TIPO_VALOR.BOOLEAN, this._$.first_line, this._$.first_column+1);
        }
        | false
        {
                $$ = INSTRUCCION.valor($1, TIPO_VALOR.BOOLEAN, this._$.first_line, this._$.first_column+1);
        }
        | texto
        {
                $$ = INSTRUCCION.valor($1, TIPO_VALOR.STRING, this._$.first_line, this._$.first_column+1);
        }
        | caracter
        {
                $$ = INSTRUCCION.valor($1, TIPO_VALOR.CHAR, this._$.first_line, this._$.first_column+1);
        }
        | identificador
        {
                $$ = INSTRUCCION.valor($1, TIPO_VALOR.IDENTIFICADOR, this._$.first_line, this._$.first_column+1);
        }
;

//Declaracion de expresiones--------------------------------------------------------------------------
EXPRESION: EXPRESION mas EXPRESION
        {
                $$ = INSTRUCCION.operacion($1,$3, TIPO_OPERACION.SUMA, this._$.first_line, this._$.first_column+1);
        }

        | EXPRESION menos EXPRESION
        {
                $$ = INSTRUCCION.operacion($1,$3, TIPO_OPERACION.RESTA, this._$.first_line, this._$.first_column+1);
        }
        | EXPRESION mul EXPRESION
        {
                $$ = INSTRUCCION.operacion($1,$3, TIPO_OPERACION.MULTIPLICACION, this._$.first_line, this._$.first_column+1);
        }
        | EXPRESION div EXPRESION
        {
                $$ = INSTRUCCION.operacion($1,$3, TIPO_OPERACION.DIVISION, this._$.first_line, this._$.first_column+1);
        }
        | EXPRESION mod EXPRESION
        {
                $$ = INSTRUCCION.operacion($1,$3, TIPO_OPERACION.MODULO, this._$.first_line, this._$.first_column+1);
        }
        | EXPRESION exp EXPRESION
        {
                $$ = INSTRUCCION.operacion($1,$3, TIPO_OPERACION.POTENCIA, this._$.first_line, this._$.first_column+1);
        }
        | menos EXPRESION %prec umenos
        {
                $$ = INSTRUCCION.operacion($2, null, TIPO_OPERACION.UNARIO, this._$.first_line, this._$.first_column+1);
        }
        | parA EXPRESION parC
        {
                $$ = $2;
        }
        | EXPRESION igual EXPRESION
        {
                $$ = INSTRUCCION.operacion($1,$3, TIPO_OPERACION.IGUAL, this._$.first_line, this._$.first_column+1);
        }
        | EXPRESION desigual EXPRESION
        {
                $$ = INSTRUCCION.operacion($1,$3, TIPO_OPERACION.DESIGUAL, this._$.first_line, this._$.first_column+1);
        }
        | EXPRESION menor EXPRESION
        {
                $$ = INSTRUCCION.operacion($1,$3, TIPO_OPERACION.MENOR, this._$.first_line, this._$.first_column+1);
        }
        | EXPRESION menorIgual EXPRESION
        {
                $$ = INSTRUCCION.operacion($1,$3, TIPO_OPERACION.MENORIGUAL, this._$.first_line, this._$.first_column+1);
        }
        | EXPRESION mayor EXPRESION
        {
                $$ = INSTRUCCION.operacion($1,$3, TIPO_OPERACION.MAYOR, this._$.first_line, this._$.first_column+1);
        }
        | EXPRESION mayorIgual EXPRESION
        {
                $$ = INSTRUCCION.operacion($1,$3, TIPO_OPERACION.MAYORIGUAL, this._$.first_line, this._$.first_column+1);
        }
        | EXPRESION or EXPRESION
        {
                $$ = INSTRUCCION.operacion($1,$3, TIPO_OPERACION.OR, this._$.first_line, this._$.first_column+1);
        }
        | EXPRESION and EXPRESION
        {
                $$ = INSTRUCCION.operacion($1,$3, TIPO_OPERACION.AND, this._$.first_line, this._$.first_column+1);
        }
        | not EXPRESION
        {
                $$ = INSTRUCCION.operacion($2 ,null, TIPO_OPERACION.NOT, this._$.first_line, this._$.first_column+1);
        }
        | EXPRESION ternario EXPRESION dospuntos EXPRESION
        {
                $$ = INSTRUCCION.ternario($1 , $3, $5, TIPO_OPERACION.TERNARIO, this._$.first_line, this._$.first_column+1);
        }
        | entero
        {
                $$ = INSTRUCCION.valor(Number($1), TIPO_VALOR.INT, this._$.first_line, this._$.first_column+1);
        }
        | doble
        {
                $$ = INSTRUCCION.valor(Number($1), TIPO_VALOR.DOUBLE, this._$.first_line, this._$.first_column+1);
        }
        | true
        {
                $$ = INSTRUCCION.valor($1, TIPO_VALOR.BOOLEAN, this._$.first_line, this._$.first_column+1);
        }
        | false
        {
                $$ = INSTRUCCION.valor($1, TIPO_VALOR.BOOLEAN, this._$.first_line, this._$.first_column+1);
        }
        | texto
        {
                $$ = INSTRUCCION.valor($1, TIPO_VALOR.STRING, this._$.first_line, this._$.first_column+1);
        }
        | caracter
        {
                $$ = INSTRUCCION.valor($1, TIPO_VALOR.CHAR, this._$.first_line, this._$.first_column+1);
        }
        | identificador
        {
                $$ = INSTRUCCION.valor($1, TIPO_VALOR.IDENTIFICADOR, this._$.first_line, this._$.first_column+1);
        }
        | parA TIPO parC EXPRESION
        {
                $$ = INSTRUCCION.casteo($2, $4, TIPO_OPERACION.CASTEO, this._$.first_line, this._$.first_column+1);
        }
        | EXPRESION mas mas
        {
                $$ = INSTRUCCION.operacion($1, null, TIPO_OPERACION.INCREMENTO, this._$.first_line, this._$.first_column+1)       
        }
        | EXPRESION menos menos
        {
                $$ = INSTRUCCION.operacion($1, null, TIPO_OPERACION.DECREMENTO, this._$.first_line, this._$.first_column+1)       
        }
        | identificador corA EXPRESION corC 
        {
                $$ = INSTRUCCION.valorv($1, $3, null,  this._$.first_line, this._$.first_column+1);
        }
        | identificador corA EXPRESION corC corA EXPRESION corC
        {
                $$ = INSTRUCCION.valorv($1, $3, $6, this._$.first_line, this._$.first_column+1);
        }
        | LLAMADAS
        {
                $$ = $1;
        }
        | UPPER
        {
                $$ = $1;
        }
        | LOWER
        {
                $$ = $1;
        }
        | ROUND
        {
                $$ = $1;
        }
        | LENGTH
        {
                $$ = $1;
        }
        | TYPEOF
        {
                $$ = $1;
        }
        | TOSTRING
        {
                $$ = $1;
        }
        | TOCHAR
        {
                $$ = $1;
        }
;




