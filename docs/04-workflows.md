# Workflows profesionales con Nuclei

En entornos reales de pentesting o análisis de vulnerabilidades, Nuclei rara vez se utiliza de forma aislada. Lo más habitual es integrarlo dentro de un **flujo de reconocimiento automatizado**, donde diferentes herramientas especializadas se encargan de cada fase del proceso: descubrir activos, identificar cuáles están activos y, finalmente, analizar posibles vulnerabilidades sobre ellos.

Este enfoque en cadena permite trabajar de forma mucho más eficiente sobre grandes superficies de ataque, reduciendo el trabajo manual y aumentando la cobertura del análisis.

---

## Flujo típico de reconocimiento

El flujo de trabajo más extendido dentro de la comunidad de seguridad ofensiva y bug bounty sigue esta estructura de tres fases:

```
Subfinder → Httpx → Nuclei
```

Cada herramienta cumple una función específica y bien delimitada dentro del proceso. La salida de una herramienta es la entrada de la siguiente, lo que permite encadenarlas de forma natural mediante archivos intermedios o pipes de sistema.

---

## Fase 1 — Descubrimiento de subdominios con Subfinder

El primer paso consiste en identificar la mayor cantidad posible de subdominios asociados al dominio objetivo. Cuanto más completa sea esta fase, mayor será la superficie de ataque que analizaremos en las fases siguientes.

Para ello se utiliza **Subfinder**, una herramienta de reconocimiento pasivo desarrollada por ProjectDiscovery. Trabaja consultando fuentes externas de inteligencia (como certificados SSL públicos, motores de búsqueda, APIs de terceros, etc.) sin interactuar directamente con el objetivo, lo que la hace especialmente discreta.

```bash
subfinder -d target.com > subdomains.txt
```

**¿Qué hace exactamente este comando?**

- `-d target.com` → especifica el dominio objetivo sobre el que queremos descubrir subdominios.
- `> subdomains.txt` → redirige toda la salida al archivo `subdomains.txt`, que contendrá un subdominio por línea.

![Subfinder ejecutándose y obteniendo subdominios del dominio objetivo](../images/10.png)

> Como se puede observar en la imagen, Subfinder muestra en tiempo real los subdominios que va descubriendo a medida que consulta sus distintas fuentes de datos. Cada línea representa un subdominio encontrado que será procesado en la siguiente fase.

El resultado final es un archivo de texto plano con una lista de subdominios, algo similar a esto:

```
api.target.com
mail.target.com
dev.target.com
admin.target.com
staging.target.com
```

---

## Fase 2 — Identificación de hosts activos con Httpx

Disponer de una lista de subdominios no es suficiente. Muchos de ellos pueden estar caídos, apuntar a IPs que ya no responden, o simplemente no tener ningún servicio web expuesto. Intentar analizar con Nuclei hosts que no responden sería una pérdida de tiempo y generaría mucho ruido en los resultados.

Por eso, el segundo paso consiste en **filtrar únicamente los hosts que están activos y responden a peticiones HTTP o HTTPS**. Para ello se utiliza **Httpx**, otra herramienta de ProjectDiscovery diseñada precisamente para esto.

```bash
httpx-pd -l subdomains.txt -silent -o alive.txt
```

**¿Qué hace exactamente este comando?**

- `-l subdomains.txt` → toma como entrada el archivo generado en la fase anterior.
- `-silent` → suprime los mensajes de estado internos y muestra únicamente los resultados limpios en pantalla.
- `-o alive.txt` → guarda los hosts activos en un nuevo archivo llamado `alive.txt`.

![Httpx comprobando cuáles de los subdominios descubiertos están activos](../images/11.png)

> En la imagen se puede ver cómo Httpx va probando cada subdominio de la lista y mostrando únicamente aquellos que responden correctamente. El resultado incluye la URL completa con el protocolo correspondiente (HTTP o HTTPS), lo que indica que el host tiene un servidor web activo y accesible.

Una vez finalizado el proceso, podemos revisar el contenido del archivo resultante para confirmar qué hosts pasarán a la siguiente fase:

![Contenido del archivo alive.txt con los hosts activos y sus URLs](../images/12.png)

> Aquí podemos ver el archivo `alive.txt` ya generado. Cada línea contiene la URL completa de un host que ha respondido positivamente durante el sondeo. Este archivo es la entrada directa que utilizará Nuclei en la siguiente fase. Gracias a este filtrado previo, nos aseguramos de que Nuclei solo trabaje sobre objetivos reales y accesibles.

---

## Fase 3 — Escaneo de vulnerabilidades con Nuclei

