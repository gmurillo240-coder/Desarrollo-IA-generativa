<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="conexion.ConexionBD" %>
<%@ page import="utilidades.Iconos" %>
<%@ page import="utilidades.Seguridad" %>
<%@ include file="includes/header.jsp" %>

<%
    String busqueda = request.getParameter("q");
    if (busqueda == null) busqueda = "";
    busqueda = busqueda.trim();
%>

<!-- ===================== ENCABEZADO ===================== -->
<div class="hero mb-4 fade-in">
    <div class="row align-items-center">
        <div class="col-lg-8">
            <span class="hero-badge">
                <i class="bi bi-search text-primary"></i> Motor de Búsqueda Global
            </span>
            <h1 class="h3 fw-bold mb-2">Búsqueda en todo el Portal</h1>
            <p class="text-muted mb-0">
                Encuentra artículos, tips prácticos y normativas éticas en un solo lugar.
            </p>
        </div>
    </div>
</div>

<!-- ===================== CAMPO DE BÚSQUEDA ===================== -->
<div class="card glass-card p-4 mb-4 fade-in delay-1">
    <form method="get" action="buscar.jsp">
        <div class="input-group input-group-lg">
            <span class="input-group-text bg-transparent border-end-0"><i class="bi bi-search text-primary"></i></span>
            <input type="text" name="q" class="form-control border-start-0" placeholder="Escribe un término (ej. prompt, derechos de autor, sesgo, java)..." value="<%= Seguridad.escapeHtml(busqueda) %>" required>
            <button type="submit" class="btn btn-primary px-4 btn-glow">Buscar</button>
        </div>
    </form>
</div>

<%
    if (!busqueda.isEmpty()) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int totalEncontrados = 0;
