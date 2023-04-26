//? ANALIZADOR DEL AST PARA GENERAR CODIGO DE GRAPHVIZ

function Graphviz(raiz){
    let contador = 0
    var salida = "digraph G{" + "\n"
    salida +="bgcolor= lightblue;"
    salida +="node[style=filled fillcolor= \"#36941c \" fontname=\" Comic Sans MS \" color=\"#36941c \"];"
    salida +="Raiz[label=\"" + raiz.valor + "\"];\n"
    salida += "Raiz[label=\"" + raiz.valor + "\"];\n"
    conectar("Raiz", raiz)
    salida += "}";
    return salida;




    function conectar(nombrePadre, padre){
        if(padre === undefined || padre === null || padre.hijos.length === 0) {        
            return
        }else{
            //console.log(padre.hijos)
            padre.hijos.forEach(
                temp=> {
                    if(temp == undefined){

                    }else{
                        let hijo = "N" + contador
                        salida += hijo +"[label=\"" + temp.valor + "\"];\n";
                        salida += nombrePadre + "->" + hijo +";\n";
                        contador++
                        conectar(hijo, temp);
                    }
                }
            )
        }
      }
    
}




module.exports = Graphviz