//Declaracion de Variables
//Si retorna null, se completo con éxito
const TIPO_DATO = require("../enum/TipoDato");
const Simbolo = require("../datos/Simbolo");
const Operacion = require("../operacion/Operaciones");
const ListaErrores = require("../errores/ListaErrores");
const ListaSimbolos = require("../datos/ListaSimbolos");


function DeclararVariable(instruccion, entorno, errores, simbolo, entornoName){
    //Declaracion de Enteros
    if(instruccion.tipodato === TIPO_DATO.INT){
        let valor = 0
        if(instruccion.valor != null){
            let resultado = Operacion(instruccion.valor, entorno, errores, simbolo)
            if(resultado.hasOwnProperty('resultado')){
                resultado = resultado.resultado
            }
            if(resultado.tipo === TIPO_DATO.INT){
                valor = resultado.valor
            }
            else{
                errores.add("Semántico", `${instruccion.id} es de tipo ${instruccion.tipodato}, no de tipo ${resultado.tipo}.` , instruccion.linea, instruccion.columna);
                return `${instruccion.id} es de tipo ${instruccion.tipodato}, no de tipo ${resultado.tipo}.`
            }
        }
        for(let i = 0; i < instruccion.id.length; i++){
            const nuevo = new Simbolo(instruccion.id[i], valor, instruccion.tipodato, instruccion.linea, instruccion.columna)
            if(entorno.buscarSimbolo(nuevo.id) == true){
                errores.add("Semántico", `${nuevo.id} no puede ser asignado porque ya existe.` , instruccion.linea, instruccion.columna);
                return `${nuevo.id} no puede ser declarado porque ya existe.`
            }
            entorno.addSimbolo(nuevo.id, nuevo)
            simbolo.add(instruccion.id[i], valor, instruccion.tipodato, entornoName, instruccion.linea, instruccion.columna)

        }
        return null
    }
    //Declaracion de Doubles
    else if(instruccion.tipodato === TIPO_DATO.DOUBLE){
        let valor = 0.0
        if(instruccion.valor != null){
            let resultado = Operacion(instruccion.valor, entorno, errores, simbolo)
            if(resultado.hasOwnProperty('resultado')){
                resultado = resultado.resultado
            }
            if(resultado.tipo === TIPO_DATO.DOUBLE){
                valor = resultado.valor
            }
            else{
                errores.add("Semántico", `${instruccion.id} es de tipo ${instruccion.tipodato}, no de tipo ${resultado.tipo}.` , instruccion.linea, instruccion.columna);
                return `${instruccion.id} es de tipo ${instruccion.tipodato}, no de tipo ${resultado.tipo}.`
            }
        }
        for(let i = 0; i < instruccion.id.length; i++){
            const nuevo = new Simbolo(instruccion.id[i], valor, instruccion.tipodato, instruccion.linea, instruccion.columna)
            if(entorno.buscarSimbolo(nuevo.id) == true){
                errores.add("Semántico", `${nuevo.id} no puede ser asignado porque ya existe.` , instruccion.linea, instruccion.columna);
                return `${nuevo.id} no puede ser declarado porque ya existe.`
            }
            entorno.addSimbolo(nuevo.id, nuevo)
            simbolo.add(instruccion.id[i], valor, instruccion.tipodato, entornoName, instruccion.linea, instruccion.columna)
        }
        return null
    }
    //Declaracion de Boolean
    else if(instruccion.tipodato === TIPO_DATO.BOOLEAN){
        let valor = true
        if(instruccion.valor != null){
            let resultado = Operacion(instruccion.valor, entorno, errores, simbolo)
            if(resultado.hasOwnProperty('resultado')){
                resultado = resultado.resultado
            }
            if(resultado.tipo === TIPO_DATO.BOOLEAN){
                valor = resultado.valor
            }
            else{
                errores.add("Semántico", `${instruccion.id} es de tipo ${instruccion.tipodato}, no de tipo ${resultado.tipo}.` , instruccion.linea, instruccion.columna);
                return `${instruccion.id} es de tipo ${instruccion.tipodato}, no de tipo ${resultado.tipo}.`
            }
        }
        for(let i = 0; i < instruccion.id.length; i++){
            const nuevo = new Simbolo(instruccion.id[i], valor, instruccion.tipodato, instruccion.linea, instruccion.columna)
            if(entorno.buscarSimbolo(nuevo.id) == true){
                errores.add("Semántico", `${nuevo.id} no puede ser asignado porque ya existe.` , instruccion.linea, instruccion.columna);
                return `${nuevo.id} no puede ser declarado porque ya existe.`
            }
            entorno.addSimbolo(nuevo.id, nuevo)
            simbolo.add(instruccion.id[i], valor, instruccion.tipodato, entornoName, instruccion.linea, instruccion.columna)
        }
        return null
    }
    //Declaracion de Character
    else if(instruccion.tipodato === TIPO_DATO.CHAR){
        let valor = '\u0000'
        if(instruccion.valor != null){
            let resultado = Operacion(instruccion.valor, entorno, errores, simbolo)
            if(resultado.hasOwnProperty('resultado')){
                resultado = resultado.resultado
            }
            if(resultado.tipo === TIPO_DATO.CHAR){
                valor = resultado.valor
            }
            else{
                errores.add("Semántico", `${instruccion.id} es de tipo ${instruccion.tipodato}, no de tipo ${resultado.tipo}.` , instruccion.linea, instruccion.columna);
                return `${instruccion.id} es de tipo ${instruccion.tipodato}, no de tipo ${resultado.tipo}.`
            }
        }
        for(let i = 0; i < instruccion.id.length; i++){
            const nuevo = new Simbolo(instruccion.id[i], valor, instruccion.tipodato, instruccion.linea, instruccion.columna)
            if(entorno.buscarSimbolo(nuevo.id) == true){
                errores.add("Semántico", `${nuevo.id} no puede ser asignado porque ya existe.` , instruccion.linea, instruccion.columna);
                return `${nuevo.id} no puede ser declarado porque ya existe.`
            }
            entorno.addSimbolo(nuevo.id, nuevo)
            simbolo.add(instruccion.id[i], valor, instruccion.tipodato, entornoName, instruccion.linea, instruccion.columna)
        }
        return null
    }
    //Declaracion de String
    else if(instruccion.tipodato === TIPO_DATO.STRING){
        let valor = ''
        if(instruccion.valor != null){
            let resultado = Operacion(instruccion.valor, entorno, errores, simbolo)
            if(resultado.hasOwnProperty('resultado')){
                resultado = resultado.resultado
            }
            if(resultado.tipo === TIPO_DATO.STRING){
                valor = resultado.valor
            }
            else{
                errores.add("Semántico", `${instruccion.id} es de tipo ${instruccion.tipodato}, no de tipo ${resultado.tipo}.` , instruccion.linea, instruccion.columna);
                return `${instruccion.id} es de tipo ${instruccion.tipodato}, no de tipo ${resultado.tipo}.`
            }
        }
        for(let i = 0; i < instruccion.id.length; i++){
            const nuevo = new Simbolo(instruccion.id[i], valor, instruccion.tipodato, instruccion.linea, instruccion.columna)
            if(entorno.buscarSimbolo(nuevo.id) == true){
                errores.add("Semántico", `${nuevo.id} no puede ser asignado porque ya existe.` , instruccion.linea, instruccion.columna);
                return `${nuevo.id} no puede ser declarado porque ya existe.`
            }
            entorno.addSimbolo(nuevo.id, nuevo)
            simbolo.add(instruccion.id[i], valor, instruccion.tipodato, entornoName, instruccion.linea, instruccion.columna)
        }
        return null
    }

}

module.exports = DeclararVariable