//? Declaracion de metodos
//* Si retorna null, se completo con éxito


const Metodo = require("../Models/Metodo")

function DeclararMetodo(instruccion, entorno, errores, metodo){
    const nuevo = new Metodo(instruccion.nombre, instruccion.parametros, instruccion.instrucciones, null, instruccion.linea, instruccion.columna)

    if(entorno.buscarSimbolo(nuevo.id) == true){
        errores.add("Semántico", `${nuevo.id} es el nombre de una variable. No puede ser asignado al método.` , instruccion.linea, instruccion.columna);
        return `${nuevo.id} es el nombre de una variable. No puede ser asignado al método.`

    }else if(entorno.buscarMetodo(nuevo.id) == true){
        errores.add("Semántico", `${nuevo.id} es el nombre de un metodo. No puede ser asignado al método.` , instruccion.linea, instruccion.columna);
        return `${nuevo.id} es el nombre de un metodo. No puede ser asignado al método.`
    }
                                                //! Añadir a la tabla de simbolos
    entorno.addMetodo(nuevo.id, nuevo)
    metodo.add(instruccion.nombre, "VOID", instruccion.linea, instruccion.columna)
    return null

}

module.exports = DeclararMetodo