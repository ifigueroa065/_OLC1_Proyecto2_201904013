class Simbolo{
    constructor(nombre, contenido, tipo, linea, columna){
        this.id = nombre;
        this.valor = contenido;
        this.tipo = tipo;
        this.linea = linea;
        this.columna = columna;
    }
}

module.exports = Simbolo