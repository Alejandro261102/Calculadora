#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE_LENGTH 256

// Estructura para pasar datos a los hilos
typedef struct {
    char *filename;
    char *search_term;
} hilo_data;

// Función que será ejecutada por cada hilo para buscar la palabra en un archivo
void *buscar_palabra(void *arg) {
    hilo_data *data = (hilo_data *) arg;
    FILE *file = fopen(data->filename, "r");
    if (file == NULL) {
        perror("Error al abrir el archivo");
        pthread_exit(NULL);
    }
    
    printf("Buscando '%s' en %s\n", data->search_term, data->filename);
    char line[MAX_LINE_LENGTH];
    int line_number = 1;
    int found = 0;
    
    while (fgets(line, sizeof(line), file)) {
        if (strstr(line, data->search_term) != NULL) {
            printf("Se encontro en %s, la palabra %s\n", data->filename, data->search_term);
            found = 1;
        }
        line_number++;
    }
    
    if (!found) {
        printf("No se encontró en %s\n", data->filename);
    }
    
    fclose(file);
    pthread_exit(NULL);
}

int main() {
    pthread_t hilos[3];
    hilo_data datos[3];
    char search_term[100];
    
    // Solicitar al usuario la palabra a buscar
    printf("Ingrese la palabra a buscar: ");
    scanf("%s", search_term);
    
    printf("\n\n");

    // Datos para los hilos
    datos[0].filename = "frutas.txt";
    datos[0].search_term = search_term;
    
    datos[1].filename = "nombres.txt";
    datos[1].search_term = search_term;
    
    datos[2].filename = "ciudades.txt";
    datos[2].search_term = search_term;
    
    // Crear hilos para buscar la palabra en los archivos
    for (int i = 0; i < 3; i++) {
        pthread_create(&hilos[i], NULL, buscar_palabra, (void *) &datos[i]);
    }
    
    // Esperar la finalización de los hilos
    for (int i = 0; i < 3; i++) {
        pthread_join(hilos[i], NULL);
    }
    
    return 0;
}
