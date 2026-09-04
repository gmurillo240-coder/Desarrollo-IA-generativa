<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="includes/header.jsp" %>

<!-- ===================== ENCABEZADO ===================== -->
<div class="hero mb-4 fade-in">
    <div class="row align-items-center">
        <div class="col-lg-8">
            <span class="hero-badge">
                <i class="bi bi-trophy text-warning"></i> Evaluación Gamificada
            </span>
            <h1 class="h3 fw-bold mb-2">Quiz Interactivo: IA Generativa & Ética Digital</h1>
            <p class="text-muted mb-0">
                Pon a prueba tus conocimientos sobre prompting, prevención de alucinaciones, normatividad
                y seguridad de datos. Al finalizar recibirás tu diagnóstico y recomendaciones personalizadas.
            </p>
        </div>
        <div class="col-lg-4 text-center mt-3 mt-lg-0">
            <div class="avatar-tech mx-auto" style="width:72px; height:72px; font-size:2.2rem; background: rgba(234, 179, 8, 0.15); border-color: rgba(234, 179, 8, 0.3);">
                <i class="bi bi-award-fill text-warning"></i>
            </div>
        </div>
    </div>
</div>

<!-- ===================== CONTENEDOR DEL JUEGO ===================== -->
<div class="row justify-content-center mb-5">
    <div class="col-lg-8">
        <!-- Barra de Progreso -->
        <div class="mb-3 fade-in delay-1">
            <div class="d-flex justify-content-between align-items-center small text-muted mb-1">
                <span id="labelProgreso">Pregunta 1 de 6</span>
                <span id="labelPuntaje">Puntaje actual: 0 pts</span>
            </div>
            <div class="progress" style="height: 8px;">
                <div id="barraProgreso" class="progress-bar bg-primary progress-bar-striped progress-bar-animated" role="progressbar" style="width: 16%;"></div>
            </div>
        </div>

        <!-- Tarjeta de Pregunta -->
        <div class="card glass-card quiz-card fade-in delay-2" id="cardPregunta" style="min-height: 380px;">
            <span class="badge bg-primary-subtle text-primary mb-2 align-self-start" id="quizCategoria">Fundamentos de IA</span>
            <h2 class="h5 fw-bold mb-4" id="quizPreguntaTexto">Cargando pregunta...</h2>

            <div id="quizOpcionesContenedor" class="mb-3">
                <!-- Opciones dinámicas -->
            </div>

            <!-- Explicación de la respuesta (Oculta hasta responder) -->
            <div id="quizExplicacion" class="alert alert-primary-subtle border-0 mb-3 small d-none">
                <div class="d-flex align-items-start gap-2">
                    <i class="bi bi-info-circle-fill text-primary fs-5 flex-shrink-0"></i>
                    <div>
                        <strong id="quizExplicacionTitulo">¡Excelente!</strong>
                        <div id="quizExplicacionTexto">Explicación detallada...</div>
                    </div>
                </div>
            </div>

            <div class="text-end mt-auto pt-2">
                <button type="button" class="btn btn-primary px-4 btn-glow d-none" id="btnSiguiente" onclick="siguientePregunta()">
                    Siguiente Pregunta <i class="bi bi-arrow-right ms-1"></i>
                </button>
            </div>
        </div>

        <!-- Tarjeta de Resultados Finales (Oculta al inicio) -->
        <div class="card glass-card p-5 text-center d-none" id="cardResultados">
            <div class="avatar-tech mx-auto mb-3" style="width:84px; height:84px; font-size:2.8rem;" id="avatarResultado">
                <i class="bi bi-trophy text-warning"></i>
            </div>
            <h2 class="h3 fw-bold mb-1" id="tituloResultado">¡Evaluación Completada!</h2>
            <p class="text-muted small mb-3">Has demostrado tu compromiso con el aprendizaje responsable de la inteligencia artificial.</p>

            <div class="display-4 fw-bold text-primary mb-3" id="puntajeFinalTexto">6 / 6</div>

            <div class="card p-3 bg-body-tertiary border mb-4 text-start small">
                <h3 class="h6 fw-bold mb-1 text-primary"><i class="bi bi-lightbulb me-1"></i> Diagnóstico Pedagógico:</h3>
                <p class="mb-0 text-muted" id="diagnosticoTexto">Excelente dominio de los conceptos esenciales...</p>
            </div>

            <div class="d-flex justify-content-center gap-2 flex-wrap">
                <button type="button" class="btn btn-outline-primary" onclick="reiniciarQuiz()">
                    <i class="bi bi-arrow-counterclockwise me-1"></i> Repetir Quiz
                </button>
                <a href="tips.jsp" class="btn btn-primary btn-glow">
                    <i class="bi bi-lightbulb me-1"></i> Explorar Más Tips
                </a>
                <a href="prompt-builder.jsp" class="btn btn-outline-secondary">
                    <i class="bi bi-stars me-1"></i> Practicar en Prompt Builder
                </a>
            </div>
        </div>
    </div>
