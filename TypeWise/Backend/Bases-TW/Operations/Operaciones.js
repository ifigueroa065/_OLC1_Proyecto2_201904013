const TIPO_DATO = require("../Reserved/TipoDato"); 
const TIPO_OPERACION = require("../Reserved/TipoOperacion");
const TIPO_VALOR = require("../Reserved/TipoValor");
const TIPO_INSTRUCCION = require("../Reserved/TipoInstruccion");
const Tipos = require("./Tipos");

                                    //* Modulo Principal 

function Operaciones(expresion, entorno, errores, simbolo){
    if(expresion.tipo === TIPO_VALOR.INT || expresion.tipo === TIPO_VALOR.DOUBLE || 
        expresion.tipo === TIPO_VALOR.STRING || expresion.tipo === TIPO_VALOR.IDENTIFICADOR ||
        expresion.tipo === TIPO_VALOR.BOOLEAN || expresion.tipo === TIPO_VALOR.CHAR){
            return Valores(expresion, entorno, errores)
    }
    else if(expresion.tipo === TIPO_VALOR.VECTORU){
        return ValoresV(expresion, entorno, errores, simbolo)
    }
                                //? Operaciones Aritmeticas

    else if(expresion.tipo === TIPO_OPERACION.SUMA){
        return suma(expresion.izquierda, expresion.derecha, entorno, errores,simbolo)
    }else if(expresion.tipo === TIPO_OPERACION.RESTA){
        return resta(expresion.izquierda, expresion.derecha, entorno, errores,simbolo)
    }else if(expresion.tipo === TIPO_OPERACION.MULTIPLICACION){
        return multiplicacion(expresion.izquierda, expresion.derecha, entorno, errores,simbolo)
    }else if(expresion.tipo === TIPO_OPERACION.DIVISION){
        return division(expresion.izquierda, expresion.derecha, entorno, errores, simbolo)
    }else if(expresion.tipo === TIPO_OPERACION.POTENCIA){
        return potencia(expresion.izquierda, expresion.derecha, entorno, errores, simbolo)
    }else if(expresion.tipo === TIPO_OPERACION.MODULO){
        return modulo(expresion.izquierda, expresion.derecha, entorno, errores, simbolo)
    }else if(expresion.tipo === TIPO_OPERACION.UNARIO){
        return unario(expresion.izquierda, expresion.derecha, entorno, errores, simbolo)
    }
                                //? Operaciones Relacionales

    else if(expresion.tipo === TIPO_OPERACION.IGUAL){
        return igual(expresion.izquierda, expresion.derecha, entorno, errores, simbolo)
    }else if(expresion.tipo === TIPO_OPERACION.DESIGUAL){
        return desigual(expresion.izquierda, expresion.derecha, entorno, errores, simbolo)
    }else if(expresion.tipo === TIPO_OPERACION.MENORIGUAL){
        return menorigual(expresion.izquierda, expresion.derecha, entorno, errores, simbolo)
    }else if(expresion.tipo === TIPO_OPERACION.MAYORIGUAL){
        return mayorigual(expresion.izquierda, expresion.derecha, entorno, errores, simbolo)
    }else if(expresion.tipo === TIPO_OPERACION.MAYOR){
        return mayor(expresion.izquierda, expresion.derecha, entorno, errores, simbolo)
    }else if(expresion.tipo === TIPO_OPERACION.MENOR){
        return menor(expresion.izquierda, expresion.derecha, entorno, errores, simbolo)
    }else if(expresion.tipo === TIPO_OPERACION.TERNARIO){
        return ternario(expresion.condicion, expresion.izquierda, expresion.derecha, entorno, errores, simbolo)
    }
                                    //? Operaciones Logicas

    else if(expresion.tipo === TIPO_OPERACION.AND){
        return and(expresion.izquierda, expresion.derecha, entorno, errores, simbolo)
    }else if(expresion.tipo === TIPO_OPERACION.OR){
        return or(expresion.izquierda, expresion.derecha, entorno, errores, simbolo)
    }else if(expresion.tipo === TIPO_OPERACION.NOT){
        return not(expresion.izquierda, null, entorno, errores, simbolo)
    }
                                        //? Otros
    else if(expresion.tipo === TIPO_OPERACION.CASTEO){
        return casteo(expresion.casteo, expresion.valor, entorno, errores, simbolo)
    }else if(expresion.tipo === TIPO_OPERACION.INCREMENTO){
        return incremento(expresion.izquierda, expresion.derecha, entorno, errores, simbolo)
    }else if(expresion.tipo === TIPO_OPERACION.DECREMENTO){
        return decremento(expresion.izquierda, expresion.derecha, entorno, errores, simbolo)
    }
    //LLamadas a metodos
    else if (expresion.tipo === TIPO_INSTRUCCION.LLAMADAA){
        return llamada(expresion, entorno, errores, simbolo)
    }
    else if (expresion.tipo === TIPO_INSTRUCCION.UPPER){
        return upper(expresion, entorno, errores, simbolo)
    }
    else if (expresion.tipo === TIPO_INSTRUCCION.LOWER){
        return lower(expresion, entorno, errores, simbolo)
    }
    else if (expresion.tipo === TIPO_INSTRUCCION.ROUND){
        return round(expresion, entorno, errores, simbolo)
    }
    else if (expresion.tipo === TIPO_INSTRUCCION.LENGTH){
        return length(expresion, entorno, errores, simbolo)
    }
    else if (expresion.tipo === TIPO_INSTRUCCION.TYPEOF){
        return type(expresion, entorno, errores, simbolo)
    }
    else if (expresion.tipo === TIPO_INSTRUCCION.TOSTRING){
        return tostring(expresion, entorno, errores, simbolo)
    }
    else if (expresion.tipo === TIPO_INSTRUCCION.TOCHAR){
        return tochar(expresion, entorno, errores, simbolo)
    }
    

}

                                    //! Operaciones

