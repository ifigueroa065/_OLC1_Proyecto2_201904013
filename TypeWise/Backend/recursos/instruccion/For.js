const TIPO_DATO = require("../enum/TipoDato")
const TIPO_INSTRUCCION = require("../enum/TipoInstruccion")
const Entorno = require("../datos/Entorno")
const Operacion = require("../operacion/Operaciones")
const AsignacionVariable = require("./AsignacionVariable")
const DeclararVariable = require("./DeclararVariable")

function For(instruccion, entorno, errores, simbolo){
    let salida = ""
    let entornoLocal = new Entorno(entorno)
    entornoLocal.setRetorno(entorno.retorno)
    let actualizar = instruccion.actualizacion
    //Asignar Variable
    let asignacion = instruccion.variable
    if(asignacion.tipo === TIPO_INSTRUCCION.DECLARACIONV){
        let consola = DeclararVariable(asignacion, entornoLocal, errores, simbolo, entornoLocal.nombre)
        if(consola != null){
            salida += consola + "\n"
        }
    }else{
        let consola = AsignacionVariable(asignacion, entornoLocal, errores, simbolo, entorno.nombre)
        if(consola != null){
            salida += consola + "\n"
        }
    }
    
    //Evaluar si la condicion es booleana
    let condicion  = Operacion(instruccion.condicion, entornoLocal, errores, simbolo)  
    if(condicion.hasOwnProperty('resultado')){
        condicion = condicion.resultado
    }
    if(condicion.tipo === TIPO_DATO.BOOLEAN){
        let ban = 0
        while(condicion.valor){
            let Local = require('./Local')
            let consola = Local(instruccion.instrucciones, entornoLocal, errores, simbolo)
            //COrrer Instrucciones
            if(consola != null){
                if(Array.isArray(consola)){
                    salida += consola[0]
                    if(consola[1] == "BREAK"){
                        ban = 1
                    } 
                }else if(typeof(consola) == 'object'){
                    let objeto = {
                        resultado: consola.resultado,
                        salida: consola.salida
                    }
                    salida = objeto
                    ban = 1
                }else{
                    salida += consola
                }
            }
            //Evaluar Condicion
            if(ban == 1){
                break;
            }else{
                //Actualizar 
                consola = AsignacionVariable(actualizar, entornoLocal, errores, simbolo, entorno.nombre)
                if(consola != null){
                    salida += consola +'\n'
                }
                //Evaluar Condicion
                condicion = Operacion(instruccion.condicion, entornoLocal, errores, simbolo)  
                if(condicion.hasOwnProperty('resultado')){
                    condicion = condicion.resultado
                }   
            }
        }
        return salida
    }else{
        errores.add("Semántico", 'La condición debe retornar un tipo booleano para proceder.' , instruccion.linea, instruccion.columna);
        return 'La condición debe retornar un tipo booleano para proceder.'
    }
}

module.exports = For