</div>

<script>
var bancoPreguntas = [
    {
        categoria: "Prevención de Errores",
        pregunta: "¿Qué significa que un Modelo de Lenguaje Grande (LLM) presente una 'alucinación'?",
        opciones: [
            "Que el servidor se quedó sin memoria RAM al procesar la solicitud.",
            "Que genera información incorrecta o ficticia presentándola con total seguridad gramatical.",
            "Que la respuesta incluye imágenes distorsionadas o con artefactos visuales.",
            "Que la inteligencia artificial adquiere conciencia propia sobre sus respuestas."
        ],
        correcta: 1,
        explicacion: "Una alucinación ocurre cuando el modelo de lenguaje genera hechos falsos, citas inventadas o código erróneo con una redacción completamente coherente y convincente. Siempre se debe verificar la información crítica con fuentes oficiales."
    },
    {
        categoria: "Privacidad y Ciberseguridad",
        pregunta: "Al utilizar herramientas públicas de IA generativa, ¿cuál es la regla de oro sobre los datos compartidos en el prompt?",
        opciones: [
            "Se pueden subir contraseñas siempre que estén dentro de un bloque de código.",
            "Nunca se deben compartir datos personales sensibles, credenciales de base de datos ni información confidencial.",
            "No existe ningún riesgo, ya que las IAs borran los prompts al instante de cerrar el navegador.",
            "Solo se deben proteger los nombres de personas, las contraseñas no tienen problema."
        ],
        correcta: 1,
        explicacion: "Las plataformas públicas de IA pueden utilizar las interacciones para retroalimentar y entrenar sus modelos. Nunca ingreses contraseñas, llaves de API, estados financieros ni datos personales de terceros."
    },
    {
        categoria: "Ingeniería de Prompts",
        pregunta: "¿En qué consiste la técnica de 'Few-Shot Prompting'?",
        opciones: [
            "En hacer preguntas muy cortas de menos de cinco palabras.",
            "En enviar el mismo prompt repetidas veces hasta que la IA acierte.",
            "En incluir en el prompt dos o más ejemplos representativos de entrada y salida deseada para guiar al modelo.",
            "En apagar y encender la conexión para acelerar el procesamiento de la respuesta."
        ],
        correcta: 2,
        explicacion: "Few-Shot Prompting consiste en proporcionar ejemplos explícitos dentro de la instrucción para que el modelo entienda el patrón exacto, el tono y el formato que esperas recibir."
    },
    {
        categoria: "Integridad Académica y Ética",
        pregunta: "En el contexto universitario o laboral, ¿cómo se debe emplear la IA generativa de forma ética?",
        opciones: [
            "Presentar el texto generado por la IA como si fuera de autoría propia sin mencionarla.",
            "Utilizarla como herramienta de apoyo, análisis y lluvia de ideas, transparentando su uso y contrastando las fuentes.",
            "Ocultar el uso de la IA cambiando únicamente los sinónimos del texto resultante.",
            "Evitar aprender a programar o investigar, dejando todo el trabajo a la máquina."
        ],
        correcta: 1,
        explicacion: "La IA es un potente acelerador cognitivo. La ética académica exige honestidad intelectual: usarla para orientar, esquematizar y aprender, declarando su uso y validando el contenido."
    },
    {
        categoria: "Sesgo y Equidad",
        pregunta: "¿Por qué los modelos generativos pueden exhibir sesgos culturales o estereotipos?",
        opciones: [
            "Porque fueron entrenados con datos masivos de internet que ya reflejan sesgos y asimetrías humanas.",
            "Porque los servidores físicos están ubicados en un único país.",
            "Porque las computadoras no entienden el idioma español.",
            "Porque es una función intencional para reducir el consumo de energía."
        ],
        correcta: 0,
        explicacion: "Los modelos de IA aprenden a partir de los datos con los que fueron alimentados. Si los textos recopilados de internet contenían prejuicios o desproporciones, el modelo tenderá a reproducirlos a menos que se le instruya explícitamente lo contrario."
    },
    {
        categoria: "Buenas Prácticas de Estructura",
        pregunta: "¿Cuáles son los componentes fundamentales para construir un prompt de nivel profesional?",
        opciones: [
            "Únicamente una palabra clave y signos de interrogación.",
            "Rol/Identidad, Objetivo claro, Contexto/Audiencia, Formato de salida esperado y Restricciones.",
            "Escribir todo en mayúsculas para que el modelo priorice la solicitud.",
            "Pedirle que sea 'inteligente y rápido' sin dar detalles."
        ],
        correcta: 1,
        explicacion: "Definir quién es la IA (Rol), qué debe hacer (Tarea), para quién es (Contexto), cómo presentarlo (Formato) y qué evitar (Restricciones) es la clave para obtener respuestas de máxima precisión."
    }
];

