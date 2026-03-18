# 📄 Creación y uso de templates en Nuclei

Los **templates** son el componente principal de Nuclei y el corazón de toda su funcionalidad.  
Un template define un conjunto de reglas que le indican al escáner **qué buscar**, **cómo buscarlo** y **qué condiciones deben cumplirse** para considerar que se ha encontrado algo relevante.

Gracias a los templates, Nuclei puede detectar vulnerabilidades conocidas, errores de configuración, exposición de información sensible y comportamientos anómalos en aplicaciones y servicios web.

Estos templates están escritos en **YAML**, un formato de configuración legible, estructurado y ampliamente utilizado en herramientas de automatización y DevOps.

Este enfoque basado en templates ofrece una enorme flexibilidad. Los analistas pueden:

- ✅ Utilizar templates creados y mantenidos por la comunidad
- ✅ Modificar templates existentes para adaptarlos a sus necesidades
- ✅ Crear sus propios templates personalizados desde cero

Esto convierte a Nuclei en una de las herramientas de escaneo más potentes y adaptables del panorama actual de seguridad ofensiva.

---

## 🏗️ Estructura básica de un template

Un template de Nuclei está compuesto por varias secciones principales. Cada sección cumple un rol específico dentro del flujo de detección:

| Sección | Descripción |
|---|---|
| `id` | Identificador único del template |
| `info` | Metadatos descriptivos: nombre, autor, severidad, etc. |
| `requests` | Define las peticiones HTTP que se enviarán al objetivo |

Adicionalmente, existen otras secciones opcionales más avanzadas como `matchers`, `extractors`, `variables` y `flow`, que permiten construir templates mucho más complejos y precisos.

---

## 🔍 Ejemplo de template: Detección de XSS

A continuación se muestra un template completo y comentado que intenta detectar una posible vulnerabilidad de tipo **Cross-Site Scripting (XSS) reflejado**.

```yaml
id: example-xss

info:
  name: Example XSS Detection
  author: Escri
  severity: medium
  description: Detecta un posible parámetro vulnerable a XSS reflejado
  tags: xss,reflected,owasp

requests:
  - method: GET
    path:
      - "{{BaseURL}}/?q=<script>alert(1)</script>"

    matchers-condition: and
    matchers:
      - type: word
        words:
          - "<script>alert(1)</script>"
        part: body

      - type: status
        status:
          - 200
```

> ⚠️ **Nota:** En el ejemplo original el bloque `info` y `requests` estaba fuera del bloque de código YAML. La estructura correcta exige que todo el contenido forme parte de un único documento YAML bien indentado.

---

## 🧩 Explicación detallada de cada sección

### 🔑 ID del template

```yaml
id: example-xss
```

El campo `id` es el **identificador único** del template dentro de toda la colección de Nuclei.  
Debe ser:

- **Descriptivo**: que refleje claramente qué detecta el template
- **En minúsculas con guiones**: siguiendo la convención `tipo-vulnerabilidad` o `tecnologia-problema`
- **Único**: no debe repetirse con ningún otro template de la colección

Ejemplos de buenos identificadores:
```
apache-struts-rce
wordpress-xmlrpc-bruteforce
nginx-path-traversal
springboot-actuator-exposure
```

---

### ℹ️ Sección `info`

```yaml
info:
  name: Example XSS Detection
  author: Escri
  severity: medium
  description: Detecta un posible parámetro vulnerable a XSS reflejado
  tags: xss,reflected,owasp
```

La sección `info` contiene los **metadatos** del template. Es fundamental rellenarla correctamente porque permite clasificar, buscar y filtrar templates de forma eficiente.

| Campo | Descripción | Valores posibles |
|---|---|---|
| `name` | Nombre legible del template | Texto libre |
| `author` | Nombre del creador | Texto libre |
| `severity` | Criticidad de la vulnerabilidad | `info`, `low`, `medium`, `high`, `critical` |
| `description` | Explicación breve de qué detecta | Texto libre |
| `tags` | Etiquetas para clasificación y filtrado | `xss`, `sqli`, `cve`, `rce`, etc. |

Las etiquetas (`tags`) son especialmente útiles porque permiten ejecutar grupos de templates de forma selectiva. Por ejemplo:

```bash
# Ejecutar solo templates relacionados con XSS
nuclei -u https://target.com -tags xss

# Ejecutar solo CVEs críticos
nuclei -u https://target.com -tags cve -severity critical
```

---

### 📡 Sección `requests`

