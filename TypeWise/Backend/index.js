'use strict'
const express = require('express')
const bodParser = require('body-parser')
const Entorno = require("./recursos/datos/Entorno");
const Iniciar = require("./recursos/instruccion/Iniciar");
const Codigo = require("./recursos/AST/Graphviz");
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
    console.log("-----------------------ArbOL--------------------------")
    console.log(graphviz)
    console.log("------------------------------------------------------")
    //Ejecucuon de Instrucciones
    const global = new Entorno(null, "GLOBAL")
    console.log("INICIANDO ANALISIS")
    let recorrido = Iniciar(arbol.instrucciones , global, errores, simbolo, metodos)
    console.log("ANALISIS FINALIZADO")
    //Salida
    var respuesta={
        message:"Resultado correcto",
        ast: "Hola",
        ast: graphviz,        //Retorna el arbol. Debe de graficarse.
        salida: recorrido,  //Retorna el texto de la consola
        errores: errores,    //Retorna la lista de errores
        simbolos: simbolo,   //Retorna la tabla de simbolos a mostrar
        metodos: metodos    //Retorna los metodos de la ejecucion
    }
    res.send(respuesta)
})

app.listen('3000', ()=>{
    console.log("---------- Servidor en puerto 3000 ----------")
}) 