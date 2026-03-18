# Introducción a Nuclei

## El reto del análisis de vulnerabilidades moderno

En el análisis moderno de ciberseguridad, una de las tareas más críticas para cualquier analista es **identificar de forma rápida y eficiente posibles fallos en sistemas, aplicaciones y servicios expuestos a Internet**. Sin embargo, esto es mucho más complejo de lo que parece a primera vista.

Las infraestructuras actuales son enormes y heterogéneas: una organización mediana puede tener decenas de servidores web, cientos de subdominios, APIs expuestas, paneles de administración, servicios de terceros y aplicaciones internas. Analizar manualmente cada uno de estos componentes en busca de vulnerabilidades sería **completamente inviable**, tanto en tiempo como en recursos humanos.

A esto se suma que las vulnerabilidades aparecen constantemente. Cada semana se publican nuevos CVEs (Common Vulnerabilities and Exposures), errores de configuración conocidos y patrones de ataque. Un analista que intente mantenerse al día de forma manual estará siempre por detrás del ritmo real de aparición de amenazas.

Por este motivo, los equipos de seguridad modernos recurren a herramientas que permiten **automatizar la detección de vulnerabilidades conocidas**, permitiendo que el analista centre su esfuerzo en lo que realmente importa: interpretar los resultados, priorizar los hallazgos y proponer soluciones.

Una de las herramientas que ha ganado mayor popularidad en los últimos años dentro de la comunidad de ciberseguridad es **Nuclei**.

---

## ¿Qué es Nuclei?

**Nuclei** es un escáner de vulnerabilidades de código abierto, rápido y altamente configurable, desarrollado por el equipo de **ProjectDiscovery**. Está escrito en Go, lo que le proporciona una velocidad de ejecución muy alta y un consumo de recursos eficiente.

Su filosofía es radicalmente distinta a la de los escáneres tradicionales. En lugar de depender de una base de datos interna y cerrada de vulnerabilidades, Nuclei se basa en el uso de **templates definidos en YAML**: archivos de texto que describen exactamente qué debe buscar el escáner en un sistema objetivo y cómo debe interpretar la respuesta.

Esto tiene una implicación muy importante: **cualquier persona puede escribir un template**, lo que convierte a Nuclei en una herramienta extremadamente adaptable a cualquier escenario de auditoría.

### ¿Qué puede detectar Nuclei?

Gracias a su sistema de templates, Nuclei es capaz de detectar una gran variedad de problemas de seguridad:

| Categoría | Descripción | Ejemplo |
|---|---|---|
| **CVEs conocidos** | Vulnerabilidades con identificador oficial | CVE-2021-44228 (Log4Shell) |
| **Errores de configuración** | Ajustes incorrectos que exponen el sistema | Cabeceras HTTP de seguridad ausentes |
| **Exposición de información sensible** | Datos que no deberían ser accesibles | Archivos `.env`, backups, credenciales |
| **Paneles administrativos** | Interfaces de gestión expuestas | Phpmyadmin, Kibana, Grafana sin auth |
| **Tecnologías vulnerables** | Versiones desactualizadas de software | WordPress 5.x con plugins vulnerables |
| **Comportamientos inseguros** | Patrones de seguridad incorrectos | CORS permisivo, Open Redirect, XSS |
| **Detección de tecnologías** | Fingerprinting del stack tecnológico | Identificar CMS, frameworks, servidores |

---

## ¿Por qué es Nuclei una herramienta clave para analistas?

### Alta velocidad de escaneo

Nuclei está diseñado para trabajar a escala. A diferencia de herramientas que analizan un objetivo de forma secuencial, Nuclei ejecuta múltiples peticiones en paralelo, lo que le permite **analizar miles de objetivos en cuestión de minutos**. En contextos como bug bounty o auditorías de infraestructuras grandes, esto supone una diferencia enorme.

### Arquitectura basada en templates

Este es el elemento central que diferencia a Nuclei del resto. Un **template** es un archivo YAML que define:

- **Qué petición hacer**: HTTP, DNS, TCP, WebSocket, etc.
- **Qué esperar en la respuesta**: palabras clave, expresiones regulares, códigos de estado, cabeceras...
- **Cómo clasificar el hallazgo**: severidad, descripción, referencias, etc.

Por ejemplo, un template puede decirle a Nuclei que envíe una petición HTTP GET a `{{BaseURL}}/.git/config` y, si la respuesta contiene la cadena `[core]`, clasifique ese hallazgo como **exposición de repositorio Git** con severidad media. Todo esto en unas pocas líneas de YAML.

Este enfoque ofrece varias ventajas prácticas:

- **Los analistas pueden crear sus propios templates** para vulnerabilidades específicas que encuentren en sus auditorías.
- **Los templates se pueden compartir** con la comunidad, creando un repositorio colectivo de conocimiento.
- **Es posible adaptar templates existentes** para ajustarlos a entornos concretos.

### Gran comunidad y repositorio público

ProjectDiscovery mantiene un repositorio público en GitHub llamado **nuclei-templates**, que en el momento de redactar esta guía contiene **más de 7.000 templates activos**, mantenidos y actualizados por cientos de colaboradores de todo el mundo.

Esto significa que, cuando se publica una nueva vulnerabilidad crítica (como Log4Shell o ProxyLogon en su momento), la comunidad suele publicar un template para Nuclei en cuestión de horas o días, permitiendo a cualquier analista verificar rápidamente si sus sistemas están afectados.

### Integración con otras herramientas del ecosistema

Nuclei no está pensado para trabajar de forma aislada, sino como parte de un **pipeline de seguridad**. Se integra de forma natural con otras herramientas del ecosistema de ProjectDiscovery y de la comunidad:

- **subfinder** → Descubre subdominios de un dominio objetivo
- **httpx** → Verifica qué hosts están activos y responden HTTP/HTTPS
- **nmap** → Escanea puertos abiertos e identifica servicios
- **amass** → Realiza reconocimiento pasivo y activo de infraestructura
- **katana** → Crawlea aplicaciones web para descubrir endpoints

La posibilidad de combinar estas herramientas permite construir **flujos de trabajo completamente automatizados** de reconocimiento y análisis.

---

## Nuclei en el ciclo de análisis de vulnerabilidades

Para entender dónde encaja Nuclei dentro de una metodología de seguridad, es importante ver el ciclo completo de un análisis. Nuclei se sitúa en la **fase de escaneo de vulnerabilidades**, después del descubrimiento de activos y la identificación de servicios:

```
Reconocimiento
     │
     ▼
Descubrimiento de hosts y subdominios   ← subfinder, amass
     │
     ▼
Identificación de servicios activos     ← httpx, nmap
     │
     ▼
Escaneo de vulnerabilidades             ← NUCLEI
     │
     ▼
Análisis manual y explotación           ← Burp Suite, metasploit...
     │
     ▼
Reporte y remediación
```

### Un flujo de trabajo típico con Nuclei

El flujo más habitual al usar Nuclei en un contexto real es el siguiente:

**1. Descubrimiento de subdominios con Subfinder**

```bash
subfinder -d ejemplo.com -o subdominios.txt
```

Subfinder consulta múltiples fuentes pasivas (certificate transparency, APIs públicas, etc.) para obtener todos los subdominios conocidos de un dominio objetivo. El resultado es una lista de subdominios que se guarda en un fichero.

**2. Identificación de hosts activos con Httpx**

```bash
cat subdominios.txt | httpx -o hosts_activos.txt
```

No todos los subdominios descubiertos estarán activos o tendrán un servicio web. Httpx verifica cuáles responden correctamente a peticiones HTTP/HTTPS y filtra los que no están operativos, evitando que Nuclei pierda tiempo en objetivos inalcanzables.

**3. Escaneo de vulnerabilidades con Nuclei**

```bash
nuclei -l hosts_activos.txt -o resultados.txt
```

