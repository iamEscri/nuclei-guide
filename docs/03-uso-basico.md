# Uso básico de Nuclei

Una vez instalada la herramienta y actualizados los templates, el siguiente paso es aprender a ejecutar escaneos básicos utilizando Nuclei.

Esta sección presenta los comandos más utilizados por analistas para realizar análisis iniciales de vulnerabilidades sobre uno o varios objetivos.

---

# Escaneo de un objetivo individual

La forma más sencilla de utilizar Nuclei es analizar una única URL.

```bash
nuclei -u https://target.com
```
![Foto 1](../images)

En este caso:

-u indica la URL objetivo.

Nuclei ejecutará automáticamente los templates disponibles sobre ese objetivo.

Durante el escaneo, la herramienta analizará el servicio y mostrará posibles hallazgos relacionados con vulnerabilidades conocidas, configuraciones inseguras o exposición de información.

Escaneo de múltiples objetivos

En escenarios reales de pentesting o bug bounty es habitual trabajar con múltiples objetivos.
Para ello, Nuclei permite cargar una lista de hosts desde un archivo.

Por ejemplo, si tenemos un archivo llamado targets.txt:

