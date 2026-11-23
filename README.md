# Implementación de Odoo 19 Community con Docker y PostgreSQL

**Universidad Nacional Agraria de la Selva (UNAS)**

- **Facultad:** Ingeniería en Informática y Sistemas (FIIS)
- **Curso:** Arquitectura de Software
- **Evaluación:** Parcial 3
- **Docente:** Hubel Solis Bonifacio
- **Lugar:** Tingo María, Perú
- **Fecha:** Noviembre de 2026

## Integrantes

Integrantes del equipo, ordenados alfabéticamente por primer apellido:

1. **Huayllacayan Chagua, Zadid**
2. **Lopez Avila, Abigail**
3. **Loreña Castro, Abdias**

---

## 1. Presentación del proyecto

Este repositorio contiene la configuración y documentación de
una implementación académica de **Odoo 19 Community** realizada
a partir de su código fuente oficial de GitHub.

La aplicación fue implementada localmente en Windows mediante
Docker Desktop, utilizando Python 3.12 y PostgreSQL 16.

El trabajo permite estudiar la arquitectura de Odoo,
su despliegue en contenedores, la conexión con PostgreSQL,
la persistencia de información y el uso del módulo de Ventas.

**Este repositorio no contiene una aplicación Odoo desarrollada
desde cero por el equipo.** El equipo configuró y desplegó
el software libre Odoo Community para fines académicos.

## 2. Contenido del repositorio

| Archivo o carpeta | Descripción |
|---|---|
| `README.md` | Guía de instalación, arquitectura y verificación |
| `Dockerfile` | Construcción de la imagen personalizada de Odoo 19 |
| `compose.yaml` | Configuración de los servicios Odoo y PostgreSQL |
| `.dockerignore` | Exclusiones del contexto de construcción Docker |
| `.gitignore` | Exclusiones de Git para archivos privados y temporales |
| `.env.example` | Plantilla para configurar la contraseña PostgreSQL |
| `preparar-odoo.ps1` | Descarga y verifica la versión exacta de Odoo |
| `documentacion/` | Informe Word y presentación PowerPoint del proyecto |

### Informe Word

**[Abrir el informe corregido del Parcial 3](documentacion/Informe_Parcial3_Odoo19_Corregido.docx)**

El documento presenta la explicación académica de la arquitectura,
la preparación del entorno, la implementación local, las
verificaciones y la demostración del módulo de Ventas.

### Presentación PowerPoint

**[Abrir la presentación del Parcial 3](documentacion/Presentacion_Parcial3_Odoo19.pptx)**

La presentación resume el trabajo realizado y sirve de apoyo
para la exposición del proyecto.

**Importante:** el Word y el PowerPoint documentan la práctica
realizada en la computadora del equipo. Las capturas, productos,
cotizaciones y demás datos mostrados corresponden al entorno
original, no a una base de datos nueva.

## 3. Procedencia del código fuente

El código de Odoo se obtuvo del repositorio oficial:

https://github.com/odoo/odoo

- **Edición:** Odoo 19 Community
- **Rama utilizada:** `19.0`
- **Commit exacto:**

`b155a99fd5881fde0d5c182a523b1bd2e541f74e`

Este identificador corresponde a un commit existente
en el repositorio oficial de Odoo.

**El equipo no realizó commits en el repositorio oficial
de Odoo ni modificó su código fuente para esta práctica.**

Existen dos repositorios diferentes:

1. **Repositorio oficial:** `github.com/odoo/odoo`
2. **Repositorio del equipo:**
   `github.com/zadidhc/odoo19-community-arquitectura-parcial3`

El repositorio del equipo contiene la configuración Docker,
el script de preparación y la documentación académica.

Para evitar duplicar el código fuente completo de Odoo,
se proporciona `preparar-odoo.ps1`, que descarga la versión
oficial identificada por el commit indicado.

## 4. Arquitectura de la solución

La aplicación utiliza una arquitectura monolítica modular.

Odoo integra su núcleo y sus módulos funcionales en un mismo
servidor de aplicación. PostgreSQL se ejecuta como un
servicio independiente para almacenar información.

Esquema general:

```text
Navegador web
      |
      | http://localhost:8070
      v
+---------------------------+
| Contenedor Odoo 19        |
| Python 3.12               |
| Nucleo + addons           |
| Puerto interno: 8069      |
+---------------------------+
      |
      | Conexion interna
      | db:5432
      v
+---------------------------+
| Contenedor PostgreSQL 16  |
| Base de datos relacional  |
| Puerto interno: 5432      |
+---------------------------+

Persistencia:
- Volumen pgdata
- Volumen odoo-data
```

### Tecnologías empleadas

| Tecnología | Función |
|---|---|
| Odoo 19 Community | Sistema ERP |
| Python 3.12 | Ejecución del servidor de aplicación |
| PostgreSQL 16 | Base de datos |
| Docker | Contenedores |
| Docker Compose | Coordinación de servicios |
| Git y GitHub | Código fuente y control de versiones |
| wkhtmltopdf 0.12.6.1 | Generación de documentos PDF |

La imagen de Odoo se construye con el `Dockerfile`
incluido en este repositorio. No se utiliza directamente
una imagen preconfigurada de Odoo.

### Puertos

| Servicio | Puerto del equipo | Puerto del contenedor |
|---|---|---|
| Odoo | 8070 | 8069 |
| PostgreSQL | 5436 | 5432 |

Ambos puertos están publicados en `127.0.0.1`,
por lo que el despliegue está orientado al uso local.

## 5. Requisitos para reproducir el proyecto

El lector debe contar con:

1. Windows y PowerShell.
2. Git instalado.
3. Docker Desktop instalado y funcionando con Linux containers.
4. Conexión a Internet.
5. Espacio libre suficiente para descargar el código,
   las dependencias y construir la imagen.
6. Un equipo compatible con `amd64` o `x86-64`,
   arquitectura utilizada para el paquete wkhtmltopdf.

El entorno original fue verificado con Docker Engine 29.7.2.

No es necesario conocer ni utilizar las rutas originales
del equipo que realizó la práctica.

**Nota:** si ya existe otro proyecto que utiliza los puertos
8070 o 5436, será necesario resolver ese conflicto antes
de iniciar los contenedores.

## 6. Paso 1: clonar el repositorio del equipo

Abrir PowerShell en una carpeta de trabajo de su elección.

Ejemplo:

```powershell
cd "$env:USERPROFILE\Documents"

git clone https://github.com/zadidhc/odoo19-community-arquitectura-parcial3.git

cd odoo19-community-arquitectura-parcial3
```

Todos los comandos siguientes deben ejecutarse desde
la carpeta raíz del repositorio recién clonado.

No es necesario utilizar `C:\PROYECTOS\ODOO_PARCIAL3`,
porque esa fue solamente la ruta de la computadora original.

## 7. Paso 2: descargar el código de Odoo 19

El repositorio incluye el archivo:

`preparar-odoo.ps1`

Este script descarga el código desde GitHub y verifica
el commit oficial utilizado en la práctica.

Primero puede revisarse:

```powershell
Get-Content .\preparar-odoo.ps1
```

Luego ejecutarse:

```powershell
Set-ExecutionPolicy -Scope Process RemoteSigned

.\preparar-odoo.ps1
```

El script utiliza `$PSScriptRoot` para identificar
automáticamente la carpeta donde se encuentra.
Por tanto, no depende de la ruta del equipo original.

Al finalizar, debe existir la carpeta `odoo/`,
que contiene el código fuente oficial descargado.

Verificar:

```powershell
git -C .\odoo rev-parse HEAD

Test-Path .\odoo\odoo-bin

Test-Path .\odoo\requirements.txt
```

El commit mostrado debe ser:

`b155a99fd5881fde0d5c182a523b1bd2e541f74e`

Si la descarga falla, no debe asumirse que la
versión más reciente de Odoo es equivalente.
Es necesario resolver la descarga del commit indicado.

## 8. Paso 3: configurar las variables de entorno

El archivo `.env` original de la computadora del equipo
no se incluye por razones de seguridad.

Se proporciona `.env.example` como plantilla.

Crear una configuración privada con una nueva contraseña:

