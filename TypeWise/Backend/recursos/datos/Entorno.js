//La clase entorno almacena la tabla de simbolos y metodos de la ejecución actual
//Funciona como una lista simple enlazada hacia arriba
class Entorno {
    constructor(padre, nombre) {
        this.nombre = nombre
        this.anterior = padre
        this.tablaSimbolos = new Map()
        this.tablaMetodos = new Map()
        this.retorno = ""
        
    }

    //Métodos para añadir-----------------------------------------------------------------------------
    addSimbolo(nombre, simbolo) {
        this.tablaSimbolos.set(nombre.toLowerCase(), simbolo)
    }

    addMetodo(nombre, metodo) {
        this.tablaMetodos.set(nombre.toLowerCase(), metodo)
    }

    //Métodos de busqueda-----------------------------------------------------------------------------

    //Busca el simvbolo en el entorno actual. Si no lo encuentra, busca en el padre.
    //Esto se repite hasta que llega a null
    getSimbolo(nombre) {
        for (let entorno = this; entorno != null; entorno = entorno.anterior) {
            var resultado = entorno.tablaSimbolos.get(nombre.toLowerCase())
            if (resultado != null) {
                return resultado
            }
        }
        return null
    }

    getSimboloE(nombre) {
        for (let entorno = this; entorno != null; entorno = entorno.anterior) {
            var resultado = entorno.tablaSimbolos.get(nombre.toLowerCase())
            if (resultado != null) {
                return {
                    resultado: resultado,
                    entorno: entorno.nombre
                }
            }
        }
        return null
    }

    getMetodo(nombre) {
        for (let entorno = this; entorno != null; entorno = entorno.anterior) {
            var resultado = entorno.tablaMetodos.get(nombre.toLowerCase())
            if (resultado != null) {
                return resultado
            }
        }
        return null
    }

    //Modificar Simbolos----------------------------------------------------------------------

    //Modificar el simbolo. Si lo encuentra, actualiza la posicion con su valor.
    //Retorna true si termina el método.
    actualizar(nombre, simbolo) {
        for (let entorno = this; entorno != null; entorno = entorno.anterior) {
            var encontrado = entorno.tablaSimbolos.get(nombre.toLowerCase())
            if (encontrado) {
                entorno.tablaSimbolos.set(nombre.toLowerCase(), simbolo)
                return true
            }
        }
        return false
    }

    //Buscar ----------------------------------------------------------------------------------------
    //Determina si el simbolo existe en todos los niveles
    buscarSimboloGlobal(nombre) {
        for (let entorno = this; entorno != null; entorno = entorno.anterior) {
            var resultado = entorno.tablaSimbolos.get(nombre.toLowerCase())
            if (resultado != null) {
                return true
            }
        }
        return false
    }

    buscarSimbolo(nombre) {
        var resultado = this.tablaSimbolos.get(nombre.toLowerCase())
        if (resultado != null) {
            return true
        }
        return false
    }

    //Determina si existe el metodo. Solo aplica para el entorno global.
    buscarMetodo(nombre) {
        for (let entorno = this; entorno != null; entorno = entorno.anterior) {
            var resultado = entorno.tablaMetodos.get(nombre.toLowerCase())
            if (resultado != null) {
                return true
            }
        }
        return false
    }

    setRetorno(tipo){
        this.retorno = tipo 
    }

}

module.exports = Entorno