function Valores(expresion, entorno, errores){
    if(expresion.tipo === TIPO_VALOR.INT){
        return {
            valor: Number(expresion.valor),
            tipo: TIPO_DATO.INT,
            linea: expresion.linea,
            columna: expresion.columna
        }
    }
    else if(expresion.tipo === TIPO_VALOR.DOUBLE){
        return {
            valor: Number(expresion.valor),
            tipo: TIPO_DATO.DOUBLE,
            linea: expresion.linea,
            columna: expresion.columna
        }
    }
    else if(expresion.tipo === TIPO_VALOR.BOOLEAN){
        return {
            valor: expresion.valor.toLowerCase() ==='false' ? false: true,
            tipo: TIPO_DATO.BOOLEAN,
            linea: expresion.linea,
            columna: expresion.columna
        }
    }
    else if(expresion.tipo === TIPO_VALOR.STRING){
        return {
            valor: expresion.valor.substring(0, expresion.valor.length),
            tipo: TIPO_DATO.STRING,
            linea: expresion.linea,
            columna: expresion.columna
        }
    }
    else if(expresion.tipo === TIPO_VALOR.CHAR){
        return {
            valor: expresion.valor.charAt(1),
            tipo: TIPO_DATO.CHAR,
            linea: expresion.linea,
            columna: expresion.columna
        }
    }
    else if(expresion.tipo === TIPO_VALOR.IDENTIFICADOR){
        let temp = entorno.getSimbolo(expresion.valor)
        if(temp!=null){
            return {
                valor: temp.valor,
                tipo: temp.tipo,
                linea: temp.linea,
                columna: temp.columna
            }
        }
        errores.add("Semántico", "Variable Inexistente: " + expresion.valor , expresion.linea, expresion.columna);
        return {
            valor: null,
            tipo: "ERROR",
            linea: expresion.linea,
            columna: expresion.columna
        }
    }
}

function ValoresV(expresion, entorno, errores, simbolo){
    let id = expresion.id
    let posicion1 = expresion.posicion1 
    let posicion2 = expresion.posicion2
    if(posicion2 == null){

                        //? Vectores Unidimensionales

        let tamaño1 = Operaciones(posicion1, entorno, errores, simbolo)
        if(tamaño1.hasOwnProperty('resultado')){
            tamaño1 = tamaño1.resultado
        }
        if(tamaño1.tipo === TIPO_DATO.INT){
            let temp = entorno.getSimbolo(id)
            if(temp!=null){
                if(Array.isArray(temp.valor)){
                    let salida = temp.valor[tamaño1.valor]
                    if(salida != undefined){
                        return {
                            valor: salida,
                            tipo: temp.tipo,
                            linea: temp.linea,
                            columna: temp.columna
                        }
                    }
                    errores.add("Semántico", "La posición no existe en el arreglo (U)." , expresion.linea, expresion.columna);
                    return {
                        valor: null,
                        tipo: "ERROR",
                        linea: expresion.linea,
                        columna: expresion.columna
                    }
                }
                errores.add("Semántico", "La variable no es un arreglo." , expresion.linea, expresion.columna);
                return {
                    valor: null,
                    tipo: "ERROR",
                    linea: expresion.linea,
                    columna: expresion.columna
                }
            }
            errores.add("Semántico", "Variable Inexistente: " + expresion.valor , expresion.linea, expresion.columna);
            return {
                valor: null,
                tipo: "ERROR",
                linea: expresion.linea,
                columna: expresion.columna
            }
        }
        errores.add("Semántico", `La posicion ingresada ingresado de ser de tipo INT, no ${tamaño1.tipo}.` , instruccion.linea, instruccion.columna);
        return {
            valor: null,
            tipo: "ERROR",
            linea: expresion.linea,
            columna: expresion.columna
        }
    }else{
                        //! Vectores Bidimensionales

        let tamaño1 = Operaciones(posicion1, entorno, errores, simbolo)
        let tamaño2 = Operaciones(posicion2, entorno, errores, simbolo)
        if(tamaño1.hasOwnProperty('resultado')){
            tamaño1 = tamaño1.resultado
        }
        if(derecha.hasOwnProperty('resultado')){
            tamaño2 = tamaño2.resultado
        }
        if(tamaño1.tipo === TIPO_DATO.INT && tamaño2.tipo === TIPO_DATO.INT){
            let temp = entorno.getSimbolo(id)
            if(temp!=null){
                if(Array.isArray(temp.valor)){
                    let salida = temp.valor[tamaño1.valor][tamaño2.valor]
                    if(salida != undefined){
                        return {
                            valor: salida,
                            tipo: temp.tipo,
                            linea: temp.linea,
                            columna: temp.columna
                        }
                    }
                    errores.add("Semántico", "La posición no existe en el arreglo(B)." , expresion.linea, expresion.columna);
                    return {
                        valor: null,
                        tipo: "ERROR",
                        linea: expresion.linea,
                        columna: expresion.columna
                    }
                }
                errores.add("Semántico", "La variable no es un arreglo." , expresion.linea, expresion.columna);
                return {
                    valor: null,
                    tipo: "ERROR",
                    linea: expresion.linea,
                    columna: expresion.columna
                }
            }
            errores.add("Semántico", "Variable Inexistente: " + expresion.valor , expresion.linea, expresion.columna);
            return {
                valor: null,
                tipo: "ERROR",
                linea: expresion.linea,
                columna: expresion.columna
            }
        }
        errores.add("Semántico", `Las posiciones ingresadas deben ser de tipo INT.` , instruccion.linea, instruccion.columna);
        return {
            valor: null,
            tipo: "ERROR",
            linea: expresion.linea,
            columna: expresion.columna
        }
    }

}


