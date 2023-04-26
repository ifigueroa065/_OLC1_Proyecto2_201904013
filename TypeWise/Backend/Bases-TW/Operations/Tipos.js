
//? Validacion de tipos
//!Retorna el tipo de la nuebvva operacion

const TIPO_DATO = require("../Reserved/TipoDato")
const TIPO_OPERACION = require("../Reserved/TipoOperacion")

function Tipos(tipo1, tipo2, operacion){
    switch (operacion) {
        case TIPO_OPERACION.SUMA:
            //Enteros
            if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.INT
            }else if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.DOUBLE
            }else if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.BOOLEAN){
                return TIPO_DATO.INT
            }else if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.STRING){
                return TIPO_DATO.STRING
            }else if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.CHAR){
                return TIPO_DATO.INT
            //Doubles
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.DOUBLE
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.DOUBLE
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.BOOLEAN){
                return TIPO_DATO.DOUBLE
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.STRING){
                return TIPO_DATO.STRING
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.CHAR){
                return TIPO_DATO.DOUBLE
            //Boolean
            }else if(tipo1 === TIPO_DATO.BOOLEAN && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.INT
            }else if(tipo1 === TIPO_DATO.BOOLEAN && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.DOUBLE
            }else if(tipo1 === TIPO_DATO.BOOLEAN && tipo2 === TIPO_DATO.STRING){
                return TIPO_DATO.STRING
            //Caracter
            }else if(tipo1 === TIPO_DATO.CHAR && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.INT
            }else if(tipo1 === TIPO_DATO.CHAR && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.DOUBLE
            }else if(tipo1 === TIPO_DATO.CHAR && tipo2 === TIPO_DATO.STRING){
                return TIPO_DATO.STRING
            }else if(tipo1 === TIPO_DATO.CHAR && tipo2 === TIPO_DATO.CHAR){
                return TIPO_DATO.STRING
            //String
            }else if(tipo1 === TIPO_DATO.STRING && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.STRING
            }else if(tipo1 === TIPO_DATO.STRING && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.STRING
            }else if(tipo1 === TIPO_DATO.STRING && tipo2 === TIPO_DATO.BOOLEAN){
                return TIPO_DATO.STRING
            }else if(tipo1 === TIPO_DATO.STRING && tipo2 === TIPO_DATO.STRING){
                return TIPO_DATO.STRING
            }else if(tipo1 === TIPO_DATO.STRING && tipo2 === TIPO_DATO.CHAR){
                return TIPO_DATO.STRING
            //Boolean
            }
            return null

        case TIPO_OPERACION.RESTA:
            //Enteros
            if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.INT
            }else if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.DOUBLE
            }else if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.BOOLEAN){
                return TIPO_DATO.INT
            }else if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.CHAR){
                return TIPO_DATO.INT
            //Doubles
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.DOUBLE
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.DOUBLE
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.BOOLEAN){
                return TIPO_DATO.DOUBLE
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.CHAR){
                return TIPO_DATO.DOUBLE
            //Boolean
            }else if(tipo1 === TIPO_DATO.BOOLEAN && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.INT
            }else if(tipo1 === TIPO_DATO.BOOLEAN && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.DOUBLE
            //Caracter
            }else if(tipo1 === TIPO_DATO.CHAR && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.INT
            }else if(tipo1 === TIPO_DATO.CHAR && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.DOUBLE
            }
            return null

        case TIPO_OPERACION.MULTIPLICACION:
            //Enteros
            if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.INT
            }else if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.DOUBLE
            }else if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.CHAR){
                return TIPO_DATO.INT
            //Doubles
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.DOUBLE
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.DOUBLE
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.CHAR){
                return TIPO_DATO.DOUBLE
            //Caracter
            }else if(tipo1 === TIPO_DATO.CHAR && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.INT
            }else if(tipo1 === TIPO_DATO.CHAR && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.DOUBLE
            }
            return null
        

        case TIPO_OPERACION.DIVISION:
            //Enteros
            if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.DOUBLE
            }else if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.DOUBLE
            }else if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.CHAR){
                return TIPO_DATO.DOUBLE
            //Doubles
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.DOUBLE
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.DOUBLE
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.CHAR){
                return TIPO_DATO.DOUBLE
            //Caracter
            }else if(tipo1 === TIPO_DATO.CHAR && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.DOUBLE
            }else if(tipo1 === TIPO_DATO.CHAR && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.DOUBLE
            }
            return null
        
        case TIPO_OPERACION.POTENCIA:
            //Enteros
            if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.INT
            }else if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.DOUBLE
            //Doubles
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.DOUBLE
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.DOUBLE
            }
            return null

        case TIPO_OPERACION.MODULO:
            //Enteros
            if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.DOUBLE
            }else if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.DOUBLE
            //Doubles
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.DOUBLE
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.DOUBLE
            }
            return null

        case TIPO_OPERACION.UNARIO:
            //Enteros
            if(tipo1 === TIPO_DATO.INT){
                return TIPO_DATO.INT
            }else if(tipo1 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.DOUBLE
            }
            return null

        //MAnejo de Operaciones relacionales ------------------------------------------------------

        case TIPO_OPERACION.IGUAL:
            //Enteros
            if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.CHAR){
                return TIPO_DATO.BOOLEAN
            //Doubles
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.CHAR){
                return TIPO_DATO.BOOLEAN
            //Boolean
            }else if(tipo1 === TIPO_DATO.BOOLEAN && tipo2 === TIPO_DATO.BOOLEAN){
                return TIPO_DATO.BOOLEAN
                //Caracter
            }else if(tipo1 === TIPO_DATO.CHAR && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.CHAR && tipo2 === TIPO_DATO.CHAR){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.CHAR && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.BOOLEAN
            //String
            }else if(tipo1 === TIPO_DATO.STRING && tipo2 === TIPO_DATO.STRING){
                    return TIPO_DATO.BOOLEAN
            }
            return null

        case TIPO_OPERACION.DESIGUAL:
            //Enteros
            if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.CHAR){
                return TIPO_DATO.BOOLEAN
            //Doubles
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.CHAR){
                return TIPO_DATO.BOOLEAN
            //Boolean
            }else if(tipo1 === TIPO_DATO.BOOLEAN && tipo2 === TIPO_DATO.BOOLEAN){
                return TIPO_DATO.BOOLEAN
                //Caracter
            }else if(tipo1 === TIPO_DATO.CHAR && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.CHAR && tipo2 === TIPO_DATO.CHAR){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.CHAR && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.BOOLEAN
            //String
            }else if(tipo1 === TIPO_DATO.STRING && tipo2 === TIPO_DATO.STRING){
                return TIPO_DATO.BOOLEAN
            }
            return null

        case TIPO_OPERACION.MAYORIGUAL:
            //Enteros
            if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.CHAR){
                return TIPO_DATO.BOOLEAN
            //Doubles
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.CHAR){
                return TIPO_DATO.BOOLEAN
            //Boolean
            }else if(tipo1 === TIPO_DATO.BOOLEAN && tipo2 === TIPO_DATO.BOOLEAN){
                return TIPO_DATO.BOOLEAN
                //Caracter
            }else if(tipo1 === TIPO_DATO.CHAR && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.CHAR && tipo2 === TIPO_DATO.CHAR){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.CHAR && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.BOOLEAN
            //String
            }else if(tipo1 === TIPO_DATO.STRING && tipo2 === TIPO_DATO.STRING){
                return TIPO_DATO.BOOLEAN
            }
            return null

        case TIPO_OPERACION.MENORIGUAL:
            //Enteros
            if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.CHAR){
                return TIPO_DATO.BOOLEAN
            //Doubles
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.CHAR){
                return TIPO_DATO.BOOLEAN
            //Boolean
            }else if(tipo1 === TIPO_DATO.BOOLEAN && tipo2 === TIPO_DATO.BOOLEAN){
                return TIPO_DATO.BOOLEAN
            //Caracter
            }else if(tipo1 === TIPO_DATO.CHAR && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.CHAR && tipo2 === TIPO_DATO.CHAR){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.CHAR && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.BOOLEAN
            //String
            }else if(tipo1 === TIPO_DATO.STRING && tipo2 === TIPO_DATO.STRING){
                return TIPO_DATO.BOOLEAN
            }
            return null

        case TIPO_OPERACION.MENOR:
            //Enteros
            if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.CHAR){
                return TIPO_DATO.BOOLEAN
            //Doubles
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.CHAR){
                return TIPO_DATO.BOOLEAN
            //Boolean
            }else if(tipo1 === TIPO_DATO.BOOLEAN && tipo2 === TIPO_DATO.BOOLEAN){
                return TIPO_DATO.BOOLEAN
            //Caracter
            }else if(tipo1 === TIPO_DATO.CHAR && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.CHAR && tipo2 === TIPO_DATO.CHAR){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.CHAR && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.BOOLEAN
            //String
            }else if(tipo1 === TIPO_DATO.STRING && tipo2 === TIPO_DATO.STRING){
                return TIPO_DATO.BOOLEAN
            }
            return null

        case TIPO_OPERACION.MAYOR:
            //Enteros
            if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.CHAR){
                return TIPO_DATO.BOOLEAN
            //Doubles
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.CHAR){
                return TIPO_DATO.BOOLEAN
            //Boolean
            }else if(tipo1 === TIPO_DATO.BOOLEAN && tipo2 === TIPO_DATO.BOOLEAN){
                return TIPO_DATO.BOOLEAN
            //Caracter
            }else if(tipo1 === TIPO_DATO.CHAR && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.CHAR && tipo2 === TIPO_DATO.CHAR){
                return TIPO_DATO.BOOLEAN
            }else if(tipo1 === TIPO_DATO.CHAR && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.BOOLEAN
            //String
            }else if(tipo1 === TIPO_DATO.STRING && tipo2 === TIPO_DATO.STRING){
                return TIPO_DATO.BOOLEAN
            }
            return null
        
            //Operaciones Logicas

        case TIPO_OPERACION.AND:
            //Boolean
            if(tipo1 === TIPO_DATO.BOOLEAN && tipo2 === TIPO_DATO.BOOLEAN){
                return TIPO_DATO.BOOLEAN
            }
            return null

        case TIPO_OPERACION.OR:
            //Boolean
            if(tipo1 === TIPO_DATO.BOOLEAN && tipo2 === TIPO_DATO.BOOLEAN){
                return TIPO_DATO.BOOLEAN
            }
            return null

        case TIPO_OPERACION.NOT:
            //Boolean
            if(tipo1 === TIPO_DATO.BOOLEAN){
                return TIPO_DATO.BOOLEAN
            }
            return null

        case TIPO_OPERACION.CASTEO:
            if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.DOUBLE
            }else if(tipo1 === TIPO_DATO.DOUBLE && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.INT
            }else if(tipo1 === TIPO_DATO.INT && tipo2 === TIPO_DATO.CHAR){
                return TIPO_DATO.CHAR
            }else if(tipo1 === TIPO_DATO.CHAR && tipo2 === TIPO_DATO.INT){
                return TIPO_DATO.INT
            }else if(tipo1 === TIPO_DATO.CHAR && tipo2 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.DOUBLE
            }
            return null

        case TIPO_OPERACION.INCREMENTO:
            //Enteros
            if(tipo1 === TIPO_DATO.INT){
                return TIPO_DATO.INT
            }else if(tipo1 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.DOUBLE
            }
            return null
        
        case TIPO_OPERACION.DECREMENTO:
            //Enteros
            if(tipo1 === TIPO_DATO.INT){
                return TIPO_DATO.INT
            }else if(tipo1 === TIPO_DATO.DOUBLE){
                return TIPO_DATO.DOUBLE
            }
            return null
      }
}

module.exports = Tipos