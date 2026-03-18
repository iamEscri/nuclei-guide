# Uso básico de Nuclei

Una vez instalada la herramienta y actualizados los templates, el siguiente paso es aprender a ejecutar escaneos básicos con Nuclei. Esta sección cubre los comandos más habituales en el día a día de un analista de seguridad, desde el análisis de un único objetivo hasta escaneos más completos con filtros y estadísticas en tiempo real.

> **Nota:** Todos los ejemplos de esta sección asumen que Nuclei está correctamente instalado y que los templates han sido actualizados previamente con `nuclei -update-templates`.

---

## Escaneo de un objetivo individual

La forma más sencilla de utilizar Nuclei es apuntar directamente a una URL concreta. Este tipo de escaneo es ideal para realizar una primera inspección rápida sobre un servicio web.

```bash
nuclei -u https://target.com
```

![Escaneo de un objetivo individual](../images/5.png)

*Ejemplo de salida al escanear un único objetivo. Nuclei comienza a ejecutar los templates disponibles y va mostrando los hallazgos en tiempo real a medida que los detecta.*

**¿Qué hace este comando internamente?**

- `-u` indica la URL del objetivo que se quiere analizar.
- Nuclei carga automáticamente **todos los templates disponibles** en el directorio de templates configurado (por defecto `~/.local/nuclei-templates/`).
- La herramienta realiza peticiones HTTP al objetivo siguiendo las condiciones definidas en cada template y compara las respuestas con los patrones de vulnerabilidad esperados.
- Si encuentra alguna coincidencia, la muestra en pantalla con su nivel de severidad, el nombre del template ejecutado y la URL afectada.

Este tipo de escaneo sin filtros es útil para tener una visión general del estado de seguridad de un objetivo, aunque puede generar bastante ruido si se ejecutan todos los templates a la vez.

---

## Escaneo de múltiples objetivos

En escenarios reales de pentesting o bug bounty, raramente se trabaja con un único objetivo. Lo habitual es disponer de una lista de dominios o IPs que han sido recopilados previamente mediante herramientas de reconocimiento como `subfinder`, `amass` o `httpx`.

Para estos casos, Nuclei permite cargar los objetivos desde un archivo de texto plano, donde cada línea contiene un host o URL diferente.

**Ejemplo de archivo `targets.txt`:**

```
https://sub1.target.com
https://sub2.target.com
https://admin.target.com
https://api.target.com
```

![Ejemplo de archivo targets.txt con múltiples objetivos](../images/6.png)

*Estructura típica de un archivo de objetivos. Cada línea representa un host o URL independiente. Este archivo suele generarse automáticamente con herramientas de reconocimiento previas al escaneo.*

Una vez preparado el archivo, el escaneo se lanza con el flag `-l`:

```bash
nuclei -l targets.txt
```

![Salida del escaneo sobre múltiples objetivos](../images/7.png)

*Nuclei itera sobre cada objetivo del archivo de forma secuencial, ejecutando todos los templates disponibles sobre cada uno de ellos. En la salida se puede observar cómo la herramienta va cambiando de objetivo y reportando los hallazgos encontrados en cada uno.*

**¿Por qué es útil este método?**

- `-l` indica que el origen de los objetivos es un **fichero de lista**.
- Nuclei procesará cada línea del archivo como un objetivo independiente.
- Permite **escalar el análisis** a decenas o cientos de hosts con un único comando, ahorrando tiempo frente a ejecutar Nuclei manualmente para cada URL.
- Es fácilmente combinable con otras herramientas: por ejemplo, se puede alimentar directamente con la salida de `httpx` para asegurarse de que solo se escanean hosts activos.

---

## Uso de templates específicos

Por defecto, Nuclei ejecuta todos los templates disponibles, lo que puede resultar en escaneos muy extensos y con mucho tráfico hacia el objetivo. En muchas ocasiones, el analista necesita centrarse en un tipo concreto de vulnerabilidades.

Para ello, el flag `-t` permite indicar la **ruta a un directorio de templates** concreto o incluso a un template individual.

**Ejemplo: escanear únicamente CVEs conocidos:**

```bash
nuclei -u https://target.com -t ~/.local/nuclei-templates/http/cves/
```

![Escaneo utilizando únicamente templates de CVEs](../images/8.png)

*Al especificar la carpeta de CVEs, Nuclei carga únicamente los templates de ese directorio. En la barra de progreso se puede observar cómo el número de templates cargados es considerablemente menor que en un escaneo completo, lo que reduce el tiempo de ejecución y el tráfico generado.*

**Casos de uso habituales del flag `-t`:**

| Objetivo del escaneo | Ruta de templates recomendada |
|---|---|
| Vulnerabilidades CVE | `~/.local/nuclei-templates/http/cves/` |
| Paneles de administración expuestos | `~/.local/nuclei-templates/http/exposed-panels/` |
| Ficheros y rutas sensibles | `~/.local/nuclei-templates/http/exposures/` |
| Tecnologías detectadas | `~/.local/nuclei-templates/http/technologies/` |
| Configuraciones inseguras | `~/.local/nuclei-templates/http/misconfiguration/` |