function llamada(expresion, entorno, errores, simbolo){
    let Run = require("../Instruction/Run");
    var consola = Run(expresion, entorno, errores, simbolo)
    if(typeof(consola) == 'object'){
        if(consola.hasOwnProperty('resultado')){
            consola = consola.resultado
        }
        return consola
    }else{
        errores.add("Semántico", "No se obtuvo un resultado como retorno." + expresion.valor , expresion.linea, expresion.columna);
        return {
            valor: null,
            tipo: "ERROR",
            linea: expresion.linea,
            columna: expresion.columna
        }
    }
}

                                    //* Operaciones

function suma(_izquierda, _derecha, entorno, errores, simbolo){
    let izquierda = Operaciones(_izquierda, entorno, errores, simbolo)
    let derecha = Operaciones(_derecha, entorno, errores, simbolo)
    if(izquierda.hasOwnProperty('resultado')){
        izquierda = izquierda.resultado
    }
    if(derecha.hasOwnProperty('resultado')){
        derecha = derecha.resultado
    }
    let tipoSalida = Tipos(izquierda.tipo, derecha.tipo, TIPO_OPERACION.SUMA)
    if(tipoSalida!=null){
        if(tipoSalida === TIPO_DATO.INT){
            let op1 = izquierda;
            let op2 = derecha;
            if(op1.tipo === TIPO_DATO.CHAR){
                op1.valor = op1.valor.charCodeAt(0); 
            }else if(op2.tipo === TIPO_DATO.CHAR){
                op2.valor = op2.valor.charCodeAt(0);
            }
            let resultado = op1.valor + op2.valor;
            return {
                valor: resultado,
                tipo: tipoSalida,
                linea: _izquierda.linea,
                columna: _izquierda.columna
            }
        }else if(tipoSalida === TIPO_DATO.DOUBLE){
            let op1 = izquierda;
            let op2 = derecha;
            if(op1.tipo === TIPO_DATO.CHAR){
                op1.valor = op1.valor.charCodeAt(0); 
            }else if(op2.tipo === TIPO_DATO.CHAR){
                op2.valor = op2.valor.charCodeAt(0);
            }
            let resultado = op1.valor + op2.valor;
            return {
                valor: resultado,
                tipo: tipoSalida,
                linea: _izquierda.linea,
                columna: _izquierda.columna
            }
        }else if(tipoSalida === TIPO_DATO.STRING){
            let op1 = izquierda;
            let op2 = derecha;
            let resultado = op1.valor + op2.valor;
            return {
                valor: resultado,
                tipo: tipoSalida,
                linea: _izquierda.linea,
                columna: _izquierda.columna
            }
        }
    }
    errores.add("Semántico", "No se pudo realizar la suma. Tipos Invalidos."  , _izquierda.linea, _izquierda.columna);
    return {
        valor: null,
        tipo: "ERROR",
        linea: null,
        columna: null
    }
}



function resta(_izquierda, _derecha, entorno, errores, simbolo){
    let izquierda = Operaciones(_izquierda, entorno, errores, simbolo)
    let derecha = Operaciones(_derecha, entorno, errores, simbolo)
    if(izquierda.hasOwnProperty('resultado')){
        izquierda = izquierda.resultado
    }
    if(derecha.hasOwnProperty('resultado')){
        derecha = derecha.resultado
    }
    let tipoSalida = Tipos(izquierda.tipo, derecha.tipo, TIPO_OPERACION.RESTA)
    if(tipoSalida!=null){
        if(tipoSalida === TIPO_DATO.INT){
            let op1 = izquierda;
            let op2 = derecha;
            if(op1.tipo === TIPO_DATO.CHAR){
                op1.valor = op1.valor.charCodeAt(0); 
            }else if(op2.tipo === TIPO_DATO.CHAR){
                op2.valor = op2.valor.charCodeAt(0);
            }
            let resultado = op1.valor - op2.valor;
            return {
                valor: resultado,
                tipo: tipoSalida,
                linea: _izquierda.linea,
                columna: _izquierda.columna 
            }
        }else if(tipoSalida === TIPO_DATO.DOUBLE){
            let op1 = izquierda;
            let op2 = derecha;
            if(op1.tipo === TIPO_DATO.CHAR){
                op1.valor = op1.valor.charCodeAt(0); 
            }else if(op2.tipo === TIPO_DATO.CHAR){
                op2.valor = op2.valor.charCodeAt(0);
            }
            let resultado = op1.valor - op2.valor;
            return {
                valor: resultado,
                tipo: tipoSalida,
                linea: _izquierda.linea,
                columna: _izquierda.columna
            }
        }
    }
    errores.add("Semántico", "No se pudo realizar la resta. Tipos Invalidos."  , _izquierda.linea, _izquierda.columna);
    return {
        valor: null,
        tipo: "ERROR",
        linea: null,
        columna: null
    }
}


