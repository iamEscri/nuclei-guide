# Creación y uso de templates en Nuclei

Los **templates** son el componente principal de Nuclei.  
Un template define una serie de reglas que permiten detectar vulnerabilidades, configuraciones inseguras o comportamientos específicos en un sistema objetivo.

Estos templates están escritos en **YAML**, un formato de configuración fácil de leer y ampliamente utilizado en herramientas de automatización.

Gracias a este enfoque, los analistas pueden:

- utilizar templates creados por la comunidad
- modificar templates existentes
- crear sus propios templates personalizados

Esto convierte a Nuclei en una herramienta extremadamente flexible.

---

# Estructura básica de un template

Un template de Nuclei suele estar compuesto por varias secciones principales:

- `id`
- `info`
- `requests`

Cada una de ellas define diferentes aspectos del comportamiento del escáner.

---

# Ejemplo de template

A continuación se muestra un ejemplo simple de template que intenta detectar una posible vulnerabilidad XSS.

```yaml
id: example-xss
```

info:
  name: Example XSS Detection
  author: Escri
  severity: medium
  description: Detecta un posible parámetro vulnerable a XSS

requests:
  - method: GET
    path:
      - "{{BaseURL}}/?q=<script>alert(1)</script>"
Explicación del template
ID
id: example-xss

El campo id identifica de forma única el template.
Debe ser un nombre claro que permita reconocer rápidamente su propósito.

Información del template
info:
  name: Example XSS Detection
  author: Escri
  severity: medium
  description: Detecta un posible parámetro vulnerable a XSS

La sección info describe el template.

Contiene información como:

nombre del template

autor

nivel de severidad

descripción de la prueba

Esto facilita organizar y clasificar los templates.

Requests
requests:
  - method: GET
    path:
      - "{{BaseURL}}/?q=<script>alert(1)</script>"

La sección requests define la petición HTTP que Nuclei enviará al objetivo.

En este ejemplo:

se realiza una petición GET

se añade un parámetro que contiene un payload XSS.

Si el servidor refleja ese payload en la respuesta, podría indicar una posible vulnerabilidad.

Ejecución de un template personalizado

Una vez creado el template, se puede ejecutar con Nuclei utilizando el parámetro -t.

Ejemplo:

nuclei -u https://target.com -t example-template.yaml

Esto ejecutará únicamente el template especificado sobre el objetivo.

Uso de templates de la comunidad

Nuclei cuenta con un repositorio público de templates mantenido por la comunidad de seguridad.

Estos templates cubren una amplia variedad de detecciones, incluyendo:

CVEs conocidas

errores de configuración

exposición de paneles administrativos

fugas de información

detección de tecnologías

Los templates se actualizan constantemente, por lo que es recomendable mantenerlos actualizados.

nuclei -update-templates
Buenas prácticas al crear templates

Cuando se desarrollan templates personalizados es recomendable:

utilizar identificadores claros

documentar correctamente la sección info

probar el template en entornos controlados

evitar generar falsos positivos

Esto facilita mantener una colección organizada y fiable de templates.

Conclusión

Los templates permiten adaptar Nuclei a diferentes escenarios de análisis de vulnerabilidades.

La posibilidad de crear templates personalizados convierte a la herramienta en un recurso muy potente para automatizar pruebas de seguridad y detectar comportamientos específicos en aplicaciones y servicios.
