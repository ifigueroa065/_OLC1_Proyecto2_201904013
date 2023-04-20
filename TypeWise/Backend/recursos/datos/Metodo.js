class Metodo{
    constructor(nombre, listaParametros, instrucciones, _return, linea, columna){
        this.id = nombre
        this.parametros = listaParametros
        this.instrucciones = instrucciones
        this.return = _return
        this.linea = linea
        this.columna = columna
    }
}

module.exports = Metodo