<div align="center">

# 🔍 nuclei-guide

**Guía técnica completa sobre Nuclei — desde la instalación hasta la creación de templates personalizados**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Nuclei](https://img.shields.io/badge/Nuclei-v3.x-blueviolet)](https://github.com/projectdiscovery/nuclei)
[![ProjectDiscovery](https://img.shields.io/badge/by-ProjectDiscovery-orange)](https://projectdiscovery.io)
![Plataforma](https://img.shields.io/badge/plataforma-Linux%20%7C%20Kali-lightgrey)
![Estado](https://img.shields.io/badge/estado-activo-brightgreen)

</div>

---

## 📖 ¿Qué es este repositorio?

Este repositorio es una **guía técnica de referencia** sobre el uso de [Nuclei](https://github.com/projectdiscovery/nuclei), el escáner de vulnerabilidades de código abierto desarrollado por ProjectDiscovery. Está pensado tanto para quienes se acercan a la herramienta por primera vez como para analistas que quieren profundizar en workflows más avanzados y en la creación de templates propios.

El contenido está organizado de forma progresiva: se parte de los conceptos básicos y se avanza hacia casos de uso reales, laboratorios prácticos y desarrollo de templates personalizados.

> ⚠️ **Aviso legal:** Todo el contenido de este repositorio tiene fines estrictamente educativos. Nunca ejecutes escaneos sobre sistemas que no sean de tu propiedad o para los que no dispongas de autorización expresa. El uso indebido de estas técnicas puede tener consecuencias legales.

---

## 📁 Estructura del repositorio

```
nuclei-guide/
├── docs/               # Documentación teórica y cheatsheets
├── labs/               # Laboratorios prácticos paso a paso
├── templates/          # Templates personalizados de Nuclei (YAML)
├── images/             # Capturas de pantalla utilizadas en la documentación
├── LICENSE
└── README.md
```

### `docs/` — Documentación y referencia

Contiene la documentación teórica de la herramienta: conceptos clave, flags disponibles, tipos de templates, cheatsheets de uso rápido y guías de referencia para el trabajo diario con Nuclei.

### `labs/` — Laboratorios prácticos

Laboratorios guiados paso a paso que combinan el despliegue de entornos vulnerables con la ejecución real de escaneos. Están diseñados para aprender haciendo, en un entorno local controlado.

### `templates/` — Templates personalizados

Colección de templates YAML desarrollados a medida para detectar vulnerabilidades específicas. Incluye ejemplos comentados y plantillas base para facilitar la creación de nuevos templates.

### `images/` — Capturas de pantalla

Recursos visuales utilizados a lo largo de la documentación y los laboratorios.

---

## 🚀 Inicio rápido

### Instalación de Nuclei

**Con Go (recomendado):**
```bash
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
```

**Con binario precompilado:**
```bash
wget https://github.com/projectdiscovery/nuclei/releases/latest/download/nuclei_linux_amd64.zip
unzip nuclei_linux_amd64.zip
chmod +x nuclei
sudo mv nuclei /usr/local/bin/
```

**Actualizar templates:**
```bash
nuclei -update-templates
```

### Primer escaneo

```bash
# Escaneo básico sobre un objetivo
nuclei -u https://ejemplo.com

# Escaneo con estadísticas en tiempo real
nuclei -u https://ejemplo.com -stats

# Filtrar por severidad y guardar resultados
nuclei -u https://ejemplo.com -severity medium,high,critical -o resultados.txt
```

---

## 🧪 Laboratorios disponibles

| Laboratorio | Descripción | Nivel |
|-------------|-------------|-------|
| [Escaneo con OWASP Juice Shop](labs/laboratorio-nuclei.md) | Despliegue de una aplicación vulnerable con Docker y escaneo completo con Nuclei | Principiante |

> Se irán añadiendo más laboratorios progresivamente.

---

## 📋 Cheatsheet rápido

```bash
# Escaneo básico
nuclei -u https://objetivo.com

# Múltiples objetivos desde archivo
nuclei -l targets.txt

# Filtrar por severidad
nuclei -u https://objetivo.com -severity low,medium,high,critical

# Usar un template específico
nuclei -u https://objetivo.com -t templates/mi-template.yaml

# Usar un directorio de templates
nuclei -u https://objetivo.com -t templates/

# Filtrar por tags
nuclei -u https://objetivo.com -tags cve,xss,sqli

# Solo templates nuevos
nuclei -u https://objetivo.com -new-templates

# Escaneo silencioso (solo hallazgos)
nuclei -u https://objetivo.com -silent

# Salida en formato JSON
nuclei -u https://objetivo.com -jsonl -o resultados.jsonl

# Limitar tasa de peticiones
nuclei -u https://objetivo.com -rate-limit 50

# Modo debug (ver peticiones y respuestas)
nuclei -u https://objetivo.com -t mi-template.yaml -debug
```

---

## 🛠️ Estructura de un template

Los templates de Nuclei están escritos en YAML y definen exactamente cómo debe comportarse el escáner: qué petición enviar, qué respuesta esperar y cómo clasificar el hallazgo.

```yaml
id: ejemplo-deteccion-cabecera

info:
  name: Detección de cabecera de seguridad ausente
  author: iamEscri
  severity: low
  description: Comprueba si la cabecera X-Frame-Options está ausente en la respuesta HTTP.
  tags: headers,misconfig

http:
  - method: GET
    path:
      - "{{BaseURL}}"

    matchers-condition: and
    matchers:
      - type: status
        status:
          - 200

      - type: word
        part: header
        negative: true
        words:
          - "X-Frame-Options"
```

Consulta la carpeta [`templates/`](templates/) para ver ejemplos completos y comentados.

---

## 📚 Documentación adicional

| Recurso | Enlace |
|---------|--------|
| Documentación oficial de Nuclei | [docs.projectdiscovery.io](https://docs.projectdiscovery.io) |
| Repositorio oficial de Nuclei | [github.com/projectdiscovery/nuclei](https://github.com/projectdiscovery/nuclei) |
| Templates oficiales de la comunidad | [github.com/projectdiscovery/nuclei-templates](https://github.com/projectdiscovery/nuclei-templates) |
| Editor online de templates | [nuclei.projectdiscovery.io](https://nuclei.projectdiscovery.io) |

---

## 📄 Licencia

Este proyecto está disponible bajo la licencia [MIT](LICENSE). Puedes usar, modificar y distribuir el contenido libremente, siempre con fines éticos y legales.

---

<div align="center">
  <sub>Desarrollado por <a href="https://github.com/iamEscri">iamEscri</a> · Contenido en constante actualización</sub>
</div>
