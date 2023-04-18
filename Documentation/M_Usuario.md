# MANUAL DE USUARIO ExREGAN :yellow_heart: :snake:



<div id='introduccion'/>

##  :arrow_lower_right: Introducción 
El programa cuenta con la implementación de una interfaz gráfica para el usuario, en la cual la interacción es amigable y compresible. Fue diseñada de forma simple para que consuma un menor gasto de recursos de su ordenador el cual se dara una mejor fluidez durante la ejecución. Este programa es de tipo _Analizador Léxico-Sintáctico_ que permite la validación de cadenas por medio de un archivo de entrada de tipo .olc

<div id='descrip'/>

## Descripción :arrow_down:

  - **Estructura de Almacenamiento**: 
Para cada lectura de un archivo de entrada se utilizaron listas ArrayList así como LinkedList para la implementacion correcta de las gramáticas ingresadas.

  - **Palabras Reservadas**:
El programa cuenta con palabras reservadas como: _CONJ_ la cual indica el inicio de un nuevo conjunto de caracteres, la cual debe de seguir una estructura de tipo Preorden. _%%_ indica la finalización de las expresiones regulares y procederá a realizar las validaciones de cadenas.
  
  - **Caracteres**:
El programa permite la lectura de cualquier caracter en cualquier posicion del archivo de entrada.


<div id='apli'/>

## Aplicación :white_check_mark:
### Interfaz Gráfica (GUI)
El programa cuenta con una vista gráfica la cual facilita la interacción entre el sistema y el usuario final para un mejor desempeño del mismo. Por medio de dicha interfaz, al usuario se le permite seleccionar de forma _gráfica_ una archivo de entrada que contendrá las gramáticas a analizar. El usuario puede navegar por la aplicación seleccionando a través de botones la acción que desea realizar, si ocurre un error en el ingreso de datos el programa creara un archivo en donde se mostrará al usuario el tipo de error que se está cometiendo y el lugar exacto del mismo. 

## - Ventana Principal 


![](https://github.com/ifigueroa065/_OLC1_Proyecto1_201904013/blob/main/Documentation/assets/img1.png)


## -Puedes cargar tu archivo (olc) en el programa desde la funcion "archivo"


![](https://github.com/ifigueroa065/_OLC1_Proyecto1_201904013/blob/main/Documentation/assets/img2.png)


## -Generar Automata


![](https://github.com/ifigueroa065/_OLC1_Proyecto1_201904013/blob/main/Documentation/assets/img3.png)

## - Analizar entrada


![](https://github.com/ifigueroa065/_OLC1_Proyecto1_201904013/blob/main/Documentation/assets/img4.png)

## - Visualizar Grafos


![](https://github.com/ifigueroa065/_OLC1_Proyecto1_201904013/blob/main/Documentation/assets/img5.png)

   | **Funcion** | **Descripcion** |
   | ---------- | ----------------- |
   | Archivo   |Para esta funcion se desplegará un submenú en el cual el usuario debe de seleccionar _Abrir_  y se le mostraá una pestaña para seleccionar el archivo de entrada|
   | Generar Automata  | Generará el automata correspondiente al archivo de entrada |
   |Analizar entrada| Mostrará en el output el resultado de las cadenas ingresadas |
  | Ver Imágenes  | Mostrará las opciones disponibles luego de generar las gramáticas |
   |>| Mostrará la imagen siguiente correspondiente a la opción seleccionada en _Ver Imágenes_ |
  
     