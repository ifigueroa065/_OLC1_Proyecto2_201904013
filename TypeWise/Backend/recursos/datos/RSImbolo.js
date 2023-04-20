class RSimbolo{
    constructor(nombre, contenido, tipo, entorno, linea, columna){
        this.id = nombre;
        this.valor = contenido;
        this.tipo = tipo;
        this.entorno = entorno;
        this.linea = linea;
        this.columna = columna;
    }
}

module.exports = RSimbolo