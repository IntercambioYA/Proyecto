#!/bin/bash





LOG_FILE="/var/log/historial_respaldo.log"
SCRIPT_NAME=$(basename "$0")


verificar_admin() {
    
    if [ ! -w "." ]; then
        echo "=================================================================="
        echo "                    ERROR DE PERMISOS"
        echo "=================================================================="
        echo "No se tienen permisos de escritura en el directorio actual."
        echo "Verifique los permisos del directorio."
        echo "=================================================================="
        exit 1
    fi

    echo "=================================================================="
    echo "       SISTEMA DE ADMINISTRACIÓN INICIADO CORRECTAMENTE"
    echo "=================================================================="
    echo "Usuario: $(whoami)"
    echo "Directorio: $(pwd)"
    echo "=================================================================="
}


configurar_log() {
    
    local log_original="/var/log/historial_respaldo.log"
    local log_fallback="./historial_respaldo.log"

    
    if [ -w "/var/log" ] || [ ! -d "/var/log" ] && mkdir -p "/var/log" 2>/dev/null; then
        LOG_FILE="$log_original"
        echo "Usando log en: $LOG_FILE"
    else
        LOG_FILE="$log_fallback"
        echo "No se puede escribir en /var/log, usando log local: $LOG_FILE"
    fi

   
    mkdir -p "$(dirname "$LOG_FILE")" 2>/dev/null

    
    if [ ! -f "$LOG_FILE" ]; then
        touch "$LOG_FILE" 2>/dev/null || {
            LOG_FILE="$log_fallback"
            echo "Fallback: Usando log local: $LOG_FILE"
            mkdir -p "$(dirname "$LOG_FILE")"
            touch "$LOG_FILE"
        }
    fi

    
    chmod 644 "$LOG_FILE" 2>/dev/null || chmod 644 "$LOG_FILE"

   
    echo "$(date '+%Y-%m-%d %H:%M:%S') - CONFIGURACION: Log configurado en $LOG_FILE" >> "$LOG_FILE"
}


log_action() {
    local mensaje="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $mensaje" >> "$LOG_FILE"
}


verificar_existencia() {
    local ruta="$1"
    local tipo="$2"  # "archivo" o "directorio"

    if [ "$tipo" = "archivo" ]; then
        if [ ! -f "$ruta" ]; then
            echo "Error: El archivo '$ruta' no existe."
            return 1
        fi
    elif [ "$tipo" = "directorio" ]; then
        if [ ! -d "$ruta" ]; then
            echo "Error: El directorio '$ruta' no existe."
            return 1
        fi
    else
        if [ ! -e "$ruta" ]; then
            echo "Error: La ruta '$ruta' no existe."
            return 1
        fi
    fi
    return 0
}


comprimir() {
    echo "=================================================================="
    echo "                     COMPRIMIR ARCHIVO/DIRECTORIO"
    echo "=================================================================="

    read -p "Ingrese la ruta del archivo o directorio a comprimir: " origen

    if ! verificar_existencia "$origen" "cualquiera"; then
        log_action "ERROR: Intento de comprimir ruta inexistente: $origen"
        return 1
    fi

    read -p "Ingrese el nombre del archivo comprimido (sin extensión): " nombre_archivo

    
    if [[ ! "$nombre_archivo" =~ \.tar\.gz$ ]]; then
        nombre_archivo="${nombre_archivo}.tar.gz"
    fi

    echo "Comprimiendo '$origen' en '$nombre_archivo'..."

    if tar -czf "$nombre_archivo" -C "$(dirname "$origen")" "$(basename "$origen")" 2>/dev/null; then
        echo "✓ Compresión exitosa: $nombre_archivo"
        log_action "COMPRESION: $origen -> $nombre_archivo (EXITOSO)"
    else
        echo "✗ Error al comprimir el archivo"
        log_action "ERROR: Fallo al comprimir $origen -> $nombre_archivo"
        return 1
    fi

    echo "=================================================================="
    read -p "Presione Enter para continuar..."
}


listar() {
    echo "=================================================================="
    echo "                     LISTAR CONTENIDO DE ARCHIVO"
    echo "=================================================================="

    read -p "Ingrese la ruta del archivo .tar.gz: " archivo_comprimido

    if ! verificar_existencia "$archivo_comprimido" "archivo"; then
        log_action "ERROR: Intento de listar archivo inexistente: $archivo_comprimido"
        return 1
    fi

    
    if ! [[ "$archivo_comprimido" =~ \.tar\.gz$ ]]; then
        echo "Advertencia: El archivo no tiene extensión .tar.gz"
    fi

    echo "Contenido de '$archivo_comprimido':"
    echo "------------------------------------------------------------------"

    if tar -tzf "$archivo_comprimido" 2>/dev/null; then
        log_action "LISTADO: $archivo_comprimido (EXITOSO)"
    else
        echo "✗ Error: No se puede leer el archivo o está corrupto"
        log_action "ERROR: Fallo al listar contenido de $archivo_comprimido"
        return 1
    fi

    echo "=================================================================="
    read -p "Presione Enter para continuar..."
}


