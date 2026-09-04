<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="includes/header.jsp" %>

<!-- ===================== ENCABEZADO ===================== -->
<div class="hero mb-4 fade-in">
    <div class="row align-items-center">
        <div class="col-lg-8">
            <span class="hero-badge">
                <i class="bi bi-stars text-primary"></i> Herramienta de Ingeniería de Prompts
            </span>
            <h1 class="h3 fw-bold mb-2">Generador de Prompts Interactivo</h1>
            <p class="text-muted mb-0">
                Aplica las mejores técnicas de prompting (Rol, Tarea, Contexto, Formato y Restricciones)
                para estructurar indicaciones precisas que obtengan resultados de máxima calidad de cualquier modelo de IA.
            </p>
        </div>
        <div class="col-lg-4 text-center mt-3 mt-lg-0">
            <div class="avatar-tech mx-auto" style="width:72px; height:72px; font-size:2.2rem;">
                <i class="bi bi-cpu-fill text-primary"></i>
            </div>
        </div>
    </div>
</div>

<!-- ===================== SELECTOR DE PLANTILLAS RÁPIDAS ===================== -->
<div class="card glass-card p-3 mb-4 fade-in delay-1">
    <div class="d-flex align-items-center gap-2 flex-wrap">
        <span class="small fw-bold text-uppercase text-muted me-2">
            <i class="bi bi-lightning-charge text-warning"></i> Plantillas Rápidas:
        </span>
        <button type="button" class="btn btn-sm btn-outline-primary" onclick="cargarPlantilla('programador')">
            <i class="bi bi-code-slash me-1"></i> Debugger Java & Web
        </button>
        <button type="button" class="btn btn-sm btn-outline-primary" onclick="cargarPlantilla('academico')">
            <i class="bi bi-mortarboard me-1"></i> Redactor Académico
        </button>
        <button type="button" class="btn btn-sm btn-outline-primary" onclick="cargarPlantilla('feynman')">
            <i class="bi bi-lightbulb me-1"></i> Explicador Didáctico (Feynman)
        </button>
        <button type="button" class="btn btn-sm btn-outline-primary" onclick="cargarPlantilla('resumen')">
            <i class="bi bi-card-checklist me-1"></i> Resumen Ejecutivo
        </button>
        <button type="button" class="btn btn-sm btn-outline-secondary ms-auto" onclick="limpiarFormulario()">
            <i class="bi bi-arrow-counterclockwise me-1"></i> Limpiar
        </button>
    </div>
</div>