function multiplicacion(_izquierda, _derecha, entorno, errores, simbolo){
    let izquierda = Operaciones(_izquierda, entorno, errores, simbolo)
    let derecha = Operaciones(_derecha, entorno, errores, simbolo)
    if(izquierda.hasOwnProperty('resultado')){
        izquierda = izquierda.resultado
    }
    if(derecha.hasOwnProperty('resultado')){
        derecha = derecha.resultado
    }
    if(izquierda.hasOwnProperty('resultado')){
        izquierda = izquierda.resultado
    }
    if(derecha.hasOwnProperty('resultado')){
        derecha = derecha.resultado
    }
    let tipoSalida = Tipos(izquierda.tipo, derecha.tipo, TIPO_OPERACION.MULTIPLICACION)
    if(tipoSalida!=null){
        if(tipoSalida === TIPO_DATO.INT){
            let op1 = izquierda;
            let op2 = derecha;
            if(op1.tipo === TIPO_DATO.CHAR){
                op1.valor = op1.valor.charCodeAt(0); 
            }else if(op2.tipo === TIPO_DATO.CHAR){
                op2.valor = op2.valor.charCodeAt(0);
            }
            let resultado = op1.valor * op2.valor;
            return {
                valor: resultado,
                tipo: tipoSalida,
                linea: _izquierda.linea,
                columna: _izquierda.columna
            }
        }else if(tipoSalida === TIPO_DATO.DOUBLE){
            let op1 = izquierda;
            let op2 = derecha;
            if(op1.tipo === TIPO_DATO.CHAR){
                op1.valor = op1.valor.charCodeAt(0); 
            }else if(op2.tipo === TIPO_DATO.CHAR){
                op2.valor = op2.valor.charCodeAt(0);
            }
            let resultado = op1.valor * op2.valor;
            return {
                valor: resultado,
                tipo: tipoSalida,
                linea: _izquierda.linea,
                columna: _izquierda.columna
            }
        }
    }
    errores.add("Semántico", "No se pudo realizar la multiplicación. Tipos Invalidos."  , _izquierda.linea, _izquierda.columna);
    return {
        valor: null,
        tipo: "ERROR",
        linea: null,
        columna: null
    }
}


function division(_izquierda, _derecha, entorno, errores, simbolo){
    let izquierda = Operaciones(_izquierda, entorno, errores, simbolo)
    let derecha = Operaciones(_derecha, entorno, errores, simbolo)
    if(izquierda.hasOwnProperty('resultado')){
        izquierda = izquierda.resultado
    }
    if(derecha.hasOwnProperty('resultado')){
        derecha = derecha.resultado
    }
    let tipoSalida = Tipos(izquierda.tipo, derecha.tipo, TIPO_OPERACION.DIVISION)
    if(tipoSalida!=null){
        if(tipoSalida === TIPO_DATO.DOUBLE){
            let op1 = izquierda;
            let op2 = derecha;
            if(op1.tipo === TIPO_DATO.CHAR){
                op1.valor = op1.valor.charCodeAt(0); 
            }else if(op2.tipo === TIPO_DATO.CHAR){
                op2.valor = op2.valor.charCodeAt(0);
            }
            if(op2.valor === 0){
                errores.add("Semántico", "No se pudo realizar la división. División entre 0."  , _izquierda.linea, _izquierda.columna);
                return {
                    valor: null,
                    tipo: "ERROR",
                    linea: null,
                    columna: null
                }
            }else{
                let resultado = op1.valor / op2.valor;
                return {
                    valor: resultado,
                    tipo: tipoSalida,
                    linea: _izquierda.linea,
                    columna: _izquierda.columna
                }
            }
        }
    }
    errores.add("Semántico", "No se pudo realizar la división. Tipos Invalidos."  , _izquierda.linea, _izquierda.columna);
    return {
        valor: null,
        tipo: "ERROR",
        linea: null,
        columna: null
    }
}


function potencia(_izquierda, _derecha, entorno, errores, simbolo){
    let izquierda = Operaciones(_izquierda, entorno, errores, simbolo)
    let derecha = Operaciones(_derecha, entorno, errores, simbolo)
    if(izquierda.hasOwnProperty('resultado')){
        izquierda = izquierda.resultado
    }
    if(derecha.hasOwnProperty('resultado')){
        derecha = derecha.resultado
    }
    let tipoSalida = Tipos(izquierda.tipo, derecha.tipo, TIPO_OPERACION.POTENCIA)
    if(tipoSalida!=null){
        if(tipoSalida === TIPO_DATO.INT){
            let op1 = izquierda;
            let op2 = derecha;
            let resultado = Math.pow(op1.valor, op2.valor);
            return {
                valor: resultado,
                tipo: tipoSalida,
                linea: _izquierda.linea,
                columna: _izquierda.columna
            }
        }else if(tipoSalida === TIPO_DATO.DOUBLE){
            let op1 = izquierda;
            let op2 = derecha;
            let resultado = Math.pow(op1.valor, op2.valor);
            return {
                valor: resultado,
                tipo: tipoSalida,
                linea: _izquierda.linea,
                columna: _izquierda.columna
            }
        }
    }
    errores.add("Semántico", "No se pudo realizar la potencia. Tipos Invalidos."  , _izquierda.linea, _izquierda.columna);
    return {
        valor: null,
        tipo: "ERROR",
        linea: null,
        columna: null
    }
}

function modulo(_izquierda, _derecha, entorno, errores, simbolo){
    let izquierda = Operaciones(_izquierda, entorno, errores, simbolo)
    let derecha = Operaciones(_derecha, entorno, errores, simbolo)
    if(izquierda.hasOwnProperty('resultado')){
        izquierda = izquierda.resultado
    }
    if(derecha.hasOwnProperty('resultado')){
        derecha = derecha.resultado
    }
    let tipoSalida = Tipos(izquierda.tipo, derecha.tipo, TIPO_OPERACION.MODULO)
    if(tipoSalida!=null){
        if(tipoSalida === TIPO_DATO.DOUBLE){
            let op1 = izquierda;
            let op2 = derecha;
            if(op2.valor === 0){
                errores.add("Semántico", "No se pudo realizar el modulo. División entre 0."  , _izquierda.linea, _izquierda.columna);
                return {
                    valor: null,
                    tipo: "ERROR",
                    linea: expresion.linea,
                    columna: expresion.columna
                }
            }else{
                let resultado = op1.valor % op2.valor;
                return {
                    valor: resultado,
                    tipo: tipoSalida,
                    linea: _izquierda.linea,
                    columna: _izquierda.columna
                }
            }
        }
    }
    errores.add("Semántico", "No se pudo realizar el modulo. Tipos Invalidos."  , _izquierda.linea, _izquierda.columna);
    return {
        valor: null,
        tipo: "ERROR",
        linea: null,
        columna: null
    }
}

