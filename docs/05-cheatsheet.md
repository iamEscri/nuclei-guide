# 📋 Nuclei CheatSheet

> Hoja de referencia rápida para el uso de **Nuclei** en análisis de vulnerabilidades.  
> Diseñada para analistas que necesitan ejecutar escaneos de forma eficiente sin consultar la documentación completa.

---

## 🔍 ¿Qué es Nuclei?

**Nuclei** es un escáner de vulnerabilidades de código abierto desarrollado por [ProjectDiscovery](https://projectdiscovery.io). Funciona mediante **templates YAML** que describen cómo detectar vulnerabilidades, configuraciones inseguras o información sensible expuesta en sistemas web.

Sus principales ventajas son:
- Alta velocidad gracias a la ejecución concurrente de peticiones.
- Gran comunidad con miles de templates públicos mantenidos activamente.
- Flexibilidad para crear templates personalizados adaptados a cada entorno.

---

## ⚙️ Instalación rápida

```bash
# Con Go (recomendado)
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest

# Con gestor de binarios (Linux/macOS)
brew install nuclei

# Verificar instalación
nuclei -version
```

---

## 🎯 Escaneo básico

### Escanear un único objetivo

```bash
nuclei -u https://target.com
```

> Ejecuta todos los templates disponibles contra el objetivo indicado. Es el punto de partida más sencillo.

---

### Escanear múltiples objetivos desde un archivo

```bash
nuclei -l targets.txt
```

> El archivo `targets.txt` debe contener **una URL o IP por línea**. Ejemplo:
> ```
> https://target1.com
> https://target2.com
> 192.168.1.10
> ```

---

## 📂 Uso de templates

Los templates son el núcleo de Nuclei. Definen **qué buscar** y **cómo detectarlo**.

### Ejecutar una carpeta de templates

```bash
nuclei -u https://target.com -t cves/
```

> Lanza todos los templates del directorio `cves/`. Útil para centrar el escaneo en una categoría concreta (CVEs, exposiciones, misconfiguraciones, etc.).

---

### Ejecutar un template concreto

```bash
nuclei -u https://target.com -t templates/cves/2024/CVE-2024-XXXX.yaml
```

> Permite ejecutar un único template específico. Recomendado cuando ya se conoce la vulnerabilidad a verificar.

---

### Listar todos los templates disponibles

```bash
nuclei -tl
```

> Muestra en pantalla todos los templates instalados localmente con su ruta y metadatos.

---

## 🔴 Filtrado por severidad

Nuclei clasifica cada template según el nivel de riesgo de la vulnerabilidad que detecta. Los niveles disponibles son:

| Severidad  | Descripción                                     |
|------------|-------------------------------------------------|
| `info`     | Información expuesta sin impacto directo        |
| `low`      | Riesgo bajo, difícil de explotar               |
| `medium`   | Riesgo moderado, puede combinarse con otros    |
| `high`     | Riesgo alto, explotación directa probable      |
| `critical` | Riesgo crítico, impacto severo en el sistema   |

### Solo vulnerabilidades críticas

```bash
nuclei -u https://target.com -severity critical
```

### Vulnerabilidades de media a crítica (uso más habitual en auditorías)

```bash
nuclei -u https://target.com -severity medium,high,critical
```

> Filtrar por severidad reduce el ruido del escaneo y permite centrarse en los hallazgos con mayor impacto real.

---

## 📊 Mostrar estadísticas en tiempo real

```bash
nuclei -u https://target.com -stats
```

> Muestra un panel con el progreso del escaneo: templates ejecutados, peticiones enviadas, hallazgos encontrados y tiempo transcurrido. Muy útil en escaneos largos para saber el estado sin esperar al final.

---

## 🔄 Gestión de templates

### Actualizar el repositorio de templates

```bash
nuclei -update-templates
```

> Descarga las últimas versiones de los templates oficiales desde el repositorio de ProjectDiscovery. **Recomendado ejecutarlo antes de cada auditoría** para asegurarse de tener las detecciones más recientes.

---

### Validar templates (detectar errores)

```bash
nuclei -validate
```

> Analiza los templates instalados y detecta errores de sintaxis o configuración incorrecta. Esencial antes de usar templates personalizados en producción.

---

### Validar un template concreto

```bash
nuclei -validate -t mi-template.yaml
```

---

## 💾 Guardar resultados

### Guardar en texto plano

```bash
nuclei -u https://target.com -o resultados.txt
```

### Guardar en formato JSON (para procesado automatizado)

```bash
nuclei -u https://target.com -jsonl -o resultados.jsonl
```

> El formato JSONL (JSON Lines) facilita la integración con otras herramientas o pipelines de análisis. Cada línea es un hallazgo independiente en formato JSON.

---

## ⚡ Rendimiento y concurrencia

### Aumentar el número de peticiones concurrentes

```bash
nuclei -u https://target.com -c 50
```

> Por defecto Nuclei usa 25 workers concurrentes. Aumentar este valor acelera el escaneo en entornos con muchos objetivos.  
> **Precaución:** valores muy altos pueden saturar el objetivo o activar mecanismos de defensa como rate limiting o IDS/IPS.

---

### Limitar la tasa de peticiones (rate limiting)

```bash
nuclei -u https://target.com -rl 100
```

> Limita el número de peticiones por segundo. Útil para escaneos sigilosos o cuando se quiere evitar interrumpir el servicio analizado.

---

### Añadir un delay entre peticiones

```bash
nuclei -u https://target.com -p 200ms
```

> Introduce una pausa de 200 milisegundos entre peticiones. Ayuda a reducir el impacto en el objetivo.

---

## 🔇 Control de salida (verbosidad)

### Modo silencioso (solo resultados)

```bash
nuclei -u https://target.com -silent
```

### Modo verbose (información detallada)

```bash
nuclei -u https://target.com -v
```

### Mostrar todas las peticiones y respuestas HTTP

```bash
nuclei -u https://target.com -debug
```

> El modo debug es útil para depurar templates propios o entender exactamente qué peticiones está realizando la herramienta.

---

## 🏷️ Filtrado avanzado por tags

Los templates de Nuclei llevan **etiquetas** que permiten agruparlos por tecnología, tipo de vulnerabilidad o protocolo.

### Ejecutar templates con un tag concreto

```bash
nuclei -u https://target.com -tags cve
nuclei -u https://target.com -tags wordpress
nuclei -u https://target.com -tags sqli
```

### Combinar tags

```bash
nuclei -u https://target.com -tags cve,rce
```

> Esto ejecutará únicamente los templates que tengan **ambas etiquetas** a la vez.

---

### Excluir tags específicos

```bash
nuclei -u https://target.com -etags dos
```

> Excluye los templates marcados con el tag `dos` (Denial of Service), evitando acciones que puedan interrumpir el servicio objetivo.

---

## 🌐 Opciones de red y proxy

### Usar un proxy HTTP (por ejemplo, Burp Suite)

```bash
nuclei -u https://target.com -proxy http://127.0.0.1:8080
```

> Redirige todas las peticiones de Nuclei a través del proxy indicado. Permite inspeccionar y analizar el tráfico generado con herramientas como Burp Suite o ZAP.

---

### Usar headers personalizados (por ejemplo, para autenticación)

```bash
nuclei -u https://target.com -H "Authorization: Bearer TOKEN" -H "X-Custom-Header: valor"
```

> Permite añadir cabeceras HTTP en todas las peticiones. Necesario cuando el objetivo requiere autenticación previa.

---

## 🛡️ Uso responsable

> **⚠️ Aviso legal:** Nuclei debe utilizarse **únicamente sobre sistemas para los que se tiene autorización explícita**.  
> El uso de esta herramienta contra sistemas sin permiso puede constituir un **delito informático** según la legislación vigente.  
> En entornos de auditoría, asegúrate siempre de contar con un contrato o documento de autorización firmado.

---

## 🧩 Ejemplo completo de auditoría

El siguiente comando representa un flujo habitual durante una auditoría profesional:

```bash
nuclei -l targets.txt \
       -severity medium,high,critical \
       -tags cve,misconfig \
       -stats \
       -c 30 \
       -rl 50 \
       -o resultados.txt \
       -jsonl -o resultados.jsonl
```

**¿Qué hace cada parámetro?**

| Parámetro                       | Función                                                        |
|---------------------------------|----------------------------------------------------------------|
| `-l targets.txt`                | Lee los objetivos desde un archivo                            |
| `-severity medium,high,critical`| Filtra solo hallazgos de media a crítica                      |
| `-tags cve,misconfig`           | Ejecuta templates de CVEs y misconfiguraciones                |
| `-stats`                        | Muestra estadísticas del escaneo en tiempo real               |
| `-c 30`                         | Usa 30 workers concurrentes                                   |
| `-rl 50`                        | Limita a 50 peticiones por segundo                            |
| `-o resultados.txt`             | Guarda los resultados en texto plano                          |
| `-jsonl -o resultados.jsonl`    | Guarda los resultados también en formato JSON Lines           |

---

## 📌 Referencia rápida de flags

| Flag                  | Descripción                                      |
|-----------------------|--------------------------------------------------|
| `-u <url>`            | Objetivo único                                   |
| `-l <archivo>`        | Lista de objetivos                               |
| `-t <template/dir>`   | Template o directorio de templates               |
| `-severity <nivel>`   | Filtrar por severidad                            |
| `-tags <tag>`         | Filtrar por etiqueta                             |
| `-etags <tag>`        | Excluir templates con esa etiqueta               |
| `-c <num>`            | Número de workers concurrentes                   |
| `-rl <num>`           | Peticiones por segundo (rate limit)              |
| `-p <tiempo>`         | Delay entre peticiones (ej: `200ms`)             |
| `-o <archivo>`        | Guardar resultados en archivo                    |
| `-jsonl`              | Salida en formato JSON Lines                     |
| `-stats`              | Mostrar estadísticas en tiempo real              |
| `-silent`             | Solo mostrar resultados                          |
| `-v`                  | Modo verbose                                     |
| `-debug`              | Mostrar peticiones y respuestas HTTP completas   |
| `-proxy <url>`        | Redirigir tráfico por un proxy                   |
| `-H <header>`         | Cabecera HTTP personalizada                      |
| `-update-templates`   | Actualizar templates al repositorio oficial      |
| `-validate`           | Validar templates                                |
| `-tl`                 | Listar todos los templates instalados            |
| `-version`            | Mostrar versión instalada                        |

---

> 📁 Este documento forma parte del repositorio [nuclei-guide](https://github.com/iamEscri/nuclei-guide).  
> Para templates personalizados, workflows y laboratorios prácticos, consulta el resto del repositorio.
