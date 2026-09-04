<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="conexion.ConexionBD" %>
<%@ page import="utilidades.Seguridad" %>
<%
    // Verificación estricta de rol de administrador
    String rolUsuario = (String) session.getAttribute("rol");
    if (rolUsuario == null || !"administrador".equalsIgnoreCase(rolUsuario)) {
        response.sendRedirect("index.jsp");
        return;
    }

    String mensaje = "";
    String tipoAlerta = "info";

    // -------------------------------------------------------------
    // ACCIONES CRUD: ARTÍCULOS
    // -------------------------------------------------------------
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String accion = request.getParameter("accion");

        // 1. Crear Artículo
        if ("crear_articulo".equals(accion)) {
            String titulo = request.getParameter("titulo");
            String resumen = request.getParameter("resumen");
            String cuerpo = request.getParameter("cuerpo");
            String tiempoStr = request.getParameter("tiempo_lectura_min");
            String catStr = request.getParameter("id_categoria");

            if (titulo != null && cuerpo != null && !titulo.trim().isEmpty() && !cuerpo.trim().isEmpty()) {
                Connection conAct = null;
                PreparedStatement psAct = null;
                try {
                    conAct = ConexionBD.obtenerConexion();
                    psAct = conAct.prepareStatement(
                        "INSERT INTO contenidos (titulo, resumen, cuerpo, tiempo_lectura_min, id_categoria, fecha_publicacion) VALUES (?, ?, ?, ?, ?, CURDATE())");
                    psAct.setString(1, titulo.trim());
                    psAct.setString(2, resumen != null ? resumen.trim() : "");
                    psAct.setString(3, cuerpo.trim());
                    psAct.setInt(4, (tiempoStr != null && !tiempoStr.isEmpty()) ? Integer.parseInt(tiempoStr) : 5);
                    psAct.setInt(5, Integer.parseInt(catStr));
                    psAct.executeUpdate();
                    mensaje = "¡Artículo creado y publicado con éxito!";
                    tipoAlerta = "success";
                } catch (Exception e) {
                    mensaje = "Error al crear artículo: " + e.getMessage();
                    tipoAlerta = "danger";
                } finally {
                    if (psAct != null) psAct.close();
                    if (conAct != null) conAct.close();
                }
            }
        }

        // 2. Eliminar Artículo
        if ("eliminar_articulo".equals(accion)) {
            String idArtStr = request.getParameter("id_contenido");
            if (idArtStr != null) {
                Connection conDel = null;
                PreparedStatement psDel = null;
                try {
                    conDel = ConexionBD.obtenerConexion();
                    psDel = conDel.prepareStatement("DELETE FROM contenidos WHERE id_contenido = ?");
                    psDel.setInt(1, Integer.parseInt(idArtStr));
                    psDel.executeUpdate();
                    mensaje = "Artículo eliminado correctamente.";
                    tipoAlerta = "success";
                } catch (Exception e) {
                    mensaje = "Error al eliminar artículo: " + e.getMessage();
                    tipoAlerta = "danger";
                } finally {
                    if (psDel != null) psDel.close();
                    if (conDel != null) conDel.close();
                }
            }
        }

        // 3. Crear Tip
        if ("crear_tip".equals(accion)) {
            String tituloTip = request.getParameter("titulo_tip");
            String descTip = request.getParameter("descripcion_tip");
            String nivelTip = request.getParameter("nivel_tip");
            String tiempoTipStr = request.getParameter("tiempo_min_tip");
            String catTipStr = request.getParameter("id_categoria_tip");

            if (tituloTip != null && descTip != null && !tituloTip.trim().isEmpty() && !descTip.trim().isEmpty()) {
                Connection conTip = null;
                PreparedStatement psTip = null;
                try {
                    conTip = ConexionBD.obtenerConexion();
                    psTip = conTip.prepareStatement(
                        "INSERT INTO tips (titulo, descripcion, nivel, tiempo_min, id_categoria) VALUES (?, ?, ?, ?, ?)");
                    psTip.setString(1, tituloTip.trim());
                    psTip.setString(2, descTip.trim());
                    psTip.setString(3, nivelTip != null ? nivelTip : "Principiante");
                    psTip.setInt(4, (tiempoTipStr != null && !tiempoTipStr.isEmpty()) ? Integer.parseInt(tiempoTipStr) : 3);
                    psTip.setInt(5, Integer.parseInt(catTipStr));
                    psTip.executeUpdate();
                    mensaje = "¡Nuevo tip agregado exitosamente!";
                    tipoAlerta = "success";
                } catch (Exception e) {
                    mensaje = "Error al crear tip: " + e.getMessage();
                    tipoAlerta = "danger";
                } finally {
                    if (psTip != null) psTip.close();
                    if (conTip != null) conTip.close();
                }
            }
        }

        // 4. Eliminar Tip
        if ("eliminar_tip".equals(accion)) {
            String idTipStr = request.getParameter("id_tip");
            if (idTipStr != null) {
                Connection conDelTip = null;
                PreparedStatement psDelTip = null;
                try {
                    conDelTip = ConexionBD.obtenerConexion();
                    psDelTip = conDelTip.prepareStatement("DELETE FROM tips WHERE id_tip = ?");
                    psDelTip.setInt(1, Integer.parseInt(idTipStr));
                    psDelTip.executeUpdate();
                    mensaje = "Tip eliminado correctamente.";
                    tipoAlerta = "success";
                } catch (Exception e) {
                    mensaje = "Error al eliminar tip: " + e.getMessage();
                    tipoAlerta = "danger";
                } finally {
                    if (psDelTip != null) psDelTip.close();
                    if (conDelTip != null) conDelTip.close();
                }
            }
        }

        // 5. Eliminar Comentario (Moderación)
        if ("eliminar_comentario".equals(accion)) {
            String idComStr = request.getParameter("id_comentario");
            if (idComStr != null) {
                Connection conDelCom = null;
                PreparedStatement psDelCom = null;
                try {
                    conDelCom = ConexionBD.obtenerConexion();
                    psDelCom = conDelCom.prepareStatement("DELETE FROM comentarios WHERE id_comentario = ?");
                    psDelCom.setInt(1, Integer.parseInt(idComStr));
                    psDelCom.executeUpdate();
                    mensaje = "Comentario moderado y eliminado correctamente.";
                    tipoAlerta = "success";
                } catch (Exception e) {
                    mensaje = "Error al moderar comentario: " + e.getMessage();
                    tipoAlerta = "danger";
                } finally {
                    if (psDelCom != null) psDelCom.close();
                    if (conDelCom != null) conDelCom.close();
                }
            }
        }
    }

    // Contadores para métricas
    int totalUsuarios = 0, totalArticulos = 0, totalTips = 0, totalComentarios = 0;
    Connection conStats = null;
    Statement stStats = null;
    ResultSet rsStats = null;
    try {
        conStats = ConexionBD.obtenerConexion();
        stStats = conStats.createStatement();
        rsStats = stStats.executeQuery("SELECT COUNT(*) FROM usuarios");
        if (rsStats.next()) totalUsuarios = rsStats.getInt(1);
        rsStats.close();

        rsStats = stStats.executeQuery("SELECT COUNT(*) FROM contenidos");
        if (rsStats.next()) totalArticulos = rsStats.getInt(1);
        rsStats.close();

        rsStats = stStats.executeQuery("SELECT COUNT(*) FROM tips");
        if (rsStats.next()) totalTips = rsStats.getInt(1);
        rsStats.close();

        rsStats = stStats.executeQuery("SELECT COUNT(*) FROM comentarios");
        if (rsStats.next()) totalComentarios = rsStats.getInt(1);
    } catch (Exception e) {
        // ignore
    } finally {
        if (rsStats != null) rsStats.close();
        if (stStats != null) stStats.close();
        if (conStats != null) conStats.close();
    }