function unario(_izquierda, _derecha, entorno, errores, simbolo){
    let izquierda = Operaciones(_izquierda, entorno, errores, simbolo)
    let tipoSalida = Tipos(izquierda.tipo, null, TIPO_OPERACION.UNARIO)
    if(izquierda.hasOwnProperty('resultado')){
        izquierda = izquierda.resultado
    }
    if(tipoSalida!=null){
        if(tipoSalida === TIPO_DATO.DOUBLE || tipoSalida === TIPO_DATO.INT){
            let op1 = izquierda;
            let resultado = op1.valor * -1;
            return {
                valor: resultado,
                tipo: tipoSalida,
                linea: _izquierda.linea,
                columna: _izquierda.columna
            }
        }
    }
    errores.add("Semántico", "No se pudo realizar la operación unaria. Tipos Invalidos."  , _izquierda.linea, _izquierda.columna);
    return {
        valor: null,
        tipo: "ERROR",
        linea: null,
        columna: null
    }
}

//Operaciones
function igual(_izquierda, _derecha, entorno, errores, simbolo){
    let izquierda = Operaciones(_izquierda, entorno, errores, simbolo)
    let derecha = Operaciones(_derecha, entorno, errores, simbolo)
    if(izquierda.hasOwnProperty('resultado')){
        izquierda = izquierda.resultado
    }
    if(derecha.hasOwnProperty('resultado')){
        derecha = derecha.resultado
    }
    let tipoSalida = Tipos(izquierda.tipo, derecha.tipo, TIPO_OPERACION.IGUAL)
    if(tipoSalida!=null){
        let op1 = izquierda;
        let op2 = derecha;
        if(op1.tipo === TIPO_DATO.CHAR){
            op1.valor = op1.valor.charCodeAt(0); 
        }else if(op2.tipo === TIPO_DATO.CHAR){
            op2.valor = op2.valor.charCodeAt(0);
        }
        let resultado = false;
        if(op1.valor == op2.valor){
            resultado = true;
        }
        return {
            valor: resultado,
            tipo: tipoSalida,
            linea: _izquierda.linea,
            columna: _izquierda.columna
        }
    }
    errores.add("Semántico", "No se pudo realizar si son iguales. Tipos Invalidos."  , _izquierda.linea, _izquierda.columna);
    return {
        valor: null,
        tipo: "ERROR",
        linea: null,
        columna: null
    }
}

function desigual(_izquierda, _derecha, entorno, errores, simbolo){
    let izquierda = Operaciones(_izquierda, entorno, errores, simbolo)
    let derecha = Operaciones(_derecha, entorno, errores, simbolo)
    if(izquierda.hasOwnProperty('resultado')){
        izquierda = izquierda.resultado
    }
    if(derecha.hasOwnProperty('resultado')){
        derecha = derecha.resultado
    }
    let tipoSalida = Tipos(izquierda.tipo, derecha.tipo, TIPO_OPERACION.DESIGUAL)
    if(tipoSalida!=null){
        let op1 = izquierda;
        let op2 = derecha;
        if(op1.tipo === TIPO_DATO.CHAR){
            op1.valor = op1.valor.charCodeAt(0); 
        }else if(op2.tipo === TIPO_DATO.CHAR){
            op2.valor = op2.valor.charCodeAt(0);
        }
        let resultado = true;
        if(op1.valor == op2.valor){
            resultado = false;
        }
        return {
            valor: resultado,
            tipo: tipoSalida,
            linea: _izquierda.linea,
            columna: _izquierda.columna
        }
    }
    errores.add("Semántico", "No se pudo realizar no son iguales. Tipos Invalidos."  , _izquierda.linea, _izquierda.columna);
    return {
        valor: null,
        tipo: "ERROR",
        linea: null,
        columna: null
    }
}

function mayorigual(_izquierda, _derecha, entorno, errores, simbolo){
    let izquierda = Operaciones(_izquierda, entorno, errores, simbolo)
    let derecha = Operaciones(_derecha, entorno, errores, simbolo)
    if(izquierda.hasOwnProperty('resultado')){
        izquierda = izquierda.resultado
    }
    if(derecha.hasOwnProperty('resultado')){
        derecha = derecha.resultado
    }
    let tipoSalida = Tipos(izquierda.tipo, derecha.tipo, TIPO_OPERACION.MAYORIGUAL)
    if(tipoSalida!=null){
        let op1 = izquierda;
        let op2 = derecha;
        if(op1.tipo === TIPO_DATO.CHAR){
            op1.valor = op1.valor.charCodeAt(0); 
        }else if(op2.tipo === TIPO_DATO.CHAR){
            op2.valor = op2.valor.charCodeAt(0);
        }
        let resultado = false;
        if(op1.valor >= op2.valor){
            resultado = true;
        }
        return {
            valor: resultado,
            tipo: tipoSalida,
            linea: _izquierda.linea,
            columna: _izquierda.columna
        }
    }
    errores.add("Semántico", "No se pudo realizar si es mayor o igual. Tipos Invalidos."  , _izquierda.linea, _izquierda.columna);
    return {
        valor: null,
        tipo: "ERROR",
        linea: null,
        columna: null
    }
}

