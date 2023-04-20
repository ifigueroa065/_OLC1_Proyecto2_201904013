const TIPO_DATO = require("../enum/TipoDato")
const Entorno = require("../datos/Entorno")
const Operacion = require("../operacion/Operaciones")

function Si(instruccion, entorno, errores, simbolo){
    var salida = ""
    let c = instruccion.condicion
    let v = instruccion.true
    let f = instruccion.false
    let condicion  = Operacion(c, entorno, errores, simbolo)
    if(condicion.hasOwnProperty('resultado')){
        condicion = condicion.resultado
    }
    if(condicion.tipo === TIPO_DATO.BOOLEAN){
        if(condicion.valor){
            //Es verdadera la condicion
            let Local = require('./Local')
            var entornoLocal = new Entorno(entorno)
            entornoLocal.setRetorno(entorno.retorno)
            var consola = Local(v, entornoLocal, errores, simbolo)
            if(consola != null){
                if(Array.isArray(consola)){
                    salida += consola[0]
                    let objeto = [salida, consola[1]]
                    salida = objeto;
                    return salida
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
        }else{
            if(f != null){
                //Revisar si viene otro If o vienen las instrucciones
                if(Array.isArray(f)){
                    //Es verdadera la condicion
                    let Local = require('./Local')
                    var entornoLocal = new Entorno(entorno)
                    entornoLocal.setRetorno(entorno.retorno)
                    var consola = Local(f, entornoLocal, errores, simbolo)
                    if(consola != null){
                        if(Array.isArray(consola)){
                            salida += consola[0]
                            let objeto = [salida, consola[1]]
                            salida = objeto;
                            return salida
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
                }else{
                    let consola = Si(f, entorno, errores, simbolo)
                    if(consola != null){
                        if(Array.isArray(consola)){
                            salida += consola[0]
                            let objeto = [salida, consola[1]]
                            salida = objeto;
                            return salida
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
            }
        }
    }
    else{
        errores.add("Semántico", 'La condición debe ser de tipo booleana para ser valida.' , instruccion.linea, instruccion.columna);
        return 'La condición debe ser d tipo booleana para ser valida.'
    }
}

module.exports = Si