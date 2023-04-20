//Operaciones relacionañes, logicas y aritmeticas
const TIPO_OPERACION = {
    //Aritmeticas
    SUMA: 'SUMA',
    RESTA: 'RESTA',
    MULTIPLICACION: 'MULTIPLICACION',
    DIVISION: 'DIVISION',
    POTENCIA: 'POTENCIA',
    MODULO: 'MODULO',
    UNARIO: 'UNARIO',
    //Relacionales
    IGUAL: 'IGUAL',
    DESIGUAL: 'DESIGUAL',
    MENORIGUAL: 'MENORIGUAL',
    MAYORIGUAL: 'MAYORIGUAL',
    MENOR: 'MENOR',
    MAYOR: 'MAYOR',
    TERNARIO: 'TERNARIO',
    //Logicas
    AND: 'AND',
    OR: 'OR',
    NOT: 'NOT',
    //Otros
    CASTEO: 'CASTEO',
    INCREMENTO: 'INCREMENTO',
    DECREMENTO: 'DECREMENTO'
}

module.exports = TIPO_OPERACION