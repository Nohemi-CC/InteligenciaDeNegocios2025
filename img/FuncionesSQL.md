> # **Funciones SQL** 🛢 👩🏻‍💻
---

 # 📊 *Universidad Tecnológica de Tula-Tepeji*  


| **👤 Nombre:** | **Nohemi Campech Colin** |
|----------------|--------------------------|
| **🆔 Matrícula:** | **22300131** |
| **📚 Materia:** | **Inteligencia de Negocios** |
| **📅 Fecha:** | **Jueves 09 de Octubre del 2025** |
---


### 📝 **Objetivo**
El presente documento tiene como propósito demostrar el uso de **funciones SQL** en la base de datos `miniBD`, aplicando ejemplos prácticos, teoría y resultados ejecutados en SQL Server Management Studio.

---

> ## 💠 **FUNCIONES DE CADENAS**

---

### 🧠 **DESCRIPCIÓN TEÓRICA**
Las **funciones de cadenas** en `SQL Server` permiten **manipular texto** para realizar tareas como:
- Convertir mayúsculas y minúsculas.  
- Contar la longitud de un texto.  
- Extraer o reemplazar partes específicas de una cadena.  

Estas funciones son útiles para **formatear información**, **mejorar la legibilidad** de los datos y **preparar salidas más claras** en los reportes SQL.

---

### ⚙️ **SINTAXIS GENERAL**
```sql
SELECT FUNCION_CADENA(campo) FROM tabla;
```

### 💻 **EJEMPLO PRACTICO**

```sql
SELECT 
    UPPER(Nombre) AS NombreMayusculas,
    LOWER(Ciudad) AS CiudadMinusculas,
    LEN(Nombre) AS LongitudNombre,
    SUBSTRING(Nombre, 1, 5) AS Primeros5Caracteres
FROM clientes;
```

## RESULTADO OBTENIDO EN SQL 🧾


| 🧍‍♀️ **NombreMayusculas** | 🏙️ **CiudadMinusculas** | 🔢 **LongitudNombre** | ✂️ **Primeros5Caracteres** |
| -------------------------- | ------------------------ | --------------------- | -------------------------- |
| CLIENTE PREMIUN            | metropoli                | 15                    | Clien                      |
| JUAN PEREZ                 | ciudad gotica            | 10                    | Juan                       |
| SOY LA VACA                | sin ciudad               | 11                    | Soy l                      |
| NATACHA                    | sin ciudad               | 7                     | Natac                      |
| SOFA LOPEZ                 | xochitlan                | 10                    | Sofa                       |
| LAURA HERNANDEZ            | sin ciudad               | 15                    | Laura                      |
| VICTOR TRUJILLO            | zacualtipan              | 15                    | Victo                      |
| CARLOS RUIZ                | metropoli                | 11                    | Carlo                      |
| JOSE ANGEL PEREZ           | salte si puedes          | 16                    | Jose                       |

### ***Conclusión:***
Estas funciones son esenciales para el tratamiento de datos tipo texto, permitiendo formatear, limpiar y preparar la información para análisis más eficientes en SQL Server.

---

> ## 📅 **FUNCIONES DE FECHAS**

### 🧭 **DESCRIPCIÓN TEÓRICA**
Las **funciones de fechas** en `SQL Server` permiten **obtener, comparar y manipular valores de tiempo**.  
Son especialmente útiles para:
- Calcular **antigüedad** o **edad**.  
- Estimar **vencimientos o proyecciones**.  
- Generar **reportes** con base en rangos de tiempo.

Estas funciones son esenciales cuando se trabaja con información **temporal o histórica** dentro de una base de datos.

### ⚙️ **SINTAXIS GENERAL**
```sql
SELECT FUNCION_DE_FECHA(GETDATE());
```

###  💻 **EJEMPLO PRACTICO**

```sql
SELECT 
    GETDATE() AS FechaActual,
    YEAR(GETDATE()) AS Año,
    MONTH(GETDATE()) AS Mes,
    DAY(GETDATE()) AS Día,
    DATEADD(YEAR, -Edad, GETDATE()) AS FechaNacimientoAprox
FROM clientes;
```

## RESULTADO OBTENIDO EN SQL 🧾