Finalmente, Nuclei analiza cada uno de los hosts activos utilizando su biblioteca de templates, generando un informe con todos los hallazgos encontrados.

Este flujo, que puede ejecutarse con tres comandos y unos pocos minutos de tiempo, proporciona una **visión completa de la superficie de ataque** de un dominio y sus posibles vulnerabilidades.

### ¿Por qué este orden importa?

Realizar los pasos en este orden no es arbitrario. Tiene un impacto directo en la eficiencia y la calidad del análisis:

- **Primero subdominios, luego activos**: Si se pasa directamente una lista de subdominios a Nuclei sin filtrar los activos, Nuclei intentará conectar con hosts que no existen o no responden, generando errores y ralentizando el proceso innecesariamente.
- **Primero activos, luego vulnerabilidades**: Nuclei puede ejecutar miles de templates sobre cada objetivo. Limitarlo a hosts confirmados como activos reduce drásticamente el ruido y el tiempo de ejecución.

---

## ¿Qué hace diferente a Nuclei de otros escáneres?

Es habitual que los analistas se pregunten por qué usar Nuclei cuando existen otras herramientas conocidas como Nessus, OpenVAS o Nikto. La respuesta está en la naturaleza de cada herramienta:

| Característica | Nuclei | Nessus / OpenVAS | Nikto |
|---|---|---|---|
| **Modelo** | Templates YAML (open source) | Base de datos propietaria | Checks codificados |
| **Extensibilidad** | Muy alta (cualquiera puede crear templates) | Baja / de pago | Baja |
| **Velocidad** | Muy alta (concurrencia en Go) | Media | Baja |
| **Coste** | Gratuito | Caro (Nessus) / Gratuito (OpenVAS) | Gratuito |
| **Comunidad** | Muy activa | Limitada | Limitada |
| **Integración en pipelines** | Excelente (CLI, output JSON/YAML) | Limitada | Media |
| **Curva de aprendizaje** | Media | Alta | Baja |

Nuclei no pretende reemplazar herramientas como Nessus en todos los contextos, pero en escenarios de bug bounty, pentesting ágil o integración en CI/CD, su flexibilidad y velocidad lo convierten en la opción preferida de muchos profesionales.

---

## Objetivo de esta guía

El objetivo de este repositorio es proporcionar **una guía práctica, estructurada y progresiva para el uso profesional de Nuclei**, orientada a analistas de ciberseguridad con distintos niveles de experiencia.

El material está organizado para que pueda seguirse de forma secuencial, pero también funciona como **referencia técnica rápida** para consultas puntuales.

A lo largo de esta guía se abordarán los siguientes aspectos:

1. **Instalación y configuración** — Cómo instalar Nuclei en distintos sistemas y configurarlo para el uso diario.
2. **Uso básico** — Los primeros pasos con la herramienta: cómo lanzar un escaneo sencillo y entender los resultados.
3. **Comandos y opciones principales** — Referencia detallada de los flags más utilizados y cuándo usarlos.
4. **Gestión de templates** — Cómo actualizar, filtrar y organizar los templates disponibles.
5. **Integración en flujos de trabajo de pentesting** — Cómo combinar Nuclei con otras herramientas del ecosistema.
6. **Creación de templates personalizados** — Cómo escribir tus propios templates en YAML para vulnerabilidades específicas.
7. **Ejemplos prácticos** — Casos de uso reales con explicaciones paso a paso.

Al finalizar esta guía, el analista será capaz de utilizar Nuclei de forma autónoma y eficiente en escenarios reales, tanto en auditorías internas como en programas de bug bounty.

---

> **Nota legal y ética**: Nuclei es una herramienta de seguridad ofensiva. Su uso debe limitarse únicamente a sistemas sobre los que se tenga autorización explícita para realizar pruebas. El uso de Nuclei contra sistemas sin autorización puede constituir un delito en la mayoría de jurisdicciones. Utilízala siempre de forma responsable y dentro del marco legal aplicable.