%>
<%@ include file="includes/header.jsp" %>

<!-- ===================== ENCABEZADO ===================== -->
<div class="hero mb-4 fade-in">
    <div class="row align-items-center">
        <div class="col-lg-8">
            <span class="hero-badge" style="background: rgba(239, 68, 68, 0.15); color: #ef4444; border-color: rgba(239, 68, 68, 0.3);">
                <i class="bi bi-shield-lock-fill text-danger"></i> Zona de Control Administrador
            </span>
            <h1 class="h3 fw-bold mb-2">Panel de Administración (CRUD)</h1>
            <p class="text-muted mb-0">
                Gestiona en tiempo real los artículos, tips de microaprendizaje y comentarios de la plataforma sin tocar phpMyAdmin.
            </p>
        </div>
        <div class="col-lg-4 text-center mt-3 mt-lg-0">
            <div class="avatar-tech mx-auto" style="width:72px; height:72px; font-size:2.2rem; background: rgba(239, 68, 68, 0.12); border-color: rgba(239, 68, 68, 0.3);">
                <i class="bi bi-gear-wide-connected text-danger"></i>
            </div>
        </div>
    </div>
</div>

<% if (!mensaje.isEmpty()) { %>
    <div class="alert alert-<%= tipoAlerta %> d-flex align-items-center gap-2 mb-4 fade-in">
        <i class="bi <%= "success".equals(tipoAlerta) ? "bi-check-circle-fill" : "bi-exclamation-circle-fill" %> flex-shrink-0"></i>
        <div><%= mensaje %></div>
    </div>
<% } %>