<div class="row g-4 mb-5">
    <!-- ===================== FORMULARIO ESTRUCTURADO ===================== -->
    <div class="col-lg-6 fade-in delay-2">
        <div class="card glass-card p-4 h-100">
            <h2 class="h5 fw-bold mb-3 d-flex align-items-center gap-2">
                <i class="bi bi-sliders text-primary"></i> Parámetros de la Instrucción
            </h2>

            <form id="formPrompt">
                <!-- 1. Rol -->
                <div class="mb-3">
                    <label class="form-label small fw-bold">
                        1. Rol / Identidad de la IA <span class="text-primary">*</span>
                    </label>
                    <input type="text" id="campoRol" class="form-control"
                           placeholder="Ej. Eres un profesor universitario senior de informática..."
                           value="Actúa como un profesor universitario senior y experto en arquitectura de software y Java.">
                    <div class="form-text small">Define la perspectiva y nivel de experiencia desde el que responderá la IA.</div>
                </div>

                <!-- 2. Tarea Principal -->
                <div class="mb-3">
                    <label class="form-label small fw-bold">
                        2. Objetivo o Tarea Principal <span class="text-primary">*</span>
                    </label>
                    <textarea id="campoTarea" class="form-control" rows="3"
                              placeholder="Ej. Explica la diferencia entre el Modelo 1 de JSP y la arquitectura MVC...">Explica la diferencia entre la arquitectura Modelo 1 (JSP con scriptlets) y MVC en aplicaciones web Java, destacando ventajas, desventajas y buenas prácticas de seguridad.</textarea>
                    <div class="form-text small">Sé específico en lo que esperas que realice la IA.</div>
                </div>

                <!-- 3. Contexto y Audiencia -->
                <div class="mb-3">
                    <label class="form-label small fw-bold">
                        3. Contexto y Audiencia
                    </label>
                    <input type="text" id="campoContexto" class="form-control"
                           placeholder="Ej. Estudiantes de ingeniería en sistemas de primer año..."
                           value="La explicación está dirigida a estudiantes de la Licenciatura en Informática preparando su proyecto final.">
                </div>

                <!-- 4. Formato de Salida -->
                <div class="mb-3">
                    <label class="form-label small fw-bold">
                        4. Formato de Salida
                    </label>
                    <select id="campoFormato" class="form-select">
                        <option value="Estructura en secciones con títulos claros, explicaciones concisas y una tabla comparativa en Markdown.">Tabla comparativa + Secciones explicativas</option>
                        <option value="Lista ordenada paso a paso con viñetas y ejemplos de código breves.">Paso a paso con ejemplos de código</option>
                        <option value="Resumen ejecutivo directo, directo al punto en no más de 3 párrafos.">Resumen ejecutivo conciso</option>
                        <option value="Código completo debidamente documentado con comentarios explicativos.">Código fuente documentado</option>
                        <option value="Texto continuo con introducción didáctica, analogías de la vida real y conclusiones.">Texto didáctico con analogías</option>
                    </select>
                </div>

                <!-- 5. Restricciones y Reglas -->
                <div class="mb-3">
                    <label class="form-label small fw-bold">
                        5. Restricciones (Qué evitar o enfatizar)
                    </label>
                    <textarea id="campoRestricciones" class="form-control" rows="2"
                              placeholder="Ej. No uses términos demasiado abstractos sin definirlos...">Usa un lenguaje formal y riguroso pero accesible. Si mencionas vulnerabilidades de seguridad (como SQL Injection o contraseñas en texto plano), explica cómo mitigarlas.</textarea>
                </div>
            </form>
        </div>
    </div>

    <!-- ===================== PREVISUALIZACIÓN Y RESULTADO ===================== -->
    <div class="col-lg-6 fade-in delay-3">
        <div class="card glass-card p-4 h-100 d-flex flex-column">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h2 class="h5 fw-bold mb-0 d-flex align-items-center gap-2">
                    <i class="bi bi-terminal text-primary"></i> Prompt Generado
                </h2>
                <span class="prompt-token-badge" id="badgeContador">~0 palabras</span>
            </div>

            <div class="prompt-output-box flex-grow-1" id="boxPromptOutput">
                <!-- Se llena dinámicamente con JavaScript -->
            </div>

            <div class="d-flex gap-2 mt-3 pt-2">
                <button type="button" class="btn btn-primary btn-glow flex-grow-1" id="btnCopiarPrompt" onclick="copiarPrompt()">
                    <i class="bi bi-clipboard-check me-1"></i> Copiar Prompt al Portapapeles
                </button>
                <button type="button" class="btn btn-outline-primary" onclick="simularRespuesta()" data-bs-toggle="modal" data-bs-target="#modalSimulador">
                    <i class="bi bi-play-circle me-1"></i> Simular Respuesta
                </button>
            </div>
        </div>
    </div>
</div>

<!-- ===================== MODAL SIMULADOR DE RESPUESTA ===================== -->
<div class="modal fade" id="modalSimulador" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content glass-card">
            <div class="modal-header border-bottom">
                <h3 class="modal-title h5 fw-bold d-flex align-items-center gap-2">
                    <i class="bi bi-robot text-primary"></i> Simulación de Respuesta de IA
                </h3>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <div class="alert alert-primary-subtle border-0 mb-3 small d-flex align-items-center gap-2">
                    <i class="bi bi-info-circle-fill text-primary flex-shrink-0"></i>
                    <div>
                        Esta es una demostración en vivo de cómo un modelo de lenguaje avanzado procesaría la estructura
                        de tu prompt para generar una respuesta de alto valor pedagógico.
                    </div>
                </div>
                <div id="contenidoSimulacion" class="small text-muted" style="line-height: 1.7;">
                    <!-- Se inyecta la simulación -->
                </div>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                <button type="button" class="btn btn-primary" onclick="copiarPrompt();" data-bs-dismiss="modal">
                    <i class="bi bi-clipboard me-1"></i> Copiar y usar en ChatGPT / Gemini
                </button>
            </div>
        </div>
    </div>
