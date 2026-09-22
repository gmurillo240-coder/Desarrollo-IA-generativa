# 🤖 IA Generativa Web &mdash; Portal Educativo e Interactivo

[![Java](https://img.shields.io/badge/Java-17%2B-ED8B00?logo=openjdk&logoColor=white)](https://www.oracle.com/java/)
[![Jakarta EE](https://img.shields.io/badge/Jakarta%20EE-11-F09819?logo=jakartaee&logoColor=white)](https://jakarta.ee/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0%2B-4479A1?logo=mysql&logoColor=white)](https://www.mysql.com/)
[![Bootstrap](https://img.shields.io/badge/Bootstrap-5.3.3-7952B3?logo=bootstrap&logoColor=white)](https://getbootstrap.com/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Plataforma web educativa e interactiva dise?ada para promover el aprendizaje responsable, ?tico y pr?ctico de la **Inteligencia Artificial Generativa**, la ingenier?a de prompts y la gobernanza digital.

Desarrollado para la **Licenciatura en Inform?tica** &bull; **Universidad de Londres**.

---

## ✨ Funcionalidades Principales

### 1. ⚡ Prompt Builder (Generador de Prompts Interactivo)
- Asistente guiado para formular instrucciones profesionales mediante 5 dimensiones clave:
  - **Rol / Identidad:** Define la perspectiva del modelo.
  - **Objetivo / Tarea:** Especificaci?n precisa de la meta.
  - **Contexto y Audiencia:** Adaptaci?n del tono y nivel de profundidad.
  - **Formato de Salida:** Tablas Markdown, listas paso a paso, c?digo documentado o res?menes ejecutivos.
  - **Restricciones:** Reglas de exclusi?n para minimizar alucinaciones.
- Plantillas r?pidas para *Debugging Java*, *Redacci?n Acad?mica*, *T?cnica Feynman* y *Resumen Ejecutivo*.
- Previsualizaci?n reactiva con c?lculo estimado de palabras/tokens y bot?n de copiado al portapapeles.
- Modal simulador de respuesta de IA.

### 2. 🏆 Quiz Interactivo de IA & ?tica Digital
- Cuestionario din?mico sobre alucinaciones, privacidad de datos sensibles, *Few-Shot Prompting*, derechos de autor y sesgo algor?tmico.
- Retroalimentaci?n explicativa inmediata por cada opci?n.
- C?lculo de nivel final (*Maestro en IA*, *Especialista en Buenas Pr?cticas*, *Explorador*) y recomendaciones personalizadas.

### 3. 💡 Biblioteca de 55 Tips de Microaprendizaje
- Consejos pr?cticos clasificados en 3 niveles (*Principiante*, *Intermedio*, *Avanzado*).
- Buscador con filtrado en vivo en tiempo real (instant search) sin recargar la p?gina.
- Sistema de guardado a favoritos con un solo clic.

### 4. 📚 Cat?logo y Lectura de Art?culos
- 12 art?culos completos organizados por categor?as tem?ticas y tiempos de lectura.
- Detecci?n autom?tica de subt?tulos y maquetaci?n de p?rrafos.
- Panel lateral con recursos externos (videos, gu?as, herramientas) con favicons din?micos.
- Secci?n de comentarios y debate para usuarios registrados.

### 5. 🔒 Seguridad y Gesti?n de Cuentas
- Cifrado criptogr?fico de contrase?as con **SHA-256 + Salt aleatoria de 16 bytes** y 1,000 rondas de hashing iterativo (`Seguridad.java`).
- Sistema retrocompatible para migraci?n transparente de contrase?as previas.
- Prevenci?n de vulnerabilidades **Cross-Site Scripting (XSS)** mediante sanitizaci?n HTML.
- Control de roles (`usuario` y `administrador`).

### 6. ⚙️ Panel de Administraci?n (CRUD)
- Acceso exclusivo para usuarios con rol de `administrador`.
- Tablero de m?tricas en tiempo real (total de usuarios, art?culos, tips y comentarios).
- M?dulo para publicar y eliminar art?culos de contenido.
- M?dulo para crear y eliminar tips categorizados.
- Moderaci?n y eliminaci?n de comentarios.

### 7. 🌓 Dise?o Futurista con Modo Oscuro (Dark Mode)
- Switcher de tema Claro/Oscuro en el navbar persistente mediante `localStorage`.
- Est?tica *Glassmorphism* (tarjetas transl?cidas con desenfoque de fondo).
- Acentos luminosos con efecto *Glow* en morado cibern?tico (`#7c3aed`).

---

## 🛠️ Tecnolog?as Empleadas

- **Backend:** Java 17, Jakarta EE 11 / Servlet API 5.0+, JDBC.
- **Base de Datos:** MySQL / MariaDB (Driver Connector/J 9.4.0) con soporte UTF-8 (`utf8mb4`).
- **Frontend:** JSP (JavaServer Pages), HTML5, CSS3 personalizado, JavaScript ES6+.
- **Estilos y Componentes:** Bootstrap 5.3.3, Bootstrap Icons 1.11.3, Google Fonts (*Plus Jakarta Sans* e *Inter*).
- **Gestor de Construcci?n:** Apache Maven.

---

## 🚀 Instalaci?n y Puesta en Marcha

### Prerrequisitos
1. **JDK 17** o superior instalado y configurado en el sistema.
2. **Servidor de Aplicaciones:** Apache Tomcat 10+ o servidor compatible con Jakarta EE (como GlassFish 7+).
3. **Servidor MySQL:** XAMPP, WampServer o servicio local de MySQL.
4. **IDE Recomendado:** Apache NetBeans 18+, Eclipse o IntelliJ IDEA.

### 1. Clonar el repositorio
```bash
git clone https://github.com/TU_USUARIO/IAGenerativaWeb.git
cd IAGenerativaWeb
```

### 2. Configurar la Base de Datos
1. Inicia el servicio de **MySQL** en tu panel de control de XAMPP.
2. Abre tu gestor favorito (phpMyAdmin o terminal de MySQL) e importa el archivo `database.sql` ubicado en la ra?z del proyecto:
   ```bash
   mysql -u root -p < database.sql
   ```
   *Esto crear? la base de datos `ia_generativa` con sus 8 tablas y todos los datos iniciales.*

### 3. Configurar Credenciales de Conexi?n
Si tu usuario o contrase?a de MySQL difieren de los valores por defecto (`root` sin contrase?a), abre el archivo:
`src/main/java/conexion/ConexionBD.java` y ajusta las constantes:
```java
private static final String USUARIO = "root";
private static final String PASSWORD = "tu_contrase?a";
```

### 4. Ejecutar el Proyecto
- En **NetBeans:** Abre el proyecto, haz clic derecho y selecciona **Clean and Build**, luego presiona **Run** (F6).
- La aplicaci?n se desplegar? en:
  ```
  http://localhost:8080/IAGenerativaWeb/
  ```

---

## 📂 Estructura del Proyecto

```
IAGenerativaWeb/
??? database.sql                  # Respaldo completo de la base de datos (UTF-8)
??? pom.xml                       # Configuraci?n y dependencias Maven
??? README.md                     # Documentaci?n oficial del repositorio
??? .gitignore                    # Exclusiones de Git (target, binarios, etc.)
??? src/
    ??? main/
        ??? java/
        ?   ??? conexion/
        ?   ?   ??? ConexionBD.java    # Conexi?n JDBC con codificaci?n UTF-8 forzada
        ?   ??? utilidades/
        ?       ??? Iconos.java        # Helpers para ?conos din?micos y niveles
        ?       ??? Seguridad.java     # Cifrado SHA-256 + Salt y sanitizaci?n XSS
        ??? webapp/
            ??? admin.jsp              # Panel de administraci?n CRUD
            ??? articulo.jsp           # Detalle de lectura y comentarios
            ??? articulos.jsp          # Cat?logo completo de art?culos
            ??? buscar.jsp             # Buscador global multidisciplinario
            ??? favoritos.jsp          # Biblioteca personal de elementos guardados
            ??? index.jsp              # P?gina de inicio interactiva
            ??? login.jsp              # Inicio de sesi?n con autenticaci?n segura
            ??? logout.jsp             # Cierre y destrucci?n de sesi?n
            ??? normatividad.jsp       # Marco normativo, ?tica y FAQs
            ??? perfil.jsp             # Gesti?n de perfil y cambio de contrase?a
            ??? prompt-builder.jsp     # Generador estructurado de prompts
            ??? quiz.jsp               # Quiz interactivo gamificado
            ??? registro.jsp           # Registro de nuevas cuentas con cifrado
            ??? tips.jsp               # Microaprendizaje con buscador en vivo
            ??? css/
            ?   ??? estilo.css         # Glassmorphism, temas claro/oscuro y glow
            ??? includes/
                ??? header.jsp         # Barra de navegaci?n superior y dark mode
                ??? footer.jsp         # Pie de p?gina y manejador de toasts
```

---

## 👨‍💻 Autor y Cr?ditos

- **Desarrollador:** Arturo Murillo
- **Carrera:** Licenciatura en Inform?tica
- **Instituci?n:** Universidad de Londres
- **A?o:** 2026

*Proyecto acad?mico de libre consulta enfocado en la divulgaci?n y buenas pr?cticas de la Inteligencia Artificial.*
