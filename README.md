# Práctica de Analizador Léxico

> Sintaxis y expresiones regulares

1. Escribir expresiones regulares para los siguientes elementos devolviendo un par (token/lexema) por cada una de ellas. ¿Existen tokens que generen lexemas diferentes?

a) Códigos postales. (Por ej.: 1234, 8366, etc., pero no 422 o 0027).

b) Número de Patentes Mercosur

c) Comentarios acotados por /* y */. Σ = {letras, *, /}

d) Identificadores de cualquier longitud que comiencen con una letra y contengan letras, dígitos o guiones. No pueden terminar con guion.

e) Ídem anterior pero que no contengan dos guiones seguidos

f) Constantes en otras bases como las del lenguaje C

g) Constantes aritméticas enteras. Controlar el rango permitido.

h) Constantes reales con formato xx.xx, controlando el rango permitido.

i) Constantes “string” de la forma “texto “

j) Palabras reservadas (IF-WHILE-DECVAR-ENDDEC-INTEGER-FLOAT-WRITE)

k) Operadores lógicos y operadores aritméticos básicos

l) Constantes en otras bases como en el lenguaje C (0b1100, 0xFF111, 0o1234567)

2. Dado el siguiente fragmento de código:

```
DECVAR
  contador: Integer;
  promedio: Float;
  actual, suma: Float;
ENDDEC

write "Hola mundo!";

contador: 0;

actual: 999;
suma: 02;
contador: contador+1;
while (contador <= 92) {
  contador: contador + 1;
  actual: (contador/0.342) + (contador*contador);
  suma: suma + actual;
}

write "La suma es: ";
write suma;

if (actual > 2){
  write "2 > 3";
}
if (actual < 3){
  if(actual >= 3){
    write "soy true";
  }
  if(actual <= 3){
    write "soy true";
  }
  if(actual != 3){
    write "soy true";
  }
  if(actual == 3){
    write "soy true";
  }
} else {
  actual: 333.3333;
}
```

a) Determinar los elementos léxicos y escribir una expresión regular para cada uno de éstos

b) Utilizar FLEX para probar el fragmento de programa anterior con las expresiones regulares definidas en el punto a)

c) Escribir una tabla de símbolos para los lexemas que correspondan