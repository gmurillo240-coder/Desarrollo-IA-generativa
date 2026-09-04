<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="conexion.ConexionBD" %>
<%@ page import="utilidades.Iconos" %>
<%@ page import="utilidades.Seguridad" %>
<%@ include file="includes/header.jsp" %>

<%
    String nivelSeleccionado = request.getParameter("nivel");
    if (nivelSeleccionado == null) nivelSeleccionado = "Todos";

    String busqueda = request.getParameter("q");
    if (busqueda == null) busqueda = "";

    Integer idUsuarioLogueado = (Integer) session.getAttribute("idUsuario");

    // ---- Procesar Guardar/Quitar Favorito de un Tip ----
    String toggleFavTipStr = request.getParameter("toggle_fav_tip");
    if (toggleFavTipStr != null && idUsuarioLogueado != null) {
        try {
            int idTipFav = Integer.parseInt(toggleFavTipStr);
            Connection conFav = ConexionBD.obtenerConexion();
            PreparedStatement psFav = conFav.prepareStatement(
                "SELECT id_favorito FROM favoritos WHERE id_usuario = ? AND tipo_item = 'tip' AND id_item = ?");
            psFav.setInt(1, idUsuarioLogueado);
            psFav.setInt(2, idTipFav);
            ResultSet rsFav = psFav.executeQuery();
            if (rsFav.next()) {
                int idFav = rsFav.getInt("id_favorito");
                rsFav.close();
                psFav.close();
                psFav = conFav.prepareStatement("DELETE FROM favoritos WHERE id_favorito = ?");
                psFav.setInt(1, idFav);
                psFav.executeUpdate();
            } else {
                rsFav.close();
                psFav.close();
                psFav = conFav.prepareStatement(
                    "INSERT INTO favoritos (id_usuario, tipo_item, id_item) VALUES (?, 'tip', ?)");
                psFav.setInt(1, idUsuarioLogueado);
                psFav.setInt(2, idTipFav);
                psFav.executeUpdate();
            }
            conFav.close();
            response.sendRedirect("tips.jsp?nivel=" + java.net.URLEncoder.encode(nivelSeleccionado, "UTF-8") + "&q=" + java.net.URLEncoder.encode(busqueda, "UTF-8"));
            return;
        } catch (Exception ex) {
            // Ignorar
        }
    }

    // Obtener lista de IDs de tips favoritos del usuario para pintar el corazón activo
    java.util.Set<Integer> tipsFavoritosIds = new java.util.HashSet<>();
    if (idUsuarioLogueado != null) {
        Connection conFavs = null;
        PreparedStatement psFavs = null;
        ResultSet rsFavs = null;
        try {
            conFavs = ConexionBD.obtenerConexion();
            psFavs = conFavs.prepareStatement(
                "SELECT id_item FROM favoritos WHERE id_usuario = ? AND tipo_item = 'tip'");
            psFavs.setInt(1, idUsuarioLogueado);
            rsFavs = psFavs.executeQuery();
            while (rsFavs.next()) {
                tipsFavoritosIds.add(rsFavs.getInt("id_item"));
            }
        } catch (Exception ex) {
            // ignore
        } finally {
            if (rsFavs != null) rsFavs.close();
            if (psFavs != null) psFavs.close();
            if (conFavs != null) conFavs.close();
        }
    }
%>

<!-- ===================== ENCABEZADO ===================== -->
<div class="hero mb-4 fade-in">
    <div class="row align-items-center">
        <div class="col-md-8">
            <span class="hero-badge">
                <i class="bi bi-lightbulb text-primary"></i> Biblioteca de Microaprendizaje
            </span>
            <h1 class="h3 fw-bold mb-1">Tips y Consejos Prácticos</h1>
            <p class="text-muted mb-0">
                Mejora tu fluidez y resultados con IA paso a paso, desde nivel principiante hasta avanzado.
            </p>
        </div>
        <div class="col-md-4 text-center mt-3 mt-md-0">
            <!-- Ilustración de progreso -->
            <svg viewBox="0 0 220 140" xmlns="http://www.w3.org/2000/svg" style="max-width: 190px; width: 100%;">
                <rect x="20"  y="80"  width="40" height="45" rx="8" fill="#86efac" opacity="0.9"/>
                <rect x="90"  y="50"  width="40" height="75" rx="8" fill="#fde68a" opacity="0.9"/>
                <rect x="160" y="20"  width="40" height="105" rx="8" fill="#fca5a5" opacity="0.9"/>
                <circle cx="40"  cy="70"  r="9" fill="#16a34a"/>
                <circle cx="110" cy="40"  r="9" fill="#d97706"/>
                <circle cx="180" cy="10"  r="9" fill="#dc2626"/>
                <path d="M40 70 L110 40 L180 10" stroke="#7c3aed" stroke-width="3" fill="none" stroke-dasharray="4 4"/>
            </svg>
        </div>
    </div>
</div>