var indiceActual = 0;
var puntaje = 0;
var respondida = false;

function cargarPregunta() {
    try {
        respondida = false;
        if (indiceActual >= bancoPreguntas.length) {
            mostrarResultados();
            return;
        }
        var p = bancoPreguntas[indiceActual];
        
        var pct = Math.round(((indiceActual + 1) / bancoPreguntas.length) * 100);
        var barra = document.getElementById('barraProgreso');
        if (barra) barra.style.width = pct + '%';
        var lblProg = document.getElementById('labelProgreso');
        if (lblProg) lblProg.textContent = 'Pregunta ' + (indiceActual + 1) + ' de ' + bancoPreguntas.length;
        var lblPunt = document.getElementById('labelPuntaje');
        if (lblPunt) lblPunt.textContent = 'Puntaje actual: ' + puntaje + ' pts';
        
        var catEl = document.getElementById('quizCategoria');
        if (catEl) catEl.textContent = p.categoria;
        var pregEl = document.getElementById('quizPreguntaTexto');
        if (pregEl) pregEl.textContent = p.pregunta;
        
        var contenedor = document.getElementById('quizOpcionesContenedor');
        if (contenedor) {
            contenedor.innerHTML = '';
            for (var idx = 0; idx < p.opciones.length; idx++) {
                (function(i) {
                    var div = document.createElement('div');
                    div.className = 'quiz-option';
                    div.innerHTML = '<span class="badge rounded-circle bg-secondary-subtle text-secondary px-2 py-1 fw-bold">' + String.fromCharCode(65 + i) + '</span><span class="flex-grow-1 ms-2">' + p.opciones[i] + '</span><i class="bi bi-circle text-muted estado-icono fs-5"></i>';
                    div.onclick = function() { seleccionarOpcion(i, div); };
                    contenedor.appendChild(div);
                })(idx);
            }
        }

        var expDiv = document.getElementById('quizExplicacion');
        if (expDiv) expDiv.classList.add('d-none');
        var btnSig = document.getElementById('btnSiguiente');
        if (btnSig) btnSig.classList.add('d-none');
    } catch(err) {
        console.error('Error al cargar pregunta:', err);
    }
}

