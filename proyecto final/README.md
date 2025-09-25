## Análisis Exploratorio de Datos (EDA) del Censo 2015

### 1. Resumen del Proyecto

Este proyecto consiste en un **Análisis Exploratorio de Datos (EDA)** detallado de la información del **Censo 2015** (American Community Survey, ACS), con el objetivo de explorar y cuantificar las relaciones entre variables socioeconómicas y demográficas a nivel de **tracto censal** y **condado**.

La metodología combina la **Estadística Descriptiva** para resumir los datos y la **Estadística Inferencial** para probar hipótesis y establecer relaciones predictivas. [cite_start]Los resultados han sido visualizados en un *dashboard* interactivo desarrollado en Python, dada la dificultad reportada con Google Sheets[cite: 534].

---

### 2. Estructura y Fuentes de Datos

[cite_start]El análisis se basa en tres *DataFrames* principales, todos previamente depurados para manejar datos nulos (eliminando registros con menos del 2% de datos faltantes)[cite: 330, 355, 356]:

| Archivo | Nivel de Agregación | Registros | Variables Clave (Ejemplos) |
| :--- | :--- | :--- | :--- |
| `Hoja_de_datos_UNO_depurado.csv` | Tracto Censal | 72,901 | [cite_start]Población total (`TotalPop`), Composición racial/étnica, Ingreso medio del hogar (`Income`) [cite: 334, 335, 336, 337] |
| `Hoja_de_datos_DOS_depurado.csv` | Tracto Censal | 72,727 | [cite_start]Ingreso per cápita (`IncomePerCap`), Tasa de pobreza (`Poverty`), Tipo de Ocupación, Transporte al Trabajo [cite: 340, 341, 342, 344] |
| `df_2015_depurado.csv` | Condado | 3,218 | [cite_start]Consolidación de 37 métricas de los archivos anteriores [cite: 350] |

**Clave de Unión:** Todos los archivos a nivel de tracto censal se unen mediante la clave **`CensusTract`**. [cite_start]El archivo a nivel de condado utiliza **`CensusId`**[cite: 332, 546, 351].

---

### 3. Metodología de Análisis

[cite_start]El EDA se organizó en torno a tres ejes principales, aplicando técnicas de correlación, pruebas de hipótesis y modelos de regresión[cite: 463, 465, 466]:

| Sección | Objetivos Principales | Pruebas Estadísticas Aplicadas |
| :--- | :--- | :--- |
| **A. Ingreso y Pobreza** | Describir la distribución de ingresos y cuantificar su relación con la pobreza. | [cite_start]**Media Aritmética** agrupada, **Correlación de Pearson ($\text{r}$)**, **Prueba T** (con prueba de Levene) [cite: 474, 478, 495, 501] |
| **B. Demografía y Etnia** | Analizar la composición poblacional y las correlaciones entre grupos étnicos e indicadores socioeconómicos. | [cite_start]Proporción **Ponderada** por población, **Ratio de Género**, **Correlación de Pearson ($\text{r}$)** [cite: 513, 516, 521, 524] |
| **C. Empleo y Sector Laboral** | Investigar la estructura laboral, el desempleo y su relación con la pobreza. | [cite_start]**Modelo de Regresión Lineal Simple** ($\text{Unemployment}$ vs. $\text{Poverty}$), **Prueba de Kruskal-Wallis** (comparación de medianas de ingresos por tipo de empleo) [cite: 525, 528, 529] |

---

### 4. Conclusiones Clave y *Insights*

[cite_start]El análisis estadístico proporcionó las siguientes conclusiones objetivas[cite: 555]:

* [cite_start]**Vínculo Ingreso-Pobreza:** Se confirmó una correlación **negativa y muy fuerte** ($\text{r} \approx -0.76$) entre el Ingreso y la Pobreza, estableciendo que el ingreso es el predictor más robusto del nivel de pobreza de un área[cite: 630, 631].
* [cite_start]**Modelo de Desempleo:** El modelo de regresión lineal demostró que la Pobreza explica el $\approx 50.8\%$ de la variación en el Desempleo ($\text{R}^2=0.508$), con una relación positiva y significativa: un aumento de 1 punto porcentual en la pobreza se asocia con un aumento de $\approx 0.35$ puntos en el desempleo[cite: 571, 572, 607].
* [cite_start]**Desigualdad Laboral:** Existe una **diferencia estadísticamente significativa** en la mediana de ingresos entre el empleo **'Professional'** y el de **'Production'** (Prueba de Kruskal-Wallis, $\text{p} \approx 0$)[cite: 573, 574, 615]. [cite_start]El sector **'Professional'** es el más prevalente ($\approx 30.99\%$)[cite: 603].
* [cite_start]**Concentración de Riqueza:** Los 5 condados con mayor ingreso se concentran en el área de Virginia y Maryland (corredor de Washington D.C.), siendo **Loudoun, Virginia**, el más alto ($\$123,453$ de ingreso promedio)[cite: 557, 558].
* **Disparidades Demográficas:**
    * [cite_start]**Población Negra y Desempleo:** Se encontró una correlación **positiva y moderada** ($\text{r} \approx 0.353$), sugiriendo que las áreas con mayor porcentaje de población 'Black' enfrentan mayores desafíos de empleo[cite: 565, 566, 634].
    * [cite_start]**Población Asiática e Ingreso:** Existe una correlación **positiva y moderada** ($\text{r} \approx 0.399$) con el Ingreso Per Cápita[cite: 635].
* [cite_start]**Movilidad y Riqueza:** El **District of Columbia** es el estado con mayor uso de transporte público **'Transit'** ($\approx 37.4\%$), superando el uso de automóvil[cite: 576, 609]. [cite_start]El uso de transporte público tiene una correlación positiva débil a moderada con el Ingreso Per Cápita ($\text{r} \approx 0.313$), lo que sugiere que áreas urbanas con altos ingresos tienden a depender más de él[cite: 577, 578].

---

### 5. Recomendaciones Analíticas Futuras

[cite_start]Se sugiere una profundización del análisis en los siguientes pasos para validar la causalidad[cite: 639]:

* [cite_start]**Modelado Jerárquico:** Utilizar modelos de regresión multi-nivel para anidar Tractos Censales dentro de Condados, y Condados dentro de Estados, para aislar la varianza geográfica[cite: 640, 641].
* [cite_start]**Clustering:** Aplicar algoritmos de segmentación para clasificar las áreas censales en grupos homogéneos (ej., "Centros de Alta Riqueza y Empleo" o "Zonas Rurales de Baja Renta")[cite: 642].
* [cite_start]**Ampliación del Kruskal-Wallis:** Extender la comparación de medianas de ingresos a todas las categorías de empleo (Service, Office, Construction) para establecer una jerarquía salarial completa[cite: 616].