<!-- ===================== MÉTRICAS RÁPIDAS ===================== -->
<div class="row g-3 mb-4 fade-in delay-1">
    <div class="col-6 col-md-3">
        <div class="card glass-card p-3 text-center">
            <div class="stat-numero"><%= totalUsuarios %></div>
            <div class="small text-muted fw-semibold">Usuarios Registrados</div>
        </div>
    </div>
    <div class="col-6 col-md-3">
        <div class="card glass-card p-3 text-center">
            <div class="stat-numero text-info"><%= totalArticulos %></div>
            <div class="small text-muted fw-semibold">Artículos Publicados</div>
        </div>
    </div>
    <div class="col-6 col-md-3">
        <div class="card glass-card p-3 text-center">
            <div class="stat-numero text-warning"><%= totalTips %></div>
            <div class="small text-muted fw-semibold">Tips Activos</div>
        </div>
    </div>
    <div class="col-6 col-md-3">
        <div class="card glass-card p-3 text-center">
            <div class="stat-numero text-success"><%= totalComentarios %></div>
            <div class="small text-muted fw-semibold">Comentarios Totales</div>
        </div>
    </div>
</div>

<!-- ===================== PESTAÑAS DE GESTIÓN ===================== -->
<ul class="nav nav-tabs mb-4 fade-in delay-2" id="adminTabs" role="tablist">
    <li class="nav-item" role="presentation">
        <button class="nav-link active fw-bold" id="articulos-tab" data-bs-toggle="tab" data-bs-target="#tabArticulos" type="button" role="tab">
            <i class="bi bi-journal-text me-1"></i> Artículos (<%= totalArticulos %>)
        </button>
    </li>
    <li class="nav-item" role="presentation">
        <button class="nav-link fw-bold" id="tips-tab" data-bs-toggle="tab" data-bs-target="#tabTips" type="button" role="tab">
            <i class="bi bi-lightbulb me-1"></i> Tips (<%= totalTips %>)
        </button>
    </li>
    <li class="nav-item" role="presentation">
        <button class="nav-link fw-bold" id="comentarios-tab" data-bs-toggle="tab" data-bs-target="#tabComentarios" type="button" role="tab">
            <i class="bi bi-chat-left-dots me-1"></i> Moderación de Comentarios (<%= totalComentarios %>)
        </button>
    </li>
</ul>

<div class="tab-content fade-in delay-3" id="adminTabsContent">
    <!-- ===================== PESTAÑA 1: ARTÍCULOS ===================== -->
    <div class="tab-pane fade show active" id="tabArticulos" role="tabpanel">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2 class="h5 fw-bold mb-0">Catálogo de Artículos</h2>
            <button class="btn btn-primary btn-sm btn-glow" data-bs-toggle="modal" data-bs-target="#modalNuevoArticulo">
                <i class="bi bi-plus-lg me-1"></i> Publicar Nuevo Artículo
            </button>
        </div>

        <div class="card glass-card p-0 overflow-hidden">
            <div class="table-responsive">
                <table class="table table-tech table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th style="width: 60px;">ID</th>
                            <th>Título</th>
                            <th>Categoría</th>
                            <th>Fecha</th>
                            <th style="width: 90px;">Lectura</th>
                            <th style="width: 120px;" class="text-end">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        Connection conArt = null;
                        PreparedStatement psArt = null;
                        ResultSet rsArt = null;
                        try {
                            conArt = ConexionBD.obtenerConexion();
                            psArt = conArt.prepareStatement(
                                "SELECT c.id_contenido, c.titulo, c.fecha_publicacion, c.tiempo_lectura_min, cat.nombre AS categoria " +
                                "FROM contenidos c JOIN categorias cat ON c.id_categoria = cat.id_categoria ORDER BY c.id_contenido DESC");
                            rsArt = psArt.executeQuery();
                            while (rsArt.next()) {
                                int idCont = rsArt.getInt("id_contenido");
                    %>
                        <tr>
                            <td class="text-muted fw-bold">#<%= idCont %></td>
                            <td>
                                <strong class="small"><%= Seguridad.escapeHtml(rsArt.getString("titulo")) %></strong>
                            </td>
                            <td><span class="badge bg-primary-subtle text-primary"><%= Seguridad.escapeHtml(rsArt.getString("categoria")) %></span></td>
                            <td class="small text-muted"><%= rsArt.getDate("fecha_publicacion") %></td>
                            <td class="small text-muted"><%= rsArt.getInt("tiempo_lectura_min") %> min</td>
                            <td class="text-end">
                                <a href="articulo.jsp?id=<%= idCont %>" class="btn btn-sm btn-outline-secondary py-0 px-1" title="Ver" target="_blank">
                                    <i class="bi bi-eye"></i>
                                </a>
                                <form method="post" action="admin.jsp" class="d-inline" onsubmit="return confirm('¿Seguro que deseas eliminar este artículo? Se eliminarán también sus comentarios y favoritos asociados.');">
                                    <input type="hidden" name="accion" value="eliminar_articulo">
                                    <input type="hidden" name="id_contenido" value="<%= idCont %>">
                                    <button type="submit" class="btn btn-sm btn-outline-danger py-0 px-1" title="Eliminar">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </form>
                            </td>
                        </tr>
                    <%
                            }
                        } catch (Exception e) {
                    %>
                        <tr><td colspan="6" class="text-danger p-3">Error al cargar artículos: <%= e.getMessage() %></td></tr>
                    <%
                        } finally {
                            if (rsArt != null) rsArt.close();
                            if (psArt != null) psArt.close();
                            if (conArt != null) conArt.close();
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- ===================== PESTAÑA 2: TIPS ===================== -->
    <div class="tab-pane fade" id="tabTips" role="tabpanel">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2 class="h5 fw-bold mb-0">Gestión de Tips de Microaprendizaje</h2>
            <button class="btn btn-primary btn-sm btn-glow" data-bs-toggle="modal" data-bs-target="#modalNuevoTip">
                <i class="bi bi-plus-lg me-1"></i> Agregar Nuevo Tip
            </button>
        </div>

        <div class="card glass-card p-0 overflow-hidden">
            <div class="table-responsive">
                <table class="table table-tech table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th style="width: 60px;">ID</th>
                            <th>Título</th>
                            <th>Nivel</th>
                            <th>Tiempo</th>
                            <th style="width: 100px;" class="text-end">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        Connection conT = null;
                        PreparedStatement psT = null;
                        ResultSet rsT = null;
                        try {
                            conT = ConexionBD.obtenerConexion();
                            psT = conT.prepareStatement("SELECT id_tip, titulo, nivel, tiempo_min FROM tips ORDER BY id_tip DESC");
                            rsT = psT.executeQuery();
                            while (rsT.next()) {
                                int idTip = rsT.getInt("id_tip");
                                String nivel = rsT.getString("nivel");
                                String colorNivel = "Principiante".equals(nivel) ? "success" : ("Intermedio".equals(nivel) ? "warning" : "danger");
                    %>
                        <tr>
                            <td class="text-muted fw-bold">#<%= idTip %></td>
                            <td><strong class="small"><%= Seguridad.escapeHtml(rsT.getString("titulo")) %></strong></td>
                            <td><span class="badge bg-<%= colorNivel %>"><%= nivel %></span></td>
                            <td class="small text-muted"><%= rsT.getInt("tiempo_min") %> min</td>
                            <td class="text-end">
                                <form method="post" action="admin.jsp" class="d-inline" onsubmit="return confirm('¿Seguro que deseas eliminar este tip?');">
                                    <input type="hidden" name="accion" value="eliminar_tip">
                                    <input type="hidden" name="id_tip" value="<%= idTip %>">
                                    <button type="submit" class="btn btn-sm btn-outline-danger py-0 px-2" title="Eliminar">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </form>
                            </td>
                        </tr>
                    <%
                            }
                        } catch (Exception e) {
                    %>
                        <tr><td colspan="5" class="text-danger p-3">Error al cargar tips: <%= e.getMessage() %></td></tr>
                    <%
                        } finally {
                            if (rsT != null) rsT.close();
                            if (psT != null) psT.close();
                            if (conT != null) conT.close();
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- ===================== PESTAÑA 3: COMENTARIOS ===================== -->
    <div class="tab-pane fade" id="tabComentarios" role="tabpanel">
        <h2 class="h5 fw-bold mb-3">Moderación de Comentarios</h2>
        <div class="card glass-card p-0 overflow-hidden">
            <div class="table-responsive">
                <table class="table table-tech table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th style="width: 60px;">ID</th>
                            <th>Usuario</th>
                            <th>Artículo</th>
                            <th>Comentario</th>
                            <th>Fecha</th>
                            <th style="width: 80px;" class="text-end">Acción</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        Connection conCm = null;
                        PreparedStatement psCm = null;
                        ResultSet rsCm = null;
                        try {
                            conCm = ConexionBD.obtenerConexion();
                            psCm = conCm.prepareStatement(
                                "SELECT cm.id_comentario, cm.comentario, cm.fecha_comentario, u.nombre, c.titulo AS articulo " +
                                "FROM comentarios cm " +
                                "JOIN usuarios u ON cm.id_usuario = u.id_usuario " +
                                "JOIN contenidos c ON cm.id_contenido = c.id_contenido " +
                                "ORDER BY cm.fecha_comentario DESC");
                            rsCm = psCm.executeQuery();
                            boolean hayComs = false;
                            while (rsCm.next()) {
                                hayComs = true;
                                int idCm = rsCm.getInt("id_comentario");
                    %>
                        <tr>
                            <td class="text-muted fw-bold">#<%= idCm %></td>
                            <td class="small fw-semibold"><%= Seguridad.escapeHtml(rsCm.getString("nombre")) %></td>
                            <td class="small text-primary"><%= Seguridad.escapeHtml(rsCm.getString("articulo")) %></td>
                            <td class="small text-muted"><%= Seguridad.escapeHtml(rsCm.getString("comentario")) %></td>
                            <td class="small text-muted"><%= rsCm.getTimestamp("fecha_comentario") %></td>
                            <td class="text-end">
                                <form method="post" action="admin.jsp" class="d-inline" onsubmit="return confirm('¿Deseas eliminar este comentario?');">
                                    <input type="hidden" name="accion" value="eliminar_comentario">
                                    <input type="hidden" name="id_comentario" value="<%= idCm %>">
                                    <button type="submit" class="btn btn-sm btn-outline-danger py-0 px-2" title="Eliminar">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </form>
                            </td>
                        </tr>
                    <%
                            }
                            if (!hayComs) {
                    %>
                        <tr><td colspan="6" class="text-muted text-center py-4">No hay comentarios para moderar.</td></tr>
                    <%
                            }
                        } catch (Exception e) {
                    %>
                        <tr><td colspan="6" class="text-danger p-3">Error al cargar comentarios: <%= e.getMessage() %></td></tr>
                    <%
                        } finally {
                            if (rsCm != null) rsCm.close();
                            if (psCm != null) psCm.close();
                            if (conCm != null) conCm.close();
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- ===================== MODAL CREAR ARTÍCULO ===================== -->
<div class="modal fade" id="modalNuevoArticulo" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content glass-card">
            <form method="post" action="admin.jsp">
                <input type="hidden" name="accion" value="crear_articulo">
                <div class="modal-header border-bottom">
                    <h3 class="modal-title h5 fw-bold"><i class="bi bi-plus-circle text-primary me-1"></i> Publicar Nuevo Artículo</h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Título del Artículo</label>
                        <input type="text" name="titulo" class="form-control" placeholder="Ej. El Futuro de los Agentes Autónomos con Java" required>
                    </div>
                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-bold">Categoría</label>
                            <select name="id_categoria" class="form-select" required>
                                <%
                                    Connection conCatSelect = null;
                                    Statement stCatSelect = null;
                                    ResultSet rsCatSelect = null;
                                    try {
                                        conCatSelect = ConexionBD.obtenerConexion();
                                        stCatSelect = conCatSelect.createStatement();
                                        rsCatSelect = stCatSelect.executeQuery("SELECT id_categoria, nombre FROM categorias");
                                        while (rsCatSelect.next()) {
                                %>
                                    <option value="<%= rsCatSelect.getInt("id_categoria") %>"><%= Seguridad.escapeHtml(rsCatSelect.getString("nombre")) %></option>
                                <%
                                        }
                                    } catch (Exception ex) {
                                    } finally {
                                        if (rsCatSelect != null) rsCatSelect.close();
                                        if (stCatSelect != null) stCatSelect.close();
                                        if (conCatSelect != null) conCatSelect.close();
                                    }
                                %>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-bold">Tiempo estimado de lectura (minutos)</label>
                            <input type="number" name="tiempo_lectura_min" class="form-control" value="5" min="1" max="60" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Resumen / Extracto</label>
                        <textarea name="resumen" class="form-control" rows="2" placeholder="Breve introducción que se muestra en las tarjetas..." required></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Cuerpo Completo del Artículo</label>
                        <textarea name="cuerpo" class="form-control" rows="8" placeholder="Escribe el contenido completo. Separa los párrafos con líneas en blanco. Si una línea es corta y sin punto final, se convertirá automáticamente en un subtítulo." required></textarea>
                    </div>
                </div>
                <div class="modal-footer border-top">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-primary btn-glow">Publicar Artículo</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- ===================== MODAL CREAR TIP ===================== -->
<div class="modal fade" id="modalNuevoTip" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content glass-card">
            <form method="post" action="admin.jsp">
                <input type="hidden" name="accion" value="crear_tip">
                <div class="modal-header border-bottom">
                    <h3 class="modal-title h5 fw-bold"><i class="bi bi-lightbulb text-warning me-1"></i> Agregar Nuevo Tip</h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Título del Tip</label>
                        <input type="text" name="titulo_tip" class="form-control" placeholder="Ej. Define el formato de salida deseado" required>
                    </div>
                    <div class="row g-3 mb-3">
                        <div class="col-6">
                            <label class="form-label small fw-bold">Nivel</label>
                            <select name="nivel_tip" class="form-select">
                                <option value="Principiante">Principiante</option>
                                <option value="Intermedio">Intermedio</option>
                                <option value="Avanzado">Avanzado</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-bold">Tiempo (min)</label>
                            <input type="number" name="tiempo_min_tip" class="form-control" value="3" min="1" max="30" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Categoría</label>
                        <select name="id_categoria_tip" class="form-select" required>
                            <%
                                try {
                                    conCatSelect = ConexionBD.obtenerConexion();
                                    stCatSelect = conCatSelect.createStatement();
                                    rsCatSelect = stCatSelect.executeQuery("SELECT id_categoria, nombre FROM categorias");
                                    while (rsCatSelect.next()) {
                            %>
                                <option value="<%= rsCatSelect.getInt("id_categoria") %>"><%= Seguridad.escapeHtml(rsCatSelect.getString("nombre")) %></option>
                            <%
                                    }
                                } catch (Exception ex) {
                                } finally {
                                    if (rsCatSelect != null) rsCatSelect.close();
                                    if (stCatSelect != null) stCatSelect.close();
                                    if (conCatSelect != null) conCatSelect.close();
                                }
                            %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Descripción / Consejo</label>
                        <textarea name="descripcion_tip" class="form-control" rows="4" placeholder="Explica de forma concisa la recomendación..." required></textarea>
                    </div>
                </div>
                <div class="modal-footer border-top">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-primary btn-glow">Guardar Tip</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>
