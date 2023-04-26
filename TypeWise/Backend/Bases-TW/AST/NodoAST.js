class NodoAST {
    constructor(nombre, valor) {
        this.nombre = nombre
        this.valor = valor
        this.hijos = []
    }

    add() {
        for (let i = 0; i < arguments.length; i++) {
            this.hijos.push(arguments[i]);
        }
    }
}

module.exports = NodoAST