# :diamond_shape_with_a_dot_inside: MANUAL DE USUARIO  :diamond_shape_with_a_dot_inside:



<div id='introduccion'/>

##  :arrow_lower_right: Introducción 
El programa cuenta con la implementación de una interfaz gráfica para el usuario, en la cual la interacción es amigable y compresible. Fue diseñada con una arquitectura simple. Este programa es de tipo _Interprete_ que permite la validación de cadenas por medio de un archivo de entrada de tipo .tw

<div id='descrip'/>

## Descripción :arrow_down:

  - **Estructura de Almacenamiento**: 
Para cada lectura de un archivo de entrada se utilizaron listas ArrayList así como LinkedList para la implementacion correcta de las gramáticas ingresadas.

  - **Palabras Reservadas**:
El programa cuenta con palabras reservadas como: _Main_ la cual indica el inicio de un nuevo conjunto de caracteres
  
 

<div id='apli'/>

## Aplicación :white_check_mark:
### Interfaz Gráfica (GUI)
El programa cuenta con una vista gráfica la cual facilita la interacción entre el sistema y el usuario final para un mejor desempeño del mismo. Por medio de dicha interfaz, al usuario se le permite seleccionar de forma _gráfica_ una archivo de entrada que contendrá la entrada a analizar. El usuario puede navegar por la aplicación seleccionando a través de botones la acción que desea realizar, si ocurre un error en el ingreso de datos el programa creara una sección donde se mostrará al usuario el tipo de error que se está cometiendo y el lugar exacto del mismo. 

## - Home 


![](https://github.com/ifigueroa065/_OLC1_Proyecto2_201904013/blob/main/Documentation/assets/img1.png)

## - Puedes testear la aplicación con este archivo :point_down:
```C

double r_toRadians;
double r_sine;
void toRadians(double angle) {
    r_toRadians = angle * 3.141592653589793 / 180;
}

void sine(double x) {
    double sin = 0.0;
    int fact;
    int i = 1;
    while (i <= 10) {
        fact = 1;
        int j = 1;
        while (j <= 2 * i - 1) {
            fact = fact * j;
            j = j + 1;
        }
        sin = sin + ((x^(2*i-1)) / fact);
        i = i + 1;
    }
    r_sine = sin;
}

void drawTree(double x1, double y1, double angle, int depth) {
    if (depth != 0) {
        toRadians(angle);
        sine(3.141592653589793 / 2 + r_toRadians);
        double x2 = x1 + (r_sine * depth * 10.0);
        toRadians(angle);
        sine(r_toRadians);
        double y2 = y1 + (r_sine * depth * 10.0);
        Print(x1 + " " + y1 + " " + x2 + " " + y2 + "");
        drawTree(x2, y2, angle - 20, depth - 1);
        drawTree(x2, y2, angle + 20, depth - 1);
    }

}

void Principal() {
    Print("===============¿SI SALE?=================");
    drawTree(250.0, 500.0, -90.0, 4);
    Print("================ FIN ====================");
}

main Principal();

/*
-------------------------SALIDAD ESPERADA----------------------
===============¿SI SALE?=================
250 500 250 407.9480439077082
250 407.9480439077082 239.31406202799965 307.8471746908033
239.31406202799965 307.8471746908033 224.18926216484266 212.19110133437974
224.18926216484266 212.19110133437974 211.6955916596029 144.01486829323312
224.18926216484266 212.19110133437974 220.62728284084255 178.82414492874477
239.31406202799965 307.8471746908033 239.31406202799965 261.8211966446574
239.31406202799965 261.8211966446574 235.75208270399955 228.45424023902243
239.31406202799965 261.8211966446574 242.87604135199976 246.32952396143438
250 407.9480439077082 260.6859379720004 361.47302585803914
260.6859379720004 361.47302585803914 260.6859379720004 315.44704781189324
260.6859379720004 315.44704781189324 257.12395864800027 282.08009140625825
260.6859379720004 315.44704781189324 264.2479172960005 299.9553751286702
260.6859379720004 361.47302585803914 275.81073783515734 341.71859712289154
275.81073783515734 341.71859712289154 279.37271715915745 326.2269244396685
275.81073783515734 341.71859712289154 288.3044083403971 336.24006238401114
================ FIN ====================
*/
```


## -Puedes cargar tu archivo (.tw) en el programa desde la funcion "abrir"


![](https://github.com/ifigueroa065/_OLC1_Proyecto2_201904013/blob/main/Documentation/assets/img2.png)



## - Output


![](https://github.com/ifigueroa065/_OLC1_Proyecto2_201904013/blob/main/Documentation/assets/img3.png)

## - Reporte de Errores


![](https://github.com/ifigueroa065/_OLC1_Proyecto2_201904013/blob/main/Documentation/assets/img4.png)

## - Visualizar AST


![](https://github.com/ifigueroa065/_OLC1_Proyecto2_201904013/blob/main/Documentation/assets/img5.png)

   | **Funcion** | **Descripcion** |
   | ---------- | ----------------- |
   | Home   | Página inicial del proyecto|
   | Abrir   |se le mostrará una pestaña para seleccionar el archivo de entrada|
   | Analizar | Llevará el análisis del archivo de entrada previamente cargado |
   | Reporte | Mostrará en el output el resultado de las cadenas ingresadas |
  | AST | Mostrará el AST generado  |
   
  
     