> **Consejo:** Explorar la estructura del directorio `~/.local/nuclei-templates/` es una buena práctica para conocer qué tipos de análisis se pueden realizar con Nuclei y qué categorías están disponibles.

---

## Filtrado por nivel de severidad

Cada template de Nuclei tiene asociado un nivel de severidad que indica el impacto potencial de la vulnerabilidad que detecta. Los niveles disponibles son, de menor a mayor riesgo:

- `info` — Información de contexto, sin impacto directo.
- `low` — Vulnerabilidades de bajo riesgo.
- `medium` — Vulnerabilidades de riesgo moderado.
- `high` — Vulnerabilidades graves que pueden ser explotadas.
- `critical` — Vulnerabilidades críticas con alto impacto potencial.

El flag `-severity` permite **filtrar los templates** que se ejecutarán según su nivel de severidad, lo que ayuda a priorizar el análisis y reducir el tiempo de escaneo.

**Escanear únicamente vulnerabilidades críticas:**

```bash
nuclei -u https://target.com -severity critical
```

**Combinar varios niveles de severidad:**

```bash
nuclei -u https://target.com -severity medium,high,critical
```

Este segundo ejemplo es el más habitual en contextos de pentesting, ya que permite ignorar los hallazgos de tipo `info` y `low` —que suelen generar mucho ruido— y centrarse en las vulnerabilidades que realmente representan un riesgo significativo.

> **Recomendación:** En un análisis inicial de superficie de ataque, combinar `-severity medium,high,critical` con `-stats` es una buena forma de obtener resultados relevantes rápidamente sin perder el control del progreso del escaneo.

---

## Mostrar estadísticas del escaneo

En escaneos largos —sobre todo cuando se analiza una lista de muchos objetivos o se ejecutan miles de templates— puede ser difícil saber en qué punto se encuentra el análisis sin algún tipo de indicador de progreso.

El flag `-stats` activa la **visualización de estadísticas en tiempo real** durante la ejecución del escaneo.

```bash
nuclei -u https://target.com -stats
```

![Panel de estadísticas en tiempo real durante el escaneo](../images/9.png)

*Cuando se activa el flag `-stats`, Nuclei muestra un panel de progreso actualizado periódicamente. En él se puede ver el número de templates ejecutados hasta el momento, las peticiones HTTP realizadas, la tasa de peticiones por segundo y el tiempo estimado restante para completar el escaneo.*

**Información que muestra el panel de estadísticas:**

- **Templates ejecutados:** cuántos templates se han procesado sobre el objetivo hasta el momento.
- **Peticiones realizadas:** número total de peticiones HTTP enviadas al objetivo.
- **Tasa de requests/s:** velocidad actual del escaneo.
- **Progreso total:** porcentaje de avance sobre el total de templates a ejecutar.
- **Hallazgos encontrados:** número de vulnerabilidades detectadas hasta el momento.

Este modo es especialmente útil cuando se trabaja con listas grandes de objetivos o en escaneos que pueden durar varios minutos, ya que permite estimar el tiempo restante y detectar si el escaneo se ha quedado bloqueado en algún punto.

---

## Ejemplo de escaneo completo

Combinando los conceptos vistos en esta sección, un flujo de trabajo típico en un análisis real podría verse así:

```bash
nuclei -l targets.txt -severity medium,high,critical -stats
```

**¿Qué hace exactamente este comando?**

1. **`-l targets.txt`** — Carga la lista de objetivos desde el archivo `targets.txt`, procesando cada host de forma individual.
2. **`-severity medium,high,critical`** — Filtra los templates y ejecuta únicamente aquellos que detectan vulnerabilidades de severidad media, alta o crítica, ignorando el ruido de nivel `info` y `low`.
3. **`-stats`** — Activa el panel de estadísticas en tiempo real, permitiendo monitorizar el progreso del análisis mientras se ejecuta.

Este comando representa un buen punto de partida para cualquier análisis: es eficiente, orientado a resultados relevantes y fácil de monitorizar. A partir de aquí, se puede ir refinando añadiendo flags adicionales como `-t` para limitar los templates, `-o` para guardar los resultados en un fichero, o `-rate-limit` para controlar el ritmo de peticiones y evitar saturar el objetivo.

---

## Resumen de flags vistos en esta sección

| Flag | Descripción | Ejemplo |
|---|---|---|
| `-u` | Especifica un único objetivo (URL o IP) | `nuclei -u https://target.com` |
| `-l` | Carga los objetivos desde un archivo de lista | `nuclei -l targets.txt` |
| `-t` | Indica la ruta a un directorio o template específico | `nuclei -u ... -t ~/.local/nuclei-templates/http/cves/` |
| `-severity` | Filtra los templates por nivel de severidad | `nuclei -u ... -severity high,critical` |
| `-stats` | Muestra estadísticas del escaneo en tiempo real | `nuclei -u ... -stats` |
