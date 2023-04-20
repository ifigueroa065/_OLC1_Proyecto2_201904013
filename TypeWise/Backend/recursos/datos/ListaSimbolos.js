//Imports
var RSimbolo = require("./RSimbolo");

//Constructor
class ListaSimbolo {
    constructor() {
        this.lista = new Array();
     }

    add(nombre, contenido, tipo, entorno, linea, columna){
        var nuevo = new RSimbolo(nombre, contenido, tipo, entorno, linea, columna);
        this.lista.push(nuevo);
    }

    update(nombre, entorno, nuevo){
        let indice = this.lista.findIndex((obj => obj.id == nombre && obj.entorno == entorno))
        this.lista[indice].valor = nuevo
    }

    
}

module.exports = ListaSimbolo;