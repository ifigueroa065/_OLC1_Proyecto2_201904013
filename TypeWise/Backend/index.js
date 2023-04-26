'use strict'
const express = require('express')
const bodParser = require('body-parser')
const Entorno = require("./Bases-TW/Models/Entorno");
const Iniciar = require("./Bases-TW/Instruction/Iniciar");
const Codigo = require("./Bases-TW/AST/Graphviz");
let cors = require('cors')

const app = express()

app.use(bodParser.json({limit:'50mb', extended:true}))
app.use(bodParser.urlencoded({limit:'50mb', extended:true}))
app.use(cors())


app.get('/',(req,res)=>{
    var respuesta={
        message:"Servidor en línea"
    }
    res.send(respuesta)
})

app.post('/analizar',(req,res)=>{
    let parser = require('./gramatica');
    let parse = require('./arbol');
    var entrada = req.body.entrada;
    var arbol = parser.parse(entrada)
    var a = parse.parse(entrada)
    //Extraer Valores
    var errores = arbol.lerrores
    var simbolo = arbol.lsimbolos;
    var metodos = arbol.lmetodos
    var ast = a.arbol
    var graphviz = Codigo(ast)
    console.log("____________________ TREE ____________________")
    console.log(graphviz)
    console.log("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")

                                                    //? Ejecucion de Instrucciones
    const global = new Entorno(null, "GLOBAL")
    console.log("-------------------------> ANALIZANDO <------------------------- ")

    let recorrido = Iniciar(arbol.instrucciones , global, errores, simbolo, metodos)
    console.log("!!!!!!!!!!!!!!!!!!!!!!!  ANALISIS SUCCESSFULLY !!!!!!!!!!!!!!!!!!!!!!!")

                                                                    //! Salida

    var respuesta={
        message:"Resultado correcto",
        ast: "Hola",
        ast: graphviz,        
        salida: recorrido,  
        errores: errores,    
        simbolos: simbolo,   
        metodos: metodos    
    }
    res.send(respuesta)
})

app.listen('3000', ()=>{
    console.log("")
    console.log("%%%%%%%%%%%%%%%%%%%%%% Servidor en puerto 3000 %%%%%%%%%%%%%%%%%%%%%%")
}) 