%>
    <div class="mb-3 fade-in delay-2">
        <h2 class="h5 fw-bold mb-0">Resultados para "<%= Seguridad.escapeHtml(busqueda) %>":</h2>
    </div>

    <!-- 1. RESULTADOS EN ARTÍCULOS -->
    <div class="mb-5 fade-in delay-2">
        <h3 class="h6 fw-bold text-primary text-uppercase mb-3 d-flex align-items-center gap-2">
            <i class="bi bi-journal-text"></i> Artículos Relacionados
        </h3>
        <div class="row g-3">
        <%
            int articulosCount = 0;
            try {
                con = ConexionBD.obtenerConexion();
                ps = con.prepareStatement(
                    "SELECT c.id_contenido, c.titulo, c.resumen, c.tiempo_lectura_min, cat.nombre AS categoria " +
                    "FROM contenidos c JOIN categorias cat ON c.id_categoria = cat.id_categoria " +
                    "WHERE c.titulo LIKE ? OR c.resumen LIKE ? OR c.cuerpo LIKE ? LIMIT 6");
                String comodin = "%" + busqueda + "%";
                ps.setString(1, comodin);
                ps.setString(2, comodin);
                ps.setString(3, comodin);
                rs = ps.executeQuery();
                while (rs.next()) {
                    articulosCount++;
                    totalEncontrados++;
        %>
            <div class="col-md-6 col-lg-4">
                <div class="card glass-card h-100 p-3 d-flex flex-column">
                    <span class="badge bg-primary-subtle text-primary align-self-start mb-2"><%= Seguridad.escapeHtml(rs.getString("categoria")) %></span>
                    <h4 class="h6 fw-bold mb-1">
                        <a href="articulo.jsp?id=<%= rs.getInt("id_contenido") %>" class="text-reset text-decoration-none">
                            <%= Seguridad.escapeHtml(rs.getString("titulo")) %>
                        </a>
                    </h4>
                    <p class="small text-muted flex-grow-1 mb-2"><%= Seguridad.escapeHtml(rs.getString("resumen")) %></p>
                    <div class="d-flex justify-content-between align-items-center border-top pt-2 small text-muted">
                        <span><i class="bi bi-clock"></i> <%= rs.getInt("tiempo_lectura_min") %> min</span>
                        <a href="articulo.jsp?id=<%= rs.getInt("id_contenido") %>" class="btn btn-sm btn-outline-primary py-0">Leer</a>
                    </div>
                </div>
            </div>
        <%
                }
                if (articulosCount == 0) {
        %>
            <div class="col-12"><p class="text-muted small">No se encontraron artículos con este término.</p></div>
        <%
                }
            } catch (Exception e) {
        %>
            <div class="col-12"><div class="alert alert-danger">Error: <%= e.getMessage() %></div></div>
        <%
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            }
        %>
        </div>
    </div>

    <!-- 2. RESULTADOS EN TIPS -->
    <div class="mb-5 fade-in delay-3">
        <h3 class="h6 fw-bold text-primary text-uppercase mb-3 d-flex align-items-center gap-2">
            <i class="bi bi-lightbulb"></i> Tips y Consejos
        </h3>
        <div class="row g-3">
        <%
            int tipsCount = 0;
            try {
                con = ConexionBD.obtenerConexion();
                ps = con.prepareStatement(
                    "SELECT id_tip, titulo, descripcion, nivel, tiempo_min FROM tips " +
                    "WHERE titulo LIKE ? OR descripcion LIKE ? LIMIT 6");
                String comodin = "%" + busqueda + "%";
                ps.setString(1, comodin);
                ps.setString(2, comodin);
                rs = ps.executeQuery();
                while (rs.next()) {
                    tipsCount++;
                    totalEncontrados++;
                    String nivel = rs.getString("nivel");
                    String colorNivel = Iconos.obtenerColorNivel(nivel);
                    String icono = Iconos.obtenerIconoTip(rs.getString("titulo"));
        %>
            <div class="col-md-6">
                <div class="tip-card border-<%= colorNivel %> glass-card p-3">
                    <div class="d-flex align-items-start gap-3">
                        <div class="tip-icono bg-<%= colorNivel %>-subtle text-<%= colorNivel %>">
                            <i class="bi <%= icono %>"></i>
                        </div>
                        <div class="flex-grow-1">
                            <div class="d-flex justify-content-between align-items-start gap-2 mb-1">
                                <h4 class="h6 mb-0 fw-bold"><%= Seguridad.escapeHtml(rs.getString("titulo")) %></h4>
                                <span class="badge bg-<%= colorNivel %>"><%= nivel %></span>
                            </div>
                            <p class="small text-muted mb-0"><%= Seguridad.escapeHtml(rs.getString("descripcion")) %></p>
                        </div>
                    </div>
                </div>
            </div>
        <%
                }
                if (tipsCount == 0) {
        %>
            <div class="col-12"><p class="text-muted small">No se encontraron tips con este término.</p></div>
        <%
                }
            } catch (Exception e) {
        %>
            <div class="col-12"><div class="alert alert-danger">Error: <%= e.getMessage() %></div></div>
        <%
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            }
        %>
        </div>
    </div>

    <!-- 3. RESULTADOS EN NORMATIVAS -->
    <div class="mb-5 fade-in delay-4">
        <h3 class="h6 fw-bold text-primary text-uppercase mb-3 d-flex align-items-center gap-2">
            <i class="bi bi-shield-check"></i> Normatividad y Ética
        </h3>
        <div class="row g-3">
        <%
            int normasCount = 0;
            try {
                con = ConexionBD.obtenerConexion();
                ps = con.prepareStatement(
                    "SELECT titulo, descripcion, icono FROM normativas " +
                    "WHERE titulo LIKE ? OR descripcion LIKE ? LIMIT 4");
                String comodin = "%" + busqueda + "%";
                ps.setString(1, comodin);
                ps.setString(2, comodin);
                rs = ps.executeQuery();
                while (rs.next()) {
                    normasCount++;
                    totalEncontrados++;
        %>
            <div class="col-md-6">
                <div class="card glass-card p-3 h-100">
                    <div class="d-flex align-items-start gap-3">
                        <div class="feature-icon mb-0 flex-shrink-0">
                            <i class="bi bi-<%= rs.getString("icono") %>"></i>
                        </div>
                        <div>
                            <h4 class="h6 fw-bold mb-1"><%= Seguridad.escapeHtml(rs.getString("titulo")) %></h4>
                            <p class="small text-muted mb-0"><%= Seguridad.escapeHtml(rs.getString("descripcion")) %></p>
                        </div>
                    </div>
                </div>
            </div>
        <%
                }
                if (normasCount == 0) {
        %>
            <div class="col-12"><p class="text-muted small">No se encontraron normativas con este término.</p></div>
        <%
                }
            } catch (Exception e) {
        %>
            <div class="col-12"><div class="alert alert-danger">Error: <%= e.getMessage() %></div></div>
        <%
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            }
        %>
        </div>
    </div>

<%
    } else {
%>
    <div class="text-center py-5 text-muted fade-in delay-2">
        <i class="bi bi-search fs-1 d-block mb-3 text-primary opacity-50"></i>
        <h3 class="h5 fw-bold">Escribe lo que deseas aprender</h3>
        <p class="small">Busca por conceptos clave como "prompts", "privacidad", "sesgo", "alucinaciones", "derechos de autor", etc.</p>
    </div>
<%
    }
%>

<%@ include file="includes/footer.jsp" %>
