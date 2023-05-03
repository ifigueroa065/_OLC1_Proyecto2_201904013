# :satellite: MANUAL TÉCNICO 

El curso de Organización de Lenguajes y Compiladores 1, perteneciente a la
Facultad de Ingeniería de la Universidad de San Carlos de Guatemala, ha quedado
satisfecho con el programa EXREGAN (que previamente ha entregado), por lo que
nuevamente se interesan en usted para generar el lenguaje TypeWise, que será un
intérprete para que los estudiantes de Introducción a la Programación y
Computación 1 utilicen para sus primeras prácticas.


## :file_folder: TypeWise
Es un analizador que interpreta instrucciones para un
lenguaje de programación que utiliza las sentencias basicas usadas en
cualquier otro lenguaje. La aplicación funciona enviando peticiones desde el Frontend
(construido con angular) hacia el Backend (desarrollado con Node.js ) esperando la respuesta
del mismo para poder mostrar los resultados del análisis del archivo de entrada


### :file_folder: Backend (Analizador)

1.  :open_file_folder: BASES-TW (API)
2.  :page_facing_up: gramatica.jison 
3.  :page_facing_up: arbol.jison 

### :file_folder: Frontend (Interfaz)
####  :file_folder: src (código fuente)
 1.  :open_file_folder: app (estructura)
 2.  :open_file_folder: assets (recursos)
 2.  :page_facing_up: index.html (interfaz)


##  :construction: Entorno de Desarrollo :construction:

- :ballot_box_with_check: Lenguajes: Javascript/Typescript. 
- :ballot_box_with_check: Framework: Angular
- :ballot_box_with_check: Entorno: Node.js
- :ballot_box_with_check: Espacio en memoria:   20 MB min.
- :ballot_box_with_check: Versión de Graphviz:    graphviz version 7.1.0 (20230121.1956)
- :ballot_box_with_check: Librerias Graphviz, Jison, CORS y express

## :recycle: Levantar proyecto :recycle:


Para ejecutar el Backend y Frontend necesitas instalar todas sus dependencias con el siguiente comando
> **Nota:** Recuerda que este comando se ejecuta donde se ubica el package.json
```sh
npm install
```


si fuera necesario se emplea 
```sh
npm audit fix
```
posteriormente se levanta el backend y el frontend con el siguiente comando
> **Nota:** En backend a nivel de index.js y en Frontend a nivel de index.html
```sh
npm start
```

si quieres saber como compilar la gramática del interprete debes ejecutar este comando donde tengas tus archivos .jison
```sh
jison gramatica.jison
```

> **Nota:** Al momento de compilar algún archivo jison es común que la ejecución de scripts esté deshabilitada en tu sistema operativo... el siguiente blog te ayudará a habilitar los permisos necesarios :)  https://www.cdmon.com/es/blog/la-ejecucion-de-scripts-esta-deshabilitada-en-este-sistema-te-contamos-como-actuar


##  :name_badge: Lectura :name_badge:

Para una lectura rapida del archivo de entrada se utilizó la herramienta Jison, creando gramaticas en la misma. Los archivos utilizados para este proceso son gramatica.jison y arbol.jison

##  :eight_spoked_asterisk: Interprete :eight_spoked_asterisk:

El programa lee caracter por caracter el archivo de entrada, el cual deberá de tener una extensión de tipo (tw) , si un caracter no cumple con la estructura definida en el programa se creará una sección con el detalle de errores

### Se implementaron varias clases de este tipo para posteriormente crear objetos y almacenarlos

```js
class Clase{
    constructor(name, listaParametros, instruction, _return, row, column){
        this.id = name
        this.parametros = listaParametros
        this.instruction = instruction
        this.return = _return
        this.row = row
        this.column = column
    }
}

module.exports = Clase
```
###  Esta clase extrae la informacion de las instrucciones y va procesando cada uno de sus valores

```js
//* Constructor de Instrucciones

const TIPO_INSTRUCCION = require("../Reserved/TipoInstruccion")
const TIPO_VALOR = require("../Reserved/TipoValor")

                                    //? Tipo de instruccion

const Instruction = {
    declaracionp: function(_tipodato, _id, _valor, _linea, _columna){
        return {
            tipodato: _tipodato,                
            id: _id,
            valor: _valor,
            linea: _linea,
            columna: _columna,
            tipo: TIPO_INSTRUCCION.DECLARACIONP
        }
    },
    asignacionv: function(_id, _expresion, _linea, _columna){
        return {
            id: _id,
            expresion: _expresion,
            linea: _linea,
            columna: _columna,
            tipo: TIPO_INSTRUCCION.ASIGNACIONV
        }
    }
}
module.exports = Instruction
```


## Diccionario 📖

Función |  Definición 
------------ | -------------
`Backend` | Su función es acceder a la información que se solicita, a través de la app, para luego combinarla y devolverla al usuario final
`Frontend` | Frontend es la parte de un sitio web que interactúa con los usuarios, por eso decimos que está del lado del cliente. 
`Package.json` | El paquete package.json es el corazón de cualquier proyecto de Node, registra metadatos importantes sobre un proyecto que se requiere
`Dependencias` | Paquetes que necesitamos en un proyecto mientras estamos desarrollándolo, pero una vez tenemos el código generado del proyecto, no vuelven a hacer falta.
`Framework` | Es un marco o esquema de trabajo generalmente utilizado por programadores para realizar el desarrollo de software
`Components` | Un componente en Angular es un elemento que está compuesto por: Un archivo que será nuestro Template (app. component. html), el cual es nuestro HTML, que es el que se va a visualizar en la interfaz de usuario, la vista o en términos más simples lo que vas a ver en la página.
`Services` | Un servicio es una clase, comúnmente decorada con el decorador Injector de Angular, mismo que indica que este Servicio puede inyectar otras dependencias de la aplicación, ya sean otros servicios como el de Http para hacer consultas AJAX.
`Peticion` | La petición o HTTP request es el mensaje que se envía desde el cliente al servidor para solicitar un resource.
`CRUD` | CRUD (Create, Read, Update, Delete) es un acrónimo para las maneras en las que se puede operar sobre información almacenada. Es un nemónico para las cuatro funciones del almacenamiento persistente.


```
Universidad San Carlos de Guatemala 2023
Programador: Marlon Isaí Figueroa Farfán
Carnet: 201904013
```
