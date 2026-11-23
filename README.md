# Implementación de Odoo 19 Community con Docker y PostgreSQL

- **Universidad Nacional Agraria de la Selva (UNAS)**
- Facultad de Ingeniería en Informática y Sistemas (FIIS)
- Curso: Arquitectura de Software
- Evaluación: Parcial 3
- Docente: Hubel Solis Bonifacio
- Tingo María, Perú — Noviembre de 2026

## Integrantes (orden alfabético)

1. Huayllacayan Chagua, Zadid
2. Lopez Avila, Abigail
3. Loreña Castro, Abdias

## 1. Descripción

Este repositorio contiene la configuración utilizada para implementar
Odoo 19 Community desde el código fuente oficial de GitHub,
mediante Docker Compose y PostgreSQL 16.

La práctica estudia la arquitectura monolítica modular de Odoo:
el núcleo y sus addons funcionan dentro de un mismo servidor,
mientras PostgreSQL proporciona la persistencia.

La configuración fue utilizada en una computadora Windows
con Docker Desktop.

## 2. Arquitectura

- Odoo 19 Community: servidor Python 3.12.
- PostgreSQL 16: base de datos relacional.
- Docker Compose: coordinación de los servicios.
- Volumen pgdata: persistencia de PostgreSQL.
- Volumen odoo-data: filestore y archivos de Odoo.
- wkhtmltopdf: generación de reportes PDF.

Puertos publicados solamente en localhost:

| Servicio | Host | Contenedor |
|---|---|---|
| Odoo | 8070 | 8069 |
| PostgreSQL | 5436 | 5432 |

Se utiliza una imagen Odoo personalizada construida con Dockerfile.
No se utiliza una imagen oficial preinstalada de Odoo.

## 3. Requisitos

- Windows con Docker Desktop funcionando en modo Linux.
- Git.
- PowerShell.
- Acceso a Internet durante la descarga y construcción.
- Arquitectura x86-64/amd64 para el paquete PDF utilizado.

El entorno original se comprobó con Docker Engine 29.7.2.
La construcción necesita recursos y espacio libre suficientes.

## 4. Clonar este repositorio

Abrir PowerShell:

```powershell
git clone https://github.com/zadidhc/odoo19-community-arquitectura-parcial3.git
cd odoo19-community-arquitectura-parcial3
```

## 5. Descargar el código fuente oficial

El código completo de Odoo no se duplica dentro de este repositorio.
Se descarga desde https://github.com/odoo/odoo.

Rama utilizada: 19.0

Commit verificado en la práctica:

b155a99fd5881fde0d5c182a523b1bd2e541f74e

Revisar y ejecutar el script de preparación:

```powershell
Get-Content .\preparar-odoo.ps1
Set-ExecutionPolicy -Scope Process RemoteSigned
.\preparar-odoo.ps1
```

El script clona Odoo y selecciona el commit exacto.
Si GitHub no permite obtener ese commit o falla la descarga,
la preparación se detiene sin construir una versión diferente.

Comprobar:

```powershell
git -C .\odoo rev-parse HEAD
Test-Path .\odoo\odoo-bin
```

## 6. Configurar el entorno

Crear el archivo local .env a partir de la plantilla,
generando una contraseña exclusiva para esta instalación:

```powershell
Copy-Item .env.example .env
$clave = [guid]::NewGuid().ToString("N")
"POSTGRES_PASSWORD=$clave" | Set-Content .env -Encoding ascii
```

No publicar .env ni revelar su contraseña.

## 7. Validar y construir Docker

Con Docker Desktop iniciado:

```powershell
docker compose config --quiet
docker compose build odoo
docker compose up -d
docker compose ps
```

La construcción descarga dependencias de sistema, paquetes Python,
el código de Odoo y wkhtmltopdf.

La contraseña de PostgreSQL se obtiene de .env.

## 8. Abrir Odoo

Ingresar en el navegador:

http://localhost:8070

