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
"println"                     return 'print';
"print"                   return 'println';
"return"                    return 'return';
"toLower"                   return 'toLower';
"toUpper"                   return 'toUpper';
"round"                     return 'round';
"length"                    return 'length';
"typeof"                    return 'typeof';
"tostring"                  return 'tostring';
"tochararray"               return 'tochar';
"main"                       return 'run';
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
        var ListaErrores = require("./Bases-TW/Errors/ListaErrores");
        var ListaSimbolos = require("./Bases-TW/Models/ListaSimbolos");
        var ListaMetodos = require("./Bases-TW/Models/ListaMetodos");
        const Nodo = require('./Bases-TW/AST/NodoAST');
        const TIPO_OPERACION = require('./Bases-TW/Reserved/TipoOperacion');
        const TIPO_VALOR = require('./Bases-TW/Reserved/TipoValor');
        const TIPO_DATO = require('./Bases-TW/Reserved/TipoDato');
        const INSTRUCCION = require('./Bases-TW/Instruction/Instruccion');

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
                //GET:  Values
                entrada1 = $1
                entrada2 = $2
                //OUTPUT
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
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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

                                //? Declaracion de Variables

DVARIABLES: TIPO LISTAID asignar EXPRESION puntocoma
        {
                //GET:  Values
                entrada1 = $1
                entrada2 = $2
                entrada3 = $4
                //OUTPUT
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
                //GET:  Values
                entrada1 = $1
                entrada2 = $2
                //OUTPUT
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
                //GET:  Values
                entrada1 = $1
                //OUTPUT
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
                //OUTPUT
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
                                //! Asignacion de valores

AVARIABLES: identificador asignar EXPRESION puntocoma
        {
                //GET:  Values
                entrada1 = $3
                
                //OUTPUT
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

                                //* Asignacion de ARREGLOS

AARREGLOS: identificador corA EXPRESION corC asignar EXPRESION puntocoma
        {
                //GET:  Values
                entrada1 = $3
                entrada2 = $6
                
                //OUTPUT
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
                //GET:  Values
                entrada1 = $3
                entrada2 = $6
                entrada3 = $9
                
                //OUTPUT
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

                                //* Declaracion de Arreglos
        
DARREGLOS: UDIMENSION
        {
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1
                entrada2 = $7
                entrada3 = $9
                //OUTPUT
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
                //GET:  Values
                entrada1 = $1
                entrada2 = $7
                //OUTPUT
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
                //GET:  Values
                entrada1 = $1
                entrada2 = $6
                //OUTPUT
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
                //GET:  Values
                entrada1 = $1
                entrada2 = $9
                entrada3 = $11
                entrada4 = $14
                //OUTPUT
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
                //GET:  Values
                entrada1 = $1
                entrada2 = $9
                //OUTPUT
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
                 //GET:  Values
                entrada1 = $1
                entrada2 = $3
                //OUTPUT
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
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1
                entrada2 = $4
                //OUTPUT
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
                //GET:  Values
                entrada1 = $2

                //OUTPUT
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

                                //* Declaración de Métodos

DMETODO: void identificador parA parC llavA INSTRUCCIONES llavC 
        {
                //GET:  Values
                entrada2 = $6
                //OUTPUT
                instruccion = INSTRUCCION.dmetodo($2, null, entrada2.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("DEC METODO", "DEC METODO")
                nodo.add(new Nodo("ID", $2), new Nodo("OPERADOR", $3), new Nodo("OPERADOR", $4), new Nodo("OPERADOR", $5), entrada2.nodo, new Nodo("OPERADOR", $7))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        
        }
        
        |void identificador parA PARAMETROS parC llavA INSTRUCCIONES llavC 
        {
                //GET:  Values
                entrada2 = $4
                entrada3 = $7
                //OUTPUT
                instruccion = INSTRUCCION.dmetodo($2, entrada2.instruccion, entrada3.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("DEC METODO", "DEC METODO")
                nodo.add(new Nodo("ID", $2), new Nodo("OPERADOR", $3), entrada2.nodo, new Nodo("OPERADOR", $5), new Nodo("OPERADOR", $6), entrada3.nodo, new Nodo("OPERADOR", $8))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
        
;

                                //* Declaración de Funciones

DFUNCION:TIPO identificador parA parC llavA INSTRUCCIONES llavC
        {
                //GET:  Values
                entrada2 = $1
                entrada3 = $6
                //OUTPUT
                instruccion = INSTRUCCION.dfuncion($2, null, entrada2.instruccion, entrada3.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("DEC FUNCION", "DEC FUNCION")
                nodo.add(new Nodo("ID", $2), new Nodo("OPERADOR", $3), new Nodo("OPERADOR", $4), entrada2.nodo, new Nodo("OPERADOR", $5), entrada3.nodo,  new Nodo("OPERADOR", $7))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
                
        }
        |TIPO identificador parA PARAMETROS parC llavA INSTRUCCIONES llavC
        {
                //GET:  Values
                entrada2 = $4
                entrada3 = $1
                entrada4 = $7
                //OUTPUT
                instruccion = INSTRUCCION.dfuncion($2, entrada2.instruccion, entrada3.instruccion, entrada4.instruccion, this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("DEC FUNCION", "DEC FUNCION")
                nodo.add(new Nodo("ID", $2), new Nodo("OPERADOR", $3), entrada2.nodo, new Nodo("OPERADOR", $5), entrada3.nodo, new Nodo("OPERADOR", $6), entrada4.nodo ,new Nodo("OPERADOR", $8))
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
;

PARAMETROS: PARAMETROS coma PARAMETRO {
               //GET:  Values
                entrada1 = $1
                entrada2 = $3
                //OUTPUT
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
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1
                //OUTPUT
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

                                //! Calls
                                
LLAMADA:        identificador parA parC puntocoma 
                {
                        //OUTPUT
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
                        //GET:  Values
                        entrada1 = $3
                        //OUTPUT
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

                                //* Obtener un retorno (usado paa expresiones)

LLAMADAS:        identificador parA parC 
                {
                        //OUTPUT
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
                        //GET:  Values
                        entrada1 = $3
                        //OUTPUT
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

                                //* Instrucciones

INSTRUCCIONES: INSTRUCCIONES INSTRUCCION
        {
                //GET:  Values
                entrada1 = $1
                entrada2 = $2
                //OUTPUT
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
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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
                 //GET:  Values
                entrada1 = $1

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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
               //GET:  Values
                entrada1 = $1

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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
               //GET:  Values
                entrada1 = $1

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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

                                //* If

IF: if parA EXPRESION parC llavA INSTRUCCIONES llavC 
        {
                //GET:  Values
                entrada1 = $3
                entrada2 = $6
                //OUTPUT
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
                //GET:  Values
                entrada1 = $3
                entrada2 = $6
                entrada2 = $10
                //OUTPUT
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
                //GET:  Values
                entrada1 = $3
                entrada2 = $6
                entrada2 = $9
                //OUTPUT
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

                                //? switch

SWITCH: switch parA EXPRESION parC llavA CASES DEFAULT llavC 
        {
                //GET:  Values
                entrada1 = $3
                entrada2 = $6
                entrada3 = $7
                //OUTPUT
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
                //GET:  Values
                entrada1 = $3
                entrada2 = $6
                //OUTPUT
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
                //GET:  Values
                entrada1 = $1
                entrada2 = $2
                //OUTPUT
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
               //GET:  Values
                entrada1 = $1

                //OUTPUT
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
                //GET:  Values
                entrada1 = $2
                entrada2 = $4
                //OUTPUT
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
                //GET:  Values
                entrada1 = $3
                
                //OUTPUT
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

                                //* While

WHILE: while parA EXPRESION parC llavA INSTRUCCIONES llavC 
        {
                //GET:  Values
                entrada1 = $3
                entrada2 = $6
                //OUTPUT
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
                                //* Do while

DOWHILE: do llavA INSTRUCCIONES llavC while parA EXPRESION parC puntocoma
        {
                //GET:  Values
                entrada2 = $3
                entrada1 = $7
                //OUTPUT
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

                                //* Do While

FOR: for parA DVAR puntocoma EXPRESION puntocoma AVAR parC llavA INSTRUCCIONES llavC
        {
                //GET:  Values
                entrada1 = $3
                entrada2 = $5
                entrada3 = $7
                entrada4 = $10
                //OUTPUT
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
                //GET:  Values
                entrada1 = $3
                entrada2 = $5
                entrada3 = $7
                entrada4 = $10
                //OUTPUT
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
                //GET:  Values
                entrada1 = $1
                entrada2 = $2
                entrada3 = $4

                //OUTPUT
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
                //GET:  Values
                entrada2 = $3

                //OUTPUT
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
                                        //*  Return

RETURN: return puntocoma 
        {
                //OUTPUT
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
                //GET:  Values
                entrada1 = $2

                //OUTPUT
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

                                //* Break

BREAK: break puntocoma 
        {
                //OUTPUT
                instruccion = INSTRUCCION.break(this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("BREAK", "BREAK")
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida
        }
;

                                //* Continue

CONTINUE: continue puntocoma 
        {
                //OUTPUT
                instruccion = INSTRUCCION.continue(this._$.first_line, this._$.first_column+1)
                nodo = new Nodo("CONTINUE", "CONTINUE")
                salida = {
                        nodo: nodo,
                        instruccion: instruccion
                }
                $$ = salida 
        }
;
                                //* print

PRINT: print parA EXPRESION parC puntocoma
        {
                //GET:  Values
                entrada1 = $3

                //OUTPUT
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
                //GET:  Values
                entrada1 = $3

                //OUTPUT
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

                                //* upper

UPPER: toUpper parA EXPRESION parC 
        {
                //GET:  Values
                entrada1 = $3

                //OUTPUT
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

                                //* Lower

LOWER: toLower parA EXPRESION parC 
        {
                //GET:  Values
                entrada1 = $3

                //OUTPUT
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

                                //* round

ROUND: round parA EXPRESION parC 
        {
                //GET:  Values
                entrada1 = $3

                //OUTPUT
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

                                //* Length

LENGTH: length parA EXPRESION parC 
        {
                //GET:  Values
                entrada1 = $3

                //OUTPUT
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

                                //* TypeOf

TYPEOF: typeof parA EXPRESION parC 
        {
                //GET:  Values
                entrada1 = $3

                //OUTPUT
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

                                //* toString
                                
TOSTRING: tostring parA EXPRESION parC 
        {
                //GET:  Values
                entrada1 = $3

                //OUTPUT
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

                                //* toChar

TOCHAR: tochar parA EXPRESION parC 
        {
                //GET:  Values
                entrada1 = $3

                //OUTPUT
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

                                //* Main

RUN: run identificador parA parC puntocoma
        {
                //OUTPUT
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
                //GET:  Values
                entrada2 = $4
                //OUTPUT
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
                //GET:  Values
                entrada1 = $1
                entrada2 = $3
                //OUTPUT
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
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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

                                //! Tipos

TIPO: int       
        {
                //OUTPUT
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
            //OUTPUT
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
            //OUTPUT
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
            //OUTPUT
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
            //OUTPUT
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

                                //* Valores Primitivos

PRIMITIVO: entero
        {
                //OUTPUT
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
                //OUTPUT
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
                //OUTPUT
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
                //OUTPUT
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
                //OUTPUT
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
                //OUTPUT
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
                //OUTPUT
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

                                //* Declaracion de expresiones

EXPRESION: EXPRESION mas EXPRESION
        {
                //GET:  Values
                entrada1 = $1
                entrada2 = $3

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1
                entrada2 = $3

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1
                entrada2 = $3

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1
                entrada2 = $3

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1
                entrada2 = $3

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1
                entrada2 = $3

                //OUTPUT
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
                //GET:  Values
                entrada1 = $2

                //OUTPUT
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
                //GET:  Values
                entrada1 = $2

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1
                entrada2 = $3

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1
                entrada2 = $3

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1
                entrada2 = $3

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1
                entrada2 = $3

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1
                entrada2 = $3

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1
                entrada2 = $3

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1
                entrada2 = $3

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1
                entrada2 = $3

                //OUTPUT
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
                //GET:  Values
                entrada1 = $2

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1
                entrada2 = $3
                entrada3 = $5

                //OUTPUT
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
                //OUTPUT
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
                //OUTPUT
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
                //OUTPUT
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
                //OUTPUT
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
                //OUTPUT
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
                //OUTPUT
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
                //OUTPUT
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
                //GET:  Values
                entrada1 = $2
                entrada2 = $4

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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
                //GET:  Values
                entrada2 = $3

                //OUTPUT
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
                //GET:  Values
                entrada2 = $3
                entrada3 = $6

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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
                //GET:  Values
                entrada1 = $1

                //OUTPUT
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




