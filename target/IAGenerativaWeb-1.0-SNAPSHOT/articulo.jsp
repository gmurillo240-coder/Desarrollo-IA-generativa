<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="conexion.ConexionBD" %>
<%@ page import="utilidades.Seguridad" %>
<%
    int idContenido = 1;
    try {
        idContenido = Integer.parseInt(request.getParameter("id"));
    } catch (Exception e) {
        idContenido = 1;
    }

    Integer idUsuarioLogueado = (Integer) session.getAttribute("idUsuario");
    String mensajeComentario = "";
    String tipoAlertaComentario = "info";

    // ---- Procesar inserción de comentario ----
    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("publicar_comentario") != null) {
        if (idUsuarioLogueado == null) {
            mensajeComentario = "Debes iniciar sesión para publicar un comentario.";
            tipoAlertaComentario = "warning";
        } else {
            String comentarioTexto = request.getParameter("comentario");
            if (comentarioTexto == null || comentarioTexto.trim().isEmpty()) {
                mensajeComentario = "Por favor escribe un comentario antes de enviar.";
                tipoAlertaComentario = "warning";
            } else {
                Connection conCom = null;
                PreparedStatement psCom = null;
                try {
                    conCom = ConexionBD.obtenerConexion();
                    psCom = conCom.prepareStatement(
                        "INSERT INTO comentarios (id_contenido, id_usuario, comentario) VALUES (?, ?, ?)");
                    psCom.setInt(1, idContenido);
                    psCom.setInt(2, idUsuarioLogueado);
                    psCom.setString(3, comentarioTexto.trim());
                    psCom.executeUpdate();
                    mensajeComentario = "¡Comentario publicado con éxito!";
                    tipoAlertaComentario = "success";
                } catch (Exception e) {
                    mensajeComentario = "Error al publicar: " + e.getMessage();
                    tipoAlertaComentario = "danger";
                } finally {
                    if (psCom != null) psCom.close();
                    if (conCom != null) conCom.close();
                }
            }
        }
    }

    // ---- Procesar Guardar/Quitar Favorito ----
    if (request.getParameter("toggle_fav") != null && idUsuarioLogueado != null) {
        Connection conFav = null;
        PreparedStatement psFav = null;
        ResultSet rsFav = null;
        try {
            conFav = ConexionBD.obtenerConexion();
            psFav = conFav.prepareStatement(
                "SELECT id_favorito FROM favoritos WHERE id_usuario = ? AND tipo_item = 'contenido' AND id_item = ?");
            psFav.setInt(1, idUsuarioLogueado);
            psFav.setInt(2, idContenido);
            rsFav = psFav.executeQuery();
            if (rsFav.next()) {
                // Ya existe -> eliminar
                int idFav = rsFav.getInt("id_favorito");
                rsFav.close();
                psFav.close();
                psFav = conFav.prepareStatement("DELETE FROM favoritos WHERE id_favorito = ?");
                psFav.setInt(1, idFav);
                psFav.executeUpdate();
            } else {
                // No existe -> insertar
                rsFav.close();
                psFav.close();
                psFav = conFav.prepareStatement(
                    "INSERT INTO favoritos (id_usuario, tipo_item, id_item) VALUES (?, 'contenido', ?)");
                psFav.setInt(1, idUsuarioLogueado);
                psFav.setInt(2, idContenido);
                psFav.executeUpdate();
            }
            response.sendRedirect("articulo.jsp?id=" + idContenido);
            return;
        } catch (Exception ex) {
            // Ignorar
        } finally {
            if (rsFav != null) rsFav.close();
            if (psFav != null) psFav.close();
            if (conFav != null) conFav.close();
        }
    }
