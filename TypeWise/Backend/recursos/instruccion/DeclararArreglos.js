//Declaracion de Vectores
//Si retorna null, se completo con éxito
const TIPO_DATO = require("../enum/TipoDato")
const TIPO_INSTRUCCION = require("../enum/TipoInstruccion")
const Simbolo = require("../datos/Simbolo")
const Operacion = require("../operacion/Operaciones")
const ListaErrores = require("../errores/ListaErrores")
const ListaSimbolos = require("../datos/ListaSimbolos");


function DeclararArreglos(instruccion, entorno, errores, simbolo, entornoName){
    //Diferenciar tipo de declaracion
    //Tipo 1 es sin valores. Tipo 2 es con valores.
    let InstruccionTipo = instruccion.tipo
    if(InstruccionTipo === TIPO_INSTRUCCION.DECLARACIONA1){
        //Verificar si ambos tipos son iguales
        if(instruccion.tipo1 === instruccion.tipo2){
            if(instruccion.tamaño2 != null){
                //Arreglos Bidemensionales
                let tamaño1 = Operacion(instruccion.tamaño1, entorno, errores, simbolo)
                let tamaño2 = Operacion(instruccion.tamaño2, entorno, errores, simbolo)
                if(tamaño1.hasOwnProperty('resultado')){
                    tamaño1 = tamaño1.resultado
                }
                if(tamaño2.hasOwnProperty('resultado')){
                    tamaño2 = tamaño2.resultado
                }
                if(tamaño1.tipo === TIPO_DATO.INT && tamaño2.tipo === TIPO_DATO.INT){
                    //Crear el arreglo
                    var valor = null

                    if(instruccion.tipo1 === TIPO_DATO.INT){
                        valor = Array(tamaño1.valor).fill(Array(tamaño2.valor).fill(0))
                    }else if(instruccion.tipo1 === TIPO_DATO.DOUBLE){
                        valor = Array(tamaño1.valor).fill(Array(tamaño2.valor).fill(0.0))
                    }else if(instruccion.tipo1 === TIPO_DATO.CHAR){
                        valor = Array(tamaño1.valor).fill(Array(tamaño2.valor).fill('\u0000'))                     
                    }else if(instruccion.tipo1 === TIPO_DATO.BOOLEAN){
                        valor = Array(tamaño1.valor).fill(Array(tamaño2.valor).fill(true))
                    }else if(instruccion.tipo1 === TIPO_DATO.STRING){
                        valor = Array(tamaño1.valor).fill(Array(tamaño2.valor).fill(''))
                    }

                    //Buscar Simbolo 
                    const nuevo = new Simbolo(instruccion.id, valor, instruccion.tipo1, instruccion.linea, instruccion.columna)
                    if(entorno.buscarSimbolo(nuevo.id) == true){
                        errores.add("Semántico", `${nuevo.id} no puede ser declarado porque ya existe.` , instruccion.linea, instruccion.columna);
                        return `${nuevo.id} no puede ser declarado porque ya existe.`
                    }
                    entorno.addSimbolo(nuevo.id, nuevo)
                    simbolo.add(instruccion.id, valor, instruccion.tipo1, entornoName, instruccion.linea, instruccion.columna)
                    return null

                }
                errores.add("Semántico", `El tamaño ingresado de ser de tipo INT. Tipo 1: ${tamaño1.tipo}  - TIpo 2: ${tamaño2.tipo}.` , instruccion.linea, instruccion.columna);
                return `El tamaño ingresado de ser de tipo INT. Tipo 1: ${tamaño1.tipo}  - Tipo 2: ${tamaño2.tipo}.`

            }else{
                //Arreglos Unidimensionales
                let tamaño1 = Operacion(instruccion.tamaño1, entorno, errores, simbolo)
                if(tamaño1.hasOwnProperty('resultado')){
                    tamaño1 = tamaño1.resultado
                }
                if(tamaño1.tipo === TIPO_DATO.INT){
                    //Crear el arreglo
                    var valor = null

                    if(instruccion.tipo1 === TIPO_DATO.INT){
                        valor = Array(tamaño1.valor).fill(0)
                    }else if(instruccion.tipo1 === TIPO_DATO.DOUBLE){
                        valor = Array(tamaño1.valor).fill(0.0)
                    }else if(instruccion.tipo1 === TIPO_DATO.CHAR){
                        valor = Array(tamaño1.valor).fill('\u0000')                     
                    }else if(instruccion.tipo1 === TIPO_DATO.BOOLEAN){
                        valor = Array(tamaño1.valor).fill(true)
                    }else if(instruccion.tipo1 === TIPO_DATO.STRING){
                        valor = Array(tamaño1.valor).fill('')
                    }

                    //Buscar Simbolo 
                    const nuevo = new Simbolo(instruccion.id, valor, instruccion.tipo1, instruccion.linea, instruccion.columna)
                    if(entorno.buscarSimbolo(nuevo.id) == true){
                        errores.add("Semántico", `${nuevo.id} no puede ser declarado porque ya existe.` , instruccion.linea, instruccion.columna);
                        return `${nuevo.id} no puede ser declarado porque ya existe.`
                    }
                    entorno.addSimbolo(nuevo.id, nuevo)
                    simbolo.add(instruccion.id, valor, instruccion.tipo1, entornoName, instruccion.linea, instruccion.columna)
                    return null

                }
                errores.add("Semántico", `El tamaño ingresado de ser de tipo INT, no ${tamaño1.tipo}.` , instruccion.linea, instruccion.columna);
                return `El tamaño ingresado de ser de tipo INT, no ${tamaño1.tipo}.`
            }
        }
        errores.add("Semántico", `Los tipos del arreglo no coinciden (${instruccion.tipo1} / ${instruccion.tipo2}).` , instruccion.linea, instruccion.columna);
        return `Los tipos del arreglo no coinciden (${instruccion.tipo1} / ${instruccion.tipo2}).`

    }else if(InstruccionTipo === TIPO_INSTRUCCION.DECLARACIONA2){
        const dimension = instruccion.dimension
        if(dimension === 1){
            //Arreglos Unidimensionales
            //Crear el arreglo
            let valor = []
            for(let x = 0; x < instruccion.valores.length; x++){
                let temp = instruccion.valores[x]
                if(Array.isArray(temp)){
                    errores.add("Semántico", `Los valores ingresados en el arreglo siguen un formato de dos dimensiones.` , instruccion.linea, instruccion.columna);
                    return `Los valores ingresados en el arreglo siguen un formato de dos dimensiones.`
                }else{
                    let resultado = Operacion(temp, entorno, errores, simbolo)
                    if(resultado.hasOwnProperty('resultado')){
                        resultado = resultado.resultado
                    }
                    if(resultado.tipo === instruccion.tipo1){
                        valor.push(resultado.valor)
                    }else{
                        errores.add("Semántico", `El array es de tipo ${instruccion.tipo1} y hay un valor de tipo ${resultado.tipo}.` , instruccion.linea, instruccion.columna);
                        return `El array es de tipo ${instruccion.tipo1} y hay un valor de tipo ${resultado.tipo}.`
                    }
                }
            }

            //Buscar Simbolo 
            const nuevo = new Simbolo(instruccion.id, valor, instruccion.tipo1, instruccion.linea, instruccion.columna)
            if(entorno.buscarSimbolo(nuevo.id) == true){
                errores.add("Semántico", `${nuevo.id} no puede ser declarado porque ya existe.` , instruccion.linea, instruccion.columna);
                return `${nuevo.id} no puede ser declarado porque ya existe.`
            }
            entorno.addSimbolo(nuevo.id, nuevo)
            simbolo.add(instruccion.id, valor, instruccion.tipo1, entornoName, instruccion.linea, instruccion.columna)
            return null

        }else{
            //Arreglos Bidimensionales 
            //Crear el arreglo
            let valor = []
            //console.log(instruccion.valores)
            for(let x = 0; x < instruccion.valores.length; x++){
                let temp = instruccion.valores[x]
                if(Array.isArray(temp)){
                    let add = []
                    for(let y = 0; y < temp.length; y++){
                        let tempo = temp[y]
                        if(Array.isArray(tempo)){
                            errores.add("Semántico", `Los valores ingresados en el arreglo siguen un formato de tres dimensiones.` , instruccion.linea, instruccion.columna);
                            return `Los valores ingresados en el arreglo siguen un formato de tres dimensiones.`
                        }else{
                            let resultado = Operacion(tempo, entorno, errores, simbolo)
                            if(resultado.hasOwnProperty('resultado')){
                                resultado = resultado.resultado
                            }
                            if(resultado.tipo === instruccion.tipo1){
                                add.push(resultado.valor)
                            }else{
                                errores.add("Semántico", `El array es de tipo ${instruccion.tipo1} y hay un valor de tipo ${resultado.tipo}.` , instruccion.linea, instruccion.columna);
                                return `El array es de tipo ${instruccion.tipo1} y hay un valor de tipo ${resultado.tipo}.`
                            }
                        }
                    }
                    valor.push(add)
                }else{
                    errores.add("Semántico", `Los valores ingresados en el arreglo siguen un formato de una dimension.` , instruccion.linea, instruccion.columna);
                    return `Los valores ingresados en el arreglo siguen un formato de una dimension.`
                }
            }

            //Buscar Simbolo 
            const nuevo = new Simbolo(instruccion.id, valor, instruccion.tipo1, instruccion.linea, instruccion.columna)
            if(entorno.buscarSimbolo(nuevo.id) == true){
                errores.add("Semántico", `${nuevo.id} no puede ser declarado porque ya existe.` , instruccion.linea, instruccion.columna);
                return `${nuevo.id} no puede ser declarado porque ya existe.`
            }
            entorno.addSimbolo(nuevo.id, nuevo)
            simbolo.add(instruccion.id, valor, instruccion.tipo1, entornoName, instruccion.linea, instruccion.columna)
            return null
        }   
    }else if(InstruccionTipo === TIPO_INSTRUCCION.DECLARACIONA3){ //Char ARRAY
        const dimension = instruccion.dimension
        if(dimension === 1){
            if(instruccion.tipo1 == TIPO_DATO.CHAR && instruccion.expresion.tipo == TIPO_INSTRUCCION.TOCHAR){
                let resultado = Operacion(instruccion.expresion, entorno, errores, simbolo)
                if(resultado.hasOwnProperty('resultado')){
                    resultado = resultado.resultado
                }
                //Crear el arreglo
                var valor = resultado.valor
                if(Array.isArray(valor)){
                    //Buscar Simbolo 
                    const nuevo = new Simbolo(instruccion.id, valor, instruccion.tipo1, instruccion.linea, instruccion.columna)
                    if(entorno.buscarSimbolo(nuevo.id) == true){
                        errores.add("Semántico", `${nuevo.id} no puede ser declarado porque ya existe.` , instruccion.linea, instruccion.columna);
                        return `${nuevo.id} no puede ser declarado porque ya existe.`
                    }
                    entorno.addSimbolo(nuevo.id, nuevo)
                    simbolo.add(instruccion.id, valor, instruccion.tipo1, entornoName, instruccion.linea, instruccion.columna)
                    return null
                }else{
                    errores.add("Semántico", `Declaración de arreglo erronea. Verifique los tipos y la entrada` , instruccion.linea, instruccion.columna);
                    return `Declaración de arreglo erronea. Verifique los tipos y la entrada.`
                }
            }else{
                errores.add("Semántico", `Declaración de arreglo erronea. Verifique los tipos y la entrada` , instruccion.linea, instruccion.columna);
                return `Declaración de arreglo erronea. Verifique los tipos y la entrada.`
            }
        }
    }

}

module.exports = DeclararArreglos