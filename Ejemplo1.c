#include <stdio.h>
#include <pthread.h>
#include <sys/sysinfo.h>
#include <sys/statvfs.h>
#include <unistd.h>
#include <stdlib.h>
#include <termios.h>
#include <string.h>

int ejecutando = 1;

// Variables globales para almacenar los datos
long free_ram_global = 0;
unsigned long free_disk_global = 0;
unsigned long rx_speed_global = 0;
unsigned long tx_speed_global = 0;

// Función para limpiar la pantalla
void limpiar_pantalla() {
    system("clear");  // Limpiar la pantalla (en Linux)
}

// Función para monitorear el uso de la memoria RAM
void *monitorear_memoria_ram(void *arg) {
    struct sysinfo info;
    while (ejecutando) {
        sysinfo(&info);  // Obtener información del sistema
        free_ram_global = info.freeram / (1024 * 1024);     // Convertir a MB
        sleep(1); // Pausa de 1 segundo
    }
    pthread_exit(NULL);
}

// Función para monitorear la memoria ROM (disco)
void *monitorear_memoria_rom(void *arg) {
    struct statvfs stat;

    while (ejecutando) {
        if (statvfs("/", &stat) == 0) {
            free_disk_global = (stat.f_bfree * stat.f_frsize) / (1024 * 1024);    // Libre en MB
        }
        sleep(1); // Pausa de 1 segundo
    }
    pthread_exit(NULL);
}

// Función para monitorear la velocidad de red Wi-Fi
void *monitorear_red(void *arg) {
    FILE *file;
    char buffer[1024];
    unsigned long prev_rx_bytes = 0, prev_tx_bytes = 0;
    unsigned long rx_bytes, tx_bytes;

    while (ejecutando) {
        file = fopen("/proc/net/dev", "r");
        if (file != NULL) {
            // Saltar las dos primeras líneas de encabezado
            fgets(buffer, sizeof(buffer), file);
            fgets(buffer, sizeof(buffer), file);

            // Leer las estadísticas de cada interfaz de red
            while (fgets(buffer, sizeof(buffer), file) != NULL) {
                char interfaz[20];
                sscanf(buffer, "%s %lu %*d %*d %*d %*d %*d %*d %lu", interfaz, &rx_bytes, &tx_bytes);

                // Si la interfaz es "wlp0s20f3"
                if (strncmp(interfaz, "wlp0s20f3:", 10) == 0) {
                    rx_speed_global = (rx_bytes - prev_rx_bytes) * 8 / 1024 / 1024;  // Velocidad de descarga en Mbps
                    tx_speed_global = (tx_bytes - prev_tx_bytes) * 8 / 1024 / 1024;  // Velocidad de subida en Mbps

                    prev_rx_bytes = rx_bytes;
                    prev_tx_bytes = tx_bytes;
                    break;
                }
            }
            fclose(file);
        }
        sleep(1); // Pausa de 1 segundo
    }
    pthread_exit(NULL);
}

// Función para detectar la entrada del teclado (Enter)
void *detectar_entrada(void *arg) {
    struct termios oldt, newt;
    tcgetattr(STDIN_FILENO, &oldt);    // Guardar la configuración actual del terminal
    newt = oldt;
    newt.c_lflag &= ~(ICANON);         // Desactivar la entrada canónica
    tcsetattr(STDIN_FILENO, TCSANOW, &newt);
    getchar();                         // Esperar a que el usuario presione Enter
    ejecutando = 0;                    // Cambiar la variable global para detener la ejecución
    tcsetattr(STDIN_FILENO, TCSANOW, &oldt); // Restaurar la configuración original del terminal
    pthread_exit(NULL);
}

int main() {
    pthread_t hilos[4]; // Hilos para RAM, ROM, red y entrada del teclado

    // Crear hilo para monitorear la RAM
    pthread_create(&hilos[0], NULL, monitorear_memoria_ram, NULL);

    // Crear hilo para monitorear la memoria ROM (disco)
    pthread_create(&hilos[1], NULL, monitorear_memoria_rom, NULL);

    // Crear hilo para monitorear la red
    pthread_create(&hilos[2], NULL, monitorear_red, NULL);

    // Crear hilo para detectar la entrada del teclado
    pthread_create(&hilos[3], NULL, detectar_entrada, NULL);

    // Bucle principal que actualiza la pantalla
    while (ejecutando) {
        limpiar_pantalla();  // Limpiar la pantalla antes de mostrar los datos
        printf("Monitoreo del sistema:\n");
        printf("RAM Libre: %ld MB\n", free_ram_global);
        printf("Disco Libre: %lu MB\n", free_disk_global);
        printf("Velocidad Wi-Fi: Descarga: %lu Mbps, Subida: %lu Mbps\n", rx_speed_global, tx_speed_global);
        sleep(1);  // Pausa para esperar la actualización
    }

    // Esperar la finalización de los hilos
    for (int i = 0; i < 4; i++) {
        pthread_join(hilos[i], NULL);
    }

    printf("Monitoreo terminado.\n");

    return 0;
}
