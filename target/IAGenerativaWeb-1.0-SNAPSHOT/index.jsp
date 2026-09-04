<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="conexion.ConexionBD" %>
<%@ page import="utilidades.Iconos" %>
<%@ page import="utilidades.Seguridad" %>
<%@ include file="includes/header.jsp" %>

<!-- ===================== HERO ===================== -->
<div class="hero mb-5">
    <div class="row align-items-center">
        <div class="col-lg-6 text-center text-lg-start fade-in">
            <span class="hero-badge">
                <i class="bi bi-cpu text-primary"></i> Portal Académico e Interactivo &bull; 2026
            </span>
            <h1 class="display-5 fw-bold mb-3">
                Aprende, crea y domina la <span class="text-primary">IA Generativa</span>
            </h1>
            <p class="lead text-muted mb-4">
                Domina la ingeniería de prompts, comprende las normativas éticas y aprovecha
                el potencial de los modelos de inteligencia artificial con nuestras herramientas interactivas.
            </p>
            <div class="d-flex flex-wrap gap-2 justify-content-center justify-content-lg-start">
                <a href="prompt-builder.jsp" class="btn btn-primary btn-lg btn-glow">
                    <i class="bi bi-stars me-1"></i> Generador de Prompts
                </a>
                <a href="quiz.jsp" class="btn btn-outline-primary btn-lg">
                    <i class="bi bi-trophy me-1"></i> Pon a prueba tus conocimientos
                </a>
                <a href="articulos.jsp" class="btn btn-outline-secondary btn-lg">
                    <i class="bi bi-book me-1"></i> Artículos
                </a>
            </div>
        </div>
        <div class="col-lg-6 text-center mt-4 mt-lg-0 fade-in delay-2">
            <!-- Ilustración SVG interactiva y flotante -->
            <svg class="hero-ilustracion" viewBox="0 0 500 400" xmlns="http://www.w3.org/2000/svg" style="max-width: 400px; width: 100%;">
                <defs>
                    <linearGradient id="circGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                        <stop offset="0%" stop-color="#7c3aed" stop-opacity="0.2"/>
                        <stop offset="100%" stop-color="#6366f1" stop-opacity="0.05"/>
                    </linearGradient>
                    <linearGradient id="robotGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                        <stop offset="0%" stop-color="#ffffff"/>
                        <stop offset="100%" stop-color="#f5f3ff"/>
                    </linearGradient>
                </defs>
                <circle cx="250" cy="200" r="170" fill="url(#circGrad)"/>
                <!-- Líneas neuronales -->
                <g stroke="#a78bfa" stroke-width="2" stroke-dasharray="6,4" fill="none" opacity="0.7">
                    <line x1="120" y1="120" x2="250" y2="200"/>
                    <line x1="380" y1="110" x2="250" y2="200"/>
                    <line x1="100" y1="260" x2="250" y2="200"/>
                    <line x1="390" y1="270" x2="250" y2="200"/>
                    <line x1="250" y1="80" x2="250" y2="200"/>
                    <line x1="250" y1="320" x2="250" y2="200"/>
                </g>
                <!-- Nodos con destellos -->
                <circle cx="120" cy="120" r="10" fill="#7c3aed"/>
                <circle cx="380" cy="110" r="8" fill="#6366f1"/>
                <circle cx="100" cy="260" r="8" fill="#8b5cf6"/>
                <circle cx="390" cy="270" r="10" fill="#a855f7"/>
                <circle cx="250" cy="80" r="7" fill="#06b6d4"/>
                <circle cx="250" cy="320" r="7" fill="#10b981"/>
                <!-- Robot central futurista -->
                <rect x="185" y="150" width="130" height="100" rx="22" fill="url(#robotGrad)" stroke="#7c3aed" stroke-width="4"/>
                <circle cx="222" cy="195" r="12" fill="#7c3aed"/>
                <circle cx="278" cy="195" r="12" fill="#7c3aed"/>
                <circle cx="225" cy="192" r="4" fill="#ffffff"/>
                <circle cx="281" cy="192" r="4" fill="#ffffff"/>
                <rect x="215" y="222" width="70" height="8" rx="4" fill="#6366f1"/>
                <!-- Antena con señal de pulso -->
                <rect x="243" y="120" width="14" height="32" rx="7" fill="#7c3aed"/>
                <circle cx="250" cy="112" r="11" fill="#ec4899"/>
                <circle cx="250" cy="112" r="5" fill="#ffffff"/>
            </svg>
        </div>
    </div>
</div>