function menorigual(_izquierda, _derecha, entorno, errores, simbolo){
    let izquierda = Operaciones(_izquierda, entorno, errores, simbolo)
    let derecha = Operaciones(_derecha, entorno, errores, simbolo)
    if(izquierda.hasOwnProperty('resultado')){
        izquierda = izquierda.resultado
    }
    if(derecha.hasOwnProperty('resultado')){
        derecha = derecha.resultado
    }
    let tipoSalida = Tipos(izquierda.tipo, derecha.tipo, TIPO_OPERACION.MENORIGUAL)
    if(tipoSalida!=null){
        let op1 = izquierda;
        let op2 = derecha;
        if(op1.tipo === TIPO_DATO.CHAR){
            op1.valor = op1.valor.charCodeAt(0); 
        }else if(op2.tipo === TIPO_DATO.CHAR){
            op2.valor = op2.valor.charCodeAt(0);
        }
        let resultado = false;
        if(op1.valor <= op2.valor){
            resultado = true;
        }
        return {
            valor: resultado,
            tipo: tipoSalida,
            linea: _izquierda.linea,
            columna: _izquierda.columna
        }
    }
    errores.add("Semántico", "No se pudo realizar si es menor o igual. Tipos Invalidos."  , _izquierda.linea, _izquierda.columna);
    return {
        valor: null,
        tipo: "ERROR",
        linea: null,
        columna: null
    }
}

function mayor(_izquierda, _derecha, entorno, errores, simbolo){
    let izquierda = Operaciones(_izquierda, entorno, errores, simbolo)
    let derecha = Operaciones(_derecha, entorno, errores, simbolo)
    if(izquierda.hasOwnProperty('resultado')){
        izquierda = izquierda.resultado
    }
    if(derecha.hasOwnProperty('resultado')){
        derecha = derecha.resultado
    }
    let tipoSalida = Tipos(izquierda.tipo, derecha.tipo, TIPO_OPERACION.MAYOR)
    if(tipoSalida!=null){
        let op1 = izquierda;
        let op2 = derecha;
        if(op1.tipo === TIPO_DATO.CHAR){
            op1.valor = op1.valor.charCodeAt(0); 
        }else if(op2.tipo === TIPO_DATO.CHAR){
            op2.valor = op2.valor.charCodeAt(0);
        }
        let resultado = false;
        if(op1.valor > op2.valor){
            resultado = true;
        }
        return {
            valor: resultado,
            tipo: tipoSalida,
            linea: _izquierda.linea,
            columna: _izquierda.columna
        }
    }
    errores.add("Semántico", "No se pudo realizar si es mayor. Tipos Invalidos."  , _izquierda.linea, _izquierda.columna);
    return {
        valor: null,
        tipo: "ERROR",
        linea: null,
        columna: null
    }
}

function menor(_izquierda, _derecha, entorno, errores, simbolo){
    let izquierda = Operaciones(_izquierda, entorno, errores, simbolo)
    let derecha = Operaciones(_derecha, entorno, errores, simbolo)
    if(izquierda.hasOwnProperty('resultado')){
        izquierda = izquierda.resultado
    }
    if(derecha.hasOwnProperty('resultado')){
        derecha = derecha.resultado
    }
    let tipoSalida = Tipos(izquierda.tipo, derecha.tipo, TIPO_OPERACION.MENOR)
    if(tipoSalida!=null){
        let op1 = izquierda;
        let op2 = derecha;
        if(op1.tipo === TIPO_DATO.CHAR){
            op1.valor = op1.valor.charCodeAt(0); 
        }else if(op2.tipo === TIPO_DATO.CHAR){
            op2.valor = op2.valor.charCodeAt(0);
        }
        let resultado = false;
        if(op1.valor < op2.valor){
            resultado = true;
        }
        return {
            valor: resultado,
            tipo: tipoSalida,
            linea: _izquierda.linea,
            columna: _izquierda.columna
        }
    }
    errores.add("Semántico", "No se pudo realizar si es menor. Tipos Invalidos."  , _izquierda.linea, _izquierda.columna);
    return {
        valor: null,
        tipo: "ERROR",
        linea: null,
        columna: null
    }
}

function ternario(_condicion, _izquierda, _derecha, entorno, errores, simbolo){
    let condicion = Operaciones(_condicion, entorno, errores, simbolo)
    let izquierda = Operaciones(_izquierda, entorno, errores, simbolo)
    let derecha = Operaciones(_derecha, entorno, errores, simbolo)
    if(izquierda.hasOwnProperty('resultado')){
        izquierda = izquierda.resultado
    }
    if(derecha.hasOwnProperty('resultado')){
        derecha = derecha.resultado
    }
    if(condicion.hasOwnProperty('resultado')){
        condicion = condicion.resultado
    }
    if(condicion.tipo === TIPO_DATO.BOOLEAN){
        if(condicion.valor){
            return {
                valor: izquierda.valor,
                tipo: izquierda.tipo,
                linea: _izquierda.linea,
                columna: _izquierda.columna
            }
        }else{
            return {
                valor: derecha.valor,
                tipo: derecha.tipo,
                linea: derecha.linea,
                columna: derecha.columna
            }
        }
    }
    errores.add("Semántico", "La condición ingresada debe retornar un booleano."  , _izquierda.linea, _izquierda.columna);
    return {
        valor: null,
        tipo: "ERROR",
        linea: null,
        columna: null
    }
}

function and(_izquierda, _derecha, entorno, errores, simbolo){
    let izquierda = Operaciones(_izquierda, entorno, errores, simbolo)
    let derecha = Operaciones(_derecha, entorno, errores, simbolo)
    if(izquierda.hasOwnProperty('resultado')){
        izquierda = izquierda.resultado
    }
    if(derecha.hasOwnProperty('resultado')){
        derecha = derecha.resultado
    }
    let tipoSalida = Tipos(izquierda.tipo, derecha.tipo, TIPO_OPERACION.AND)
    if(tipoSalida!=null){
        let op1 = izquierda;
        let op2 = derecha;

        let resultado = false;
        if(op1.valor && op2.valor){
            resultado = true;
        }
        return {
            valor: resultado,
            tipo: tipoSalida,
            linea: _izquierda.linea,
            columna: _izquierda.columna
        }
    }
    errores.add("Semántico", "No se pudo validar la operación and. Tipos Invalidos."  , _izquierda.linea, _izquierda.columna);
    return {
        valor: null,
        tipo: "ERROR",
        linea: null,
        columna: null
    }
}

