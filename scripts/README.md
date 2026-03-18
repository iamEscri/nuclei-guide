# 📂 scripts/

> Scripts de automatización de pipelines para reconocimiento y análisis de vulnerabilidades con Nuclei.

---

## 📄 Archivos

| Archivo | Descripción |
|--------|-------------|
| `nuclei_pipeline.sh` | Pipeline completo: enumeración de subdominios → hosts activos → escaneo de vulnerabilidades |

---

## 🔧 `nuclei_pipeline.sh`

Automatiza el flujo completo de recon + escaneo encadenando tres herramientas de [ProjectDiscovery](https://github.com/projectdiscovery):

```bash
#!/bin/bash
TARGET=$1
subfinder -d $TARGET > subdomains.txt
httpx -l subdomains.txt > alive.txt
nuclei -l alive.txt -severity medium,high,critical -stats
```

### ¿Qué hace cada paso?

```
$TARGET (dominio)
      │
      ▼
┌─────────────┐
│  subfinder  │  Enumera subdominios del dominio objetivo
└──────┬──────┘
       │ subdomains.txt
       ▼
┌─────────────┐
│    httpx    │  Filtra qué subdominios están activos (responden HTTP/S)
└──────┬──────┘
       │ alive.txt
       ▼
┌─────────────┐
│   nuclei    │  Escanea los hosts vivos buscando vulns medium/high/critical
└─────────────┘
```

| Paso | Herramienta | Output | Función |
|------|-------------|--------|---------|
| 1 | `subfinder` | `subdomains.txt` | Descubrimiento de subdominios |
| 2 | `httpx` | `alive.txt` | Filtrado de hosts activos |
| 3 | `nuclei` | stdout + stats | Detección de vulnerabilidades |

---

## 🚀 Uso

```bash
# Dar permisos de ejecución
chmod +x nuclei_pipeline.sh

# Ejecutar contra un dominio
./nuclei_pipeline.sh ejemplo.com
```

---

## 📦 Requisitos

| Herramienta | Instalación |
|-------------|-------------|
| [subfinder](https://github.com/projectdiscovery/subfinder) | `go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest` |
| [httpx](https://github.com/projectdiscovery/httpx) | `go install github.com/projectdiscovery/httpx/cmd/httpx@latest` |
| [nuclei](https://github.com/projectdiscovery/nuclei) | `go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest` |

---

## ⚠️ Aviso legal

Usar este script únicamente contra sistemas sobre los que tengas **autorización expresa**. El uso no autorizado puede ser constitutivo de delito.

---

_Parte del repositorio [nuclei-guide](https://github.com/iamEscri/nuclei-guide) · by [@iamEscri](https://github.com/iamEscri)_
