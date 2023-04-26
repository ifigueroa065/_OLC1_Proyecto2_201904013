//?Prepara y carga la informacion importante


const TIPO_INSTRUCCION = require("../Reserved/TipoInstruccion")
const AsignacionVariable = require("./AsignacionVariable")
const AsignacionArreglos = require("./AsignacionArreglo")
const DeclararVariable = require("./DeclararVariable")
const DeclararArreglos = require("./DeclararArreglos")
const DeclararMetodo = require("./DeclararMetodo")
const DeclararFuncion = require("./DeclararFuncion")
const ListaErrores = require("../Errors/ListaErrores");
const ListaSimbolos = require("../Models/ListaSimbolos");
const Run = require("./Run")

function Iniciar(instrucciones, entorno, errores, simbolo, metodo){
    var salida = ""
    
                        //? Declaracion, asignacion y creacion de metodos y variables

    for(let i = 0; i< instrucciones.length; i++){
        if (instrucciones[i].tipo === TIPO_INSTRUCCION.DECLARACIONV){
            var consola = DeclararVariable(instrucciones[i], entorno, errores, simbolo, "GLOBAL")
            if(consola != null){
                salida += consola + "\n"
            }
        }
        else if (instrucciones[i].tipo === TIPO_INSTRUCCION.DECLARACIONA1 || instrucciones[i].tipo === TIPO_INSTRUCCION.DECLARACIONA2){
            var consola = DeclararArreglos(instrucciones[i], entorno, errores, simbolo, "GLOBAL")
            if(consola != null){
                salida += consola +'\n'
            }
        }
        else if (instrucciones[i].tipo === TIPO_INSTRUCCION.DMETODO){
            var consola = DeclararMetodo(instrucciones[i], entorno, errores, metodo)
            if(consola != null){
                salida += consola +'\n'
            }
        }

        else if (instrucciones[i].tipo === TIPO_INSTRUCCION.DFUNCION){
            var consola = DeclararFuncion(instrucciones[i], entorno, errores, metodo)
            if(consola != null){
                salida += salida += consola +'\n'
            }
        }
    }

                                        //! Ejecutar las funciones con Main
    for(let i = 0; i < instrucciones.length; i++){
        if (instrucciones[i].tipo === TIPO_INSTRUCCION.RUN){
            var consola = Run(instrucciones[i], entorno, errores, simbolo)
            if(consola != null){
                if(typeof(consola) == 'object'){
                    salida += consola.salida
                }else{
                    salida += consola
                }
            }
        }
    }
    return salida
}

module.exports = Iniciar