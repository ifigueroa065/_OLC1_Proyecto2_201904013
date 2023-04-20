const Operacion = require("../operacion/Operaciones")

function Print(instruccion, entorno, errores, simbolo){
    let expresion = instruccion.expresion
    let consola = Operacion(expresion, entorno, errores, simbolo)
    if(consola.hasOwnProperty('resultado')){
        consola = consola.resultado
    }
    return consola.valor
}

module.exports = Print