<!-- ===================== TIP DESTACADO ===================== -->
<div class="mb-5 fade-in delay-1">
<%
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        con = ConexionBD.obtenerConexion();
        ps = con.prepareStatement(
            "SELECT id_tip, titulo, descripcion, nivel, tiempo_min FROM tips ORDER BY RAND() LIMIT 1");
        rs = ps.executeQuery();
        if (rs.next()) {
            int idTipDest = rs.getInt("id_tip");
            String tituloTip = rs.getString("titulo");
            String nivelTip = rs.getString("nivel");
            String colorNivel = Iconos.obtenerColorNivel(nivelTip);
            String iconoTip = Iconos.obtenerIconoTip(tituloTip);
%>
    <div class="tip-destacado">
        <div class="d-flex align-items-start gap-3 flex-wrap flex-md-nowrap">
            <div class="tip-icono bg-<%= colorNivel %>-subtle text-<%= colorNivel %>" style="width:56px; height:56px; font-size:1.6rem;">
                <i class="bi <%= iconoTip %>"></i>
            </div>
            <div class="flex-grow-1">
                <div class="d-flex justify-content-between align-items-center mb-1">
                    <span class="badge bg-primary-subtle text-primary fw-semibold text-uppercase">
                        <i class="bi bi-stars"></i> Consejo del momento
                    </span>
                    <span class="small text-muted"><i class="bi bi-clock"></i> <%= rs.getInt("tiempo_min") %> min de práctica</span>
                </div>
                <h2 class="h5 mt-1 mb-2 fw-bold"><%= Seguridad.escapeHtml(tituloTip) %></h2>
                <p class="text-muted mb-3"><%= Seguridad.escapeHtml(rs.getString("descripcion")) %></p>
                <div class="d-flex align-items-center gap-2">
                    <span class="badge bg-<%= colorNivel %>"><%= nivelTip %></span>
                    <a href="tips.jsp" class="btn btn-sm btn-outline-primary ms-2">Ver más tips en biblioteca</a>
                </div>
            </div>
        </div>
    </div>
<%
        }
    } catch (Exception e) {
        // En caso de fallo silencioso de conexión
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>
</div>

<!-- ===================== HERRAMIENTAS DESTACADAS ===================== -->
<div class="mb-5 fade-in delay-2">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h2 class="h4 mb-0 fw-bold">Herramientas de Aprendizaje</h2>
            <p class="text-muted small mb-0">Experimenta de forma práctica con nuestras aplicaciones guiadas.</p>
        </div>
    </div>
    <div class="row g-3">
        <div class="col-md-6">
            <div class="card glass-card h-100 p-4 border-start border-primary border-4">
                <div class="d-flex align-items-start gap-3">
                    <div class="avatar-tech flex-shrink-0">
                        <i class="bi bi-sliders text-primary fs-3"></i>
                    </div>
                    <div>
                        <span class="badge bg-primary-subtle text-primary mb-2">Herramienta Interactiva</span>
                        <h3 class="h5 fw-bold mb-2">Generador de Prompts (Prompt Builder)</h3>
                        <p class="text-muted small mb-3">
                            Aprende a formular indicaciones efectivas mediante una estructura profesional:
                            Rol, Tarea, Contexto, Formato y Restricciones. ¡Copia o prueba tus prompts en vivo!
                        </p>
                        <a href="prompt-builder.jsp" class="btn btn-sm btn-primary btn-glow">
                            Abrir Generador <i class="bi bi-arrow-right ms-1"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card glass-card h-100 p-4 border-start border-warning border-4">
                <div class="d-flex align-items-start gap-3">
                    <div class="avatar-tech flex-shrink-0" style="background: rgba(234, 179, 8, 0.15); border-color: rgba(234, 179, 8, 0.3);">
                        <i class="bi bi-trophy text-warning fs-3"></i>
                    </div>
                    <div>
                        <span class="badge bg-warning-subtle text-warning-emphasis mb-2">Evaluación Gamificada</span>
                        <h3 class="h5 fw-bold mb-2">Quiz de IA & Ética Digital</h3>
                        <p class="text-muted small mb-3">
                            ¿Sabes cómo evitar alucinaciones, proteger datos sensibles o respetar derechos de autor?
                            Pon a prueba tus conocimientos con retroalimentación inmediata.
                        </p>
                        <a href="quiz.jsp" class="btn btn-sm btn-outline-warning">
                            Comenzar Cuestionario <i class="bi bi-arrow-right ms-1"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- ===================== CATEGORIAS ===================== -->
<div class="d-flex justify-content-between align-items-center mb-3 fade-in">
    <div>
        <h2 id="categorias" class="h4 mb-0 fw-bold">Explora por categorías</h2>
        <p class="text-muted small mb-0">Toca una categoría para filtrar los contenidos relacionados.</p>
    </div>
    <a href="articulos.jsp" class="btn btn-sm btn-outline-primary">
        Ver todos los artículos <i class="bi bi-arrow-right"></i>
    </a>
</div>

<div class="row g-3 mb-5">
<%
    String[] acentos = {"accent-1", "accent-2", "accent-3", "accent-4"};
    Integer categoriaSeleccionada = null;
    try {
        categoriaSeleccionada = Integer.parseInt(request.getParameter("categoria"));
    } catch (Exception e) {
        categoriaSeleccionada = null;
    }

    try {
        con = ConexionBD.obtenerConexion();
        ps = con.prepareStatement("SELECT id_categoria, nombre, descripcion, icono FROM categorias");
        rs = ps.executeQuery();
        int i = 0;
        while (rs.next()) {
            int idCat = rs.getInt("id_categoria");
            String claseDelay = "delay-" + ((i % 4) + 1);
            String claseAcento = acentos[i % acentos.length];
            boolean activa = (categoriaSeleccionada != null && categoriaSeleccionada == idCat);
            i++;
%>
    <div class="col-md-3 col-6 fade-in <%= claseDelay %>">
        <a href="index.jsp?categoria=<%= idCat %>#categorias" class="text-decoration-none text-reset d-block h-100">
            <div class="feature-card <%= claseAcento %> feature-clicable <%= activa ? "feature-activa" : "" %>">
                <div class="feature-icon"><i class="bi bi-<%= rs.getString("icono") %>"></i></div>
                <h3 class="h6 mb-1 fw-bold"><%= Seguridad.escapeHtml(rs.getString("nombre")) %></h3>
                <p class="small text-muted mb-0"><%= Seguridad.escapeHtml(rs.getString("descripcion")) %></p>
            </div>
        </a>
    </div>
<%
        }
    } catch (Exception e) {
%>
    <div class="col-12"><div class="alert alert-danger">Error al cargar categorías: <%= e.getMessage() %></div></div>
<%
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>
</div>

<!-- ===================== CONTENIDOS / ARTÍCULOS ===================== -->
<div id="resultados" class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-3 fade-in">
<%
    String nombreCategoriaActiva = null;
    if (categoriaSeleccionada != null) {
        try {
            con = ConexionBD.obtenerConexion();
            ps = con.prepareStatement("SELECT nombre FROM categorias WHERE id_categoria = ?");
            ps.setInt(1, categoriaSeleccionada);
            rs = ps.executeQuery();
            if (rs.next()) nombreCategoriaActiva = rs.getString("nombre");
        } catch (Exception e) {
            nombreCategoriaActiva = null;
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        }
    }

    if (nombreCategoriaActiva != null) {
%>
    <h2 class="h4 mb-0 fw-bold">Artículos de "<%= Seguridad.escapeHtml(nombreCategoriaActiva) %>"</h2>
    <a href="index.jsp#categorias" class="btn btn-sm btn-outline-secondary">
        <i class="bi bi-x-lg"></i> Quitar filtro
    </a>
<%
    } else {
%>
    <h2 class="h4 mb-0 fw-bold">Artículos Recientes</h2>
<%
    }
%>
</div>

<div class="row g-3 mb-5">
<%
    try {
        con = ConexionBD.obtenerConexion();
        if (categoriaSeleccionada != null) {
            ps = con.prepareStatement(
                "SELECT id_contenido, titulo, resumen, tiempo_lectura_min " +
                "FROM contenidos WHERE id_categoria = ? ORDER BY fecha_publicacion DESC");
            ps.setInt(1, categoriaSeleccionada);
        } else {
            ps = con.prepareStatement(
                "SELECT id_contenido, titulo, resumen, tiempo_lectura_min " +
                "FROM contenidos ORDER BY fecha_publicacion DESC LIMIT 6");
        }
        rs = ps.executeQuery();
        int i = 0;
        boolean hayContenidos = false;
        while (rs.next()) {
            hayContenidos = true;
            i++;
            String claseDelay = "delay-" + (((i - 1) % 4) + 1);
%>
    <div class="col-md-4 fade-in <%= claseDelay %>">
        <div class="card glass-card h-100">
            <div class="card-body d-flex flex-column p-4">
                <h3 class="h6 fw-bold mb-2"><%= Seguridad.escapeHtml(rs.getString("titulo")) %></h3>
                <p class="small text-muted flex-grow-1"><%= Seguridad.escapeHtml(rs.getString("resumen")) %></p>
                <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
                    <span class="small text-muted"><i class="bi bi-clock"></i> <%= rs.getInt("tiempo_lectura_min") %> min</span>
                    <a href="articulo.jsp?id=<%= rs.getInt("id_contenido") %>" class="btn btn-sm btn-outline-primary">
                        Leer artículo <i class="bi bi-arrow-right"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
<%
        }
        if (!hayContenidos) {
%>
    <div class="col-12">
        <div class="alert alert-light border text-center py-4">
            <i class="bi bi-folder-x fs-3 text-muted d-block mb-2"></i>
            No se encontraron artículos en esta categoría.
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