function or(_izquierda, _derecha, entorno, errores, simbolo){
    let izquierda = Operaciones(_izquierda, entorno, errores, simbolo)
    let derecha = Operaciones(_derecha, entorno, errores, simbolo)
    if(izquierda.hasOwnProperty('resultado')){
        izquierda = izquierda.resultado
    }
    if(derecha.hasOwnProperty('resultado')){
        derecha = derecha.resultado
    }
    let tipoSalida = Tipos(izquierda.tipo, derecha.tipo, TIPO_OPERACION.OR)
    if(tipoSalida!=null){
        let op1 = izquierda;
        let op2 = derecha;

        let resultado = false;
        if(op1.valor || op2.valor){
            resultado = true;
        }
        return {
            valor: resultado,
            tipo: tipoSalida,
            linea: _izquierda.linea,
            columna: _izquierda.columna
        }
    }
    errores.add("Semántico", "No se pudo validar la operación or. Tipos Invalidos."  , _izquierda.linea, _izquierda.columna);
    return {
        valor: null,
        tipo: "ERROR",
        linea: null,
        columna: null
    }
}

function not(_izquierda, _derecha, entorno, errores, simbolo){
    let izquierda = Operaciones(_izquierda, entorno, errores, simbolo)
    if(izquierda.hasOwnProperty('resultado')){
        izquierda = izquierda.resultado
    }
    let tipoSalida = Tipos(izquierda.tipo, null, TIPO_OPERACION.NOT)
    if(tipoSalida!=null){
        let op1 = izquierda;

        let resultado = !op1.valor;
        
        return {
            valor: resultado,
            tipo: tipoSalida,
            linea: _izquierda.linea,
            columna: _izquierda.columna
        }
    }
    errores.add("Semántico", "No se pudo validar la operación not. Tipos Invalidos."  , _izquierda.linea, _izquierda.columna);
    return {
        valor: null,
        tipo: "ERROR",
        linea: null,
        columna: null
    }
}

                                    //! Otros
                                    
function casteo(_casteo, _expresion, entorno, errores, simbolo){
    let valor = Operaciones(_expresion, entorno, errores, simbolo)
    if(valor.hasOwnProperty('resultado')){
        valor = valor.resultado
    }
    let nuevo = _casteo
    let tipoSalida = Tipos(valor.tipo, nuevo, TIPO_OPERACION.CASTEO)
    if(tipoSalida!=null){
        if(tipoSalida === TIPO_DATO.INT){
            let salida = valor;
            if(valor.tipo === TIPO_DATO.CHAR){
                salida.valor = salida.valor.charCodeAt(0)
            }else if(valor.tipo === TIPO_DATO.DOUBLE){
                salida.valor = Math.trunc(salida.valor)
            }
            return {
                valor: salida.valor,
                tipo: tipoSalida,
                linea: valor.linea,
                columna: valor.columna
            }
        }else if(tipoSalida === TIPO_DATO.DOUBLE){
            let salida = valor;
            if(valor.tipo === TIPO_DATO.CHAR){
                salida.valor = salida.valor.charCodeAt(0)
                salida.valor = salida.valor + 0.0
            }else if(valor.tipo === TIPO_DATO.INT){
                salida.valor = salida.valor + 0.0
            }
            return {
                valor: salida.valor,
                tipo: tipoSalida,
                linea: valor.linea,
                columna: valor.columna
            }
        }else if(tipoSalida === TIPO_DATO.CHAR){
            let salida = valor;
            if(valor.tipo === TIPO_DATO.INT){
                salida.valor = String.fromCharCode(salida.valor)
            }
            return {
                valor: salida.valor,
                tipo: tipoSalida,
                linea: valor.linea,
                columna: valor.columna
            }
        }
    }
    errores.add("Semántico", `Casteo Invalido. ${valor.tipo} no puede ser casteado a ${nuevo}.`  , valor.linea, valor.columna);
    return {
        valor: null,
        tipo: "ERROR",
        linea: null,
        columna: null
    }
}

function incremento(_izquierda, _derecha, entorno, errores, simbolo){
    let izquierda = Operaciones(_izquierda, entorno, errores, simbolo)
    if(izquierda.hasOwnProperty('resultado')){
        izquierda = izquierda.resultado
    }
    let tipoSalida = Tipos(izquierda.tipo, null, TIPO_OPERACION.INCREMENTO)
    if(tipoSalida!=null){
        if(tipoSalida === TIPO_DATO.DOUBLE || tipoSalida === TIPO_DATO.INT){
            let op1 = izquierda;
            let resultado = op1.valor + 1;
            return {
                valor: resultado,
                tipo: tipoSalida,
                linea: _izquierda.linea,
                columna: _izquierda.columna
            }
        }
    }
    errores.add("Semántico", "No se pudo realizar el incremento. Tipos Invalidos."  , _izquierda.linea, _izquierda.columna);
    return {
        valor: null,
        tipo: "ERROR",
        linea: null,
        columna: null
    }
}

function decremento(_izquierda, _derecha, entorno, errores, simbolo){
    let izquierda = Operaciones(_izquierda, entorno, errores, simbolo)
    if(izquierda.hasOwnProperty('resultado')){
        izquierda = izquierda.resultado
    }
    let tipoSalida = Tipos(izquierda.tipo, null, TIPO_OPERACION.DECREMENTO)
    if(tipoSalida!=null){
        if(tipoSalida === TIPO_DATO.DOUBLE || tipoSalida === TIPO_DATO.INT){
            let op1 = izquierda;
            let resultado = op1.valor - 1;
            return {
                valor: resultado,
                tipo: tipoSalida,
                linea: _izquierda.linea,
                columna: _izquierda.columna
            }
        }
    }
    errores.add("Semántico", "No se pudo realizar el decremento. Tipos Invalidos."  , _izquierda.linea, _izquierda.columna);
    return {
        valor: null,
        tipo: "ERROR",
        linea: null,
        columna: null
    }
}