Con la lista de hosts activos ya disponible, podemos lanzar Nuclei sobre todos ellos de forma simultánea. Nuclei ejecutará automáticamente todos los templates disponibles sobre cada host, buscando vulnerabilidades conocidas, configuraciones incorrectas, exposiciones de información sensible y otros problemas de seguridad.

```bash
nuclei -l alive.txt
```

**¿Qué hace exactamente este comando?**

- `-l alive.txt` → indica a Nuclei que utilice el archivo con los hosts activos como lista de objetivos, en lugar de un único dominio.

Al no especificar ningún template concreto, Nuclei utilizará por defecto todos los templates disponibles en su instalación local, organizados por severidad y categoría.

![Nuclei ejecutando sus templates sobre los hosts activos del archivo alive.txt](../images/13.png)

> En la imagen se puede observar cómo Nuclei procesa los hosts de la lista uno a uno, mostrando en tiempo real los hallazgos que va detectando. Cada resultado indica el host afectado, el template que lo identificó, la severidad del hallazgo y una breve descripción del problema. Los hallazgos se colorean según su nivel de severidad para facilitar una lectura rápida: críticos en rojo, altos en naranja, medios en amarillo, e informativos en azul.

---

## Ventajas de este enfoque

Integrar Nuclei dentro de un flujo automatizado como este aporta múltiples ventajas frente a su uso aislado:

### Automatización completa del reconocimiento

Todo el proceso, desde el descubrimiento de subdominios hasta el análisis de vulnerabilidades, puede ejecutarse de forma encadenada sin intervención manual. Esto permite analizar grandes cantidades de activos en poco tiempo.

### Mayor eficiencia y menor ruido

Al filtrar previamente los hosts activos con Httpx, Nuclei solo trabaja sobre objetivos reales y accesibles. Esto reduce significativamente el número de fallos de conexión, acelera el análisis y hace que los resultados sean más limpios y útiles.

### Integración natural entre herramientas

Las tres herramientas comparten formatos compatibles: texto plano, una línea por entrada. Esto facilita enormemente la creación de pipelines y permite encadenarlas en un único comando si se desea:

```bash
subfinder -d target.com -silent | httpx-pd -silent | nuclei
```

### Escalabilidad

Este flujo funciona igualmente bien tanto para auditorías pequeñas (un único dominio con pocos subdominios) como para análisis de grandes infraestructuras con miles de activos. Solo es necesario ajustar la configuración de concurrencia de cada herramienta.

---

## Consideraciones importantes

Aunque este flujo automatiza gran parte del trabajo, es fundamental tener en cuenta algunos aspectos antes de ejecutarlo:

**Verificación manual de hallazgos.** No todos los resultados que reporta Nuclei representan vulnerabilidades reales. Algunos pueden ser falsos positivos producidos por configuraciones específicas del servidor o por comportamientos inesperados en la respuesta. Siempre es recomendable revisar los hallazgos más importantes de forma manual antes de incluirlos en un informe.

**Autorización previa obligatoria.** Este tipo de escaneos activos solo deben realizarse sobre sistemas para los que se disponga de autorización explícita por escrito. Ejecutar este flujo contra sistemas de terceros sin permiso constituye una actividad ilegal en la mayoría de jurisdicciones, independientemente de la intención.

**Control de la agresividad del escaneo.** En entornos de producción, es recomendable ajustar la concurrencia y la tasa de peticiones para evitar causar interrupciones en los servicios analizados. Nuclei ofrece parámetros como `-rate-limit` y `-c` para controlar esto.

**Actualización de los templates.** La efectividad de Nuclei depende directamente de la actualización de su base de templates. Es recomendable ejecutar `nuclei -update-templates` antes de cada ciclo de análisis para asegurarse de que se están utilizando las últimas detecciones disponibles.

---

## Conclusión

Integrar Nuclei dentro de un flujo de reconocimiento estructurado como el que se ha descrito en este documento permite optimizar significativamente el proceso de análisis de vulnerabilidades.

Al combinar herramientas especializadas para cada fase —Subfinder para el descubrimiento, Httpx para el filtrado y Nuclei para el análisis— los analistas pueden centrarse en lo que realmente aporta valor: interpretar los resultados, validar los hallazgos y generar conclusiones accionables, en lugar de dedicar tiempo a tareas repetitivas y de bajo valor.

Este flujo es ampliamente utilizado en programas de bug bounty, auditorías de seguridad y ejercicios de red team, y constituye una base sólida sobre la que construir workflows más avanzados adaptados a cada contexto.