```yaml
requests:
  - method: GET
    path:
      - "{{BaseURL}}/?q=<script>alert(1)</script>"
```

La sección `requests` es donde se define **qué petición HTTP enviará Nuclei** al objetivo. Es la sección más importante y la que determina el comportamiento del escáner.

#### Componentes principales:

**`method`**: El método HTTP utilizado. Puede ser `GET`, `POST`, `PUT`, `DELETE`, `HEAD`, `OPTIONS`, etc.

**`path`**: La ruta o rutas a las que se enviará la petición. Se utiliza la variable `{{BaseURL}}` que Nuclei sustituye automáticamente por la URL del objetivo.

```yaml
path:
  - "{{BaseURL}}/admin"
  - "{{BaseURL}}/admin/login"
  - "{{BaseURL}}/.env"
```

> 💡 Es posible definir **múltiples rutas** en un mismo template. Nuclei las probará todas de forma secuencial.

**`body`** (para peticiones POST): Permite enviar datos en el cuerpo de la petición.

```yaml
method: POST
path:
  - "{{BaseURL}}/login"
body: "username=admin&password=admin"
```

**`headers`**: Permite añadir cabeceras HTTP personalizadas.

```yaml
headers:
  Content-Type: application/json
  Authorization: "Bearer {{token}}"
```

---

### ✅ Sección `matchers` (validación de resultados)

La sección `matchers` es la que determina si una respuesta del servidor **coincide con el patrón esperado**, es decir, si el objetivo es vulnerable o presenta el comportamiento buscado.

Sin matchers, Nuclei no sabe cuándo debe reportar un hallazgo. Son **imprescindibles** para evitar falsos positivos.

```yaml
matchers-condition: and
matchers:
  - type: word
    words:
      - "<script>alert(1)</script>"
    part: body

  - type: status
    status:
      - 200
```

#### Tipos de matchers disponibles:

| Tipo | Descripción | Ejemplo de uso |
|---|---|---|
| `word` | Busca palabras o cadenas específicas | Detectar texto reflejado en la respuesta |
| `regex` | Aplica expresiones regulares | Detectar patrones complejos como IPs, tokens, etc. |
| `status` | Comprueba el código de estado HTTP | Verificar que la respuesta es un `200 OK` |
| `size` | Comprueba el tamaño de la respuesta | Detectar respuestas anómalas por su longitud |
| `binary` | Busca secuencias de bytes específicas | Útil para detectar cabeceras binarias |
| `dsl` | Expresiones lógicas avanzadas con DSL propio | Condiciones complejas combinadas |

#### Condición entre matchers:

Con `matchers-condition` se puede controlar cómo se combinan los matchers:

```yaml
matchers-condition: and  # Todos deben cumplirse
matchers-condition: or   # Basta con que uno se cumpla
```

---

### 🔎 Sección `extractors` (extracción de datos)

Los `extractors` permiten **extraer información** de la respuesta del servidor y mostrarla en el output. Son útiles cuando se quiere obtener datos concretos como tokens, versiones de software, rutas internas, etc.

```yaml
extractors:
  - type: regex
    part: body
    regex:
      - "version: ([0-9.]+)"
```

En este ejemplo, Nuclei extraería y mostraría el número de versión encontrado en el cuerpo de la respuesta.

---

## ▶️ Ejecución de un template personalizado

Una vez creado el template, se puede ejecutar con Nuclei usando el parámetro `-t`:

```bash
nuclei -u https://target.com -t example-template.yaml
```

Para ejecutar todos los templates de un directorio:

```bash
nuclei -u https://target.com -t ./mis-templates/
```

Para ejecutar contra una lista de objetivos:

```bash
nuclei -l targets.txt -t example-template.yaml
```

Para aumentar la verbosidad y ver más detalles durante la ejecución:

```bash
nuclei -u https://target.com -t example-template.yaml -v
```

---

## 🌐 Uso de templates de la comunidad

