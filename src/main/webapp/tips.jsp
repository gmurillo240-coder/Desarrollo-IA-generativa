<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="conexion.ConexionBD" %>
<%@ page import="utilidades.Iconos" %>
<%@ include file="includes/header.jsp" %>

<%
    // ---- Leemos los filtros que llegan por la URL, ej: tips.jsp?nivel=Intermedio&q=prompt ----
    String nivelSeleccionado = request.getParameter("nivel");
    if (nivelSeleccionado == null) nivelSeleccionado = "Todos";

    String busqueda = request.getParameter("q");
    if (busqueda == null) busqueda = "";
%>

<!-- ===================== ENCABEZADO ===================== -->
<div class="hero mb-4 fade-in">
    <div class="row align-items-center">
        <div class="col-md-8">
            <h1 class="h3 fw-bold mb-1">Tips y consejos</h1>
            <p class="text-muted mb-0">Mejora tu experiencia con IA generativa, un consejo a la vez.</p>
        </div>
        <div class="col-md-4 text-md-end mt-3 mt-md-0">
            <i class="bi bi-stars text-primary" style="font-size: 3rem;"></i>
        </div>
    </div>
</div>

<!-- ===================== BUSCADOR ===================== -->
<form method="get" action="tips.jsp" class="mb-3 fade-in">
    <input type="hidden" name="nivel" value="<%= nivelSeleccionado %>">
    <div class="input-group input-group-lg shadow-sm">
        <span class="input-group-text bg-white border-end-0"><i class="bi bi-search text-primary"></i></span>
        <input type="text" name="q" value="<%= busqueda %>" class="form-control border-start-0"
               placeholder="Buscar tip, por ejemplo: prompts, privacidad, sesgo...">
        <button type="submit" class="btn btn-primary px-4">Buscar</button>
    </div>
</form>

<!-- ===================== FILTROS POR NIVEL ===================== -->
<ul class="nav nav-pills mb-4 fade-in gap-2">
    <%
        String[] niveles = {"Todos", "Principiante", "Intermedio", "Avanzado"};
        for (String n : niveles) {
            String activo = n.equals(nivelSeleccionado) ? "active" : "";
    %>
    <li class="nav-item">
        <a class="nav-link <%= activo %>"
           href="tips.jsp?nivel=<%= n %>&q=<%= busqueda %>"><%= n %></a>
    </li>
    <% } %>
</ul>

<div class="row g-3">
<%
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        con = ConexionBD.obtenerConexion();

        // Armamos la consulta segun los filtros seleccionados
        String sql = "SELECT titulo, descripcion, nivel, tiempo_min FROM tips WHERE 1 = 1";
        if (!"Todos".equals(nivelSeleccionado)) {
            sql += " AND nivel = ?";
        }
        if (!busqueda.trim().isEmpty()) {
            sql += " AND (titulo LIKE ? OR descripcion LIKE ?)";
        }
        sql += " ORDER BY FIELD(nivel, 'Principiante','Intermedio','Avanzado'), id_tip";

        ps = con.prepareStatement(sql);

        int index = 1;
        if (!"Todos".equals(nivelSeleccionado)) {
            ps.setString(index++, nivelSeleccionado);
        }
        if (!busqueda.trim().isEmpty()) {
            String comodin = "%" + busqueda.trim() + "%";
            ps.setString(index++, comodin);
            ps.setString(index++, comodin);
        }

        rs = ps.executeQuery();
        int i = 0;
        boolean hayResultados = false;
        while (rs.next()) {
            hayResultados = true;
            i++;
            String claseDelay = "delay-" + (((i - 1) % 4) + 1);
            String titulo = rs.getString("titulo");
            String nivel = rs.getString("nivel");

            String colorNivel = Iconos.obtenerColorNivel(nivel);
            String icono = Iconos.obtenerIconoTip(titulo);
%>
    <div class="col-md-6 fade-in <%= claseDelay %>">
        <div class="tip-card border-<%= colorNivel %>">
            <div class="d-flex align-items-start gap-3">
                <div class="tip-icono bg-<%= colorNivel %>-subtle text-<%= colorNivel %>">
                    <i class="bi <%= icono %>"></i>
                </div>
                <div class="flex-grow-1">
                    <div class="d-flex justify-content-between align-items-start gap-2">
                        <h3 class="h6 mb-1"><%= titulo %></h3>
                        <span class="badge bg-<%= colorNivel %>"><%= nivel %></span>
                    </div>
                    <p class="small text-muted mb-2"><%= rs.getString("descripcion") %></p>
                    <span class="small text-muted">
                        <i class="bi bi-clock"></i> <%= rs.getInt("tiempo_min") %> min para aplicarlo
                    </span>
                </div>
            </div>
        </div>
    </div>
<%
        }
        if (!hayResultados) {
%>
    <div class="col-12">
        <div class="alert alert-light border text-center">
            No encontramos tips que coincidan con tu búsqueda. Intenta con otra palabra o nivel.
        </div>
    </div>
<%
        }
    } catch (Exception e) {
%>
    <div class="col-12"><div class="alert alert-danger">Error al cargar tips: <%= e.getMessage() %></div></div>
<%
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>
</div>

<%@ include file="includes/footer.jsp" %>