%>
<%@ include file="includes/header.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-3">
    <a href="articulos.jsp" class="text-decoration-none text-muted small">&larr; Volver al catálogo de Artículos</a>
    
    <%
        // Verificar si este artículo ya es favorito del usuario actual
        boolean esFavorito = false;
        if (idUsuarioLogueado != null) {
            Connection conFavCheck = null;
            PreparedStatement psFavCheck = null;
            ResultSet rsFavCheck = null;
            try {
                conFavCheck = ConexionBD.obtenerConexion();
                psFavCheck = conFavCheck.prepareStatement(
                    "SELECT 1 FROM favoritos WHERE id_usuario = ? AND tipo_item = 'contenido' AND id_item = ?");
                psFavCheck.setInt(1, idUsuarioLogueado);
                psFavCheck.setInt(2, idContenido);
                rsFavCheck = psFavCheck.executeQuery();
                if (rsFavCheck.next()) {
                    esFavorito = true;
                }
            } catch (Exception ex) {
                // ignore
            } finally {
                if (rsFavCheck != null) rsFavCheck.close();
                if (psFavCheck != null) psFavCheck.close();
                if (conFavCheck != null) conFavCheck.close();
            }
        }
    %>

    <% if (idUsuarioLogueado != null) { %>
        <a href="articulo.jsp?id=<%= idContenido %>&toggle_fav=1" class="btn btn-sm <%= esFavorito ? "btn-danger" : "btn-outline-danger" %> d-flex align-items-center gap-1">
            <i class="bi <%= esFavorito ? "bi-heart-fill" : "bi-heart" %>"></i>
            <span><%= esFavorito ? "Guardado en Favoritos" : "Guardar en Favoritos" %></span>
        </a>
    <% } else { %>
        <a href="login.jsp" class="btn btn-sm btn-outline-secondary" title="Inicia sesión para guardar en favoritos">
            <i class="bi bi-heart me-1"></i> Guardar
        </a>
    <% } %>
</div>

<div class="row mt-2 mb-5">
    <div class="col-lg-8">
