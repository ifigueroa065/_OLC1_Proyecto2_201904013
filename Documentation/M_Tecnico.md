# :pushpin: MANUAL TÉCNICO 

 Se construyeron analizadores Léxico y Sintáctico, capaces de crear un
sistema que realiza el Método del Árbol y el Método de Thompson. Se requiere que las expresiones regulares sean ingresadas en notación
polaca o prefija.
Cabe destacar que el sistema cuenta con un Intérprete de Expresiones Regulares el cual es el 
encargado de analizar un archivo de expresiones regulares que definirán el
patrón que se utilizará dentro del sistema para que reciba los lexemas,

## Estructura del proyecto
-  :file_folder: Analizadores (archivos jflex|cup)
-  :file_folder: Generadores (otras opciones para compilar)
-  :file_folder: Interfaz (Interfaz de ExREGAN)
-  :file_folder: Main (Modelos utilizados en el proyecto)

##  :notebook_with_decorative_cover: Lectura recomendada 
      https://github.com/ifigueroa065/Jflex-Cup.git

## Entorno de Desarrollo :outbox_tray:


- :ballot_box_with_check: IDE:       Apache NetBeans IDE 16 
- :ballot_box_with_check: JDK:      19.0.2; Java HotSpot(TM) 64-Bit Server VM 19.0.2+7-44
- :ballot_box_with_check: Runtime:  Java(TM) SE Runtime Environment 19.0.2+7-44
- :ballot_box_with_check: Espacio en memoria:   20 MB min.
- :ballot_box_with_check: Versión de Graphviz:    graphviz version 7.1.0 (20230121.1956)
- :ballot_box_with_check: Librerias JLex y Cup

## JFLEX & CUP 🍵


Para ejecutar los archivos A_Lexical_ y A_Sintactico se utilizó el siguiente código en el Main 
```java
try{        
            //ruta donde se encuentran nuestros archivos
            String ruta = "src/main/java/Analizadores/";
            String[] opcFlex = {ruta +  "A_Lexico.jflex", "-d", ruta};
            jflex.Main.generate(opcFlex);
            String[] opcCup = {"-destdir", ruta, "-parser", "Sintactico", ruta + "A_Sintactico.cup"};
            java_cup.Main.main(opcCup);
            
        }catch(Exception e)
```
## Lectura :blue_book:

Para una lectura rapida del archivo de entrada se utilizaron las herramientas JLex y Cup, creando gramaticas en la misma. Los archivos utilizados para este proceso son A_Lexico.jflex, A_Sintactico.cup, A_Lexical.java, A_sintactico.java, Tabla_sym.java

## Analizador :bomb:

El programa lee caracter por caracter el archivo de entrada, el cual deberá de tener una extensión de tipo (olc) , si un caracter no cumple con la estructura definida en el programa se creará un archivo de Reporte de Errores de tipo html.




## Diccionario 📖

Función |  Definición 
------------ | -------------
`Tree` | Genera todas las estructuras del programa como el Arbol de Expresiones Regulares, Tabla Siguiente, Tabla Transiciones, AFD y AFND.
`Thompson` | Clase en la cual estan los datos necesarios para realizar el Automata Finito No Determinista.
`State` | Contiene los datos de los estados creados para el Automata Finito Determinista.
`Regex` | Realiza la lectura caracter por caracter de la expresion ingresada.
`PrintGraphTree` | Su funcionalidad es extraer los datos de la clase Tree para realizar los grafos correspondientes con la herramienta _GraphViz_
`PrintGraphAutomata` | Su funcionalidad es extraer los datos de la clase Automata para realizar los grafos correspondientes con la herramienta _GraphViz_
`PrintGraphThompson` | Su funcionalidad es extraer los datos de la clase Thompson para realizar los grafos correspondientes con la herramienta _GraphViz_
`ExREGAN` | Clase de tipo visual para el usuario que puede mandar a llamar a las claes ya antes mencionadas. Interfaz Grafica.
`CMD` | Funcion auxiliar utilizada en distintas clases para la generacion de los grafos.


```
Universidad San Carlos de Guatemala 2023
Programador: Marlon Isaí Figueroa Farfán
Carnet: 201904013
```