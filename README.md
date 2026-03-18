# 🔬 nuclei-guide

> Repositorio técnico sobre el uso de **Nuclei** en análisis de vulnerabilidades — workflows profesionales, cheatsheets, laboratorios prácticos y scripts de automatización.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Nuclei](https://img.shields.io/badge/tool-Nuclei-blueviolet)
![Status](https://img.shields.io/badge/status-active-brightgreen)

---

## 📁 Estructura del repositorio

```
nuclei-guide/
├── docs/           # Documentación técnica, guías y cheatsheets
├── images/         # Recursos visuales y capturas de pantalla
├── labs/           # Laboratorios prácticos
├── scripts/        # Scripts de automatización de pipelines
├── LICENSE
└── README.md
```

---

## 📚 Contenido

### `docs/`
Documentación técnica sobre el uso de Nuclei, organizada por módulos:
- Instalación y configuración
- Uso de templates oficiales y personalizados
- Cheatsheets de flags y opciones
- Workflows profesionales para bug bounty y pentesting

### `labs/`
Entornos y escenarios prácticos para aprender a usar Nuclei en situaciones reales:
- Detección de vulnerabilidades conocidas
- Pruebas con targets de práctica
- Ejercicios guiados paso a paso

### `scripts/`
Scripts de automatización listos para usar en pipelines de reconocimiento y escaneo.

### `images/`
Recursos visuales de apoyo para la documentación.

---

## ⚡ Pipeline de automatización

El script principal (`scripts/`) automatiza el flujo completo de reconocimiento + escaneo de vulnerabilidades:

```bash
#!/bin/bash
# Uso: ./pipeline.sh <dominio>

TARGET=$1

subfinder -d $TARGET > subdomains.txt    # Enumeración de subdominios
httpx -l subdomains.txt > alive.txt      # Filtrado de hosts activos
nuclei -l alive.txt -severity medium,high,critical -stats  # Escaneo de vulnerabilidades
```

**Flujo:**
```
Dominio objetivo
      │
      ▼
subfinder  ──►  subdomains.txt
      │
      ▼
httpx      ──►  alive.txt
      │
      ▼
nuclei     ──►  Resultados (medium / high / critical)
```

### Requisitos

| Herramienta | Instalación |
|-------------|-------------|
| [Nuclei](https://github.com/projectdiscovery/nuclei) | `go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest` |
| [subfinder](https://github.com/projectdiscovery/subfinder) | `go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest` |
| [httpx](https://github.com/projectdiscovery/httpx) | `go install github.com/projectdiscovery/httpx/cmd/httpx@latest` |

---

## 🚀 Inicio rápido

```bash
# Clonar el repositorio
git clone https://github.com/iamEscri/nuclei-guide.git
cd nuclei-guide

# Dar permisos al script
chmod +x scripts/pipeline.sh

# Ejecutar el pipeline completo
./scripts/pipeline.sh ejemplo.com
```

---

## ⚠️ Aviso legal

Este repositorio tiene fines **exclusivamente educativos**. Toda la información aquí contenida está orientada a profesionales de la ciberseguridad y estudiantes que operan en entornos autorizados.

> El uso de estas herramientas o técnicas sobre sistemas sin autorización expresa es **ilegal**. El autor no se hace responsable del uso indebido de este contenido.

---

## 📄 Licencia

Distribuido bajo la licencia [MIT](LICENSE).

---

<p align="center">
  Hecho con por <a href="https://github.com/iamEscri">iamEscri</a>
</p>