</div>

<script>
// Manejador del Prompt Builder
const plantillas = {
    programador: {
        rol: "Eres un ingeniero de software senior y arquitecto de sistemas especialista en Java, Jakarta EE y seguridad web.",
        tarea: "Analiza el siguiente fragmento de código o problema arquitectónico. Identifica posibles vulnerabilidades (como inyección SQL o exposición de credenciales) y propone una refactorización limpia y moderna siguiendo buenas prácticas.",
        contexto: "Aplicación web académica desarrollada con Maven, Servlets/JSP y base de datos relacional MySQL.",
        formato: "Estructura la respuesta en: 1) Diagnóstico del problema, 2) Código refactorizado comentado, 3) Recomendaciones de seguridad.",
        restricciones: "Sé conciso, no omitas el manejo adecuado de excepciones (try-with-resources) y utiliza estándares modernos de Java 17+."
    },
    academico: {
        rol: "Eres un investigador académico y profesor experto en ética tecnológica e inteligencia artificial.",
        tarea: "Redacta una justificación académica sobre la importancia de enseñar el uso ético y responsable de la IA generativa en la educación superior.",
        contexto: "Proyecto de titulación para la Licenciatura en Informática de la Universidad de Londres.",
        formato: "Texto académico estructurado en: Introducción formal, 3 argumentos clave respaldados por tendencias globales, y una conclusión propositiva.",
        restricciones: "Mantén un tono riguroso, formal y objetivo. Evita el tono publicitario o sensacionalista."
    },
    feynman: {
        rol: "Eres un divulgador científico y docente inspirado en la técnica pedagógica de Richard Feynman.",
        tarea: "Explica cómo funcionan los Modelos de Lenguaje Grande (LLMs) y qué significa realmente que una IA 'alucine'.",
        contexto: "Para personas que no tienen conocimientos técnicos avanzados pero tienen curiosidad científica.",
        formato: "Usa analogías sencillas y cotidianas (como una biblioteca o un juego de palabras), divide en 3 pasos clave y finaliza con una moraleja.",
        restricciones: "Prohibido usar jerga matemática o técnica compleja sin definirla inmediatamente con un ejemplo práctico."
    },
    resumen: {
        rol: "Eres un analista de inteligencia de negocios y consultor de productividad tecnológica.",
        tarea: "Sintetiza las directrices clave de la Ley de Inteligencia Artificial (AI Act) y sus implicaciones para pequeñas y medianas empresas.",
        contexto: "Informe estratégico para directores de tecnología y gerentes de proyecto.",
        formato: "Tabla comparativa de riesgos (Mínimo, Alto, Prohibido) seguida de 5 recomendaciones operativas inmediatas.",
        restricciones: "Máxima concisión. Respuestas directas, orientadas a la acción y libres de relleno."
    }
};

function actualizarPrompt() {
    const rol = document.getElementById('campoRol').value.trim();
    const tarea = document.getElementById('campoTarea').value.trim();
    const contexto = document.getElementById('campoContexto').value.trim();
    const formato = document.getElementById('campoFormato').value.trim();
    const restricciones = document.getElementById('campoRestricciones').value.trim();

    let partes = [];
    if (rol) partes.push("# ROL:\n" + rol);
    if (tarea) partes.push("# OBJETIVO / TAREA:\n" + tarea);
    if (contexto) partes.push("# CONTEXTO Y AUDIENCIA:\n" + contexto);
    if (formato) partes.push("# FORMATO DE RESPUESTA ESPERADO:\n" + formato);
    if (restricciones) partes.push("# REGLAS Y RESTRICCIONES:\n" + restricciones);

    const textoFinal = partes.join("\n\n");
    const box = document.getElementById('boxPromptOutput');
    box.textContent = textoFinal || "(Completa los campos a la izquierda para armar tu prompt...)";

    const totalPalabras = textoFinal ? textoFinal.split(/\s+/).length : 0;
    document.getElementById('badgeContador').textContent = "~" + totalPalabras + " palabras (" + textoFinal.length + " caracteres)";
}

