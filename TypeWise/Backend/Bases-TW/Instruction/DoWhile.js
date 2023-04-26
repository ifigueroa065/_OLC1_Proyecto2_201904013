const TIPO_DATO = require("../Reserved/TipoDato")
const Entorno = require("../Models/Entorno")
const Operacion = require("../Operations/Operaciones")

function DoWhile(instruccion, entorno, errores, simbolo){
    let salida = ""
    let condicion  = Operacion(instruccion.condicion, entorno, errores, simbolo)  
    if(condicion.hasOwnProperty('resultado')){
        condicion = condicion.resultado
    }
    if(condicion.tipo === TIPO_DATO.BOOLEAN){
        let ban = 0
        do{
            let entornoLocal = new Entorno(entorno)
            entornoLocal.setRetorno(entorno.retorno)
            let Local = require('./Local')
            let consola = Local(instruccion.instrucciones, entornoLocal, errores, simbolo)
                                                    //? Correr Instrucciones
            if(consola != null){
                if(Array.isArray(consola)){
                    salida += consola[0]
                    if(consola[1] == "BREAK"){
                        ban = 1
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
                }
            }
                                                    //? Evaluar Condicion
            if(ban == 1){
                break;
            }else{
                condicion = Operacion(instruccion.condicion, entorno, errores, simbolo)     
                if(condicion.hasOwnProperty('resultado')){
                    condicion = condicion.resultado
                }
            }
        }
        while(condicion.valor)
        return salida
    }else{
        errores.add("Semántico", 'La condición debe retornar un tipo booleano para proceder.' , instruccion.linea, instruccion.columna);
        return 'La condición debe retornar un tipo booleano para proceder.'
    }
}

module.exports = DoWhile