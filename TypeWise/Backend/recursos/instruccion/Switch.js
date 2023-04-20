const TIPO_INSTRUCCION = require("../enum/TipoInstruccion")
const Entorno = require("../datos/Entorno")
const Operacion = require("../operacion/Operaciones")

function Switch(instruccion, entorno, errores, simbolo){
    var salida = ""
    let expresion = instruccion.valor
    let casos = instruccion.casos
    let def = instruccion.default
    let valor  = Operacion(expresion, entorno, errores, simbolo)
    if(valor.hasOwnProperty('resultado')){
        valor = valor.resultado
    }
    if(valor.tipo != "ERROR"){
        let ban = 0;

        for(let i = 0; i < casos.length; i++){
            if(ban == 1){
                break;
            }

            let val = Operacion(casos[i].valor, entorno, errores, simbolo)
            if(val.hasOwnProperty('resultado')){
                val = val.resultado
            }
            if(val.valor == valor.valor){
                //Revisar si viene un break
                for(let j = 0; j < casos[i].instrucciones.length; j++){
                    if(casos[i].instrucciones[j].tipo === TIPO_INSTRUCCION.BREAK){
                        ban = 1;
                        break;
                    }
                }
                //Ejecutar Instrucciones
                let Local = require('./Local')
                var entornoLocal = new Entorno(entorno)
                entornoLocal.setRetorno(entorno.retorno)
                var consola = Local(casos[i].instrucciones, entornoLocal, errores, simbolo)
                if(consola != null){
                    if(Array.isArray(consola)){
                        salida += consola[0]
                        if(consola[1] == "CONTINUE"){
                            errores.add("Semántico", `Las sentencias continue solo se pueden usar en ciclos.` , instruccion.linea, instruccion.columna);
                            return `Las sentencias continue solo se pueden usar en ciclos.`
                        }
                    }else if(typeof(consola) == 'object'){
                        let objeto = {
                            resultado: consola.resultado,
                            salida: consola.salida
                        }
                        salida = objeto
                        ban = 1
                    }else{
                        salida += consola 
                        return salida
                    }
                }
            }
        }

        //Correr Default
        if(ban != 1){
            //Ejecutar Instrucciones
            let Local = require('./Local')
            var entornoLocal = new Entorno(entorno)
            entornoLocal.setRetorno(entorno.retorno)
            var consola = Local(def.instrucciones, entornoLocal, errores, simbolo)
            if(consola != null){
                if(Array.isArray(consola)){
                    salida += consola[0]
                    if(consola[1] == "CONTINUE"){
                        errores.add("Semántico", `Las sentencias continue solo se pueden usar en ciclos.` , instruccion.linea, instruccion.columna);
                        return `Las sentencias continue solo se pueden usar en ciclos.`
                    }
                }else if(typeof(consola) == 'object'){
                    return{
                        resultado: consola.resultado,
                        salida: consola.salida
                    }
                }else{
                    salida += consola 
                    return salida
                }
            }
        }
        return salida
    }
    else{
        errores.add("Semántico", 'Hay un error en el valor a comparar.' , instruccion.linea, instruccion.columna);
        return 'Hay un error en el valor a comparar.'
    }
}

module.exports = Switch