<!-- ===================== BUSCADOR ===================== -->
<form method="get" action="tips.jsp" class="mb-3 fade-in" id="formBusqueda">
    <input type="hidden" name="nivel" value="<%= Seguridad.escapeHtml(nivelSeleccionado) %>">
    <div class="input-group input-group-lg shadow-sm">
        <span class="input-group-text bg-body-tertiary border-end-0"><i class="bi bi-search text-primary"></i></span>
        <input type="text" name="q" value="<%= Seguridad.escapeHtml(busqueda) %>" class="form-control border-start-0"
               id="campoBusqueda" autocomplete="off"
               placeholder="Buscar tip, por ejemplo: prompts, privacidad, sesgo, plantillas...">
        <button type="submit" class="btn btn-primary px-4 btn-glow">Buscar</button>
    </div>
    <p class="small text-muted mt-1 mb-0">
        <i class="bi bi-lightning-charge text-primary"></i> Escribe para filtrar en tiempo real en la pantalla.
    </p>
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
           href="tips.jsp?nivel=<%= n %>&q=<%= Seguridad.escapeHtml(busqueda) %>"><%= n %></a>
    </li>
    <% } %>
</ul>

<div class="row g-3" id="listaTips">
<%
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        con = ConexionBD.obtenerConexion();
        String sql = "SELECT id_tip, titulo, descripcion, nivel, tiempo_min FROM tips WHERE 1 = 1";
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
            int idTip = rs.getInt("id_tip");
            String claseDelay = "delay-" + (((i - 1) % 4) + 1);
            String titulo = rs.getString("titulo");
            String nivel = rs.getString("nivel");
            String colorNivel = Iconos.obtenerColorNivel(nivel);
            String icono = Iconos.obtenerIconoTip(titulo);
            boolean esFav = tipsFavoritosIds.contains(idTip);
%>
    <div class="col-md-6 fade-in <%= claseDelay %> tip-item">
        <div class="tip-card border-<%= colorNivel %> glass-card">
            <div class="d-flex align-items-start gap-3">
                <div class="tip-icono bg-<%= colorNivel %>-subtle text-<%= colorNivel %>">
                    <i class="bi <%= icono %>"></i>
                </div>
                <div class="flex-grow-1">
                    <div class="d-flex justify-content-between align-items-start gap-2 mb-1">
                        <h3 class="h6 mb-0 fw-bold tip-titulo"><%= Seguridad.escapeHtml(titulo) %></h3>
                        <div class="d-flex align-items-center gap-1 flex-shrink-0">
                            <span class="badge bg-<%= colorNivel %>"><%= nivel %></span>
                            <% if (idUsuarioLogueado != null) { %>
                                <a href="tips.jsp?toggle_fav_tip=<%= idTip %>&nivel=<%= Seguridad.escapeHtml(nivelSeleccionado) %>&q=<%= Seguridad.escapeHtml(busqueda) %>" 
                                   class="btn-fav <%= esFav ? "active" : "" %>" 
                                   title="<%= esFav ? "Quitar de favoritos" : "Guardar en favoritos" %>">
                                    <i class="bi <%= esFav ? "bi-heart-fill" : "bi-heart" %>"></i>
                                </a>
                            <% } %>
                        </div>
                    </div>
                    <p class="small text-muted mb-2 tip-descripcion"><%= Seguridad.escapeHtml(rs.getString("descripcion")) %></p>
                    <div class="d-flex justify-content-between align-items-center small text-muted">
                        <span><i class="bi bi-clock"></i> <%= rs.getInt("tiempo_min") %> min de lectura</span>
                        <a href="prompt-builder.jsp" class="text-primary text-decoration-none small">
                            Probar en Prompt Builder &rarr;
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
<%
        }
        if (!hayResultados) {
%>
    <div class="col-12">
        <div class="alert alert-light border text-center py-5">
            <i class="bi bi-emoji-smile fs-2 text-muted d-block mb-2"></i>
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

<!-- Mensaje de "sin resultados" para el filtrado en vivo (JS) -->
<div class="col-12" id="sinResultadosJS" style="display:none;">
    <div class="alert alert-light border text-center py-4">
        No encontramos tips que coincidan con "<strong id="textoBuscadoJS"></strong>".
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function () {
    var campo = document.getElementById('campoBusqueda');
    var items = document.querySelectorAll('#listaTips .tip-item');
    var mensajeSinResultados = document.getElementById('sinResultadosJS');
    var textoBuscado = document.getElementById('textoBuscadoJS');

    if (!campo) return;

    campo.addEventListener('input', function () {
        var texto = campo.value.trim().toLowerCase();
        var visibles = 0;

        items.forEach(function (item) {
            var titulo = item.querySelector('.tip-titulo').textContent.toLowerCase();
            var descripcion = item.querySelector('.tip-descripcion').textContent.toLowerCase();
            var coincide = titulo.indexOf(texto) !== -1 || descripcion.indexOf(texto) !== -1;

            item.style.display = coincide ? '' : 'none';
            if (coincide) visibles++;
        });

        if (mensajeSinResultados) {
            mensajeSinResultados.style.display = (visibles === 0 && texto !== '') ? '' : 'none';
            if (textoBuscado) textoBuscado.textContent = campo.value.trim();
        }
    });
});
</script>

<%@ include file="includes/footer.jsp" %>
