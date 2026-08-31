<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="conexion.ConexionBD" %>
<%@ include file="includes/header.jsp" %>

<!-- ===================== ENCABEZADO ===================== -->
<div class="hero mb-4 fade-in">
    <div class="row align-items-center">
        <div class="col-md-8">
            <h1 class="h3 fw-bold mb-1">Normatividad y uso responsable</h1>
            <p class="text-muted mb-0">Conoce las reglas y recomendaciones para usar la IA de manera ética y segura.</p>
        </div>
        <div class="col-md-4 text-md-end mt-3 mt-md-0">
            <i class="bi bi-shield-check text-primary" style="font-size: 3rem;"></i>
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
        <div class="feature-card <%= claseAcento %> h-100">
            <div class="d-flex align-items-start gap-3">
                <div class="feature-icon flex-shrink-0 mb-0">
                    <i class="bi bi-<%= rs.getString("icono") %>"></i>
                </div>
                <div>
                    <h3 class="h6 mb-1"><%= rs.getString("titulo") %></h3>
                    <p class="small text-muted mb-0"><%= rs.getString("descripcion") %></p>
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

<div class="alert alert-primary mt-4 fade-in">
    <i class="bi bi-lightbulb"></i>
    <strong>Idea clave:</strong> Usar IA de forma responsable es construir un mejor futuro para todos.
</div>

<!-- ===================== PREGUNTAS FRECUENTES ===================== -->
<h2 class="h5 mt-5 mb-3 fade-in">Preguntas frecuentes</h2>
<div class="accordion fade-in" id="acordeonFAQ">

    <div class="accordion-item">
        <h3 class="accordion-header">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq1">
                ¿Es legal usar contenido generado por IA?
            </button>
        </h3>
        <div id="faq1" class="accordion-collapse collapse" data-bs-parent="#acordeonFAQ">
            <div class="accordion-body small text-muted">
                Depende de cómo lo uses. En general es legal, pero debes revisar si el resultado
                se parece demasiado a una obra protegida por derechos de autor, y siempre es buena
                práctica indicar cuándo un contenido fue generado con IA.
            </div>
        </div>
    </div>

    <div class="accordion-item">
        <h3 class="accordion-header">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq2">
                ¿La IA generativa guarda mis datos personales?
            </button>
        </h3>
        <div id="faq2" class="accordion-collapse collapse" data-bs-parent="#acordeonFAQ">
            <div class="accordion-body small text-muted">
                Algunas herramientas pueden almacenar tus conversaciones para mejorar el servicio.
                Evita compartir información sensible (contraseñas, datos bancarios, información
                confidencial de terceros) en tus prompts.
            </div>
        </div>
    </div>

    <div class="accordion-item">
        <h3 class="accordion-header">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq3">
                ¿Puedo confiar siempre en lo que responde la IA?
            </button>
        </h3>
        <div id="faq3" class="accordion-collapse collapse" data-bs-parent="#acordeonFAQ">
            <div class="accordion-body small text-muted">
                No siempre. La IA generativa puede cometer errores o inventar información con
                seguridad (esto se conoce como "alucinación"). Siempre verifica los datos
                importantes con otra fuente confiable.
            </div>
        </div>
    </div>

    <div class="accordion-item">
        <h3 class="accordion-header">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq4">
                ¿Puedo meterme en problemas por usar IA en la escuela o el trabajo?
            </button>
        </h3>
        <div id="faq4" class="accordion-collapse collapse" data-bs-parent="#acordeonFAQ">
            <div class="accordion-body small text-muted">
                Sí, si no respetas las políticas de tu institución u organización. Algunas permiten
                el uso libre, otras piden declararlo, y algunas lo prohíben en ciertas tareas
                (como exámenes). Ante la duda, siempre pregunta antes de usarla.
            </div>
        </div>
    </div>

</div>

<%@ include file="includes/footer.jsp" %>
