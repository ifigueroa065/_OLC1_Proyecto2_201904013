const Entorno = require("../datos/Entorno")
const Local = require("./Local")
const DeclararParametro = require("./DeclararParametro")
const Instruccion = require("./Instruccion")
const TIPO_INSTRUCCION = require("../enum/TipoInstruccion");

function Run(instruccion, entorno, errores, simbolo){
    var salida = ""
    var buscar = entorno.getMetodo(instruccion.nombre)
    if(buscar != null){
        var entornoLocal = new Entorno(entorno, instruccion.nombre)
        entornoLocal.setRetorno(buscar.return)
        var existeReturn = false
        if(buscar.return == null){
            existeReturn = true
        }else{
            for(let i = 0; i < buscar.instrucciones.length; i++){
                if (buscar.instrucciones[i].tipo === TIPO_INSTRUCCION.RETURN){
                    existeReturn = true
                }
            }
        }

        if(existeReturn){
            if(buscar.parametros != null){
                if(instruccion.valores != null && buscar.parametros.length == instruccion.valores.length){
                    var error = false;
                    //Declarar Parametros
                    for(let i = 0 ; i < buscar.parametros.length ; i++){
                        var declarar = Instruccion.declaracionp(buscar.parametros[i].tipodato, buscar.parametros[i].id, instruccion.valores[i], instruccion.linea, instruccion.columna)
                        var consola = DeclararParametro(declarar, entornoLocal, errores, simbolo, entornoLocal.nombre)
                        if(consola != null){
                            error = true;
                            salida += consola +'\n'
                        }
                    }
                    if(error){
                        return salida
                    }
                    let ejecutar = Local(buscar.instrucciones, entornoLocal, errores, simbolo)
                    if(ejecutar != null){
                        if(Array.isArray(ejecutar)){
                            errores.add("Semántico", `Las sentencias continue o break solo se pueden usar en ciclos.` , instruccion.linea, instruccion.columna);
                            return `Las sentencias continue o break solo se pueden usar en ciclos.`
                        }else if(typeof(ejecutar) == 'object'){
                            return{
                                resultado: ejecutar.resultado,
                                salida: ejecutar.salida
                            }
                        }else{
                            salida += ejecutar 
                            return salida
                        }
                    }
                    return salida
                }
                else{
                    errores.add("Semántico", `La cantidad de parámetros no coinciden.` , instruccion.linea, instruccion.columna);
                    return `La cantidad de parámetros no coinciden.`
                }
            }
            else {
                let ejecutar = Local(buscar.instrucciones, entornoLocal, errores, simbolo)
                if(ejecutar != null){
                    if(Array.isArray(ejecutar)){
                        errores.add("Semántico", `Las sentencias continue o break solo se pueden usar en ciclos.` , instruccion.linea, instruccion.columna);
                        return `Las sentencias continue o break solo se pueden usar en ciclos.`
                    }else if(typeof(ejecutar) == 'object'){
                        return{
                            resultado: ejecutar.resultado,
                            salida: ejecutar.salida
                        }
                    }else{
                        salida += ejecutar 
                        return salida
                    }
                }
                return salida
            }
        }else{
            errores.add("Semántico", `La función '${instruccion.nombre}' carece de un return.` , instruccion.linea, instruccion.columna);
            return `La función '${instruccion.nombre}' carece de un return.`
        }
    }
    errores.add("Semántico", `El metodo '${instruccion.nombre}' no existe.` , instruccion.linea, instruccion.columna);
    return `El metodo '${instruccion.nombre}' no existe.`
}

module.exports = Run