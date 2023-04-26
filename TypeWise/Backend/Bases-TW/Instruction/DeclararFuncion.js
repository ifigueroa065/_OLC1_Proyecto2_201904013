//?Declaracion de metodos
//* Si retorna null, se completo con éxito


const Metodo = require("../Models/Metodo")

function DeclararFuncion(instruccion, entorno, errores, metodo){
    const nuevo = new Metodo(instruccion.nombre, instruccion.parametros, instruccion.instrucciones, instruccion.return, instruccion.linea, instruccion.columna)

    if(entorno.buscarSimbolo(nuevo.id) == true){
        errores.add("Semántico", `${nuevo.id} es el nombre de una variable. No puede ser asignado a la función.` , instruccion.linea, instruccion.columna);
        return `${nuevo.id} es el nombre de una variable. No puede ser asignado a la función.`

    }else if(entorno.buscarMetodo(nuevo.id) == true){
        errores.add("Semántico", `${nuevo.id} es el nombre de un metodo. No puede ser asignado a la función.` , instruccion.linea, instruccion.columna);
        return `${nuevo.id} es el nombre de un metodo. No puede ser asignado a la función.`
    }
                                    //! Añadir a la tabla de simbolos
    entorno.addMetodo(nuevo.id, nuevo)
    metodo.add(instruccion.nombre, instruccion.return, instruccion.linea, instruccion.columna)
    return null
}

module.exports = DeclararFuncion