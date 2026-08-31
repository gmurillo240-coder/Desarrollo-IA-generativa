<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="conexion.ConexionBD" %>
<%@ include file="includes/header.jsp" %>

<%
    // El id del articulo llega por la URL, ej: articulo.jsp?id=1
    int idContenido;
    try {
        idContenido = Integer.parseInt(request.getParameter("id"));
    } catch (Exception e) {
        idContenido = 1; // valor por defecto si no llega el parametro
    }
%>

<a href="index.jsp" class="text-decoration-none fade-in d-inline-block mb-2">&larr; Volver a Aprender</a>

<div class="row mt-2">
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
            <span class="badge bg-primary-subtle text-primary mb-2"><%= rs.getString("categoria") %></span>
            <h1 class="h3 fw-bold"><%= rs.getString("titulo") %></h1>
            <p class="text-muted small mb-0">
                <i class="bi bi-calendar3"></i> Publicado el <%= rs.getDate("fecha_publicacion") %>
                &nbsp;&middot;&nbsp;
                <i class="bi bi-clock"></i> <%= rs.getInt("tiempo_lectura_min") %> min de lectura
            </p>
        </div>

        <!-- ===================== CUERPO DEL ARTICULO ===================== -->
        <article class="fade-in delay-1">
<%
            // Dividimos el texto en parrafos (separados por linea en blanco).
            // Si un "parrafo" es corto y no termina en punto, lo tratamos como
            // un subtitulo dentro del articulo.
            String cuerpoCompleto = rs.getString("cuerpo");
            String[] parrafos = cuerpoCompleto.split("\\r?\\n\\s*\\r?\\n");
            for (String parrafo : parrafos) {
                String texto = parrafo.trim();
                if (texto.isEmpty()) continue;

                boolean pareceSubtitulo = texto.length() < 90 && !texto.endsWith(".");
                if (pareceSubtitulo) {
%>
            <h2 class="h5 text-primary mt-4 mb-2"><%= texto %></h2>
<%
                } else {
%>
            <p><%= texto %></p>
<%
                }
            }
%>
        </article>
<%
        } else {
%>
        <div class="alert alert-warning">No se encontró el contenido solicitado.</div>
<%
        }
    } catch (Exception e) {
%>
        <div class="alert alert-danger">Error: <%= e.getMessage() %></div>
<%
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>
    </div>

    <div class="col-lg-4">
        <!-- ===================== RECURSOS RELACIONADOS ===================== -->
        <div class="card p-3 mb-3 fade-in delay-2">
            <h2 class="h6 mb-3"><i class="bi bi-link-45deg text-primary"></i> Recursos relacionados</h2>
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

            // Elegimos un icono y un color segun el tipo de recurso
            String iconoTipo = "bi-link-45deg";
            String colorTipo = "secondary";
            if ("Video".equals(tipoRecurso))            { iconoTipo = "bi-play-circle-fill"; colorTipo = "danger"; }
            else if ("Guia".equals(tipoRecurso))         { iconoTipo = "bi-journal-text";     colorTipo = "primary"; }
            else if ("Herramienta".equals(tipoRecurso))  { iconoTipo = "bi-tools";             colorTipo = "success"; }
            else if ("Enlace".equals(tipoRecurso))       { iconoTipo = "bi-globe2";            colorTipo = "info"; }

            // Sacamos el dominio de la URL para mostrar su favicon como miniatura
            String dominio = "";
            try {
                dominio = new java.net.URL(urlRecurso).getHost();
            } catch (Exception ex) {
                dominio = "";
            }
%>
            <a href="<%= urlRecurso %>" target="_blank" class="recurso-item">
                <div class="recurso-miniatura bg-<%= colorTipo %>-subtle">
                    <% if (!dominio.isEmpty()) { %>
                        <img src="https://www.google.com/s2/favicons?sz=64&domain=<%= dominio %>"
                             alt="" class="recurso-favicon"
                             onerror="this.style.display='none'; this.nextElementSibling.style.display='inline-block';">
                    <% } %>
                    <i class="bi <%= iconoTipo %> text-<%= colorTipo %>" style="<%= !dominio.isEmpty() ? "display:none;" : "" %>"></i>
                </div>
                <div class="recurso-texto">
                    <span class="recurso-titulo"><%= tituloRecurso %></span>
                    <span class="badge bg-<%= colorTipo %>-subtle text-<%= colorTipo %>"><%= tipoRecurso %></span>
                </div>
            </a>
<%
        }
        if (!hayRecursos) {
%>
            <p class="text-muted small mb-0">No hay recursos relacionados aún.</p>
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

        <!-- ===================== TIP DE APOYO ===================== -->
        <div class="card p-3 fade-in delay-3 bg-primary-subtle border-0">
            <h2 class="h6"><i class="bi bi-lightbulb text-primary"></i> Recuerda</h2>
            <p class="small text-muted mb-0">
                La IA generativa es una herramienta de apoyo. Verifica siempre la información
                importante antes de usarla, y consulta la sección de
                <a href="normatividad.jsp">Normatividad</a> para conocer las buenas prácticas.
            </p>
        </div>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>
