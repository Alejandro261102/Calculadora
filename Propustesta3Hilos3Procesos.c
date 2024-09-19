/*Curso: Sistemas Operativos
(C) Septiembre 2024
Implementó: Papas con chile 

Programa que mediante 3 hilos se realiza la multiplicacion de 2 matrices de 3 x 3, 
donde hay 3 hilos y cada hilo se encarga de multiplicar cada columna por fila*/

#include <stdio.h>
#include <pthread.h>

// Definir el tamaño de las matrices
#define N 3

// Definimos el valor de las matrices a multiplicar
int A[N][N] = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9}
};

int B[N][N] = {
    {9, 8, 7},
    {6, 5, 4},
    {3, 2, 1}
};

// Matriz resultado
int C[N][N];

// Estructura para pasar los datos a los hilos
typedef struct {
    int fila; // Fila que el hilo va a calcular
} datos_hilo;

// Función que calculará una fila de la matriz resultante
void *multiplicar_fila(void *arg) {
    datos_hilo *datos = (datos_hilo *)arg;
    int fila = datos->fila;

    // Calcular los elementos de la fila
    for (int j = 0; j < N; j++) {
        C[fila][j] = 0; // Inicializar el elemento
        for (int k = 0; k < N; k++) {
            C[fila][j] += A[fila][k] * B[k][j];
        }
    }

    // Mensaje indicando que el hilo ha terminado
    printf("El hilo %d ha terminado su proceso\n", fila + 1);

    pthread_exit(NULL);
}

int main() {
    pthread_t hilos[N];  // Arreglo para almacenar los identificadores de los hilos
    datos_hilo datos[N]; // Estructuras de datos para cada hilo

    // Crear los hilos
    for (int i = 0; i < N; i++) {
        datos[i].fila = i; // Asignar la fila a cada hilo
        pthread_create(&hilos[i], NULL, multiplicar_fila, (void *)&datos[i]);
    }

    // Esperar a que los hilos terminen
    for (int i = 0; i < N; i++) {
        pthread_join(hilos[i], NULL);
    }

    // Imprimir la matriz resultado
    printf("Resultado de la multiplicación de matrices:\n");
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            printf("%d ", C[i][j]);
        }
        printf("\n");
    }

    return 0;
}