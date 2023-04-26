//* Imports

var RMetodo = require("./RMetodo");

//*Constructor

class ListaMetodo {
    constructor() {
        this.lista = new Array();
     }

    add(nombre, tipo, linea, columna){
        var nuevo = new RMetodo(nombre, tipo, linea, columna);
        this.lista.push(nuevo);
    }

    
}

module.exports = ListaMetodo;