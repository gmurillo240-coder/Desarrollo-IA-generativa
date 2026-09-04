<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="conexion.ConexionBD" %>
<%@ page import="utilidades.Seguridad" %>
<%@ include file="includes/header.jsp" %>

<!-- ===================== ENCABEZADO ===================== -->
<div class="hero mb-4 fade-in">
    <div class="row align-items-center">
        <div class="col-md-8">
            <span class="hero-badge">
                <i class="bi bi-shield-check text-primary"></i> Gobernanza y Cumplimiento
            </span>
            <h1 class="h3 fw-bold mb-1">Normatividad y Uso Responsable</h1>
            <p class="text-muted mb-0">Directrices éticas, legales y de seguridad para el uso legítimo de la inteligencia artificial.</p>
        </div>
        <div class="col-md-4 text-md-end text-center mt-3 mt-md-0">
            <div class="avatar-tech ms-md-auto mx-auto" style="width:72px; height:72px; font-size:2.4rem;">
                <i class="bi bi-shield-check text-primary"></i>
            </div>
        </div>
    </div>
</div>

<div class="row g-3">
<%
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String[] acentos = {"accent-1", "accent-2", "accent-3", "accent-4"};
    try {
        con = ConexionBD.obtenerConexion();
        ps = con.prepareStatement("SELECT titulo, descripcion, icono FROM normativas");
        rs = ps.executeQuery();
        int i = 0;
        while (rs.next()) {
            String claseDelay = "delay-" + ((i % 4) + 1);
            String claseAcento = acentos[i % acentos.length];
            i++;
%>
    <div class="col-md-6 fade-in <%= claseDelay %>">
        <div class="feature-card <%= claseAcento %> glass-card h-100">
            <div class="d-flex align-items-start gap-3">
                <div class="feature-icon flex-shrink-0 mb-0">
                    <i class="bi bi-<%= rs.getString("icono") %>"></i>
                </div>
                <div>
                    <h2 class="h6 fw-bold mb-1"><%= Seguridad.escapeHtml(rs.getString("titulo")) %></h2>
                    <p class="small text-muted mb-0"><%= Seguridad.escapeHtml(rs.getString("descripcion")) %></p>
                </div>
            </div>
        </div>
    </div>
<%
        }
    } catch (Exception e) {
%>
    <div class="col-12"><div class="alert alert-danger">Error al cargar normativas: <%= e.getMessage() %></div></div>
<%
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>
</div>

<div class="alert alert-primary-subtle border-0 mt-4 fade-in d-flex align-items-center gap-3 p-3">
    <i class="bi bi-lightbulb-fill text-primary fs-3 flex-shrink-0"></i>
    <div>
        <strong>Principio Rector:</strong> La inteligencia artificial generativa debe ser un potenciador de las capacidades humanas, no un sustituto de la responsabilidad crítica, la honestidad intelectual ni la privacidad de las personas.
    </div>
</div>

<!-- ===================== PREGUNTAS FRECUENTES ===================== -->
<h2 class="h5 mt-5 mb-3 fade-in fw-bold d-flex align-items-center gap-2">
    <i class="bi bi-question-circle text-primary"></i> Preguntas Frecuentes sobre Regulación y Ética
</h2>
<div class="accordion fade-in" id="acordeonFAQ">

    <div class="accordion-item glass-card mb-2 border">
        <h3 class="accordion-header">
            <button class="accordion-button collapsed bg-transparent fw-semibold" type="button" data-bs-toggle="collapse" data-bs-target="#faq1">
                ¿Es legal utilizar código o contenidos generados por IA en mis proyectos?
            </button>
        </h3>
        <div id="faq1" class="accordion-collapse collapse" data-bs-parent="#acordeonFAQ">
            <div class="accordion-body small text-muted">
                Sí, en la mayoría de las legislaciones actuales es legal emplear herramientas de IA para asistencia y generación. No obstante, debes asegurar que no infrinjas licencias de código abierto restrictivas, no copies fragmentos protegidos por patentes o derechos de autor comerciales, y siempre declarar la asistencia de IA cuando sea requerido por tu organización o institución educativa.
            </div>
        </div>
    </div>

    <div class="accordion-item glass-card mb-2 border">
        <h3 class="accordion-header">
            <button class="accordion-button collapsed bg-transparent fw-semibold" type="button" data-bs-toggle="collapse" data-bs-target="#faq2">
                ¿Qué sucede con los datos privados o de clientes que ingreso en los prompts?
            </button>
        </h3>
        <div id="faq2" class="accordion-collapse collapse" data-bs-parent="#acordeonFAQ">
            <div class="accordion-body small text-muted">
                En versiones comerciales gratuitas o estándar, las empresas proveedoras pueden registrar las conversaciones para re-entrenar sus modelos. Nunca ingreses contraseñas, secretos de API, registros médicos, identificaciones oficiales ni datos sensibles. Si tu empresa requiere procesar datos confidenciales, se deben contratar entornos empresariales (Enterprise) con cláusulas estrictas de no-retención de datos (Zero-Data Retention).
            </div>
        </div>
    </div>

    <div class="accordion-item glass-card mb-2 border">
        <h3 class="accordion-header">
            <button class="accordion-button collapsed bg-transparent fw-semibold" type="button" data-bs-toggle="collapse" data-bs-target="#faq3">
                ¿Cómo puedo detectar y mitigar una alucinación generada por la IA?
            </button>
        </h3>
        <div id="faq3" class="accordion-collapse collapse" data-bs-parent="#acordeonFAQ">
            <div class="accordion-body small text-muted">
                Aplica la regla de verificación cruzada: si la IA cita un artículo legal, una fórmula matemática o un método técnico, búscalo en la documentación oficial. Además, diseña tus prompts solicitando que la IA proporcione su cadena de razonamiento y que señale explícitamente cuando no cuente con certeza sobre un dato.
            </div>
        </div>
    </div>

    <div class="accordion-item glass-card mb-2 border">
        <h3 class="accordion-header">
            <button class="accordion-button collapsed bg-transparent fw-semibold" type="button" data-bs-toggle="collapse" data-bs-target="#faq4">
                ¿Qué marco normativo internacional regula el uso de la IA?
            </button>
        </h3>
        <div id="faq4" class="accordion-collapse collapse" data-bs-parent="#acordeonFAQ">
            <div class="accordion-body small text-muted">
                El referente global más avanzado es la Ley de Inteligencia Artificial de la Unión Europea (EU AI Act), la cual clasifica las aplicaciones de IA según su nivel de riesgo (Inaceptable, Alto, Limitado y Mínimo). Esta norma prohíbe la manipulación cognitiva y la vigilancia masiva no autorizada, e impone obligaciones estrictas de transparencia y auditoría para sistemas de alto impacto.
            </div>
        </div>
    </div>

</div>

<div class="text-center mt-5 mb-3">
    <a href="quiz.jsp" class="btn btn-outline-primary btn-glow px-4">
        <i class="bi bi-trophy me-1"></i> Pon a prueba lo aprendido en el Quiz de IA
    </a>
</div>

<%@ include file="includes/footer.jsp" %>