Si la base de datos todavía no existe, realizar la configuración
inicial de Odoo desde su asistente de creación de base de datos.

Nombre utilizado en la práctica:

odoo_parcial3

Utilizar una contraseña administrativa nueva y guardar
las credenciales de forma privada.

Al terminar la inicialización, acceder a Odoo e instalar
las aplicaciones Contactos y Ventas.

En una instalación nueva no se incluyen automáticamente
los registros comerciales creados en la práctica original.

## 9. Verificar el funcionamiento

```powershell
docker compose ps
```

Verificar el acceso HTTP:

```powershell
Invoke-WebRequest http://127.0.0.1:8070/web/login -UseBasicParsing
```

Comprobar el generador de PDF:

```powershell
docker compose exec -T odoo wkhtmltopdf --version
```

Consultar los registros del servidor:

```powershell
docker compose logs --tail 50 odoo
```

Comprobar los módulos en PostgreSQL, después de crear la base:

```powershell
docker compose exec -T db psql -U odoo -d odoo_parcial3 -c "SELECT name, state FROM ir_module_module WHERE name IN ('contacts','sale');"
```

## 10. Demostración de Ventas

En la práctica original se realizaron estas actividades:

1. Instalación de Contactos y Ventas.
2. Configuración de una empresa de demostración en PEN.
3. Registro de los productos ALN01 y CNJ01.
4. Creación de la plantilla comercial Lámparas LED.
5. Registro de la cotización S00021 por S/ 53,10.
6. Generación de PDF con diseño Boxed.
7. Duplicación de S00021 para obtener S00022.
8. Confirmación de S00022 como orden de venta.
9. Verificación de persistencia mediante PostgreSQL.

Estos identificadores e importes corresponden al entorno original.
Una base nueva no garantiza los mismos números de secuencia ni
recrea los productos, clientes o cotizaciones automáticamente.

No se documentó una factura emitida ni un pago recibido.

## 11. Persistencia

Los datos se almacenan en dos volúmenes Docker:

- pgdata
- odoo-data

Recrear el contenedor no implica borrar estos volúmenes.

IMPORTANTE: no usar `docker compose down -v` si se necesita
conservar la información. Ese comando puede eliminar los volúmenes.

Para trasladar la demostración original es necesario realizar
un respaldo compatible de la base de datos y del filestore,
y restaurarlo siguiendo un procedimiento independiente.

## 12. Comandos de administración

Detener sin eliminar los volúmenes:

```powershell
docker compose stop
```

Volver a iniciar contenedores existentes:

```powershell
docker compose start
```

Revisar el estado:

```powershell
docker compose ps
```

Después de cambiar el código fuente incorporado a la imagen,
es necesario reconstruir la imagen y recrear el servicio Odoo.

## 13. Alcance y limitaciones

La instalación original fue comprobada localmente con Odoo 19,
PostgreSQL 16, Contactos y Ventas.

Este repositorio presenta los archivos necesarios para reproducir
el despliegue, sujeto a la disponibilidad de GitHub, las imágenes
base, las dependencias externas y los recursos del equipo.

La validación de una clonación limpia es una comprobación
adicional a la ejecución de la instancia original.

La configuración está orientada a una práctica académica local;
no representa un despliegue endurecido para producción.

## 14. Referencias

- Código fuente oficial: https://github.com/odoo/odoo
- Documentación Odoo: https://www.odoo.com/documentation/19.0/
- Docker: https://docs.docker.com/
- PostgreSQL: https://www.postgresql.org/docs/

## Documentación de la entrega

En la carpeta `documentacion/` se incluyen:

- [Informe corregido del Parcial 3](documentacion/Informe_Parcial3_Odoo19_Corregido.docx)
- [Presentación del Parcial 3](documentacion/Presentacion_Parcial3_Odoo19.pptx)

El informe explica la arquitectura, implementación, pruebas
y demostración del proyecto Odoo 19 Community.

La presentación resume el trabajo para su exposición académica.
