# 🔍 Nuclei Guide

> Recurso técnico profesional para el uso de **Nuclei** en flujos reales de análisis de vulnerabilidades. Orientado a analistas de ciberseguridad que buscan automatizar y escalar su proceso de reconocimiento.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Nuclei](https://img.shields.io/badge/tool-Nuclei-blueviolet)
![Status](https://img.shields.io/badge/status-active-brightgreen)


---

## 📌 ¿Qué encontrarás aquí?

Este repositorio no es un simple listado de comandos. Está diseñado para que entiendas:

- **Cuándo** usar Nuclei dentro de un workflow real
- **Cómo** integrarlo con otras herramientas (subfinder, httpx)
- **Qué resultados** esperar y cómo validarlos
- **Cuáles son sus limitaciones** reales en entornos profesionales

---

## 🧠 ¿Qué es Nuclei?

**Nuclei** es un scanner de vulnerabilidades basado en templates que permite realizar detecciones rápidas y automatizadas sobre aplicaciones web, APIs e infraestructura expuesta.

Su principal ventaja es la **velocidad y escalabilidad**, siendo especialmente útil en fases de reconocimiento masivo.

```
Template → Target → Detección automatizada → Output estructurado
```

---

## 📁 Estructura del repositorio

```
nuclei-guide/
├── docs/           # Documentación técnica, guías y cheatsheets
├── images/         # Recursos visuales y capturas de pantalla
├── labs/           # Laboratorios prácticos con entornos controlados
├── scripts/        # Scripts de automatización de pipelines
├── LICENSE
└── README.md
```

---

## ⚙️ Metodología de uso

Nuclei debe integrarse dentro de un flujo estructurado, no ejecutarse de forma aislada:

```
Enumeración de subdominios → Hosts activos → Escaneo de vulnerabilidades → Validación manual
```

### Pipeline aplicado en este repositorio

```bash
subfinder → httpx → nuclei → validación manual
```

| Fase | Herramienta | Propósito |
|------|-------------|-----------|
| Enumeración | `subfinder` | Descubrir subdominios |
| Filtrado | `httpx` | Identificar hosts activos |
| Escaneo | `nuclei` | Detectar vulnerabilidades conocidas |
| Validación | Manual | Confirmar impacto real |

---

## 🚀 Uso práctico

### 1. Enumeración de subdominios

```bash
subfinder -d target.com -o subdomains.txt
```

### 2. Filtrado de hosts activos

```bash
httpx -l subdomains.txt -silent -o alive.txt
```

### 3. Escaneo con Nuclei

```bash
# Usando los templates por defecto (recomendado)
nuclei -l alive.txt -t ~/nuclei-templates/ -o results.txt

# Usando templates personalizados del repo
nuclei -l alive.txt -t ./scripts/templates/ -o results.txt
```

> 📂 Los scripts de automatización del pipeline completo están disponibles en [`/scripts`](./scripts/).

---

## 📦 Templates de Nuclei

Antes de ejecutar Nuclei, asegúrate de tener los templates actualizados:

```bash
nuclei -update-templates
```

Nuclei descarga y mantiene los templates oficiales en `~/nuclei-templates/`. Sin templates actualizados, el escaneo no detectará las vulnerabilidades más recientes.

---

## 🧪 Laboratorio práctico

El directorio [`/labs`](./labs/) incluye un entorno de laboratorio basado en Docker para practicar en un escenario controlado.

### Objetivo
Detectar vulnerabilidades reales sobre una aplicación vulnerable desplegada localmente.

### Proceso
1. Despliegue de la aplicación vulnerable
2. Ejecución del pipeline completo
3. Uso de templates específicos
4. Análisis y validación de resultados

### Conclusión
Nuclei permite detectar exposiciones de forma rápida, pero **siempre requiere validación manual** para confirmar el impacto real.

---

## ⚠️ Limitaciones

Nuclei es potente, pero tiene limitaciones importantes que todo analista debe conocer:

- **Dependencia de templates**: solo detecta lo que sus templates cubren
- **Falsos positivos**: algunos templates detectan configuraciones sin impacto explotable real; los resultados deben verificarse manualmente
- **Sin análisis lógico**: no detecta vulnerabilidades de lógica de negocio
- **No sustituye auditorías manuales**: es un acelerador, no una solución final

### ✅ Úsalo para
- Reconocimiento masivo y automatizado
- Detección rápida de exposiciones conocidas
- Integración en pipelines de CI/CD
- Fases iniciales de análisis

### ❌ No lo uses como única herramienta en
- Auditorías profundas
- Análisis de lógica de negocio
- Validación final de vulnerabilidades críticas

---

## 🔄 Falsos positivos y validación

Todo output de Nuclei debe pasar por un proceso de validación:

1. **Verificar manualmente** la vulnerabilidad detectada
2. **Confirmar el impacto real** en el contexto del target
3. **No confiar ciegamente** en el output automatizado

> 👉 Nuclei **detecta**, pero no **valida completamente**.

---

## 🔍 Comparativa con otras herramientas

| Herramienta | Uso principal | Ventajas | Limitaciones |
|-------------|--------------|----------|--------------|
| **Nuclei** | Recon masivo | Rápido, automatizable, gratuito | Dependencia de templates |
| **Nessus** | Auditoría completa | Alta precisión | Más lento, licencia de pago |
| **OpenVAS** | Open source | Flexible, sin coste | Complejo de configurar |

---

## 📚 Documentación adicional

La carpeta [`/docs`](./docs/) contiene:

- Guías técnicas detalladas
- Cheatsheets de uso rápido
- Recursos de referencia para analistas

---

## 🎯 Conclusión

Nuclei es una herramienta clave en fases de **reconocimiento y detección masiva** dentro de un análisis de vulnerabilidades. Su valor reside en la automatización, escalabilidad y rapidez.

Sin embargo, su uso debe complementarse siempre con:
- Validación manual de resultados
- Otras herramientas de análisis
- Criterio técnico del analista

> 👉 Utilizado correctamente, Nuclei permite **reducir significativamente la superficie de ataque** en fases iniciales de un engagement. Combínalo siempre con `subfinder` y `httpx` para un pipeline completo y eficiente.

---

## 👤 Autor

Proyecto desarrollado como parte de formación en análisis de vulnerabilidades y seguridad ofensiva.  
Diseñado como recurso técnico reutilizable y material de portfolio profesional.
