import pandas as pd
import plotly.express as px
import streamlit as st
import os

# 1. Configuración de la Página de Streamlit
st.set_page_config(
    page_title="Dashboard Socioeconómico - Múltiples Archivos",
    layout="wide", # Usa el ancho completo de la pantalla
    initial_sidebar_state="auto"
)

# Definición de nombres de archivo y la carpeta donde se guardaron
DATA_DIR = 'Datos_Depurados' # Asegúrate de que esta carpeta exista y contenga los archivos
FILE_UNO = os.path.join(DATA_DIR, 'Hoja_de_datos_UNO_depurado.csv')
FILE_DOS = os.path.join(DATA_DIR, 'Hoja_de_datos_DOS_depurado.csv')
FILE_COUNTRY = os.path.join(DATA_DIR, '2015_country_depurado.csv')

# --- Función de Carga y Combinación de Datos ---
@st.cache_data # Usar la caché de Streamlit para no recargar los datos en cada interacción
def load_data():
    dataframes = {}
    try:
        # A. Cargar y Unir HOJA UNO y HOJA DOS (Nivel CensusTract)
        # Se asume que tienen el mismo índice (CensusTract, State, County) para la unión
        # Los datos de inspección sugieren que las filas son coincidentes y complementarias.
        df_uno = pd.read_csv(FILE_UNO)
        df_dos = pd.read_csv(FILE_DOS)
        
        # Las columnas 'State' y 'County' son cruciales para la unión y el dashboard
        # Aseguramos que 'CensusTract' sea la clave de unión si existe en ambos (parece que sí)
        # Si 'CensusTract' está en ambos, se usa como clave primaria para el merge
        if 'CensusTract' in df_uno.columns and 'CensusTract' in df_dos.columns:
            # Seleccionar solo las columnas de interés en el df_uno
            cols_uno_to_keep = ['CensusTract', 'State', 'County', 'TotalPop', 'Income']
            df_uno_subset = df_uno[cols_uno_to_keep]
            
            # Unir los dos DataFrames a nivel de CensusTract
            # Esto asume que el resto de las columnas importantes (IncomePerCap, Unemployment, Poverty)
            # están en df_dos, y que 'State', 'County' y 'TotalPop' están en df_uno (como sugiere la estructura original).
            df_combined = pd.merge(df_uno_subset, df_dos, on=['CensusTract'], how='inner')
            # Las columnas de unión como 'State' y 'County' se eliminan de df_dos si existieran
            
            # Renombrar columnas clave para el Dashboard
            df_combined = df_combined.rename(columns={
                'IncomePerCap': 'Ingreso Per Cápita', 
                'Unemployment': 'Tasa de Desempleo', 
                'TotalPop': 'Población Total',
                'Poverty': 'Tasa de Pobreza'
            })
            
            dataframes['Datos por Bloque Censal (Unido)'] = df_combined
            st.sidebar.success("✅ Datos por Bloque Censal (Unido) cargados.")
            
        else:
            st.error("Error: Las hojas de datos UNO y DOS deben tener la columna 'CensusTract' para unirse.")
            
        # B. Cargar el archivo de Condado (Nivel County)
        df_country = pd.read_csv(FILE_COUNTRY)
        
        # Renombrar columnas clave para el Dashboard (asegura consistencia con el DF unido)
        df_country = df_country.rename(columns={
            'IncomePerCap': 'Ingreso Per Cápita', 
            'Unemployment': 'Tasa de Desempleo', 
            'TotalPop': 'Población Total',
            'Poverty': 'Tasa de Pobreza'
        })
        
        dataframes['Datos por Condado (Resumen)'] = df_country
        st.sidebar.success("✅ Datos por Condado (Resumen) cargados.")

    except FileNotFoundError as e:
        st.error(f"Error: Asegúrate de que los archivos CSV estén en la carpeta '{DATA_DIR}'. Falta: {e}")
        return {}
    except Exception as e:
        st.error(f"Error al cargar o unir los datos: {e}")
        return {}

    return dataframes

# 2. Cargar Datos y Seleccionar el DataFrame
dataframes_dict = load_data()

# Título y Configuración Inicial
st.title("📊 Dashboard Socioeconómico Interactivo")
st.markdown("---") 

# Selector de Origen de Datos
st.sidebar.header("Selección de Datos")
if not dataframes_dict:
    st.error("No se pudieron cargar los datos. Revisa la consola para más detalles.")
    st.stop() # Detiene la ejecución si no hay datos

# Obtener la lista de DataFrames disponibles
df_keys = list(dataframes_dict.keys())

# Widget de selección en el sidebar para elegir el DataFrame a mostrar
selected_key = st.sidebar.selectbox(
    'Selecciona el Origen de Datos a Visualizar:',
    options=df_keys,
    index=0 
)

df = dataframes_dict[selected_key]
# Ahora df contiene el DataFrame seleccionado ('df_combined' o 'df_country')

# Obtener la lista única de Estados para el filtro del DataFrame seleccionado
if 'State' in df.columns:
    list_of_states = df['State'].unique()
    list_of_states.sort()
else:
    # Esto no debería pasar con tus datos, pero es una protección
    list_of_states = []

# --- Control de Filtro (Sidebar) ---
st.sidebar.header(f"Filtro por Estado en {selected_key}")
selected_state = st.sidebar.selectbox(
    'Selecciona un Estado:',
    options=list_of_states,
    index=0 
)

# 3. Generación del Dashboard

if selected_state and 'State' in df.columns:
    # Filtrar el DataFrame por el estado seleccionado
    filtered_df = df[df['State'] == selected_state]
    
    # Determinar la unidad de análisis para los títulos
    unidad_analisis = "Condado" if selected_key == 'Datos por Condado (Resumen)' else "Bloque Censal"

    # --- 1. Generar Estadísticas de Resumen (en dos columnas) ---
    st.header(f"Estadísticas Resumen para **{selected_state}** ({selected_key})")
    
    # Validación de las columnas necesarias
    if 'Ingreso Per Cápita' in filtered_df.columns and 'Tasa de Desempleo' in filtered_df.columns and 'Tasa de Pobreza' in filtered_df.columns:

        if not filtered_df.empty:
            # Usar 'Tasa de Pobreza' como métrica adicional
            avg_income = filtered_df['Ingreso Per Cápita'].mean()
            avg_unemployment = filtered_df['Tasa de Desempleo'].mean()
            avg_poverty = filtered_df['Tasa de Pobreza'].mean()
            
            # Usar st.columns para un diseño horizontal (3 columnas ahora)
            col1, col2, col3 = st.columns(3)
            
            with col1:
                st.metric(
                    label="Ingreso Per Cápita Promedio", 
                    value=f"${avg_income:,.0f}", 
                    help=f"Media del Ingreso Per Cápita de los {unidad_analisis}s."
                )

            with col2:
                st.metric(
                    label="Tasa de Desempleo Promedio", 
                    value=f"{avg_unemployment:.2f}%", # Se muestra en formato decimal en los datos, ajustado a %
                    help=f"Media de la Tasa de Desempleo de los {unidad_analisis}s."
                )
                
            with col3:
                st.metric(
                    label="Tasa de Pobreza Promedio", 
                    value=f"{avg_poverty:.2f}%", 
                    help=f"Media de la Tasa de Pobreza de los {unidad_analisis}s."
                )
                
            st.markdown("---")

            # --- 2. Generar Gráfico de Dispersión (Scatter Plot) ---
            st.header(f"Relación Ingreso Per Cápita vs. Tasa de Desempleo (por {unidad_analisis})")
            
            # Seleccionar la columna de hover name según la unidad de análisis
            hover_col = 'County' if 'County' in filtered_df.columns else filtered_df.columns[0] # Usa 'County' o la primera columna si no está
            
            # Asegurar que 'Tasa de Desempleo' y 'Tasa de Pobreza' estén en formato 0-100 para Plotly si es necesario.
            # Según tu inspección, parecen estar en 0-100 para el archivo country, y 0-100 para el unido.
            # Asumimos que están en porcentaje (0-100) o que Plotly lo manejará. Si estuvieran en decimal (0-1), 
            # habría que multiplicarlos por 100. Los datos de inspección sugieren que están entre 0 y 100.
            
            # Para el gráfico, si las variables son un porcentaje (ej: 0.05), multiplicamos por 100 para la etiqueta, 
            # si son ya porcentajes (ej: 5.0), no. Por la inspección, parece que 'Unemployment' y 'Poverty' 
            # están como porcentajes (0-100) en el archivo '2015_country_depurado'. 
            # Y en el original 'Hoja_de_datos_DOS' como porcentajes. Usaremos esto como base.

            fig = px.scatter(
                filtered_df,
                x='Ingreso Per Cápita',
                y='Tasa de Desempleo',
                size='Población Total',
                color='Tasa de Pobreza', # Usar la columna renombrada
                hover_name=hover_col,
                title=f'Ingreso Per Cápita vs. Tasa de Desempleo en {selected_state} por {unidad_analisis}',
                labels={
                    'Ingreso Per Cápita': 'Ingreso Per Cápita (USD)',
                    'Tasa de Desempleo': 'Tasa de Desempleo (%)',
                    'Tasa de Pobreza': 'Tasa de Pobreza (%)',
                    'Población Total': 'Población Total'
                },
                template='plotly_white'
            )
            
            # Mejorar la apariencia del eje y (Desempleo) y color (Pobreza)
            # Asumiendo que están en % (0-100) o decimales que Plotly interpreta.
            fig.update_yaxes(ticksuffix="%")
            fig.update_xaxes(tickprefix="$", tickformat=",")
            
            # Mostrar el gráfico de Plotly en Streamlit
            st.plotly_chart(fig, use_container_width=True)

        else:
            st.warning(f"No hay datos para el estado seleccionado: {selected_state} en el conjunto **{selected_key}**.")
    else:
        st.error(f"El conjunto de datos **{selected_key}** no tiene todas las columnas necesarias para el dashboard (Ingreso Per Cápita, Tasa de Desempleo, Población Total, Tasa de Pobreza).")

else:
    st.info("Por favor, selecciona un origen de datos y un estado en el panel de la izquierda para comenzar.")

# 4. Ejecutar la Aplicación
# Para ejecutar esta aplicación, guarda el código como 'app.py' (o el nombre que prefieras)
# y ejecuta el siguiente comando en tu terminal:
# streamlit run app.py