```powershell
if (Test-Path ".env") {
    throw "Ya existe un archivo .env. No sobrescribir."
}

$clave = [guid]::NewGuid().ToString("N")

"POSTGRES_PASSWORD=$clave" |
    Set-Content ".env" -Encoding ascii
```

La variable `POSTGRES_PASSWORD` permite configurar
la contraseña del usuario PostgreSQL utilizado
por los dos servicios Docker.

El archivo `.env` está excluido mediante `.gitignore`
y no debe publicarse en GitHub.

Esta contraseña no es la contraseña de acceso
del usuario administrador de Odoo.

## 9. Paso 4: construir e iniciar los servicios

Primero abrir Docker Desktop y confirmar que
el motor Docker esté funcionando.

Desde la raíz del repositorio ejecutar:

```powershell
docker compose config --quiet

docker compose build odoo

docker compose up -d

docker compose ps
```

### ¿Qué hace cada comando?

- `docker compose config --quiet`: valida la configuración.
- `docker compose build odoo`: construye la imagen de Odoo.
- `docker compose up -d`: crea e inicia los servicios.
- `docker compose ps`: muestra el estado de los contenedores.

La construcción utiliza el código descargado en `odoo/`,
instala las dependencias de Python y prepara
el generador de PDF wkhtmltopdf.

Se espera encontrar:

- Un servicio `db` con PostgreSQL 16.
- Un servicio `odoo` ejecutando Odoo 19.

El inicio puede tardar mientras se cargan los servicios.

## 10. Paso 5: abrir y configurar Odoo

Abrir el navegador y visitar:

**http://localhost:8070**

Si el sistema todavía no tiene una base de datos,
seguir el asistente de creación de Odoo.

Nombre de la base utilizado en la práctica:

`odoo_parcial3`

### Contraseñas que deben distinguirse

**Contraseña PostgreSQL**

Es la generada en `.env`. Permite la conexión
entre el servidor Odoo y PostgreSQL.

**Contraseña maestra de bases de datos de Odoo**

Protege las operaciones de creación, restauración
y administración de bases de datos.

En una configuración de Odoo sin personalizar,
su valor predeterminado puede ser `admin`.
Debe cambiarse para un entorno expuesto a otros usuarios.

**Contraseña del administrador de Odoo**

Es la contraseña del usuario que se configura
para ingresar a la aplicación y administrar sus módulos.

No debe confundirse con las dos anteriores.

Durante la creación de la base de datos,
seleccionar el idioma y las opciones necesarias
para la práctica.

Una vez iniciada la sesión, instalar:

1. Contactos.
2. Ventas.

En una instalación nueva, los datos comerciales
de la computadora original no aparecerán automáticamente.

## 11. Paso 6: verificar el funcionamiento

### Estado de contenedores

```powershell
docker compose ps
```

### Respuesta del servidor

```powershell
Invoke-WebRequest `
    -Uri "http://127.0.0.1:8070/web/login" `
    -UseBasicParsing
```

El resultado esperado para una solicitud válida
a la página de acceso es `HTTP 200`.

### Generador de documentos PDF

```powershell
docker compose exec -T odoo wkhtmltopdf --version
```

En el entorno original se verificó:

`wkhtmltopdf 0.12.6.1 (with patched qt)`

### Registros del servidor

```powershell
docker compose logs --tail 50 odoo
```

### Módulos instalados

Después de crear la base de datos e instalar
Contactos y Ventas:

```powershell
docker compose exec -T db psql `
    -U odoo `
    -d odoo_parcial3 `
    -c "SELECT name, state FROM ir_module_module WHERE name IN ('contacts','sale');"
