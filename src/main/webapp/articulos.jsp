<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="conexion.ConexionBD" %>
<%@ page import="utilidades.Seguridad" %>
<%@ include file="includes/header.jsp" %>

<%
    String categoriaParam = request.getParameter("cat");
    Integer idCategoria = null;
    if (categoriaParam != null && !categoriaParam.isEmpty()) {
        try {
            idCategoria = Integer.parseInt(categoriaParam);
        } catch (Exception e) {
            idCategoria = null;
        }
    }

    String busqueda = request.getParameter("q");
    if (busqueda == null) busqueda = "";
%>

<!-- ===================== ENCABEZADO ===================== -->
<div class="hero mb-4 fade-in">
    <div class="row align-items-center">
        <div class="col-lg-8">
            <span class="hero-badge">
                <i class="bi bi-journal-text text-primary"></i> Biblioteca de Contenidos
            </span>
            <h1 class="h3 fw-bold mb-2">Artículos y Guías sobre IA Generativa</h1>
            <p class="text-muted mb-0">
                Explora nuestra colección completa de lecturas especializadas clasificadas por temas,
                desde fundamentos y herramientas hasta ética y automatización.
            </p>
        </div>
        <div class="col-lg-4 text-center mt-3 mt-lg-0">
            <div class="avatar-tech mx-auto" style="width:68px; height:68px; font-size:2rem;">
                <i class="bi bi-book-half text-primary"></i>
            </div>
        </div>
    </div>
</div>

<!-- ===================== BUSCADOR Y FILTROS ===================== -->
<div class="card glass-card p-3 mb-4 fade-in delay-1">
    <form method="get" action="articulos.jsp" class="row g-2 align-items-center">
        <div class="col-md-7">
            <div class="input-group">
                <span class="input-group-text bg-transparent border-end-0"><i class="bi bi-search text-muted"></i></span>
                <input type="text" name="q" class="form-control border-start-0" placeholder="Buscar artículo por título o resumen..." value="<%= Seguridad.escapeHtml(busqueda) %>">
            </div>
        </div>
        <div class="col-md-3">
            <select name="cat" class="form-select">
                <option value="">Todas las categorías</option>
                <%
                    Connection con = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;
                    try {
                        con = ConexionBD.obtenerConexion();
                        ps = con.prepareStatement("SELECT id_categoria, nombre FROM categorias ORDER BY nombre");
                        rs = ps.executeQuery();
                        while (rs.next()) {
                            int catId = rs.getInt("id_categoria");
                            String catNom = rs.getString("nombre");
                            boolean sel = (idCategoria != null && idCategoria == catId);
                %>
                    <option value="<%= catId %>" <%= sel ? "selected" : "" %>><%= Seguridad.escapeHtml(catNom) %></option>
                <%
                        }
                    } catch (Exception e) {
                        // ignore
                    } finally {
                        if (rs != null) rs.close();
                        if (ps != null) ps.close();
                        if (con != null) con.close();
                    }
                %>
            </select>
        </div>
        <div class="col-md-2 d-flex gap-1">
            <button type="submit" class="btn btn-primary w-100 btn-glow">Filtrar</button>
            <% if ((idCategoria != null) || !busqueda.isEmpty()) { %>
                <a href="articulos.jsp" class="btn btn-outline-secondary" title="Quitar filtros"><i class="bi bi-x-lg"></i></a>
            <% } %>
        </div>
    </form>
</div>

<!-- ===================== LISTADO DE ARTÍCULOS ===================== -->
<div class="row g-4 mb-5">
<%
    try {
        con = ConexionBD.obtenerConexion();
        String sql = "SELECT c.id_contenido, c.titulo, c.resumen, c.tiempo_lectura_min, c.fecha_publicacion, cat.nombre AS categoria " +
                     "FROM contenidos c JOIN categorias cat ON c.id_categoria = cat.id_categoria WHERE 1 = 1";
        
        if (idCategoria != null) {
            sql += " AND c.id_categoria = ?";
        }
        if (!busqueda.trim().isEmpty()) {
            sql += " AND (c.titulo LIKE ? OR c.resumen LIKE ?)";
        }
        sql += " ORDER BY c.fecha_publicacion DESC";

        ps = con.prepareStatement(sql);
        int paramIdx = 1;
        if (idCategoria != null) {
            ps.setInt(paramIdx++, idCategoria);
        }
        if (!busqueda.trim().isEmpty()) {
            String comodin = "%" + busqueda.trim() + "%";
            ps.setString(paramIdx++, comodin);
            ps.setString(paramIdx++, comodin);
        }

        rs = ps.executeQuery();
        boolean hayArticulos = false;
        int count = 0;
        while (rs.next()) {
            hayArticulos = true;
            count++;
            String delayClass = "delay-" + (((count - 1) % 4) + 1);
%>
    <div class="col-md-6 col-lg-4 fade-in <%= delayClass %>">
        <div class="card glass-card h-100">
            <div class="card-body d-flex flex-column p-4">
                <span class="badge bg-primary-subtle text-primary align-self-start mb-2">
                    <%= Seguridad.escapeHtml(rs.getString("categoria")) %>
                </span>
                <h2 class="h5 fw-bold mb-2">
                    <a href="articulo.jsp?id=<%= rs.getInt("id_contenido") %>" class="text-reset text-decoration-none">
                        <%= Seguridad.escapeHtml(rs.getString("titulo")) %>
                    </a>
                </h2>
                <p class="small text-muted flex-grow-1">
                    <%= Seguridad.escapeHtml(rs.getString("resumen")) %>
                </p>
                <div class="d-flex justify-content-between align-items-center mt-3 pt-3 border-top small text-muted">
                    <span><i class="bi bi-calendar3"></i> <%= rs.getDate("fecha_publicacion") %></span>
                    <span><i class="bi bi-clock"></i> <%= rs.getInt("tiempo_lectura_min") %> min</span>
                </div>
                <div class="mt-3">
                    <a href="articulo.jsp?id=<%= rs.getInt("id_contenido") %>" class="btn btn-sm btn-outline-primary w-100">
                        Leer artículo completo <i class="bi bi-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
<%
        }
        if (!hayArticulos) {
%>
    <div class="col-12">
        <div class="alert alert-light border text-center py-5">
            <i class="bi bi-search fs-1 text-muted d-block mb-3"></i>
            <h3 class="h5 fw-bold">No se encontraron artículos</h3>
            <p class="text-muted small mb-3">No hay publicaciones que coincidan con los criterios de búsqueda.</p>
            <a href="articulos.jsp" class="btn btn-sm btn-primary">Ver todos los artículos</a>
        </div>
    </div>
<%
        }
    } catch (Exception e) {
%>
    <div class="col-12"><div class="alert alert-danger">Error al cargar artículos: <%= e.getMessage() %></div></div>
<%
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>
</div>

<%@ include file="includes/footer.jsp" %>