| ⏰ **FechaActual**       | 📆 **Año** | 🔢 **Mes** | 🗓️ **Día** | 🎂 **FechaNacimientoAprox** |
| ----------------------- | ---------- | ---------- | ----------- | --------------------------- |
| 2025-10-10 00:10:31.273 | 2025       | 10         | 10          | 2000-10-10 00:10:31.273     |
| 2025-10-10 00:10:31.273 | 2025       | 10         | 10          | 1998-10-10 00:10:31.273     |
| 2025-10-10 00:10:31.273 | 2025       | 10         | 10          | 1995-10-10 00:10:31.273     |
| 2025-10-10 00:10:31.273 | 2025       | 10         | 10          | 1984-10-10 00:10:31.273     |
| 2025-10-10 00:10:31.273 | 2025       | 10         | 10          | 2006-10-10 00:10:31.273     |
| 2025-10-10 00:10:31.273 | 2025       | 10         | 10          | 1995-10-10 00:10:31.273     |
| 2025-10-10 00:10:31.273 | 2025       | 10         | 10          | 2000-10-10 00:10:31.273     |
| 2025-10-10 00:10:31.273 | 2025       | 10         | 10          | 1984-10-10 00:10:31.273     |
| 2025-10-10 00:10:31.273 | 2025       | 10         | 10          | 1951-10-10 00:10:31.273     |

### ***Conclusión:***
Las funciones de fecha son indispensables para el análisis temporal dentro de SQL Server.
Permiten calcular intervalos, realizar proyecciones o generar informes cronológicos con precisión.

---

> ## ⚙️ **CONTROL DE VALORES NULOS**

### 🧠 **DESCRIPCIÓN TEÓRICA**
Los valores **nulos (`NULL`)** representan la **ausencia de información** en una base de datos.  
En `SQL Server`, es posible **controlar y reemplazar** esos valores mediante funciones como:

- `ISNULL()` → reemplaza un valor `NULL` por uno definido.  
- `COALESCE()` → devuelve el primer valor **no nulo** de una lista.  

Estas funciones son fundamentales para **evitar errores** en cálculos, concatenaciones o reportes, garantizando que los resultados siempre muestren información legible.

---



### ⚙️ **SINTAXIS GENERAL**
```sql
SELECT ISNULL(campo, 'Valor por defecto') FROM tabla;
```

###  💻 **EJEMPLO PRACTICO**

```sql
SELECT 
    IdCliente,
    Nombre,
    ISNULL(Ciudad, 'Sin ciudad') AS CiudadCorregida
FROM clientes;
```

## RESULTADO OBTENIDO EN SQL 🧾

| 🆔 **IdCliente** | 👤 **Nombre**    | 🏙️ **CiudadCorregida** |
| ---------------- | ---------------- | ----------------------- |
| 1                | Cliente Premiun  | Metropoli               |
| 2                | Juan Perez       | Ciudad Gotica           |
| 3                | Soy la Vaca      | Sin ciudad              |
| 4                | Natacha          | Sin ciudad              |
| 5                | Sofa Lopez       | Xochitlan               |
| 6                | Laura Hernandez  | Sin ciudad              |
| 7                | Victor Trujillo  | Zacualtipan             |
| 8                | Carlos Ruiz      | Metropoli               |
| 9                | Jose Angel Perez | Salte si Puedes         |

### ***Conclusión:***
El manejo de valores nulos es crucial para mantener la integridad y legibilidad de los datos.
Funciones como `ISNULL()` permiten mostrar resultados completos y coherentes, mejorando la presentación y confiabilidad de las consultas en SQL Server.

---

>## 🔁 **USO DE MERGE**

### 🧠 **DESCRIPCIÓN TEÓRICA**
El comando `MERGE` en `SQL Server` se utiliza para **sincronizar datos** entre una tabla de **origen** y una de **destino**.  
Permite ejecutar de forma **unificada** las operaciones de:
- 🟢 `INSERT` → inserta registros que no existen en el destino.  
- 🟡 `UPDATE` → actualiza registros coincidentes.  
- 🔴 `DELETE` → elimina registros que ya no están en el origen.  

Esta instrucción es especialmente útil para **automatizar procesos de integración de datos**, manteniendo tablas actualizadas con una sola sentencia.

---


### ⚙️ **SINTAXIS GENERAL**
```sql
MERGE tabla_destino AS D
USING tabla_origen AS O
ON D.id = O.id
WHEN MATCHED THEN UPDATE ...
WHEN NOT MATCHED THEN INSERT ...
WHEN NOT MATCHED BY SOURCE THEN DELETE
```
---