Nuclei cuenta con un repositorio público oficial llamado **[nuclei-templates](https://github.com/projectdiscovery/nuclei-templates)**, mantenido activamente por la comunidad y el equipo de ProjectDiscovery.

Este repositorio cubre una amplia variedad de detecciones, entre ellas:

- 🛡️ **CVEs conocidas** — vulnerabilidades públicas con identificador CVE
- ⚙️ **Errores de configuración** — servicios mal configurados y expuestos
- 🖥️ **Paneles administrativos** — detección de interfaces de gestión accesibles
- 📂 **Fugas de información** — archivos sensibles expuestos (`.env`, `.git`, backups, etc.)
- 🔍 **Detección de tecnologías** — identificación de frameworks, CMS, servidores, etc.
- 🔐 **Credenciales por defecto** — comprobación de contraseñas predeterminadas

Para mantener actualizados los templates de la comunidad:

```bash
nuclei -update-templates
```

---

## ✨ Variables disponibles en templates

Nuclei pone a disposición una serie de **variables dinámicas** que pueden usarse en los templates:

| Variable | Descripción |
|---|---|
| `{{BaseURL}}` | URL completa del objetivo (con protocolo y puerto) |
| `{{Host}}` | Hostname del objetivo |
| `{{Port}}` | Puerto del objetivo |
| `{{Path}}` | Ruta del objetivo |
| `{{Scheme}}` | Protocolo (`http` o `https`) |
| `{{RootURL}}` | URL raíz sin ruta |

Ejemplo usando varias variables:

```yaml
path:
  - "{{Scheme}}://{{Host}}:{{Port}}/admin"
```

---

## 🧪 Buenas prácticas al crear templates

Al desarrollar templates personalizados, es importante seguir una serie de recomendaciones para garantizar su calidad, precisión y mantenibilidad:

### 1. Usa identificadores claros y descriptivos
El `id` debe describir exactamente qué detecta el template. Evita nombres genéricos como `test1` o `mi-template`.

### 2. Documenta correctamente la sección `info`
Rellena siempre `name`, `author`, `severity`, `description` y `tags`. Esto facilita la búsqueda y el filtrado de templates.

### 3. Incluye matchers para reducir falsos positivos
Un template sin matchers reportará todos los resultados como positivos. Define siempre condiciones concretas que validen el hallazgo.

### 4. Prueba en entornos controlados
Antes de usar un template en producción, pruébalo en entornos de laboratorio como [DVWA](https://github.com/digininja/DVWA), [VulnHub](https://www.vulnhub.com/) o instancias locales vulnerables.

### 5. Usa `matchers-condition: and` cuando sea posible
Combinar múltiples condiciones reduce drásticamente los falsos positivos.

### 6. Versiona y organiza tus templates
Mantén tus templates en un repositorio Git, organizados por categoría. Esto facilita su mantenimiento y colaboración.

---

## 🗂️ Ejemplo de template avanzado: Detección de archivo `.env` expuesto

Un caso de uso muy común en Bug Bounty y pentesting es detectar archivos `.env` accesibles públicamente, que pueden contener credenciales y configuraciones sensibles.

```yaml
id: env-file-exposure

info:
  name: .env File Exposure
  author: Escri
  severity: high
  description: Detecta archivos .env accesibles públicamente que pueden contener credenciales
  tags: exposure,config,env,sensitive

requests:
  - method: GET
    path:
      - "{{BaseURL}}/.env"
      - "{{BaseURL}}/.env.local"
      - "{{BaseURL}}/.env.backup"

    matchers-condition: and
    matchers:
      - type: word
        words:
          - "DB_PASSWORD"
          - "APP_KEY"
          - "SECRET"
        condition: or
        part: body

      - type: status
        status:
          - 200

    extractors:
      - type: regex
        part: body
        regex:
          - "[A-Z_]+=.+"
```

Este template:
1. Prueba tres rutas comunes de archivos `.env`
2. Verifica que la respuesta contiene palabras clave típicas de archivos de entorno
3. Extrae todas las variables de entorno encontradas para mostrarlas en el output

---

## 📌 Conclusión

Los templates son el motor que hace a Nuclei tan potente y versátil. Entender su estructura permite ir más allá del uso básico y construir herramientas de detección precisas, adaptadas a cada escenario de análisis.

La posibilidad de crear templates personalizados, combinada con el repositorio público de la comunidad, convierte a Nuclei en una pieza fundamental para:

- 🔴 Equipos de Red Team y pentesters
- 🔵 Equipos de Blue Team que buscan proactividad
- 🐛 Investigadores de Bug Bounty
- 🏢 Equipos de seguridad que automatizan auditorías internas

> 💡 **Recuerda:** La calidad de un escaneo con Nuclei depende directamente de la calidad de sus templates. Invierte tiempo en crearlos bien y obtendrás resultados precisos y accionables.

---

*Guía creada por [Escri](https://github.com/iamEscri) · [nuclei-guide](https://github.com/iamEscri/nuclei-guide)*
