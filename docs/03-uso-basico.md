# Uso básico de Nuclei

Una vez instalada la herramienta y actualizados los templates, el siguiente paso es aprender a ejecutar escaneos básicos utilizando Nuclei.

Esta sección presenta los comandos más utilizados por analistas para realizar análisis iniciales de vulnerabilidades sobre uno o varios objetivos.

---

# Escaneo de un objetivo individual

La forma más sencilla de utilizar Nuclei es analizar una única URL.

```bash
nuclei -u https://target.com