<%
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        con = ConexionBD.obtenerConexion();
        ps = con.prepareStatement(
            "SELECT c.titulo, c.cuerpo, c.tiempo_lectura_min, c.fecha_publicacion, cat.nombre AS categoria " +
            "FROM contenidos c JOIN categorias cat ON c.id_categoria = cat.id_categoria " +
            "WHERE c.id_contenido = ?");
        ps.setInt(1, idContenido);
        rs = ps.executeQuery();
        if (rs.next()) {
%>
        <!-- ===================== ENCABEZADO DEL ARTICULO ===================== -->
        <div class="hero mb-4 fade-in">
            <span class="badge bg-primary-subtle text-primary mb-2"><%= Seguridad.escapeHtml(rs.getString("categoria")) %></span>
            <h1 class="h3 fw-bold mb-3"><%= Seguridad.escapeHtml(rs.getString("titulo")) %></h1>
            <p class="text-muted small mb-0 d-flex align-items-center gap-3">
                <span><i class="bi bi-calendar3"></i> <%= rs.getDate("fecha_publicacion") %></span>
                <span><i class="bi bi-clock"></i> <%= rs.getInt("tiempo_lectura_min") %> min de lectura</span>
            </p>
        </div>

        <!-- ===================== CUERPO DEL ARTICULO ===================== -->
        <article class="card glass-card p-4 p-md-5 mb-4 fade-in delay-1" style="font-size: 1.05rem; line-height: 1.8;">
<%
            String cuerpoCompleto = rs.getString("cuerpo");
            String[] parrafos = cuerpoCompleto.split("\\r?\\n\\s*\\r?\\n");
            for (String parrafo : parrafos) {
                String texto = parrafo.trim();
                if (texto.isEmpty()) continue;

                boolean pareceSubtitulo = texto.length() < 90 && !texto.endsWith(".");
                if (pareceSubtitulo) {
%>
            <h2 class="h5 text-primary fw-bold mt-4 mb-3"><%= Seguridad.escapeHtml(texto) %></h2>
<%
                } else {
%>
            <p class="mb-3"><%= Seguridad.escapeHtml(texto) %></p>
<%
                }
            }
%>
        </article>
<%
        } else {
%>
        <div class="alert alert-warning">No se encontró el artículo solicitado.</div>
<%
        }
    } catch (Exception e) {
%>
        <div class="alert alert-danger">Error al cargar contenido: <%= e.getMessage() %></div>
<%
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>

        <!-- ===================== SECCIÓN DE COMENTARIOS ===================== -->
        <div class="card glass-card p-4 mt-4 fade-in delay-2">
            <h3 class="h5 fw-bold mb-3 d-flex align-items-center gap-2">
                <i class="bi bi-chat-left-dots text-primary"></i> Discusión y Preguntas
            </h3>

            <% if (!mensajeComentario.isEmpty()) { %>
                <div class="alert alert-<%= tipoAlertaComentario %> py-2 small mb-3">
                    <%= mensajeComentario %>
                </div>
            <% } %>

            <!-- Formulario para comentar -->
            <% if (idUsuarioLogueado != null) { %>
                <form method="post" action="articulo.jsp?id=<%= idContenido %>" class="mb-4">
                    <div class="mb-2">
                        <textarea name="comentario" class="form-control" rows="3" placeholder="Escribe tu reflexión, duda o aporte sobre esta lectura..." required></textarea>
                    </div>
                    <button type="submit" name="publicar_comentario" value="1" class="btn btn-primary btn-sm btn-glow">
                        <i class="bi bi-send me-1"></i> Publicar comentario
                    </button>
                </form>
            <% } else { %>
                <div class="alert alert-light border py-3 small text-center mb-4">
                    ¿Quieres participar en la conversación? 
                    <a href="login.jsp" class="fw-bold text-primary text-decoration-none">Inicia sesión</a> o 
                    <a href="registro.jsp" class="fw-bold text-primary text-decoration-none">crea tu cuenta</a> para comentar.
                </div>
            <% } %>

            <!-- Lista de comentarios existentes -->
            <div class="comentarios-lista">
                <%
                    Connection conListCom = null;
                    PreparedStatement psListCom = null;
                    ResultSet rsListCom = null;
                    try {
                        conListCom = ConexionBD.obtenerConexion();
                        psListCom = conListCom.prepareStatement(
                            "SELECT c.comentario, c.fecha_comentario, u.nombre, u.rol " +
                            "FROM comentarios c JOIN usuarios u ON c.id_usuario = u.id_usuario " +
                            "WHERE c.id_contenido = ? ORDER BY c.fecha_comentario DESC");
                        psListCom.setInt(1, idContenido);
                        rsListCom = psListCom.executeQuery();
                        boolean hayComentarios = false;
                        while (rsListCom.next()) {
                            hayComentarios = true;
                            String autor = rsListCom.getString("nombre");
                            String rolAutor = rsListCom.getString("rol");
                            char inicial = autor.length() > 0 ? autor.charAt(0) : 'U';
                %>
                    <div class="comment-item">
                        <div class="d-flex align-items-center gap-2 mb-1">
                            <div class="comment-avatar"><%= inicial %></div>
                            <div>
                                <strong class="small"><%= Seguridad.escapeHtml(autor) %></strong>
                                <% if ("administrador".equals(rolAutor)) { %>
                                    <span class="badge bg-danger ms-1" style="font-size: 0.65rem;">ADMIN</span>
                                <% } %>
                                <span class="text-muted small ms-2"><i class="bi bi-clock"></i> <%= rsListCom.getTimestamp("fecha_comentario") %></span>
                            </div>
                        </div>
                        <p class="small text-muted mb-0 ps-5">
                            <%= Seguridad.escapeHtml(rsListCom.getString("comentario")) %>
                        </p>
                    </div>
                <%
                        }
                        if (!hayComentarios) {
                %>
                    <p class="text-muted small text-center py-3 mb-0">Sé el primero en compartir una reflexión o duda sobre este tema.</p>
                <%
                        }
                    } catch (Exception e) {
                %>
                    <p class="text-danger small">Error al cargar comentarios: <%= e.getMessage() %></p>
                <%
                    } finally {
                        if (rsListCom != null) rsListCom.close();
                        if (psListCom != null) psListCom.close();
                        if (conListCom != null) conListCom.close();
                    }
                %>
            </div>
        </div>
    </div>

    <!-- Barra lateral -->
    <div class="col-lg-4">
        <!-- Recursos Relacionados -->
        <div class="card glass-card p-3 mb-3 fade-in delay-2">
            <h2 class="h6 mb-3 fw-bold"><i class="bi bi-link-45deg text-primary"></i> Recursos relacionados</h2>
<%
    try {
        con = ConexionBD.obtenerConexion();
        ps = con.prepareStatement("SELECT titulo, tipo, url FROM recursos WHERE id_contenido = ?");
        ps.setInt(1, idContenido);
        rs = ps.executeQuery();
        boolean hayRecursos = false;
        while (rs.next()) {
            hayRecursos = true;
            String tituloRecurso = rs.getString("titulo");
            String tipoRecurso = rs.getString("tipo");
            String urlRecurso = rs.getString("url");

            String iconoTipo = "bi-link-45deg";
            String colorTipo = "secondary";
            if ("Video".equals(tipoRecurso))            { iconoTipo = "bi-play-circle-fill"; colorTipo = "danger"; }
            else if ("Guia".equals(tipoRecurso))         { iconoTipo = "bi-journal-text";     colorTipo = "primary"; }
            else if ("Herramienta".equals(tipoRecurso))  { iconoTipo = "bi-tools";             colorTipo = "success"; }
            else if ("Enlace".equals(tipoRecurso))       { iconoTipo = "bi-globe2";            colorTipo = "info"; }

            String dominio = "";
            try {
                dominio = new java.net.URL(urlRecurso).getHost();
            } catch (Exception ex) {
                dominio = "";
            }
%>
            <a href="<%= urlRecurso %>" target="_blank" class="recurso-item mb-2">
                <div class="recurso-miniatura bg-<%= colorTipo %>-subtle">
                    <% if (!dominio.isEmpty()) { %>
                        <img src="https://www.google.com/s2/favicons?sz=64&domain=<%= dominio %>"
                             alt="" class="recurso-favicon"
                             onerror="this.style.display='none'; this.nextElementSibling.style.display='inline-block';">
                    <% } %>
                    <i class="bi <%= iconoTipo %> text-<%= colorTipo %>" style="<%= !dominio.isEmpty() ? "display:none;" : "" %>"></i>
                </div>
                <div class="recurso-texto">
                    <span class="recurso-titulo"><%= Seguridad.escapeHtml(tituloRecurso) %></span>
                    <span class="badge bg-<%= colorTipo %>-subtle text-<%= colorTipo %>"><%= tipoRecurso %></span>
                </div>
            </a>
<%
        }
        if (!hayRecursos) {
%>
            <p class="text-muted small mb-0">No hay recursos externos asociados.</p>
<%
        }
    } catch (Exception e) {
%>
        <p class="text-danger small mb-0">Error al cargar recursos.</p>
<%
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>
        </div>

        <!-- Tip de Apoyo -->
        <div class="card glass-card p-3 mb-3 fade-in delay-3 border-start border-primary border-4">
            <h2 class="h6 fw-bold"><i class="bi bi-lightbulb text-primary"></i> Recomendación Pedagógica</h2>
            <p class="small text-muted mb-2">
                Recuerda que la IA generativa es una herramienta de apoyo y aumento cognitivo.
                Verifica siempre las fuentes críticas y respeta las políticas de integridad académica.
            </p>
            <a href="normatividad.jsp" class="small fw-semibold text-primary text-decoration-none">
                Ver políticas y normativas &rarr;
            </a>
        </div>

        <!-- Acceso Rápido a Prompt Builder -->
        <div class="card glass-card p-3 fade-in delay-4 border-start border-warning border-4">
            <h2 class="h6 fw-bold"><i class="bi bi-stars text-warning"></i> Ponlo en práctica</h2>
            <p class="small text-muted mb-2">
                Aplica los conceptos de esta lectura estructurando un prompt efectivo en nuestro generador.
            </p>
            <a href="prompt-builder.jsp" class="btn btn-sm btn-outline-warning w-100">
                Ir al Prompt Builder
            </a>
        </div>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>
