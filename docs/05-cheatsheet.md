# Nuclei CheatSheet

Esta sección presenta una **hoja de referencia rápida** con los comandos más utilizados de Nuclei durante análisis de vulnerabilidades.

El objetivo de este documento es proporcionar a los analistas una guía rápida para ejecutar escaneos comunes sin necesidad de consultar la documentación completa.

---

# Escaneo básico

Escaneo de un único objetivo:

```bash
nuclei -u https://target.com
```

Escaneo de múltiples objetivos desde un archivo:

nuclei -l targets.txt
Uso de templates

Ejecutar un conjunto específico de templates:

nuclei -u https://target.com -t cves/

Ejecutar un template concreto:

nuclei -u https://target.com -t template.yaml
Filtrado por severidad

Escanear únicamente vulnerabilidades críticas:

nuclei -u https://target.com -severity critical

Escanear vulnerabilidades medias, altas y críticas:

nuclei -u https://target.com -severity medium,high,critical
Mostrar estadísticas

Mostrar estadísticas del escaneo en tiempo real:

nuclei -u https://target.com -stats
Actualizar templates

Actualizar el repositorio de templates:

nuclei -update-templates
Validar templates

Validar templates para detectar errores:

nuclei -validate
Guardar resultados

Guardar resultados en un archivo:

nuclei -u https://target.com -o resultados.txt
Aumentar concurrencia

Aumentar el número de peticiones concurrentes:

nuclei -u https://target.com -c 50

Esto puede acelerar el escaneo en entornos con muchos objetivos.

Ejemplo completo

Un ejemplo común durante auditorías sería:

nuclei -l targets.txt -severity medium,high,critical -stats -o resultados.txt

Este comando:

analiza múltiples objetivos

filtra vulnerabilidades relevantes

muestra estadísticas

guarda los resultados en un archivo

Nota

Los ejemplos utilizan target.com como dominio genérico para representar el sistema objetivo del análisis.
En un escenario real debe sustituirse por el dominio o dirección IP del sistema que se desea analizar.
