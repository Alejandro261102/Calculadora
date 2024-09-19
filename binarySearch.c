/*Curso: Sistemas Operativos
(C) Septiembre 2024
Implementó: Papas con chile 


ESCOM-IPN
Programa que lee n numeros de una entrada Numeros_ordenados.txt
y realiza una busqueda de x elemento usando el algoritmo de busqueda binaria.

Compilación: gcc -o busquedaBinariahilos busquedaBinariahilos.c tiempo.c -pthread

Ejecucion: ./busquedaBinariahilos n x (n:tamaño del arreglo de numeros x:elemento a buscar)


RECUERDA AÑADIR UN ARCHIVO DE TEXTO LLAMADO Numeros_ordenado.txt, por obvias razones el archivo 
debe contener numeros ordenados.

*********************************************************/



#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define N_THREADS 3

int *numeros, n, x, *indices;

int busquedaBinaria(int l, int r, int *numeros, int dato);
void leerNumeros(int n, int *numeros);
void *procesarBusqueda(void *id);


int main(int argc, char *argv[]){


    //Designa memoria para N_TREADS hilos y para los indices
    pthread_t threads = (pthread_t) malloc(N_THREADS * sizeof(pthread_t));
    indices = (int *) malloc(N_THREADS * sizeof(int));
    
    int i, pos = -1;


    if(argc != 3){
        printf("ERROR: Numeros de parametros incorrecto\n");
        exit(1);
    }

    n = atoi(argv[1]);
    x = atoi(argv[2]);

    numeros = (int*) malloc(n * sizeof(int));

    if(numeros == NULL){
        printf("ERROR: No se ha podido crear el arreglo de numeros\n");
        exit(1);
    }

    leerNumeros(n, numeros);


    
    //Creacion de los hilos de ejecuciòn
    for(i = 1; i<N_THREADS; i++){
        if(pthread_create(&threads[i], NULL, procesarBusqueda, (void*)i) != 0){
            perror("El thread no  pudo crearse");
			exit(-1);
        }
    }
    procesarBusqueda(0);
    
    for (i=1; i<N_THREADS; i++) pthread_join (threads[i], NULL);

    for(i = 0; i<N_THREADS && pos == -1; i++) if(indices[i] != -1) pos = indices[i];
/////////////////////////////////////////////////////////////////////////////////////////
    

    //Resultados de la busqueda.
    printf("Numero buscado: %d, N: %d\nResultado: ", x, n);
    
    if(pos == -1)
        printf("%d no esta en el arreglo\n", x);
    else
        printf("%d ha sido encontrado en la posicion %d\n", x, pos);
  
  
    free(numeros);

    return 0;
}
/*******************************************************************************
int busquedaBinaria(int n, int *A, int dato) 
Recibe: int[] arreglo de números, int número de elementos del arreglo
Devuelve: int, el indice en el arreglo donde se encuentra el elemento a buscar
Observaciones: Implementa el algoritmo de busqueda binaria, Funciona dividiendo 
repetidamente a la mitad la parte de la lista en la que podría encontrarse el 
elemento, hasta reducir el rango de búsqueda a uno. 
*******************************************************************************/

int busquedaBinaria(int l, int r, int *numeros, int dato){
    int izq = l, der = r, mitad;

    while(izq <= der){
        mitad = (izq + der) / 2;
        if(numeros[mitad] == dato){
            return mitad;
        }
        else if(numeros[mitad] > dato){
            der = mitad - 1;
        }
        else{
            izq = mitad + 1;
        }
    }

    return -1;
}



void leerNumeros(int n, int *numeros){

    FILE *archivo_numeros;
    int i;

    archivo_numeros = fopen("Numeros_ordenados.txt", "r");

    if(archivo_numeros == NULL){
        printf("ERROR: No se ha podido abrir el archivo de numeros\n");
        exit(1);
    }

    for(i = 0; i < n; i++){
        fscanf(archivo_numeros, "%d\n", numeros + i);
    }

    fclose(archivo_numeros);
}

void *procesarBusqueda(void *id){
    int nthThread = (int) id;    
    int l, r;

    l = (nthThread * n )/N_THREADS;
    r = (nthThread == N_THREADS - 1)? n : ((nthThread +  1) * n) / N_THREADS;

    indices[nthThread] = busquedaBinaria(l, r, numeros, x);
}