function seleccionarOpcion(idx, elemento) {
    if (respondida) return;
    respondida = true;

    var p = bancoPreguntas[indiceActual];
    var todasLasOpciones = document.querySelectorAll('.quiz-option');
    for (var j = 0; j < todasLasOpciones.length; j++) {
        todasLasOpciones[j].classList.add('disabled');
    }

    var icono = elemento.querySelector('.estado-icono');
    var explicacionDiv = document.getElementById('quizExplicacion');
    var expTitulo = document.getElementById('quizExplicacionTitulo');
    var expTexto = document.getElementById('quizExplicacionTexto');

    if (idx === p.correcta) {
        elemento.classList.add('correct');
        if (icono) icono.className = 'bi bi-check-circle-fill text-success fs-5';
        puntaje++;
        if (expTitulo) {
            expTitulo.className = 'text-success fw-bold';
            expTitulo.innerHTML = '<i class="bi bi-check-circle me-1"></i> ¡Respuesta Correcta!';
        }
    } else {
        elemento.classList.add('incorrect');
        if (icono) icono.className = 'bi bi-x-circle-fill text-danger fs-5';
        if (expTitulo) {
            expTitulo.className = 'text-danger fw-bold';
            expTitulo.innerHTML = '<i class="bi bi-x-circle me-1"></i> Respuesta Incorrecta';
        }

        if (todasLasOpciones[p.correcta]) {
            todasLasOpciones[p.correcta].classList.add('correct');
            var icoCorr = todasLasOpciones[p.correcta].querySelector('.estado-icono');
            if (icoCorr) icoCorr.className = 'bi bi-check-circle-fill text-success fs-5';
        }
    }

    if (expTexto) expTexto.textContent = p.explicacion;
    if (explicacionDiv) explicacionDiv.classList.remove('d-none');
    var lblPunt = document.getElementById('labelPuntaje');
    if (lblPunt) lblPunt.textContent = 'Puntaje actual: ' + puntaje + ' pts';
    var btnSig = document.getElementById('btnSiguiente');
    if (btnSig) btnSig.classList.remove('d-none');
}

function siguientePregunta() {
    indiceActual++;
    if (indiceActual < bancoPreguntas.length) {
        cargarPregunta();
    } else {
        mostrarResultados();
    }
}

function mostrarResultados() {
    var cardPreg = document.getElementById('cardPregunta');
    if (cardPreg) cardPreg.classList.add('d-none');
    var cardRes = document.getElementById('cardResultados');
    if (cardRes) cardRes.classList.remove('d-none');

    var puntFin = document.getElementById('puntajeFinalTexto');
    if (puntFin) puntFin.textContent = puntaje + ' / ' + bancoPreguntas.length;
    var diag = document.getElementById('diagnosticoTexto');
    var tit = document.getElementById('tituloResultado');
    var avatar = document.getElementById('avatarResultado');

    if (puntaje === 6) {
        if (tit) tit.innerHTML = '<i class="bi bi-trophy-fill text-warning me-2"></i> ¡Excelente! Nivel: Maestro en IA y Ética';
        if (diag) diag.textContent = '¡Puntaje perfecto! Cuentas con una sólida comprensión de las implicaciones éticas, los riesgos de alucinación y la ingeniería de prompts. Estás listo para liderar el uso de IA en tu ámbito profesional.';
        if (avatar) avatar.innerHTML = '<i class="bi bi-trophy-fill text-warning"></i>';
    } else if (puntaje >= 4) {
        if (tit) tit.innerHTML = '<i class="bi bi-award-fill text-primary me-2"></i> Muy Bien: Especialista en Buenas Prácticas';
        if (diag) diag.textContent = 'Tienes bases firmes sobre el uso responsable de la inteligencia artificial. Te recomendamos explorar la sección de Normatividad y los Tips avanzados para afinar los detalles donde tuviste dudas.';
        if (avatar) avatar.innerHTML = '<i class="bi bi-award-fill text-primary"></i>';
    } else {
        if (tit) tit.innerHTML = '<i class="bi bi-book-half text-info me-2"></i> En Desarrollo: Explorador de IA';
        if (diag) diag.textContent = 'Has dado el primer paso para familiarizarte con los desafíos de la IA generativa. Te sugerimos revisar con atención nuestra sección de Tips y Normatividad para reforzar conceptos de privacidad y prompting.';
        if (avatar) avatar.innerHTML = '<i class="bi bi-book-half text-info"></i>';
    }
}

function reiniciarQuiz() {
    indiceActual = 0;
    puntaje = 0;
    var cardRes = document.getElementById('cardResultados');
    if (cardRes) cardRes.classList.add('d-none');
    var cardPreg = document.getElementById('cardPregunta');
    if (cardPreg) cardPreg.classList.remove('d-none');
    cargarPregunta();
}

// Ejecutar inmediatamente
cargarPregunta();

// Respaldo de carga
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', cargarPregunta);
}
</script>

<%@ include file="includes/footer.jsp" %>
