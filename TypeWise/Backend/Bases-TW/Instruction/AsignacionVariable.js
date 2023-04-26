//? Permite asignar un valor de cualquier tipo a una variable
//! Si retorna null, se completo con éxito

const Operacion = require("../Operations/Operaciones")

function Asignacion(instruccion, entorno, errores, simbolo, entornoName){
    const id = instruccion.id               
    const buscar = entorno.buscarSimboloGlobal(id)
    if(buscar){
        var valor = Operacion(instruccion.expresion, entorno, errores, simbolo)
        if(valor.hasOwnProperty('resultado')){
            valor = valor.resultado
        }
        var temp = entorno.getSimboloE(id)
        let variable = temp.resultado
        let antiguo = variable.tipo
        let nuevo = valor.tipo
        
        if(antiguo===nuevo){
            variable.valor = valor.valor
            entorno.actualizar(id , variable)
            simbolo.update(id, temp.entorno, valor.valor)
            return null
        }
        errores.add("Semántico", `${id} es de tipo ${antiguo}, no de tipo ${nuevo}.` , instruccion.linea, instruccion.columna);
        return `${id} es de tipo ${antiguo}, no de tipo ${nuevo}.`
    }
    errores.add("Semántico", `${id} no puede recibir valores porque no existe.` , instruccion.linea, instruccion.columna);
    return `${id} no puede recibir valores porque no existe.`
}

module.exports = Asignacion