function cargarPlantilla(clave) {
    const p = plantillas[clave];
    if (!p) return;
    document.getElementById('campoRol').value = p.rol;
    document.getElementById('campoTarea').value = p.tarea;
    document.getElementById('campoContexto').value = p.contexto;
    document.getElementById('campoFormato').value = p.formato;
    document.getElementById('campoRestricciones').value = p.restricciones;
    actualizarPrompt();
    mostrarToast("Plantilla '" + clave + "' cargada con éxito.", "primary");
}

function limpiarFormulario() {
    document.getElementById('campoRol').value = '';
    document.getElementById('campoTarea').value = '';
    document.getElementById('campoContexto').value = '';
    document.getElementById('campoRestricciones').value = '';
    actualizarPrompt();
    mostrarToast("Campos limpiados.", "secondary");
}

function copiarPrompt() {
    const texto = document.getElementById('boxPromptOutput').textContent;
    if (!texto || texto.startsWith("(")) {
        mostrarToast("Por favor escribe un prompt antes de copiar.", "warning");
        return;
    }
    navigator.clipboard.writeText(texto).then(() => {
        mostrarToast("¡Prompt copiado al portapapeles con éxito!", "success");
    }).catch(() => {
        mostrarToast("No se pudo copiar automáticamente. Puedes seleccionarlo manualmente.", "warning");
    });
}

function simularRespuesta() {
    const tarea = document.getElementById('campoTarea').value;
    const cont = document.getElementById('contenidoSimulacion');
    cont.innerHTML = `
        <h5 class="fw-bold text-primary mb-2">Respuesta Estructurada por el Modelo:</h5>
        <p><strong>1. Introducción y Fundamentos:</strong> En respuesta a tu solicitud sobre <em>"${tarea.substring(0, 70)}..."</em>, la separación de responsabilidades arquitectónicas es indispensable para garantizar escalabilidad y seguridad en entornos productivos.</p>
        <div class="table-responsive my-3">
            <table class="table table-bordered table-sm small">
                <thead class="table-light">
                    <tr><th>Criterio</th><th>Modelo 1 (Scriptlets JSP)</th><th>Arquitectura MVC</th></tr>
                </thead>
                <tbody>
                    <tr><td><strong>Mantenimiento</strong></td><td>Complejo: Código Java y HTML mezclados.</td><td>Alto: Separación clara de controladores y vistas.</td></tr>
                    <tr><td><strong>Seguridad</strong></td><td>Riesgo elevado si no se sanitiza en cada vista.</td><td>Centralizada en filtros y controladores.</td></tr>
                    <tr><td><strong>Idoneidad</strong></td><td>Prototipos rápidos y proyectos educativos.</td><td>Estándar de la industria y sistemas empresariales.</td></tr>
                </tbody>
            </table>
        </div>
        <p><strong>2. Recomendación de Seguridad Crítica:</strong> Asegúrate siempre de implementar contraseñas cifradas mediante sal criptográfica y emplear <code>PreparedStatement</code> para neutralizar cualquier vector de inyección SQL.</p>
    `;
}

// Escuchar cambios en los inputs en tiempo real
document.addEventListener('DOMContentLoaded', function() {
    ['campoRol', 'campoTarea', 'campoContexto', 'campoFormato', 'campoRestricciones'].forEach(id => {
        const el = document.getElementById(id);
        if (el) {
            el.addEventListener('input', actualizarPrompt);
            el.addEventListener('change', actualizarPrompt);
        }
    });
    actualizarPrompt();
});
</script>

<%@ include file="includes/footer.jsp" %>
