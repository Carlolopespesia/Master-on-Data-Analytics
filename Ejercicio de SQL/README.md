# Resumen del proyecto SQL

Este proyecto consiste en una serie de ejercicios de consultas SQL sobre una base de datos de películas. El trabajo se ha estructurado en tres partes principales: la base de datos, los enunciados de los ejercicios y las soluciones a dichos ejercicios, complementadas por un documento que detalla el proceso de configuración inicial.

## 1. Base de datos (`BBDD_Proyecto.sql`)
La base de datos del proyecto se ha diseñado en **PostgreSQL** y abarca múltiples tablas que gestionan información de una plataforma de alquiler de películas. Las tablas principales incluyen:

* `actor`: Almacena la información de los actores.
* `film`: Contiene los detalles de las películas, como título, descripción, duración y clasificación.
* `category`: Clasifica las películas por género.
* `rental`: Registra los alquileres de películas.
* `payment`: Guarda los pagos realizados por los clientes.
* `inventory`: Gestiona el inventario de las películas disponibles en las tiendas.
* `customer`: Almacena la información de los clientes.
* `store` y `staff`: Contienen datos de las tiendas y sus empleados.

El archivo SQL no solo define el esquema de la base de datos, sino que también incluye la inserción de una gran cantidad de datos y la creación de funciones y vistas para facilitar diversas consultas.

## 2. Enunciados (`EnunciadoDataProject_SQL.Lógica.pdf`)
El proyecto incluye un total de **64 ejercicios** de lógica de consultas SQL. Estos ejercicios varían en complejidad y cubren temas como la selección de datos con filtros (`WHERE`), agrupamiento (`GROUP BY`), ordenamiento (`ORDER BY`), uniones entre tablas (`JOIN`), y el uso de funciones de agregación y lógicas.

## 3. Soluciones (`Ejercicios.sql`)
[cite_start]El archivo `Ejercicios.sql` contiene las **consultas SQL para resolver los 64 ejercicios propuestos**[cite: 3]. [cite_start]Cada consulta está debidamente comentada con el número y la descripción del ejercicio al que corresponde[cite: 3]. Las soluciones incluyen:
* Consultas simples de selección.
* Consultas con filtros de fechas y valores numéricos.
* Ejercicios que combinan múltiples tablas utilizando `JOIN` para obtener información relacionada.
* Uso de cláusulas `GROUP BY` y `HAVING` para agrupar y filtrar resultados.
* Ejemplos del uso de `LIKE` para búsquedas de texto y `ORDER BY` para organizar los resultados.

## 4. Documentación del trabajo (`Documentación del trabajo.pdf`)
[cite_start]Este documento proporciona una **pequeña memoria de la configuración** del entorno para la tarea de SQL[cite: 2]. [cite_start]El autor detalla los problemas iniciales con el puerto del servidor al intentar usar **MySQL** y **Xampp**, y cómo se resolvió la situación al migrar a una instalación de **PostgreSQL**[cite: 2]. El documento sirve como una guía de diagnóstico para la configuración del proyecto y confirma la correcta ejecución del script de soluciones.