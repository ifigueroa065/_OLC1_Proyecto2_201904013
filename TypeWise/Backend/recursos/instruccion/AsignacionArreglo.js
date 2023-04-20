const Operaciones = require("../operacion/Operaciones")
const TIPO_DATO = require("../enum/TipoDato")

function AsignacionA(instruccion, entorno, errores, simbolo, entornoName){
    const id = instruccion.id               
    let posicion1 = instruccion.posicion1 
    let posicion2 = instruccion.posicion2
    const buscar = entorno.buscarSimboloGlobal(id)
    if(buscar){
        var valor = Operaciones(instruccion.expresion, entorno, errores, simbolo)
        if(valor.hasOwnProperty('resultado')){
            valor = valor.resultado
        }
        var variable = entorno.getSimboloE(id)
        var temp = variable.resultado
        let antiguo = temp.tipo
        let nuevo = valor.tipo
        
        if(antiguo===nuevo){
            if(posicion2 == null){
                //Arreglos Unidimensionales
                let tamaño1 = Operaciones(posicion1, entorno, errores, simbolo)
                if(tamaño1.hasOwnProperty('resultado')){
                    tamaño1 = tamaño1.resultado
                }
                if(tamaño1.tipo === TIPO_DATO.INT){
                    if(Array.isArray(temp.valor)){
                        let salida = temp.valor[tamaño1.valor]
                        if(salida != undefined){
                            temp.valor[tamaño1.valor] = valor.valor
                            entorno.actualizar(id , temp)
                            simbolo.update(id, variable.entorno, temp.valor)
                            return null
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
                errores.add("Semántico", `La posicion ingresada debe de ser de tipo INT, no ${tamaño1.tipo}.` , instruccion.linea, instruccion.columna);
                return {
                    valor: null,
                    tipo: "ERROR",
                    linea: expresion.linea,
                    columna: expresion.columna
                }

            }else{
                //Arreglos Bidimensionales
                let tamaño1 = Operaciones(posicion1, entorno, errores, simbolo)
                let tamaño2 = Operaciones(posicion2, entorno, errores, simbolo)
                if(tamaño1.hasOwnProperty('resultado')){
                    tamaño1 = tamaño1.resultado
                }
                if(tamaño2.hasOwnProperty('resultado')){
                    tamaño2 = tamaño2.resultado
                }
                if(tamaño1.tipo === TIPO_DATO.INT && tamaño2.tipo === TIPO_DATO.INT){
                    if(Array.isArray(temp.valor)){
                        let salida = temp.valor[tamaño1.valor][tamaño2.valor]
                        if(salida != undefined){
                            temp.valor[tamaño1.valor][tamaño2.valor] = valor.valor
                            entorno.actualizar(id , temp)
                            simbolo.update(id, variable.entorno, temp.valor)
                            return null
                        }
                        errores.add("Semántico", "La posición no existe en el arreglo (B)." , expresion.linea, expresion.columna);
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
                errores.add("Semántico", `Las posiciones ingresadas deben de ser de tipo INT.` , instruccion.linea, instruccion.columna);
                return {
                    valor: null,
                    tipo: "ERROR",
                    linea: expresion.linea,
                    columna: expresion.columna
                }

            }
            
        }
        errores.add("Semántico", `${id} es de tipo ${antiguo}, no de tipo ${nuevo}.` , instruccion.linea, instruccion.columna);
        return `${id} es de tipo ${antiguo}, no de tipo ${nuevo}.`
    }
    errores.add("Semántico", `${id} no puede recibir valores porque no existe.` , instruccion.linea, instruccion.columna);
    return `${id} no puede recibir valores porque no existe.`
}

module.exports = AsignacionA