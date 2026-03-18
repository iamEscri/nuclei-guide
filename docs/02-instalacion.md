# Instalación de Nuclei

Antes de comenzar a utilizar Nuclei, es necesario preparar correctamente el entorno de trabajo: instalar la herramienta y descargar su repositorio de templates (plantillas de detección).

En esta sección se describen los métodos de instalación más habituales, con especial atención al entorno **Kali Linux**, que es la distribución de referencia en laboratorios de ciberseguridad y pentesting. También se explica una instalación alternativa mediante Go para quienes prefieran disponer de la última versión de desarrollo.

---

## Instalación en Kali Linux mediante APT

La forma más rápida y recomendada de instalar Nuclei en Kali Linux es a través del gestor de paquetes **APT**. Este método garantiza una instalación limpia, integrada con el sistema de paquetes de la distribución y fácilmente actualizable en el futuro.

Abre una terminal y ejecuta los siguientes comandos:

```bash
sudo apt update
sudo apt install nuclei
```

> **¿Qué hace cada comando?**
> - `sudo apt update` — Sincroniza la lista de paquetes disponibles con los repositorios de Kali. Esto asegura que se va a instalar la versión más reciente disponible.
> - `sudo apt install nuclei` — Descarga e instala Nuclei junto con todas sus dependencias necesarias.

### Verificación de la instalación

Una vez finalizada la instalación, es importante comprobar que la herramienta ha quedado correctamente instalada en el sistema. Para ello ejecuta:

```bash
nuclei -version
```

![Versión de Nuclei tras la instalación](../images/1.png)

Si la instalación fue correcta, el sistema mostrará en pantalla la versión instalada de Nuclei, el número de build y la fecha de compilación. Si en cambio aparece un error del tipo `command not found`, revisa que el paquete se instaló sin errores y que el directorio de binarios se encuentra en el `PATH` del sistema.

---

## Actualización de los templates

Los **templates** son el componente más importante de Nuclei. Son ficheros escritos en formato YAML que contienen las reglas y condiciones que la herramienta utiliza para detectar vulnerabilidades, configuraciones erróneas, tecnologías expuestas y mucho más.

Sin templates, Nuclei no puede realizar ningún análisis. Por eso, justo después de instalar la herramienta, el primer paso es descargar el repositorio oficial de templates mantenido por la comunidad de ProjectDiscovery.

Ejecuta el siguiente comando:

```bash
nuclei -update-templates
```

![Actualización del repositorio de templates](../images/2.png)

> Este comando conecta con el repositorio oficial de templates en GitHub y descarga la versión más reciente. Se recomienda ejecutarlo periódicamente para disponer siempre de las últimas detecciones.

### Ubicación de los templates

Por defecto, Nuclei almacena todos los templates descargados en el siguiente directorio del usuario:

```
~/.nuclei-templates/
```

![Estructura del directorio de templates](../images/3.png)

Dentro de este directorio encontrarás una estructura de carpetas organizada por categorías, lo que facilita localizar los templates según el tipo de análisis que quieras realizar. Algunas de las categorías más relevantes son:

- **cves/** — Templates para detectar vulnerabilidades conocidas (CVEs) en servicios y aplicaciones.
- **exposures/** — Detecta ficheros o recursos sensibles expuestos públicamente, como backups, logs o credenciales.
- **misconfiguration/** — Identifica errores de configuración habituales en servidores web, paneles de administración, etc.
- **technologies/** — Detecta qué tecnologías, frameworks o versiones están siendo utilizadas por el objetivo.
- **panels/** — Localiza paneles de administración accesibles públicamente (WordPress, Kibana, Grafana, etc.).

Estos templates pueden usarse directamente tal como están o modificarse y adaptarse a las necesidades específicas de cada análisis.

---

## Instalación alternativa mediante Go

Si prefieres disponer de la versión de desarrollo más reciente de Nuclei, o si estás trabajando en un entorno donde no tienes acceso a los repositorios de APT, puedes instalar la herramienta directamente desde el código fuente usando **Go**.

> **Requisito previo:** Necesitas tener Go instalado en tu sistema (versión 1.21 o superior). Puedes verificarlo ejecutando `go version`.

Ejecuta el siguiente comando para descargar y compilar Nuclei directamente desde el repositorio oficial:

```bash
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
```

> El flag `-v` activa el modo verbose, mostrando el progreso de descarga y compilación. El sufijo `@latest` indica que se debe obtener la última versión disponible en el repositorio.

### Añadir el binario al PATH

Tras la instalación mediante Go, el binario de Nuclei se guarda en el directorio `~/go/bin/`. Para poder ejecutar `nuclei` desde cualquier ubicación sin tener que indicar la ruta completa, es necesario añadir ese directorio al `PATH` del sistema.

Añade la siguiente línea al final de tu fichero `~/.bashrc` o `~/.zshrc`:

```bash
export PATH=$PATH:$HOME/go/bin
```

Después, recarga la configuración del shell para que el cambio surta efecto:

```bash
source ~/.bashrc   # o source ~/.zshrc si usas Zsh
```

A partir de este momento podrás ejecutar `nuclei` directamente desde cualquier directorio.

---

## Comprobación final

Independientemente del método de instalación utilizado, puedes verificar en cualquier momento que Nuclei está correctamente instalado y accesible ejecutando el siguiente comando:

```bash
nuclei -h
```

![Pantalla de ayuda de Nuclei](../images/4.png)

Este comando muestra la pantalla de ayuda completa de la herramienta, con todos los flags y opciones disponibles. Si la ayuda se muestra correctamente, significa que Nuclei está listo para ser utilizado.

> Si el comando no se reconoce, comprueba que el directorio donde está instalado el binario se encuentra en la variable `PATH` de tu sistema.

---

## Resumen del proceso de instalación

A continuación se muestra un resumen de los pasos realizados en esta sección:

| Paso | Comando | Descripción |
|------|---------|-------------|
| 1 | `sudo apt update && sudo apt install nuclei` | Instala Nuclei mediante APT |
| 2 | `nuclei -version` | Verifica que la instalación fue correcta |
| 3 | `nuclei -update-templates` | Descarga el repositorio de templates |
| 4 | `nuclei -h` | Comprueba el acceso al binario y muestra la ayuda |

---

## Conclusión

Con Nuclei instalado y los templates actualizados, el entorno está completamente preparado para comenzar a realizar análisis de vulnerabilidades.

En la siguiente sección se explicará el **uso básico de la herramienta**: cómo lanzar los primeros escaneos, cómo seleccionar templates concretos y cómo interpretar los resultados obtenidos.