```

Los módulos deben figurar con estado `installed`.

## 12. Demostración realizada en el entorno original

La práctica académica incluyó:

1. Instalación de las aplicaciones Contactos y Ventas.
2. Configuración comercial de demostración en soles peruanos (PEN).
3. Registro de los productos `ALN01` y `CNJ01`.
4. Creación de una plantilla comercial para lámparas LED.
5. Elaboración de la cotización `S00021`.
6. Verificación del importe de `S/ 53,10`.
7. Generación del documento PDF con diseño `Boxed`.
8. Duplicación de la cotización para obtener `S00022`.
9. Confirmación de `S00022` como orden de venta.
10. Inspección de la persistencia en PostgreSQL.

Estos resultados están descritos en el informe Word
y resumidos en la presentación.

**Advertencia:** la cotización `S00021`, el pedido
`S00022` y los productos no se generan automáticamente
al clonar este repositorio.

El lector puede reproducir el flujo creando sus propios
productos, clientes y cotizaciones desde Odoo.

Los números de documento podrían ser diferentes
en una base de datos recién creada.

## 13. Persistencia y respaldo de datos

Docker Compose utiliza dos volúmenes:

- `pgdata`: información de PostgreSQL.
- `odoo-data`: archivos y datos persistentes de Odoo.

Los datos se conservan al detener y volver a iniciar
los contenedores, siempre que no se eliminen
los volúmenes correspondientes.

Para detener:

```powershell
docker compose stop
```

Para volver a iniciar los contenedores existentes:

```powershell
docker compose start
```

Para consultar su estado:

```powershell
docker compose ps
```

**No ejecutar `docker compose down -v` si se desea
conservar los datos.** Esa instrucción puede eliminar
los volúmenes del proyecto.

El repositorio no incluye una copia de la base original,
contraseñas privadas ni el filestore de la demostración.

Para trasladar exactamente esos datos se requiere
preparar y restaurar un respaldo compatible
de PostgreSQL y los archivos de Odoo.

## 14. Problemas frecuentes

### Docker Desktop no está iniciado

Si aparece un error de conexión con Docker Engine,
abrir Docker Desktop y verificar que esté funcionando.

### El puerto 8070 o 5436 está ocupado

Revisar si otra aplicación o contenedor utiliza
el mismo puerto. Resolver el conflicto antes
de volver a iniciar la aplicación.

### Odoo no responde inmediatamente

Consultar el estado y los registros:

```powershell
docker compose ps

docker compose logs --tail 50 odoo
```

Esperar a que el servidor termine de cargar
antes de concluir que existe un problema.

### El código de Odoo no existe

Comprobar:

```powershell
Test-Path .\odoo\odoo-bin
```

Si devuelve `False`, revisar la ejecución
de `preparar-odoo.ps1`.

### La contraseña PostgreSQL no coincide

No cambiar la contraseña de `.env` esperando que
una base PostgreSQL ya inicializada actualice
automáticamente sus credenciales.

Las credenciales y los datos persistentes
deben mantenerse coherentes.

## 15. Alcance de la entrega

Este repositorio permite estudiar y reproducir
la configuración de Odoo 19 Community usada
en el Parcial 3 de Arquitectura de Software.

Incluye los archivos técnicos necesarios para intentar
la construcción de una instalación local nueva y los
documentos académicos que describen la práctica original.

### Comprobaciones realizadas en el equipo original

- Odoo 19 Community iniciado.
- PostgreSQL 16 operativo.
- Base de datos `odoo_parcial3` existente.
- Contactos y Ventas instalados.
- Acceso web comprobado con `HTTP 200`.
- Generación de PDF disponible mediante wkhtmltopdf.
- Persistencia configurada mediante volúmenes Docker.

### Comprobación pendiente

La instalación desde una clonación completamente nueva
de este repositorio debe validarse por separado.

Las instrucciones fueron preparadas para facilitar
esa reproducción, pero no debe confundirse la
validación de la instancia original con una prueba
ya completada en una segunda computadora.

La solución es académica y local; no representa
una configuración de producción endurecida.

## 16. Referencias

- [Código fuente oficial de Odoo](https://github.com/odoo/odoo)
- [Documentación de Odoo 19](https://www.odoo.com/documentation/19.0/)
- [Documentación de Docker](https://docs.docker.com/)
- [Documentación de PostgreSQL](https://www.postgresql.org/docs/)
- [Seguridad de bases de datos de Odoo](https://www.odoo.com/documentation/19.0/administration/on_premise/deploy.html)

---

**Proyecto académico — Parcial 3 de Arquitectura de Software**

**Universidad Nacional Agraria de la Selva — FIIS, 2026**