descomprimir() {
    echo "=================================================================="
    echo "                     DESCOMPRIMIR ARCHIVO"
    echo "=================================================================="

    read -p "Ingrese la ruta del archivo .tar.gz: " archivo_comprimido

    if ! verificar_existencia "$archivo_comprimido" "archivo"; then
        log_action "ERROR: Intento de descomprimir archivo inexistente: $archivo_comprimido"
        return 1
    fi

    read -p "Ingrese el directorio de destino (presione Enter para usar el directorio actual): " destino

    
    if [ -z "$destino" ]; then
        destino="."
    fi

    
    if [ ! -d "$destino" ]; then
        echo "Creando directorio de destino: $destino"
        mkdir -p "$destino"
    fi

    echo "Descomprimiendo '$archivo_comprimido' en '$destino'..."

    if tar -xzf "$archivo_comprimido" -C "$destino" 2>/dev/null; then
        echo "✓ Descompresión exitosa en: $destino"
        log_action "DESCOMPRESION: $archivo_comprimido -> $destino (EXITOSO)"
    else
        echo "✗ Error al descomprimir el archivo"
        log_action "ERROR: Fallo al descomprimir $archivo_comprimido -> $destino"
        return 1
    fi

    echo "=================================================================="
    read -p "Presione Enter para continuar..."
}


menu_respaldo() {
    while true; do
        clear
        echo "=================================================================="
        echo "                        MENU DE RESPALDO"
        echo "=================================================================="
        echo "1. Comprimir archivo/directorio"
        echo "2. Listar contenido de archivo comprimido"
        echo "3. Descomprimir archivo"
        echo "4. Volver al menú principal"
        echo "=================================================================="
        read -p "Seleccione una opción [1-4]: " opcion_respaldo

        case $opcion_respaldo in
            1)
                comprimir
                ;;
            2)
                listar
                ;;
            3)
                descomprimir
                ;;
            4)
                log_action "MENU: Salida del submenú de respaldo"
                break
                ;;
            *)
                echo "Opción inválida. Por favor, seleccione una opción del 1 al 4."
                read -p "Presione Enter para continuar..."
                ;;
        esac
    done
}


info_sistema() {
    echo "=================================================================="
    echo "                    INFORMACIÓN DEL SISTEMA"
    echo "=================================================================="
    echo "Usuario actual: $(whoami)"
    echo "Fecha y hora: $(date)"
    echo "Sistema operativo: $(uname -a)"
    echo "Espacio en disco:"
    df -h
    echo "=================================================================="
    read -p "Presione Enter para continuar..."
}


menu_principal() {
    while true; do
        clear
        echo "=================================================================="
        echo "                    SISTEMA DE ADMINISTRACIÓN"
        echo "                         MENÚ PRINCIPAL"
        echo "=================================================================="
        echo "1. Respaldo"
        echo "2. Información del Sistema"
        echo "3. Ver log de respaldos"
        echo "4. Salir"
        echo "=================================================================="
        read -p "Seleccione una opción [1-4]: " opcion_principal

        case $opcion_principal in
            1)
                log_action "MENU: Acceso al submenú de respaldo"
                menu_respaldo
                ;;
            2)
                info_sistema
                ;;
            3)
                echo "=================================================================="
                echo "                    HISTORIAL DE RESPALDOS"
                echo "=================================================================="
                if [ -f "$LOG_FILE" ]; then
                    cat "$LOG_FILE"
                else
                    echo "No hay historial de respaldos disponible."
                fi
                echo "=================================================================="
                read -p "Presione Enter para continuar..."
                ;;
            4)
                echo "Saliendo del sistema..."
                log_action "SISTEMA: Salida del sistema de administración"
                exit 0
                ;;
            *)
                echo "Opción inválida. Por favor, seleccione una opción del 1 al 4."
                read -p "Presione Enter para continuar..."
                ;;
        esac
    done
}


main() {
    
    verificar_admin

    
    configurar_log

    
    log_action "SISTEMA: Inicio del sistema de administración por usuario $(whoami)"

    
    menu_principal
}


main "$@"