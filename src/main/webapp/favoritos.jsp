<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="conexion.ConexionBD" %>
<%@ page import="utilidades.Iconos" %>
<%@ page import="utilidades.Seguridad" %>
<%
    Integer idUsuarioLogueado = (Integer) session.getAttribute("idUsuario");
    if (idUsuarioLogueado == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // ---- Procesar eliminación de favorito ----
    String eliminarTipo = request.getParameter("del_tipo");
    String eliminarId = request.getParameter("del_id");
    if (eliminarTipo != null && eliminarId != null) {
        Connection conDel = null;
        PreparedStatement psDel = null;
        try {
            conDel = ConexionBD.obtenerConexion();
            psDel = conDel.prepareStatement(
                "DELETE FROM favoritos WHERE id_usuario = ? AND tipo_item = ? AND id_item = ?");
            psDel.setInt(1, idUsuarioLogueado);
            psDel.setString(2, eliminarTipo);
            psDel.setInt(3, Integer.parseInt(eliminarId));
            psDel.executeUpdate();
            response.sendRedirect("favoritos.jsp");
            return;
        } catch (Exception ex) {
            // ignore
        } finally {
            if (psDel != null) psDel.close();
            if (conDel != null) conDel.close();
        }
    }
%>
<%@ include file="includes/header.jsp" %>

<!-- ===================== ENCABEZADO ===================== -->
<div class="hero mb-4 fade-in">
    <div class="row align-items-center">
        <div class="col-lg-8">
            <span class="hero-badge">
                <i class="bi bi-heart-fill text-danger"></i> Biblioteca Personal
            </span>
            <h1 class="h3 fw-bold mb-2">Mis Favoritos Guardados</h1>
            <p class="text-muted mb-0">
                Accede rápidamente a los artículos y tips prácticos que has marcado para repasar en cualquier momento.
            </p>
        </div>
        <div class="col-lg-4 text-center mt-3 mt-lg-0">
            <div class="avatar-tech mx-auto" style="width:68px; height:68px; font-size:2rem; background: rgba(236, 72, 153, 0.15); border-color: rgba(236, 72, 153, 0.3);">
                <i class="bi bi-bookmark-heart text-danger"></i>
            </div>
        </div>
    </div>
</div>

<!-- ===================== SECCIÓN DE ARTÍCULOS FAVORITOS ===================== -->
<div class="mb-5 fade-in delay-1">
    <h2 class="h5 fw-bold mb-3 d-flex align-items-center gap-2">
        <i class="bi bi-journal-bookmark text-primary"></i> Artículos Guardados
    </h2>

    <div class="row g-3">
    <%
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int totalArticulos = 0;
        try {
            con = ConexionBD.obtenerConexion();
            ps = con.prepareStatement(
                "SELECT c.id_contenido, c.titulo, c.resumen, c.tiempo_lectura_min, f.fecha_guardado, cat.nombre AS categoria " +
                "FROM favoritos f " +
                "JOIN contenidos c ON f.id_item = c.id_contenido " +
                "JOIN categorias cat ON c.id_categoria = cat.id_categoria " +
                "WHERE f.id_usuario = ? AND f.tipo_item = 'contenido' " +
                "ORDER BY f.fecha_guardado DESC");
            ps.setInt(1, idUsuarioLogueado);
            rs = ps.executeQuery();
            while (rs.next()) {
                totalArticulos++;
                int idCont = rs.getInt("id_contenido");
    %>
        <div class="col-md-6 col-lg-4">
            <div class="card glass-card h-100 p-4 d-flex flex-column">
                <div class="d-flex justify-content-between align-items-start mb-2">
                    <span class="badge bg-primary-subtle text-primary"><%= Seguridad.escapeHtml(rs.getString("categoria")) %></span>
                    <a href="favoritos.jsp?del_tipo=contenido&del_id=<%= idCont %>" class="btn-fav active" title="Quitar de favoritos">
                        <i class="bi bi-trash text-danger"></i>
                    </a>
                </div>
                <h3 class="h6 fw-bold mb-2">
                    <a href="articulo.jsp?id=<%= idCont %>" class="text-reset text-decoration-none">
                        <%= Seguridad.escapeHtml(rs.getString("titulo")) %>
                    </a>
                </h3>
                <p class="small text-muted flex-grow-1"><%= Seguridad.escapeHtml(rs.getString("resumen")) %></p>
                <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top small text-muted">
                    <span><i class="bi bi-clock"></i> <%= rs.getInt("tiempo_lectura_min") %> min</span>
                    <a href="articulo.jsp?id=<%= idCont %>" class="btn btn-sm btn-outline-primary">Leer artículo</a>
                </div>
            </div>
        </div>
    <%
            }
            if (totalArticulos == 0) {
    %>
        <div class="col-12">
            <div class="alert alert-light border py-4 text-center small text-muted">
                <i class="bi bi-journal-x fs-2 d-block mb-2 text-muted"></i>
                No has guardado ningún artículo aún. Puedes guardar artículos haciendo clic en el botón de corazón dentro de cada lectura.
                <div class="mt-2"><a href="articulos.jsp" class="btn btn-sm btn-outline-primary">Explorar artículos</a></div>
            </div>
        </div>
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

<!-- ===================== SECCIÓN DE TIPS FAVORITOS ===================== -->
<div class="mb-5 fade-in delay-2">
    <h2 class="h5 fw-bold mb-3 d-flex align-items-center gap-2">
        <i class="bi bi-lightbulb text-warning"></i> Tips Guardados
    </h2>

    <div class="row g-3">
    <%
        int totalTips = 0;
        try {
            con = ConexionBD.obtenerConexion();
            ps = con.prepareStatement(
                "SELECT t.id_tip, t.titulo, t.descripcion, t.nivel, t.tiempo_min, f.fecha_guardado " +
                "FROM favoritos f " +
                "JOIN tips t ON f.id_item = t.id_tip " +
                "WHERE f.id_usuario = ? AND f.tipo_item = 'tip' " +
                "ORDER BY f.fecha_guardado DESC");
            ps.setInt(1, idUsuarioLogueado);
            rs = ps.executeQuery();
            while (rs.next()) {
                totalTips++;
                int idTip = rs.getInt("id_tip");
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
                            <h3 class="h6 mb-0 fw-bold"><%= Seguridad.escapeHtml(rs.getString("titulo")) %></h3>
                            <a href="favoritos.jsp?del_tipo=tip&del_id=<%= idTip %>" class="btn-fav active" title="Quitar de favoritos">
                                <i class="bi bi-trash text-danger"></i>
                            </a>
                        </div>
                        <p class="small text-muted mb-2"><%= Seguridad.escapeHtml(rs.getString("descripcion")) %></p>
                        <div class="d-flex justify-content-between align-items-center small text-muted">
                            <span class="badge bg-<%= colorNivel %>"><%= nivel %></span>
                            <span><i class="bi bi-clock"></i> <%= rs.getInt("tiempo_min") %> min</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    <%
            }
            if (totalTips == 0) {
    %>
        <div class="col-12">
            <div class="alert alert-light border py-4 text-center small text-muted">
                <i class="bi bi-lightbulb-off fs-2 d-block mb-2 text-muted"></i>
                No has guardado ningún tip aún. Puedes guardar tips haciendo clic en el corazón de cada tarjeta en la sección de Tips.
                <div class="mt-2"><a href="tips.jsp" class="btn btn-sm btn-outline-primary">Explorar tips</a></div>
            </div>
        </div>
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

<%@ include file="includes/footer.jsp" %>
