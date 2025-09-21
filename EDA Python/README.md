# Análisis Exploratorio de Datos (EDA)

[cite_start]Este repositorio contiene un análisis exploratorio de datos (EDA) realizado sobre un conjunto de datos, centrándose en la limpieza, el preprocesamiento y la visualización de la información[cite: 25]. [cite_start]El análisis incluyó el manejo de datos nulos y corruptos, la creación de un nuevo DataFrame y la generación de una variedad de gráficos y estadísticas para desglosar la información de las tablas[cite: 22, 24].

## Preparación y Manejo de Datos

[cite_start]Para asegurar que los datos estuvieran en un formato adecuado para el estudio, se llevaron a cabo las siguientes operaciones de preprocesamiento[cite: 341]:
* **Manejo de valores nulos**:
    * [cite_start]Se eliminaron las columnas con más del 2% de datos nulos[cite: 9, 343].
    * [cite_start]Los valores nulos en la columna `'default'` se trataron como verdaderos[cite: 9, 344].
    * [cite_start]Los valores nulos de la columna `'euribor3m'` se sustituyeron por el valor inmediatamente superior[cite: 10, 345].
    * [cite_start]Se aplicaron condiciones específicas para imputar los valores nulos en la columna `'age'` según el estado civil y la educación[cite: 11, 346].
* [cite_start]**Manejo de datos corruptos**: Las columnas con variables no numéricas se reemplazaron por variables numéricas[cite: 19].
* [cite_start]**Creación del nuevo DataFrame**: Se generó un nuevo archivo CSV para el estudio posterior[cite: 20, 21].

## Análisis de Variables Clave

[cite_start]El análisis se centró en varias variables numéricas y cualitativas para entender sus distribuciones y características[cite: 348].

### Distribución de la Edad (`age`)
[cite_start]La variable `age` muestra una asimetría positiva (sesgada a la derecha), lo que significa que la mayoría de los datos se concentran en edades jóvenes y de mediana edad[cite: 26, 349]. [cite_start]La media es de 41.09 años y la mediana es de 39.00 años, lo que confirma la asimetría[cite: 67, 68, 352]. [cite_start]El 50% central de la población se encuentra en el rango de 32 a 48 años[cite: 77, 354].

### Distribución de la Duración de Interacciones (`duration`)
[cite_start]La variable `duration` presenta una asimetría extrema y positiva, con la mayoría de las interacciones siendo muy cortas[cite: 78, 79]. [cite_start]La media es de 257.69 segundos y la mediana es de 179.00 segundos, confirmando la asimetría[cite: 120, 121]. [cite_start]La duración de las interacciones es un factor clave para predecir si una persona se suscribe a un servicio[cite: 328, 329, 364, 365].

### Distribución del Número de Contactos (`campaign`)
[cite_start]La variable `campaign` está fuertemente sesgada a la derecha, con la mayoría de los clientes siendo contactados solo una vez[cite: 132, 134, 135]. [cite_start]El 75% de los clientes fueron contactados tres veces o menos[cite: 176, 178].

### Matriz de Correlaciones
[cite_start]Se realizó una matriz de correlaciones para visualizar las relaciones entre varias variables numéricas[cite: 313]. [cite_start]Se identificaron correlaciones positivas fuertes entre `euribor3m` y `emp.var.rate` (0.96) y entre `nr.employed` y `emp.var.rate` (0.93)[cite: 317, 319].

### Análisis Bivariado (Edad vs. Suscripción y Duración vs. Suscripción)
* [cite_start]**Edad y Suscripción**: Los boxplots indican que la distribución de la edad es similar entre los grupos que se suscribieron y los que no, sugiriendo que la edad no es un factor significativo para la suscripción[cite: 322, 325, 361, 362].
* [cite_start]**Duración y Suscripción**: La duración de la llamada muestra una diferencia considerable entre los dos grupos [cite: 327, 363][cite_start], con llamadas más largas correlacionadas con una mayor probabilidad de suscripción[cite: 328, 329, 364].

## Conclusión
El análisis reveló hallazgos clave sobre el conjunto de datos, como la fuerte correlación entre ciertas variables socioeconómicas y la importancia de la duración de las llamadas como un indicador predictivo para la suscripción. [cite_start]Este trabajo fue realizado por Carlos Alejandro López Rodríguez, alumno del máster de Análisis de datos de Prometeo. [cite: 371]