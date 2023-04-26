//* Imports
var error = require("./Error");

//* Constructor
class ListaErrores {
    constructor() {
        this.lista = new Array();
     }

    add(tipo, descripcion, linea, columna){
        var nuevo = new error(tipo, descripcion, linea, columna);
        this.lista.push(nuevo);
    }
}

module.exports = ListaErrores;