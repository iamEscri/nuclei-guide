# Introducción a Nuclei

En el análisis moderno de vulnerabilidades, una de las tareas más importantes para los analistas de seguridad es **identificar de forma rápida y eficiente posibles fallos en sistemas, aplicaciones y servicios expuestos**.  
A medida que las infraestructuras crecen y la superficie de ataque aumenta, realizar estas comprobaciones manualmente se vuelve poco viable. Por este motivo, los analistas recurren a herramientas que permiten **automatizar la detección de vulnerabilidades conocidas**.

Una de las herramientas que ha ganado gran popularidad en los últimos años dentro de la comunidad de ciberseguridad es **Nuclei**.

---

# ¿Qué es Nuclei?

**Nuclei** es un escáner de vulnerabilidades rápido y altamente configurable desarrollado por el equipo de **ProjectDiscovery**.  

Su principal característica es que se basa en el uso de **templates definidos en YAML**, que describen patrones específicos que el escáner debe buscar en un sistema objetivo.

En lugar de depender únicamente de una base de datos interna de vulnerabilidades, Nuclei utiliza estos templates para detectar:

- Vulnerabilidades conocidas (CVEs)
- Errores de configuración
- Exposición de información sensible
- Paneles administrativos accesibles
- Tecnologías vulnerables
- Comportamientos inseguros en aplicaciones web

Esto convierte a Nuclei en una herramienta extremadamente flexible que puede adaptarse a distintos escenarios de auditoría.

---

# ¿Por qué es una herramienta importante para analistas?

El uso de herramientas como Nuclei permite a los analistas de seguridad **automatizar gran parte del proceso de detección inicial de vulnerabilidades**.  

Entre sus principales ventajas destacan:

- **Alta velocidad de escaneo**  
  Permite analizar grandes cantidades de objetivos en poco tiempo.

- **Arquitectura basada en templates**  
  Los analistas pueden crear o modificar templates para detectar vulnerabilidades específicas.

- **Gran comunidad**  
  Existe un repositorio público de templates mantenido activamente por la comunidad de seguridad.

- **Integración con otras herramientas de reconocimiento**  
  Nuclei suele utilizarse dentro de flujos de trabajo junto a herramientas como:

  - subfinder
  - httpx
  - nmap
  - amass

Gracias a esta integración, es posible construir **pipelines automatizados de reconocimiento y escaneo de vulnerabilidades**.

---

# Uso de Nuclei en el ciclo de análisis de vulnerabilidades

Dentro de una metodología de análisis de seguridad, Nuclei suele emplearse **después de la fase de descubrimiento de activos**.

Un flujo de trabajo típico puede ser:

Reconocimiento → Descubrimiento de hosts → Identificación de servicios → Escaneo de vulnerabilidades

Por ejemplo:

Subfinder → Httpx → Nuclei


En este flujo:

- **Subfinder** descubre subdominios
- **Httpx** identifica qué hosts están activos
- **Nuclei** analiza esos hosts en busca de vulnerabilidades

Este enfoque permite automatizar gran parte del proceso de análisis inicial y centrar el trabajo manual en los hallazgos más relevantes.

---

# Objetivo de esta guía

El objetivo de este repositorio es proporcionar **una guía práctica y estructurada para el uso profesional de Nuclei**, orientada a analistas de ciberseguridad.

A lo largo de este proyecto se abordarán los siguientes aspectos:

- Instalación y configuración de la herramienta
- Uso básico de Nuclei
- Comandos más utilizados
- Integración en flujos de trabajo de pentesting
- Creación de templates personalizados
- Ejemplos prácticos de uso

La finalidad es que este material pueda servir como **referencia técnica rápida para analistas**, facilitando el aprendizaje y la aplicación de la herramienta en escenarios reales.