###  💻 **EJEMPLO PRACTICO**

```sql
IF OBJECT_ID('tempdb..#nuevosProductos') IS NOT NULL DROP TABLE #nuevosProductos;
CREATE TABLE #nuevosProductos(
    IdProducto INT,
    NombreProducto NVARCHAR(100),
    Categoria NVARCHAR(100),
    Precio DECIMAL(12,2)
);

INSERT INTO #nuevosProductos VALUES
(1, 'Monitor LG 24"', 'Electrónica', 2499.00),
(2, 'Teclado Mecánico', 'Periféricos', 999.00),
(3, 'Mouse Óptico', 'Periféricos', 499.00);

MERGE productos AS destino
USING #nuevosProductos AS origen
ON destino.IdProducto = origen.IdProducto
WHEN MATCHED THEN
    UPDATE SET destino.Precio = origen.Precio
WHEN NOT MATCHED THEN
    INSERT (IdProducto, NombreProducto, Categoria, Precio)
    VALUES (origen.IdProducto, origen.NombreProducto, origen.Categoria, origen.Precio);
```

```sql
 SELECT * FROM productos;
```

## RESULTADO OBTENIDO EN SQL 🧾

| 🆔 **IdProducto** | 🛒 **NombreProducto** | 🗂️ **Categoria** | 💲 **Precio** |
| ----------------- | --------------------- | ----------------- | ------------- |
| 1                 | Monitor LG 24"        | Electrónica       | 2499.00       |
| 2                 | Teclado Mecánico      | Periféricos       | 999.00        |
| 3                 | Mouse Óptico          | Periféricos       | 499.00        |

### ***Conclusión:***
El uso de `MERGE` permite mantener sincronización y coherencia entre tablas,
reduciendo líneas de código y evitando errores comunes al combinar operaciones `INSERT`, `UPDATE` y `DELETE`.

---


>## 🧮 **USO DE CASE**

### 🧠 **DESCRIPCIÓN TEÓRICA**
La instrucción `CASE` en `SQL Server` permite **evaluar condiciones lógicas** dentro de una consulta y **devolver valores personalizados** según el resultado.  
Es una herramienta muy útil para:
- **Clasificar datos** según criterios específicos.  
- **Asignar etiquetas o categorías** dentro de una tabla.  
- **Realizar cálculos condicionales** sin modificar los datos originales.  

En otras palabras, `CASE` funciona como una estructura de control tipo **"if-else"** directamente dentro de una instrucción `SELECT`.

---

### ⚙️ **SINTAXIS GENERAL**
```sql
SELECT 
    CASE 
        WHEN condicion THEN resultado
        ELSE valor_por_defecto
    END
FROM tabla;
```

###  💻 **EJEMPLO PRACTICO**

```sql
SELECT 
    Nombre,
    Edad,
    CASE 
        WHEN Edad < 25 THEN 'Joven'
        WHEN Edad BETWEEN 25 AND 50 THEN 'Adulto'
        ELSE 'Adulto Mayor'
    END AS CategoriaEdad,
    CASE 
        WHEN Ciudad = 'Sin ciudad' THEN 'Desconocido'
        ELSE 'Registrado'
    END AS EstadoCiudad
FROM clientes;
```

## RESULTADO OBTENIDO EN SQL 🧾

| 👤 **Nombre**    | 🔢 **Edad** | 🧭 **CategoriaEdad** | 🏙️ **EstadoCiudad** |
| ---------------- | ----------- | -------------------- | -------------------- |
| Cliente Premiun  | 25          | Adulto               | Registrado           |
| Juan Perez       | 27          | Adulto               | Registrado           |
| Soy la Vaca      | 30          | Adulto               | Desconocido          |
| Natacha          | 30          | Adulto               | Desconocido          |
| Sofa Lopez       | 30          | Adulto               | Registrado           |
| Laura Hernandez  | 30          | Adulto               | Desconocido          |
| Victor Trujillo  | 25          | Adulto               | Registrado           |
| Carlos Ruiz      | 41          | Adulto               | Registrado           |
| Jose Angel Perez | 74          | Adulto Mayor         | Registrado           |

### ***Conclusión:***
La instrucción `CASE` permite dinamizar consultas mediante evaluaciones condicionales.
Es una herramienta poderosa para clasificar, comparar y analizar datos directamente en las consultas sin necesidad de procedimientos adicionales.