function upper(expresion, entorno, errores, simbolo){
    let valor= Operaciones(expresion.expresion, entorno, errores, simbolo)
    if(valor.hasOwnProperty('resultado')){
        valor = valor.resultado
    }
    if(valor.tipo == TIPO_DATO.STRING){
        let resultado = valor.valor.toUpperCase()
        return {
            valor: resultado,
            tipo: TIPO_DATO.STRING,
            linea: expresion.linea,
            columna: expresion.columna
        }
    }else{
        errores.add("Semántico", "La función toUpper solo recibe valores de String. Tipos Invalidos."  , expresion.linea, expresion.columna);
        return {
            valor: null,
            tipo: "ERROR",
            linea: null,
            columna: null
        }
    }
}

function lower(expresion, entorno, errores, simbolo){
    let valor= Operaciones(expresion.expresion, entorno, errores, simbolo)
    if(valor.hasOwnProperty('resultado')){
        valor = valor.resultado
    }
    if(valor.tipo == TIPO_DATO.STRING){
        let resultado = valor.valor.toLowerCase()
        return {
            valor: resultado,
            tipo: TIPO_DATO.STRING,
            linea: expresion.linea,
            columna: expresion.columna
        }
    }else{
        errores.add("Semántico", "La función toLower solo recibe valores de String. Tipos Invalidos."  , expresion.linea, expresion.columna);
        return {
            valor: null,
            tipo: "ERROR",
            linea: null,
            columna: null
        }
    }

}

function round(expresion, entorno, errores, simbolo){
    let valor= Operaciones(expresion.expresion, entorno, errores, simbolo)
    if(valor.hasOwnProperty('resultado')){
        valor = valor.resultado
    }
    if(valor.tipo == TIPO_DATO.DOUBLE || valor.tipo == TIPO_DATO.INT){
        let resultado = Math.round(valor.valor)
        return {
            valor: resultado,
            tipo: TIPO_DATO.DOUBLE,
            linea: expresion.linea,
            columna: expresion.columna
        }
    }else{
        errores.add("Semántico", "La función Round solo recibe valores númericos. Tipos Invalidos."  , expresion.linea, expresion.columna);
        return {
            valor: null,
            tipo: "ERROR",
            linea: null,
            columna: null
        }
    }

}

function length(expresion, entorno, errores, simbolo){
    let valor = Operaciones(expresion.expresion, entorno, errores, simbolo)
    if(valor.hasOwnProperty('resultado')){
        valor = valor.resultado
    }
    if(valor.tipo == TIPO_DATO.STRING || Array.isArray(valor.valor)){
        let resultado = valor.valor.length
        return {
            valor: resultado,
            tipo: TIPO_DATO.INT,
            linea: expresion.linea,
            columna: expresion.columna
        }
    }else{
        errores.add("Semántico", "La función Round solo recibe Strings o Arreglos. Tipos Invalidos."  , expresion.linea, expresion.columna);
        return {
            valor: null,
            tipo: "ERROR",
            linea: null,
            columna: null
        }
    }

}

function type(expresion, entorno, errores, simbolo){
    let valor = Operaciones(expresion.expresion, entorno, errores, simbolo)
    if(valor.hasOwnProperty('resultado')){
        valor = valor.resultado
    }
    if(Array.isArray(valor.valor)){
        let resultado = "ARRAY"
        return {
            valor: resultado,
            tipo: TIPO_DATO.STRING,
            linea: expresion.linea,
            columna: expresion.columna
        }
    }else{
        let resultado = valor.tipo
        return {
            valor: resultado,
            tipo: TIPO_DATO.STRING,
            linea: expresion.linea,
            columna: expresion.columna
        }
    }

}

function tostring(expresion, entorno, errores, simbolo){
    let valor = Operaciones(expresion.expresion, entorno, errores, simbolo)
    if(valor.hasOwnProperty('resultado')){
        valor = valor.resultado
    }
    if(!Array.isArray(valor.valor)){
        if(valor.tipo == TIPO_DATO.INT || valor.tipo == TIPO_DATO.DOUBLE || valor.tipo == TIPO_DATO.BOOLEAN){
            let resultado = valor.valor.toString()
            return {
                valor: resultado,
                tipo: TIPO_DATO.STRING,
                linea: expresion.linea,
                columna: expresion.columna
            }
        }else{
            errores.add("Semántico", "La función toString solo recibe valores númericos o booleanos. Tipos Invalidos."  , expresion.linea, expresion.columna);
            return {
                valor: null,
                tipo: "ERROR",
                linea: null,
                columna: null
            }    
        }
    }else{
        errores.add("Semántico", "La función toString solo recibe valores númericos o booleanos. Tipos Invalidos."  , expresion.linea, expresion.columna);
        return {
            valor: null,
            tipo: "ERROR",
            linea: null,
            columna: null
        }
    }

}

function tochar(expresion, entorno, errores, simbolo){
    let valor = Operaciones(expresion.expresion, entorno, errores, simbolo)
    if(valor.hasOwnProperty('resultado')){
        valor = valor.resultado
    }
    if(valor.tipo == TIPO_DATO.STRING){
        let resultado = [...valor.valor]
        return {
            valor: resultado,
            tipo: TIPO_DATO.CHAR,
            linea: expresion.linea,
            columna: expresion.columna
        }
    }else{
        errores.add("Semántico", "La función toChar solo recibe cadenas. Tipos Invalidos."  , expresion.linea, expresion.columna);
        return {
            valor: null,
            tipo: "ERROR",
            linea: null,
            columna: null
        }    
    }

}

module.exports = Operaciones