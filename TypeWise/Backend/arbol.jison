/* Análisis Léxico */
%lex

%options case-insensitive         
%x string
%%

/*Ignorar*/
\s+                                                  //Espacios en blanco
\/\/.*                                               //Comentario unilinea
\/\*([^"!>"]|[\r|\f|\s|\t|\n])*\*\/                  //Comentario multilinea

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
[0-9]+("."[0-9]+)            return 'doble';
[0-9]+                       return 'entero';               
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
        const Nodo = require('./recursos/AST/NodoAST');
        const TIPO_OPERACION = require('./recursos/enum/TipoOperacion');
        const TIPO_VALOR = require('./recursos/enum/TipoValor');
        const TIPO_DATO = require('./recursos/enum/TipoDato');
        const INSTRUCCION = require('./recursos/instruccion/Instruccion');

        //Instrucciones
        var lista = new ListaErrores();
        var simbolos = new ListaSimbolos();
        var metodos = new ListaMetodos();
        let entrada3;
        let entrada4;
        let entrada1;
        let entrada2;
        let salida;
        let instruccion;
        let nodo;

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
             //Separar Entrada
             entrada1 = $1   
             nodo = new Nodo("RAIZ", "RAIZ")
             nodo.add(entrada1.nodo)
             //Objeto de Salida
             salida = {
                lerrores: lista,
                instrucciones: entrada1.instruccion,
                lsimbolos: simbolos,
                lmetodos: metodos,
                arbol: nodo
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
                //Obtencion de valores
                entrada1 = $1
                entrada2 = $2
                //Creacion de la salida
                entrada1.instruccion.push(entrada2.instruccion)
                instruccion = entrada1.instruccion
                nodo = entrada1.nodo
                nodo.add(entrada2.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida

        }

        | SENTENCIA
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = [entrada1.instruccion]
                nodo = new Nodo("SENTENCIAS", "SENTENCIAS")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
                
                
;

SENTENCIA: DVARIABLES
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = entrada1.instruccion;
                nodo = new Nodo("SENTENCIA", "SENTENCIA")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | DARREGLOS
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = entrada1.instruccion;
                nodo = new Nodo("SENTENCIA", "SENTENCIA")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | DMETODO
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = entrada1.instruccion;
                nodo = new Nodo("SENTENCIA", "SENTENCIA")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | DFUNCION
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = entrada1.instruccion;
                nodo = new Nodo("SENTENCIA", "SENTENCIA")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | RUN
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = entrada1.instruccion;
                nodo = new Nodo("SENTENCIA", "SENTENCIA")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | error puntocoma
        {
                lista.add("Sintáctico", "Token Inesperado " + $1 , @1.first_line, @1.first_column + 1);
        }
;

//Declaracion de Variables ----------------------------------------------------------------------

DVARIABLES: TIPO LISTAID asignar EXPRESION puntocoma
        {
                //Obtencion de valores
                entrada1 = $1
                entrada2 = $2
                entrada3 = $4
                //Creacion de la salida
                instruccion = INSTRUCCION.declaracionv(entrada1.instruccion, entrada2.instruccion, entrada3.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("DEC VARIABLES", "DEC VARIABLES")
                nodo.add(entrada1.nodo, entrada2.nodo ,new Nodo("OPERADOR", $3), entrada3.nodo, new Nodo("OPERADOR", $5))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | TIPO LISTAID puntocoma
        {
                //Obtencion de valores
                entrada1 = $1
                entrada2 = $2
                //Creacion de la salida
                instruccion = INSTRUCCION.declaracionv(entrada1.instruccion, entrada2.instruccion, null, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("DEC VARIABLES", "DEC VARIABLES")
                nodo.add(entrada1.nodo, entrada2.nodo ,new Nodo("OPERADOR", $3))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
;

LISTAID:  LISTAID coma identificador
        {
                //Obtencion de valores
                entrada1 = $1
                //Creacion de la salida
                entrada1.instruccion.push($3)
                instruccion = entrada1.instruccion
                nodo = entrada1.nodo
                 nodo.add(new Nodo("ID", $3))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }

        | identificador 
        {
                //Creacion de la salida
                instruccion = [$1]
                nodo = new Nodo("LISTA ID", "LISTA ID")
                nodo.add(new Nodo("ID", $1))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }

;
//Asignacion de Valores-------------------------------------------------------------------
AVARIABLES: identificador asignar EXPRESION puntocoma
        {
                //Obtencion de valores
                entrada1 = $3
                
                //Creacion de la salida
                instruccion = INSTRUCCION.asignacionv($1,entrada1.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("ASI VARIABLES", "ASI VARIABLES")
                nodo.add(new Nodo("ID", $1),new Nodo("OPERADOR", $2),  entrada1.nodo, new Nodo("OPERADOR", $4))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida

        }
;

//Asignacion de Arreglos-------------------------------------------------------------------
AARREGLOS: identificador corA EXPRESION corC asignar EXPRESION puntocoma
        {
                //Obtencion de valores
                entrada1 = $3
                entrada2 = $6
                
                //Creacion de la salida
                instruccion = INSTRUCCION.asignarv($1, entrada1.instruccion, null, entrada2.instruccion,  this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("ASI UNIDIMENSIONAL", "ASI UNIDIMENSIONAL")
                nodo.add(new Nodo("ID", $1),new Nodo("OPERADOR", $2),  entrada1.nodo, new Nodo("OPERADOR", $4), new Nodo("OPERADOR", $5),  entrada2.nodo, new Nodo("OPERADOR", $7))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | identificador corA EXPRESION corC corA EXPRESION corC asignar EXPRESION puntocoma
        {
                //Obtencion de valores
                entrada1 = $3
                entrada2 = $6
                entrada3 = $9
                
                //Creacion de la salida
                instruccion =  INSTRUCCION.asignarv($1, entrada1.instruccion, entrada2.instruccion, entrada3.instruccion, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("ASI BIDIMENSIONAL", "ASI BIDIMENSIONAL")
                nodo.add(new Nodo("OPERADOR", $1),new Nodo("OPERADOR", $2),  entrada1.nodo, new Nodo("OPERADOR", $4), new Nodo("OPERADOR", $5),  entrada2.nodo, new Nodo("OPERADOR", $7))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida

        }
;
//Declaracion de Arreglos -----------------------------------------------------------------------------
DARREGLOS: UDIMENSION
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = entrada1.instruccion;
                nodo = new Nodo("DEC ARREGLOS", "DEC ARREGLOS")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida

        }
        | BDIMENSION
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = entrada1.instruccion;
                nodo = new Nodo("DEC ARREGLOS", "DEC ARREGLOS")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida

        }
;

UDIMENSION: TIPO identificador corA corC asignar new TIPO corA EXPRESION corC puntocoma
        {
                //Obtencion de valores
                entrada1 = $1
                entrada2 = $7
                entrada3 = $9
                //Creacion de la salida
                instruccion = INSTRUCCION.declaraciona1(entrada1.instruccion, $2, entrada2.instruccion, entrada3.instruccion, null,this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("DEC UNIDIMENSIONAL", "DEC UNIDIMENSIONAL")
                nodo.add(entrada1.nodo, new Nodo("ID", $2),new Nodo("OPERADOR", $3), new Nodo("OPERADOR", $4), new Nodo("OPERADOR", $5),  new Nodo("OPERADOR", $6), entrada2.nodo ,new Nodo("OPERADOR", $8), entrada3.nodo, new Nodo("OPERADOR", $10), new Nodo("OPERADOR", $11))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | TIPO identificador corA corC asignar corA LISTAVALORES corC puntocoma
        {
                //Obtencion de valores
                entrada1 = $1
                entrada2 = $7
                //Creacion de la salida
                instruccion = INSTRUCCION.declaraciona2(1, entrada1.instruccion, $2, entrada2.instruccion, null, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("DEC UNIDIMENSIONAL", "DEC UNIDIMENSIONAL")
                nodo.add(entrada1.nodo, new Nodo("ID", $2),new Nodo("OPERADOR", $3), new Nodo("OPERADOR", $4), new Nodo("OPERADOR", $5),  new Nodo("OPERADOR", $6), entrada2.nodo ,new Nodo("OPERADOR", $8), new Nodo("OPERADOR", $9))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida

        }
        | TIPO identificador corA corC asignar EXPRESION puntocoma
        {
                //Obtencion de valores
                entrada1 = $1
                entrada2 = $6
                //Creacion de la salida
                instruccion = INSTRUCCION.declaraciona3(1, entrada1.instruccion, $2, entrada1.instruccion, null, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("DEC UNIDIMENSIONAL", "DEC UNIDIMENSIONAL")
                nodo.add(entrada1.nodo, new Nodo("OPERADOR", $2),new Nodo("OPERADOR", $3), new Nodo("OPERADOR", $4), new Nodo("OPERADOR", $5),  entrada2.nodo ,new Nodo("OPERADOR", $7))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
;

BDIMENSION: TIPO identificador corA corC corA corC asignar new TIPO corA EXPRESION corC corA EXPRESION corC puntocoma
        {
                //Obtencion de valores
                entrada1 = $1
                entrada2 = $9
                entrada3 = $11
                entrada4 = $14
                //Creacion de la salida
                instruccion = INSTRUCCION.declaraciona1(entrada1.instruccion, $2, entrada2.instruccion, entrada3.instruccion, entrada4.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("DEC BIDIMENSIONAL", "DEC BIDIMENSIONAL")
                nodo.add(entrada1.nodo, new Nodo("ID", $2),new Nodo("OPERADOR", $3), new Nodo("OPERADOR", $4), new Nodo("OPERADOR", $5),  new Nodo("OPERADOR", $6), new Nodo("OPERADOR", $7),new Nodo("OPERADOR", $8), entrada2.nodo, new Nodo("OPERADOR", $10), entrada3.nodo, new Nodo("OPERADOR", $12), new Nodo("OPERADOR", $13), entrada4.nodo, new Nodo("OPERADOR", $15), new Nodo("OPERADOR", $16))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida

        }
        | TIPO identificador corA corC corA corC asignar corA VALORES corC puntocoma
        {
                //Obtencion de valores
                entrada1 = $1
                entrada2 = $9
                //Creacion de la salida
                instruccion = INSTRUCCION.declaraciona2(2, entrada1.instruccion, $2, entrada2.instruccion, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("DEC BIDIMENSIONAL", "DEC BIDIMENSIONAL")
                nodo.add(entrada1.nodo, new Nodo("ID", $2),new Nodo("OPERADOR", $3), new Nodo("OPERADOR", $4), new Nodo("OPERADOR", $5),  new Nodo("OPERADOR", $6), new Nodo("OPERADOR", $7),new Nodo("OPERADOR", $8), entrada2.nodo, new Nodo("OPERADOR", $10), new Nodo("OPERADOR", $11))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida

        }
        
;

LISTAVALORES: LISTAVALORES coma PRIMITIVO
        {
                 //Obtencion de valores
                entrada1 = $1
                entrada2 = $3
                //Creacion de la salida
                entrada1.instruccion.push(entrada2.instruccion)
                instruccion = entrada1.instruccion
                nodo = entrada1.nodo
                nodo.add(entrada2.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | PRIMITIVO
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = [entrada1.instruccion]
                nodo = new Nodo("LISTAVALORES", "LISTAVALORES")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
;

VALORES: VALORES coma corA LISTAVALORES corC
        {
                //Obtencion de valores
                entrada1 = $1
                entrada2 = $4
                //Creacion de la salida
                entrada1.instruccion.push(entrada2.instruccion)
                instruccion = entrada1.instruccion
                nodo = entrada1.nodo
                nodo.add(entrada2.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | corA LISTAVALORES corC
        {
                //Obtencion de valores
                entrada1 = $2

                //Creacion de la salida
                instruccion = [entrada1.instruccion]
                nodo = new Nodo("VALORES", "VALORES")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
;
//Declarar Metodos----------------------------------------------------------------------------
DMETODO: identificador parA parC llavA INSTRUCCIONES llavC 
        {
                //Obtencion de valores
                entrada2 = $5
                //Creacion de la salida
                instruccion = INSTRUCCION.dmetodo($1, null, entrada2.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("DEC METODO", "DEC METODO")
                nodo.add(new Nodo("ID", $1), new Nodo("OPERADOR", $2), new Nodo("OPERADOR", $3), new Nodo("OPERADOR", $4), entrada2.nodo, new Nodo("OPERADOR", $6))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        
        }
        |identificador parA parC dospuntos void llavA INSTRUCCIONES llavC
        {
                //Obtencion de valores
                entrada2 = $7
                //Creacion de la salida
                instruccion = INSTRUCCION.dmetodo($1, null, entrada2.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("DEC METODO", "DEC METODO")
                nodo.add(new Nodo("ID", $1), new Nodo("OPERADOR", $2), new Nodo("OPERADOR", $3), new Nodo("OPERADOR", $4), new Nodo("OPERADOR", $5), new Nodo("OPERADOR", $6), entrada2.nodo, new Nodo("OPERADOR", $8))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | identificador parA PARAMETROS parC llavA INSTRUCCIONES llavC 
        {
                //Obtencion de valores
                entrada2 = $3
                entrada3 = $6
                //Creacion de la salida
                instruccion = INSTRUCCION.dmetodo($1, entrada2.instruccion, entrada3.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("DEC METODO", "DEC METODO")
                nodo.add(new Nodo("ID", $1), new Nodo("OPERADOR", $2), entrada2.nodo, new Nodo("OPERADOR", $4), new Nodo("OPERADOR", $5), entrada3.nodo, new Nodo("OPERADOR", $7))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        |identificador parA PARAMETROS parC dospuntos void llavA INSTRUCCIONES llavC
        {
                //Obtencion de valores
                entrada2 = $3
                entrada3 = $8
                //Creacion de la salida
                instruccion = INSTRUCCION.dmetodo($1, entrada2.instruccion, entrada3.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("DEC METODO", "DEC METODO")
                nodo.add(new Nodo("ID", $1), new Nodo("OPERADOR", $2), entrada2.nodo, new Nodo("OPERADOR", $4), new Nodo("OPERADOR", $5), new Nodo("OPERADOR", $6),new Nodo("OPERADOR", $7), entrada3.nodo, new Nodo("OPERADOR", $9))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
;

//Declarar Funciones----------------------------------------------------------------------------
DFUNCION: identificador parA parC dospuntos TIPO llavA INSTRUCCIONES llavC
        {
                //Obtencion de valores
                entrada2 = $5
                entrada3 = $7
                //Creacion de la salida
                instruccion = INSTRUCCION.dfuncion($1, null, entrada2.instruccion, entrada3.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("DEC FUNCION", "DEC FUNCION")
                nodo.add(new Nodo("ID", $1), new Nodo("OPERADOR", $2), new Nodo("OPERADOR", $3), new Nodo("OPERADOR", $4), entrada2.nodo, new Nodo("OPERADOR", $6), entrada3.nodo,  new Nodo("OPERADOR", $8))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
                
        }
        |identificador parA PARAMETROS parC dospuntos TIPO llavA INSTRUCCIONES llavC
        {
                //Obtencion de valores
                entrada2 = $3
                entrada3 = $6
                entrada4 = $8
                //Creacion de la salida
                instruccion = INSTRUCCION.dfuncion($1, entrada2.instruccion, entrada3.instruccion, entrada4.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("DEC FUNCION", "DEC FUNCION")
                nodo.add(new Nodo("ID", $1), new Nodo("OPERADOR", $2), entrada2.nodo, new Nodo("OPERADOR", $4), new Nodo("OPERADOR", $5), entrada3.nodo, new Nodo("OPERADOR", $7), entrada4.nodo ,new Nodo("OPERADOR", $9))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
;

PARAMETROS: PARAMETROS coma PARAMETRO {
               //Obtencion de valores
                entrada1 = $1
                entrada2 = $3
                //Creacion de la salida
                entrada1.instruccion.push(entrada2.instruccion)
                instruccion = entrada1.instruccion
                nodo = entrada1.nodo
                nodo.add(entrada2.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | PARAMETRO 
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = [entrada1.instruccion]
                nodo = new Nodo("PARAMETROS", "PARAMETROS")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }

                
;

PARAMETRO: TIPO identificador 
        {
                //Obtencion de valores
                entrada1 = $1
                //Creacion de la salida
                instruccion = INSTRUCCION.declaracionp(entrada1.instruccion, $2, null, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("PARAMETRO", "PARAMETRO")
                nodo.add(entrada1.nodo, new Nodo("ID", $2))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida

        }
;

//LLamadas--------------------------------------------------------------------------------
LLAMADA:        identificador parA parC puntocoma 
                {
                        //Creacion de la salida
                        instruccion = INSTRUCCION.llamada($1, null, this._$.first_line, this._$.first_column+1)
                        nodo = new Nodo("LLAMAR", "LLAMAR")
                        nodo.add(new Nodo("ID", $1), new Nodo("OPERADOR", $2), new Nodo("OPERADOR", $3), new Nodo("OPERADOR", $4))
                        salida = {
                                nodo: nodo,
                                instruccion: instruccion
                        }
                        $$ = salida
                }
                | identificador parA ENTRADAS parC puntocoma {
                        //Obtencion de valores
                        entrada1 = $3
                        //Creacion de la salida
                        instruccion = INSTRUCCION.llamadaa($1, entrada1.instruccion, this._$.first_line, this._$.first_column+1)
                        nodo = new Nodo("LLAMAR", "LLAMAR")
                        nodo.add(new Nodo("ID", $1), new Nodo("OPERADOR", $2), entrada1.nodo, new Nodo("OPERADOR", $4), new Nodo("OPERADOR", $5))
                        salida = {
                                nodo: nodo,
                                instruccion: instruccion
                        }
                        $$ = salida
                }
;

//Obtener un retorno (usado paa expresiones)-------------------------------------------------------
LLAMADAS:        identificador parA parC 
                {
                        //Creacion de la salida
                        instruccion = INSTRUCCION.llamadaa($1, null, this._$.first_line, this._$.first_column+1)
                        nodo = new Nodo("LLAMAR", "LLAMAR")
                        nodo.add(new Nodo("ID", $1), new Nodo("OPERADOR", $2), new Nodo("OPERADOR", $3))
                        salida = {
                                nodo: nodo,
                                instruccion: instruccion
                        }
                        $$ = salida
                        
                }
                | identificador parA ENTRADAS parC {
                        //Obtencion de valores
                        entrada1 = $3
                        //Creacion de la salida
                        instruccion = INSTRUCCION.llamadaa($1, entrada1.instruccion, this._$.first_line, this._$.first_column+1)
                        nodo = new Nodo("LLAMAR", "LLAMAR")
                        nodo.add(new Nodo("IDENTIFICADOR", $1), new Nodo("OPERADOR", $2), entrada1.nodo, new Nodo("OPERADOR", $4))
                        salida = {
                                nodo: nodo,
                                instruccion: instruccion
                        }
                        $$ = salida
                }
;
//Instrucciones---------------------------------------------------------------------------
INSTRUCCIONES: INSTRUCCIONES INSTRUCCION
        {
                //Obtencion de valores
                entrada1 = $1
                entrada2 = $2
                //Creacion de la salida
                entrada1.instruccion.push(entrada2.instruccion)
                instruccion = entrada1.instruccion
                nodo = entrada1.nodo
                nodo.add(entrada2.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }

        | INSTRUCCION
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = [entrada1.instruccion]
                nodo = new Nodo("INSTRUCCIONES", "INSTRUCCIONES")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
               
;

INSTRUCCION: DVARIABLES
        {
                 //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = entrada1.instruccion;
                nodo = new Nodo("INSTRUCCION", "INSTRUCCION")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | AVARIABLES
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = entrada1.instruccion;
                nodo = new Nodo("INSTRUCCION", "INSTRUCCION")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | DARREGLOS
        {
               //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = entrada1.instruccion;
                nodo = new Nodo("INSTRUCCION", "INSTRUCCION")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | AARREGLOS
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = entrada1.instruccion;
                nodo = new Nodo("INSTRUCCION", "INSTRUCCION")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | RETURN
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = entrada1.instruccion;
                nodo = new Nodo("INSTRUCCION", "INSTRUCCION")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | LLAMADA
        {
               //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = entrada1.instruccion;
                nodo = new Nodo("INSTRUCCION", "INSTRUCCION")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | PRINT
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = entrada1.instruccion;
                nodo = new Nodo("INSTRUCCION", "INSTRUCCION")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | IF
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = entrada1.instruccion;
                nodo = new Nodo("INSTRUCCION", "INSTRUCCION")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | SWITCH
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = entrada1.instruccion;
                nodo = new Nodo("INSTRUCCION", "INSTRUCCION")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | BREAK
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = entrada1.instruccion;
                nodo = new Nodo("INSTRUCCION", "INSTRUCCION")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | CONTINUE
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = entrada1.instruccion;
                nodo = new Nodo("INSTRUCCION", "INSTRUCCION")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | WHILE
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = entrada1.instruccion;
                nodo = new Nodo("INSTRUCCION", "INSTRUCCION")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | DOWHILE
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = entrada1.instruccion;
                nodo = new Nodo("INSTRUCCION", "INSTRUCCION")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | FOR
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = entrada1.instruccion;
                nodo = new Nodo("INSTRUCCION", "INSTRUCCION")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | error puntocoma
        {
                lista.add("Sintáctico", "Token Inesperado " + $1 , @1.first_line, @1.first_column + 1);
        }
;
//IF------------------------------------------------------------------------------------------
IF: if parA EXPRESION parC llavA INSTRUCCIONES llavC 
        {
                //Obtencion de valores
                entrada1 = $3
                entrada2 = $6
                //Creacion de la salida
                instruccion = INSTRUCCION.si(entrada1.instruccion, entrada2.instruccion, null, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("IF", "IF")
                nodo.add(new Nodo("OPERADOR", $1), new Nodo("OPERADOR", $2), entrada1.nodo, new Nodo("OPERADOR", $4), new Nodo("OPERADOR", $5),  entrada2.nodo, new Nodo("OPERADOR", $7))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        |if parA EXPRESION parC llavA INSTRUCCIONES llavC else llavA INSTRUCCIONES llavC 
        {
                //Obtencion de valores
                entrada1 = $3
                entrada2 = $6
                entrada2 = $10
                //Creacion de la salida
                instruccion = INSTRUCCION.si(entrada1.instruccion, entrada2.instruccion, entrada3.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("IF", "IF")
                nodo.add(new Nodo("OPERADOR", $1), new Nodo("OPERADOR", $2), entrada1.nodo, new Nodo("OPERADOR", $4), new Nodo("OPERADOR", $5),  entrada2.nodo, new Nodo("OPERADOR", $7),new Nodo("OPERADOR", $8), new Nodo("OPERADOR", $9), entrada3.nodo, new Nodo("OPERADOR", $11))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        |if parA EXPRESION parC llavA INSTRUCCIONES llavC else IF 
        {
                //Obtencion de valores
                entrada1 = $3
                entrada2 = $6
                entrada2 = $9
                //Creacion de la salida
                instruccion = INSTRUCCION.si(entrada1.instruccion, entrada2.instruccion, entrada3.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("IF", "IF")
                nodo.add(new Nodo("OPERADOR", $1), new Nodo("OPERADOR", $2), entrada1.nodo, new Nodo("OPERADOR", $4), new Nodo("OPERADOR", $5),  entrada2.nodo, new Nodo("OPERADOR", $7),new Nodo("OPERADOR", $8), entrada3.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida

        }
;

//Switch------------------------------------------------------------------------------------------
SWITCH: switch parA EXPRESION parC llavA CASES DEFAULT llavC 
        {
                //Obtencion de valores
                entrada1 = $3
                entrada2 = $6
                entrada3 = $7
                //Creacion de la salida
                instruccion = INSTRUCCION.switch(entrada1.instruccion, entrada2.instruccion, entrada3.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("SWITCH", "SWITCH")
                nodo.add(new Nodo("OPERADOR", $1), new Nodo("OPERADOR", $2), entrada1.nodo, new Nodo("OPERADOR", $4), new Nodo("OPERADOR", $5),  entrada2.nodo, entrada3.nodo,  new Nodo("OPERADOR", $8))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | switch parA EXPRESION parC llavA CASES llavC 
        {
                //Obtencion de valores
                entrada1 = $3
                entrada2 = $6
                //Creacion de la salida
                instruccion = INSTRUCCION.switch(entrada1.instruccion, entrada2.instruccion,null, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("SWITCH", "SWITCH")
                nodo.add(new Nodo("OPERADOR", $1), new Nodo("OPERADOR", $2), entrada1.nodo, new Nodo("OPERADOR", $4), new Nodo("OPERADOR", $5),  entrada2.nodo, new Nodo("OPERADOR", $7))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
;

CASES:  CASES CASO
        {
                //Obtencion de valores
                entrada1 = $1
                entrada2 = $2
                //Creacion de la salida
                entrada1.instruccion.push(entrada2.instruccion)
                instruccion = entrada1.instruccion
                nodo = entrada1.nodo
                nodo.add(entrada2.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        
        | CASO
        {
               //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = [entrada1.instruccion]
                nodo = new Nodo("CASES", "CASES")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
                
;

CASO: case EXPRESION dospuntos INSTRUCCIONES
        {
                //Obtencion de valores
                entrada1 = $2
                entrada2 = $4
                //Creacion de la salida
                instruccion = INSTRUCCION.case(entrada1.instruccion, entrada2.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("CASE", "CASE")
                nodo.add(new Nodo("OPERADOR", $1), entrada1.nodo, new Nodo("OPERADOR", $3), entrada2.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        
        }
;
        
DEFAULT:  default dospuntos INSTRUCCIONES
        {
                //Obtencion de valores
                entrada1 = $3
                
                //Creacion de la salida
                instruccion = INSTRUCCION.default(null, entrada1.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("DEFAULT", "DEFAULT")
                nodo.add(new Nodo("OPERADOR", $1), new Nodo("OPERADOR", $2), entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
;

//While------------------------------------------------------------------------------------------
WHILE: while parA EXPRESION parC llavA INSTRUCCIONES llavC 
        {
                //Obtencion de valores
                entrada1 = $3
                entrada2 = $6
                //Creacion de la salida
                instruccion = INSTRUCCION.while(entrada1.instruccion, entrada2.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("WHILE", "WHILE")
                nodo.add(new Nodo("OPERADOR", $1), new Nodo("OPERADOR", $2), entrada1.nodo, new Nodo("OPERADOR", $4), new Nodo("OPERADOR", $5),  entrada2.nodo, new Nodo("OPERADOR", $7))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida

        }
;
//Do While------------------------------------------------------------------------------------------
DOWHILE: do llavA INSTRUCCIONES llavC while parA EXPRESION parC puntocoma
        {
                //Obtencion de valores
                entrada2 = $3
                entrada1 = $7
                //Creacion de la salida
                instruccion = INSTRUCCION.dowhile(entrada1.instruccion, entrada2.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("DO-WHILE", "DO-WHILE")
                nodo.add(new Nodo("OPERADOR", $1), new Nodo("OPERADOR", $2), entrada2.nodo, new Nodo("OPERADOR", $4), new Nodo("OPERADOR", $5), new Nodo("OPERADOR", $6), entrada1.nodo, new Nodo("OPERADOR", $8), new Nodo("OPERADOR", $9))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
                
        }
;

//Do While------------------------------------------------------------------------------------------
FOR: for parA DVAR puntocoma EXPRESION puntocoma AVAR parC llavA INSTRUCCIONES llavC
        {
                //Obtencion de valores
                entrada1 = $3
                entrada2 = $5
                entrada3 = $7
                entrada4 = $10
                //Creacion de la salida
                instruccion = INSTRUCCION.for(entrada1.instruccion, entrada2.instruccion, entrada3.instruccion, entrada4.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("FOR", "FOR")
                nodo.add(new Nodo("OPERADOR", $1), new Nodo("OPERADOR", $2), entrada1.nodo, new Nodo("OPERADOR", $4), entrada2.nodo, new Nodo("OPERADOR", $6), entrada3.nodo, new Nodo("OPERADOR", $8), new Nodo("OPERADOR", $9), entrada4.nodo, new Nodo("OPERADOR", $11))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
               
        }
        | for parA AVAR puntocoma EXPRESION puntocoma AVAR parC llavA INSTRUCCIONES llavC
        {
                //Obtencion de valores
                entrada1 = $3
                entrada2 = $5
                entrada3 = $7
                entrada4 = $10
                //Creacion de la salida
                instruccion = INSTRUCCION.for(entrada1.instruccion, entrada2.instruccion, entrada3.instruccion, entrada4.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("FOR", "FOR")
                nodo.add(new Nodo("OPERADOR", $1), new Nodo("OPERADOR", $2), entrada1.nodo, new Nodo("OPERADOR", $4), entrada2.nodo, new Nodo("OPERADOR", $6), entrada3.nodo, new Nodo("OPERADOR", $8), new Nodo("OPERADOR", $9), entrada4.nodo, new Nodo("OPERADOR", $11))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
;

DVAR:  TIPO LISTAID asignar EXPRESION
        {
                //Obtencion de valores
                entrada1 = $1
                entrada2 = $2
                entrada3 = $4

                //Creacion de la salida
                instruccion = INSTRUCCION.declaracionv(entrada1.instruccion, entrada2.instruccion, entrada3.instruccion, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("DECLARACION VAR", "DECLARACION VAR")
                nodo.add(entrada1.nodo, entrada2.nodo, new Nodo("OPERADOR", $3), entrada3.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
               
        }
;

AVAR: identificador asignar EXPRESION 
        {
                //Obtencion de valores
                entrada2 = $3

                //Creacion de la salida
                instruccion = INSTRUCCION.asignacionv($1,entrada2.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("ASIGNACION VAR", "ASIGNACION VAR")
                nodo.add(new Nodo("ID", $1), new Nodo("OPERADOR", $2), entrada2.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
               
        }
;
//Funcion Return---------------------------------------------------------------------------------------
RETURN: return puntocoma 
        {
                //Creacion de la salida
                instruccion =INSTRUCCION.return(null, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("RETURN", "RETURN")
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
                
        }
        | return EXPRESION puntocoma 
        {
                //Obtencion de valores
                entrada1 = $2

                //Creacion de la salida
                instruccion = INSTRUCCION.return(entrada1.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("RETURN", "RETURN")
                nodo.add(new Nodo("OPERADOR", $1), entrada1.nodo, new Nodo("OPERADOR", $3))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        
                
        }
;

//Funcion Break---------------------------------------------------------------------------------------
BREAK: break puntocoma 
        {
                //Creacion de la salida
                instruccion = INSTRUCCION.break(this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("BREAK", "BREAK")
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
;
//Funcion Continue---------------------------------------------------------------------------------------
CONTINUE: continue puntocoma 
        {
                //Creacion de la salida
                instruccion = INSTRUCCION.continue(this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("CONTINUE", "CONTINUE")
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida 
        }
;
//Funcion Print---------------------------------------------------------------------------------------
PRINT: print parA EXPRESION parC puntocoma
        {
                //Obtencion de valores
                entrada1 = $3

                //Creacion de la salida
                instruccion = INSTRUCCION.print(entrada1.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("PRINT", "PRINT")
                nodo.add(new Nodo("OPERADOR", $1), new Nodo("OPERADOR", $2), entrada1.nodo, new Nodo("OPERADOR", $4), new Nodo("OPERADOR", $5))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        
        }
        | println parA EXPRESION parC puntocoma
        {
                //Obtencion de valores
                entrada1 = $3

                //Creacion de la salida
                instruccion = INSTRUCCION.println(entrada1.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("PRINTLN", "PRINTLN")
                nodo.add(new Nodo("OPERADOR", $1), new Nodo("OPERADOR", $2), entrada1.nodo, new Nodo("OPERADOR", $4), new Nodo("OPERADOR", $5))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
; 

//Funcion Upper---------------------------------------------------------------------------------------
UPPER: toUpper parA EXPRESION parC 
        {
                //Obtencion de valores
                entrada1 = $3

                //Creacion de la salida
                instruccion = INSTRUCCION.upper(entrada1.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("UPPER", "UPPER")
                nodo.add(new Nodo("OPERADOR", $1), new Nodo("OPERADOR", $2), entrada1.nodo, new Nodo("OPERADOR", $4))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        
        }
;

//Funcion Lower---------------------------------------------------------------------------------------
LOWER: toLower parA EXPRESION parC 
        {
                //Obtencion de valores
                entrada1 = $3

                //Creacion de la salida
                instruccion = INSTRUCCION.lower(entrada1.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("LOWER", "LOWER")
                nodo.add(new Nodo("OPERADOR", $1), new Nodo("OPERADOR", $2), entrada1.nodo, new Nodo("OPERADOR", $4))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
;

//Funcion Round---------------------------------------------------------------------------------------
ROUND: round parA EXPRESION parC 
        {
                //Obtencion de valores
                entrada1 = $3

                //Creacion de la salida
                instruccion = INSTRUCCION.round(entrada1.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("ROUND", "ROUND")
                nodo.add(new Nodo("OPERADOR", $1), new Nodo("OPERADOR", $2), entrada1.nodo, new Nodo("OPERADOR", $4))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
                
        }
;

//Funcion Lenth---------------------------------------------------------------------------------------
LENGTH: length parA EXPRESION parC 
        {
                //Obtencion de valores
                entrada1 = $3

                //Creacion de la salida
                instruccion = INSTRUCCION.length(entrada1.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("LENGTH", "LENGTH")
                nodo.add(new Nodo("OPERADOR", $1), new Nodo("OPERADOR", $2), entrada1.nodo, new Nodo("OPERADOR", $4))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
;

//Funcion TypeOf---------------------------------------------------------------------------------------
TYPEOF: typeof parA EXPRESION parC 
        {
                //Obtencion de valores
                entrada1 = $3

                //Creacion de la salida
                instruccion = INSTRUCCION.typeof(entrada1.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("TYPEOF", "TYPEOF")
                nodo.add(new Nodo("OPERADOR", $1), new Nodo("OPERADOR", $2), entrada1.nodo, new Nodo("OPERADOR", $4))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
         
        }
;

//Funcion toString---------------------------------------------------------------------------------------
TOSTRING: tostring parA EXPRESION parC 
        {
                //Obtencion de valores
                entrada1 = $3

                //Creacion de la salida
                instruccion = INSTRUCCION.tostring(entrada1.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("TOSTRING", "TOSTRING")
                nodo.add(new Nodo("TOSTRING", $1), new Nodo("OPERADOR", $2), entrada1.nodo, new Nodo("OPERADOR", $4))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida 
                
        }
;

//Funcion toString---------------------------------------------------------------------------------------
TOCHAR: tochar parA EXPRESION parC 
        {
                //Obtencion de valores
                entrada1 = $3

                //Creacion de la salida
                instruccion = INSTRUCCION.tochar(entrada1.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("TOCHAR", "TOCHAR")
                nodo.add(new Nodo("TOCHAR", $1), new Nodo("OPERADOR", $2), entrada1.nodo, new Nodo("OPERADOR", $4))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida 
        }
;

//Funcion Run---------------------------------------------------------------------------------------
RUN: run identificador parA parC puntocoma
        {
                //Creacion de la salida
                instruccion = INSTRUCCION.run($2, null, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("RUN", "RUN")
                nodo.add(new Nodo("RUN", $1), new Nodo("ID", $2), new Nodo("OPERADOR", $3), new Nodo("OPERADOR", $4), new Nodo("OPERADOR", $5))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | run identificador parA ENTRADAS parC puntocoma 
        {
                //Obtencion de valores
                entrada2 = $4
                //Creacion de la salida
                instruccion = INSTRUCCION.run($2, entrada2.instruccion, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("RUN", "RUN")
                nodo.add(new Nodo("RUN", $1), new Nodo("ID", $2), new Nodo("OPERADOR", $3), entrada2.nodo, new Nodo("OPERADOR", $5), new Nodo("OPERADOR", $6))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
                
        }
; 

ENTRADAS: ENTRADAS coma EXPRESION 
        {
                //Obtencion de valores
                entrada1 = $1
                entrada2 = $3
                //Creacion de la salida
                entrada1.instruccion.push(entrada2.instruccion)
                instruccion = entrada1.instruccion
                nodo = entrada1.nodo
                nodo.add(entrada2.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | EXPRESION 
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = [entrada1.instruccion]
                nodo = new Nodo("ENTRADA", "ENTRADA")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
;

//Tipos-----------------------------------------------------------------------------------
TIPO: int       
        {
                //Creacion de la salida
                instruccion = TIPO_DATO.INT
                nodo = new Nodo("TIPO", "TIPO")
                nodo.add(new Nodo("INT", $1))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
    | double    
    {
            //Creacion de la salida
                instruccion = TIPO_DATO.DOUBLE
                nodo = new Nodo("TIPO", "TIPO")
                nodo.add(new Nodo("DOUBLE", $1))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
    }
    | boolean   
    {
            //Creacion de la salida
                instruccion = TIPO_DATO.BOOLEAN
                nodo = new Nodo("TIPO", "TIPO")
                nodo.add(new Nodo("BOOLEAN", $1))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida

    }
    | char      
    {
            //Creacion de la salida
                instruccion = TIPO_DATO.CHAR
                nodo = new Nodo("TIPO", "TIPO")
                nodo.add(new Nodo("CHAR", $1))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
    }
    | string    
    {
            //Creacion de la salida
                instruccion = TIPO_DATO.STRING
                nodo = new Nodo("TIPO", "TIPO")
                nodo.add(new Nodo("STRING", $1))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
    }
;

//Valores Primitivos-----------------------------------------------------------------------------------
PRIMITIVO: entero
        {
                //Creacion de la salida
                instruccion = INSTRUCCION.valor(Number($1), TIPO_VALOR.INT, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("PRIMITIVO", "PRIMITIVO")
                nodo.add(new Nodo("ENTERO", $1))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | doble
        {
                //Creacion de la salida
                instruccion = INSTRUCCION.valor(Number($1), TIPO_VALOR.DOUBLE, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("PRIMITIVO", "PRIMITIVO")
                nodo.add(new Nodo("DOBLE", $1))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | true
        {
                //Creacion de la salida
                instruccion = INSTRUCCION.valor($1, TIPO_VALOR.BOOLEAN, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("PRIMITIVO", "PRIMITIVO")
                nodo.add(new Nodo("BOOLEAN", $1))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | false
        {
                //Creacion de la salida
                instruccion = INSTRUCCION.valor($1, TIPO_VALOR.BOOLEAN, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("PRIMITIVO", "PRIMITIVO")
                nodo.add(new Nodo("BOOLEAN", $1))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | texto
        {
                //Creacion de la salida
                instruccion = INSTRUCCION.valor($1, TIPO_VALOR.STRING, this._$.first_line, this._$.first_column+1);;
                nodo = new Nodo("PRIMITIVO", "PRIMITIVO")
                nodo.add(new Nodo("STRING", $1))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | caracter
        {
                //Creacion de la salida
                instruccion = INSTRUCCION.valor($1, TIPO_VALOR.CHAR, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("PRIMITIVO", "PRIMITIVO")
                nodo.add(new Nodo("CHAR", $1))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | identificador
        {
                //Creacion de la salida
                instruccion = INSTRUCCION.valor($1, TIPO_VALOR.IDENTIFICADOR, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("PRIMITIVO", "PRIMITIVO")
                nodo.add(new Nodo("ID", $1))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
;

//Declaracion de expresiones--------------------------------------------------------------------------
EXPRESION: EXPRESION mas EXPRESION
        {
                //Obtencion de valores
                entrada1 = $1
                entrada2 = $3

                //Creacion de la salida
                instruccion = INSTRUCCION.operacion(entrada1.instruccion,entrada2.instruccion, TIPO_OPERACION.SUMA, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(entrada1.nodo, new Nodo("OPERADOR", $2), entrada2.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }

        | EXPRESION menos EXPRESION
        {
                //Obtencion de valores
                entrada1 = $1
                entrada2 = $3

                //Creacion de la salida
                instruccion = INSTRUCCION.operacion(entrada1.instruccion,entrada2.instruccion, TIPO_OPERACION.RESTA, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(entrada1.nodo, new Nodo("OPERADOR", $2), entrada2.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | EXPRESION mul EXPRESION
        {
                //Obtencion de valores
                entrada1 = $1
                entrada2 = $3

                //Creacion de la salida
                instruccion = INSTRUCCION.operacion(entrada1.instruccion,entrada2.instruccion, TIPO_OPERACION.MULTIPLICACION, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(entrada1.nodo, new Nodo("OPERADOR", $2), entrada2.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | EXPRESION div EXPRESION
        {
                //Obtencion de valores
                entrada1 = $1
                entrada2 = $3

                //Creacion de la salida
                instruccion = INSTRUCCION.operacion(entrada1.instruccion,entrada2.instruccion, TIPO_OPERACION.DIVISION, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(entrada1.nodo, new Nodo("OPERADOR", $2), entrada2.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | EXPRESION mod EXPRESION
        {
                //Obtencion de valores
                entrada1 = $1
                entrada2 = $3

                //Creacion de la salida
                instruccion = INSTRUCCION.operacion(entrada1.instruccion,entrada2.instruccion, TIPO_OPERACION.MODULO, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(entrada1.nodo, new Nodo("OPERADOR", $2), entrada2.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | EXPRESION exp EXPRESION
        {
                //Obtencion de valores
                entrada1 = $1
                entrada2 = $3

                //Creacion de la salida
                instruccion = INSTRUCCION.operacion(entrada1.instruccion,entrada2.instruccion, TIPO_OPERACION.POTENCIA, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(entrada1.nodo, new Nodo("OPERADOR", $2), entrada2.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
                
        }
        | menos EXPRESION %prec umenos
        {
                //Obtencion de valores
                entrada1 = $2

                //Creacion de la salida
                instruccion = INSTRUCCION.operacion(entrada1.instruccion,null, TIPO_OPERACION.UNARIO, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(new Nodo("OPERADOR", $1), entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | parA EXPRESION parC
        {
                //Obtencion de valores
                entrada1 = $2

                //Creacion de la salida
                instruccion = entrada1.instruccion;
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(new Nodo("OPERADOR", $1), entrada1.nodo, new Nodo("OPERADOR", $3))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | EXPRESION igual EXPRESION
        {
                //Obtencion de valores
                entrada1 = $1
                entrada2 = $3

                //Creacion de la salida
                instruccion = INSTRUCCION.operacion(entrada1.instruccion,entrada2.instruccion, TIPO_OPERACION.IGUAL, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(entrada1.nodo, new Nodo("OPERADOR", $2), entrada2.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | EXPRESION desigual EXPRESION
        {
                //Obtencion de valores
                entrada1 = $1
                entrada2 = $3

                //Creacion de la salida
                instruccion = INSTRUCCION.operacion(entrada1.instruccion,entrada2.instruccion, TIPO_OPERACION.DESIGUAL, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(entrada1.nodo, new Nodo("OPERADOR", $2), entrada2.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | EXPRESION menor EXPRESION
        {
                //Obtencion de valores
                entrada1 = $1
                entrada2 = $3

                //Creacion de la salida
                instruccion = INSTRUCCION.operacion(entrada1.instruccion,entrada2.instruccion, TIPO_OPERACION.MENOR, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(entrada1.nodo, new Nodo("OPERADOR", $2), entrada2.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | EXPRESION menorIgual EXPRESION
        {
                //Obtencion de valores
                entrada1 = $1
                entrada2 = $3

                //Creacion de la salida
                instruccion = INSTRUCCION.operacion(entrada1.instruccion,entrada2.instruccion, TIPO_OPERACION.MENORIGUAL, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(entrada1.nodo, new Nodo("OPERADOR", $2), entrada2.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | EXPRESION mayor EXPRESION
        {
                //Obtencion de valores
                entrada1 = $1
                entrada2 = $3

                //Creacion de la salida
                instruccion = INSTRUCCION.operacion(entrada1.instruccion,entrada2.instruccion, TIPO_OPERACION.MAYOR, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(entrada1.nodo, new Nodo("OPERADOR", $2), entrada2.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
                
        }
        | EXPRESION mayorIgual EXPRESION
        {
                //Obtencion de valores
                entrada1 = $1
                entrada2 = $3

                //Creacion de la salida
                instruccion = INSTRUCCION.operacion(entrada1.instruccion,entrada2.instruccion, TIPO_OPERACION.MAYORIGUAL, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(entrada1.nodo, new Nodo("OPERADOR", $2), entrada2.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | EXPRESION or EXPRESION
        {
                //Obtencion de valores
                entrada1 = $1
                entrada2 = $3

                //Creacion de la salida
                instruccion = INSTRUCCION.operacion(entrada1.instruccion,entrada2.instruccion, TIPO_OPERACION.OR, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(entrada1.nodo, new Nodo("OPERADOR", $2), entrada2.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | EXPRESION and EXPRESION
        {
                //Obtencion de valores
                entrada1 = $1
                entrada2 = $3

                //Creacion de la salida
                instruccion = INSTRUCCION.operacion(entrada1.instruccion,entrada2.instruccion, TIPO_OPERACION.AND, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(entrada1.nodo, new Nodo("OPERADOR", $2), entrada2.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | not EXPRESION
        {
                //Obtencion de valores
                entrada1 = $2

                //Creacion de la salida
                instruccion = INSTRUCCION.operacion(entrada1.instruccion,null, TIPO_OPERACION.NOT, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(new Nodo("OPERADOR", $1), entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | EXPRESION ternario EXPRESION dospuntos EXPRESION
        {
                //Obtencion de valores
                entrada1 = $1
                entrada2 = $3
                entrada3 = $5

                //Creacion de la salida
                instruccion = INSTRUCCION.ternario(entrada1.instruccion,entrada2.instruccion, entrada3.instruccion, TIPO_OPERACION.TERNARIO, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(entrada1.nodo, new Nodo("OPERADOR", $2), entrada2.nodo, new Nodo("OPERADOR", $4), entrada3.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | entero
        {
                //Creacion de la salida
                instruccion = INSTRUCCION.valor(Number($1), TIPO_VALOR.INT, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(new Nodo("ENTERO", $1))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | doble
        {
                //Creacion de la salida
                instruccion = INSTRUCCION.valor(Number($1), TIPO_VALOR.DOUBLE, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(new Nodo("DOBLE", $1))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | true
        {
                //Creacion de la salida
                instruccion = INSTRUCCION.valor($1, TIPO_VALOR.BOOLEAN, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(new Nodo("BOOLEAN", $1))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | false
        {
                //Creacion de la salida
                instruccion = INSTRUCCION.valor($1, TIPO_VALOR.BOOLEAN, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(new Nodo("BOOLEAN", $1))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | texto
        {
                //Creacion de la salida
                instruccion = INSTRUCCION.valor($1, TIPO_VALOR.STRING, this._$.first_line, this._$.first_column+1);;
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(new Nodo("STRING", $1))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | caracter
        {
                //Creacion de la salida
                instruccion = INSTRUCCION.valor($1, TIPO_VALOR.CHAR, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(new Nodo("CHAR", $1))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | identificador
        {
                //Creacion de la salida
                instruccion = INSTRUCCION.valor($1, TIPO_VALOR.IDENTIFICADOR, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(new Nodo("ID", $1))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | parA TIPO parC EXPRESION
        {
                //Obtencion de valores
                entrada1 = $2
                entrada2 = $4

                //Creacion de la salida
                instruccion = INSTRUCCION.casteo(entrada1.instruccion, entrada2.instruccion, TIPO_OPERACION.CASTEO, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(new Nodo("OPERADOR", $1), entrada1.nodo, new Nodo("OPERADOR", $3), entrada2.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | EXPRESION mas mas
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = INSTRUCCION.operacion(entrada1.instruccion, null, TIPO_OPERACION.INCREMENTO, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(entrada1.nodo, new Nodo("OPERADOR", $2), new Nodo("OPERADOR", $3))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida       
        }
        | EXPRESION menos menos
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = INSTRUCCION.operacion(entrada1.instruccion, null, TIPO_OPERACION.DECREMENTO, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(entrada1.nodo, new Nodo("OPERADOR", $2), new Nodo("OPERADOR", $3))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida         
        }
        | identificador corA EXPRESION corC 
        {
                //Obtencion de valores
                entrada2 = $3

                //Creacion de la salida
                instruccion = INSTRUCCION.valorv($1, entrada2.instruccion, null,  this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(new Nodo("ID", $1), new Nodo("OPERADOR", $2), entrada2.nodo, new Nodo("OPERADOR", $4))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida

        }
        | identificador corA EXPRESION corC corA EXPRESION corC
        {
                //Obtencion de valores
                entrada2 = $3
                entrada3 = $6

                //Creacion de la salida
                instruccion = INSTRUCCION.valorv($1, entrada2.instruccion, entrada3.instruccion, this._$.first_line, this._$.first_column+1);
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(new Nodo("ID", $1), new Nodo("OPERADOR", $2), entrada2.nodo, new Nodo("OPERADOR", $4), new Nodo("OPERADOR", $5), entrada3.nodo, new Nodo("OPERADOR", $7))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | LLAMADAS
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = entrada1.instruccion;
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        
        }
        | UPPER
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = entrada1.instruccion;
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | LOWER
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = entrada1.instruccion;
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | ROUND
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = entrada1.instruccion;
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | LENGTH
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = entrada1.instruccion;
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | TYPEOF
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = entrada1.instruccion;
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | TOSTRING
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = entrada1.instruccion;
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        | TOCHAR
        {
                //Obtencion de valores
                entrada1 = $1

                //Creacion de la salida
                instruccion = entrada1.instruccion;
                nodo = new Nodo("EXPRESION", "EXPRESION")
                nodo.add(entrada1.nodo)
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
;




