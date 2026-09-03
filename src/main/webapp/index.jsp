<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="conexion.ConexionBD" %>
<%@ page import="utilidades.Iconos" %>
<%@ include file="includes/header.jsp" %>

<!-- ===================== HERO ===================== -->
<div class="hero mb-5">
    <div class="row align-items-center">
        <div class="col-lg-6 text-center text-lg-start fade-in">
            <h1 class="display-5 fw-bold">Aprende, crea y crece con <span class="text-primary">IA Generativa</span></h1>
            <p class="lead text-muted">
                Explora contenidos, consejos y normativas para usar la inteligencia artificial
                de forma responsable y creativa.
            </p>
            <a href="tips.jsp" class="btn btn-primary btn-lg mt-2">Comenzar a aprender <i class="bi bi-arrow-right"></i></a>
        </div>
        <div class="col-lg-6 text-center mt-4 mt-lg-0 fade-in delay-2">
            <!-- Ilustracion SVG generada en codigo, sin depender de imagenes externas -->
            <svg class="hero-ilustracion" viewBox="0 0 500 400" xmlns="http://www.w3.org/2000/svg" style="max-width: 380px; width: 100%;">
                <circle cx="250" cy="200" r="170" fill="#ede9fe"/>
                <!-- lineas de conexion tipo red neuronal -->
                <g stroke="#c4b5fd" stroke-width="2" fill="none">
                    <line x1="120" y1="120" x2="250" y2="200"/>
                    <line x1="380" y1="110" x2="250" y2="200"/>
                    <line x1="100" y1="260" x2="250" y2="200"/>
                    <line x1="390" y1="270" x2="250" y2="200"/>
                    <line x1="250" y1="80" x2="250" y2="200"/>
                    <line x1="250" y1="320" x2="250" y2="200"/>
                </g>
                <!-- nodos -->
                <circle cx="120" cy="120" r="10" fill="#a78bfa"/>
                <circle cx="380" cy="110" r="8" fill="#a78bfa"/>
                <circle cx="100" cy="260" r="8" fill="#a78bfa"/>
                <circle cx="390" cy="270" r="10" fill="#a78bfa"/>
                <circle cx="250" cy="80" r="7" fill="#a78bfa"/>
                <circle cx="250" cy="320" r="7" fill="#a78bfa"/>
                <!-- robot central -->
                <rect x="185" y="150" width="130" height="100" rx="20" fill="#ffffff" stroke="#7c3aed" stroke-width="4"/>
                <circle cx="222" cy="195" r="10" fill="#7c3aed"/>
                <circle cx="278" cy="195" r="10" fill="#7c3aed"/>
                <rect x="215" y="220" width="70" height="8" rx="4" fill="#7c3aed"/>
                <rect x="242" y="120" width="16" height="35" rx="8" fill="#7c3aed"/>
                <circle cx="250" cy="112" r="10" fill="#7c3aed"/>
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
            "SELECT titulo, descripcion, nivel, tiempo_min FROM tips ORDER BY RAND() LIMIT 1");
        rs = ps.executeQuery();
        if (rs.next()) {
            String tituloTip = rs.getString("titulo");
            String nivelTip = rs.getString("nivel");
            String colorNivel = Iconos.obtenerColorNivel(nivelTip);
            String iconoTip = Iconos.obtenerIconoTip(tituloTip);
%>
    <div class="tip-destacado">
        <div class="d-flex align-items-start gap-3">
            <div class="tip-icono bg-<%= colorNivel %>-subtle text-<%= colorNivel %>" style="width:52px; height:52px; font-size:1.5rem;">
                <i class="bi <%= iconoTip %>"></i>
            </div>
            <div class="flex-grow-1">
                <span class="small text-primary fw-semibold text-uppercase">
                    <i class="bi bi-stars"></i> Tip destacado
                </span>
                <h2 class="h5 mt-1 mb-1"><%= tituloTip %></h2>
                <p class="text-muted mb-2"><%= rs.getString("descripcion") %></p>
                <span class="badge bg-<%= colorNivel %> me-2"><%= nivelTip %></span>
                <span class="small text-muted"><i class="bi bi-clock"></i> <%= rs.getInt("tiempo_min") %> min</span>
                <a href="tips.jsp" class="btn btn-sm btn-outline-primary ms-3">Ver más tips</a>
            </div>
        </div>
    </div>
<%
        }
    } catch (Exception e) {
        // Si falla, simplemente no se muestra el tip destacado
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>
</div>

<!-- ===================== POR QUE APRENDER ===================== -->
<h2 class="h4 mb-3 fade-in">¿Por qué aprender sobre IA generativa?</h2>
<p class="text-muted small fade-in mb-3">Toca una tarjeta para ver más detalles.</p>
<div class="row g-3 mb-5">
    <div class="col-md-3 col-6 fade-in delay-1">
        <div class="feature-card accent-1 feature-clicable" data-bs-toggle="collapse" data-bs-target="#detalle1" role="button" aria-expanded="false">
            <div class="d-flex justify-content-between align-items-start">
                <div class="feature-icon"><i class="bi bi-rocket-takeoff"></i></div>
                <i class="bi bi-chevron-down feature-chevron"></i>
            </div>
            <h3 class="h6 mb-1">Aprovecha su potencial</h3>
            <p class="small text-muted mb-0">Descubre para qué sirve realmente y cómo puede ayudarte en tu día a día.</p>
            <div class="collapse" id="detalle1">
                <p class="small text-muted mb-0 pt-2 mt-2 border-top">
                    Desde redactar un correo o resumir un texto largo, hasta organizar ideas para
                    un proyecto: la IA generativa puede ahorrarte tiempo en tareas cotidianas que
                    antes tomaban mucho más esfuerzo.
                </p>
            </div>
        </div>
    </div>
    <div class="col-md-3 col-6 fade-in delay-2">
        <div class="feature-card accent-2 feature-clicable" data-bs-toggle="collapse" data-bs-target="#detalle2" role="button" aria-expanded="false">
            <div class="d-flex justify-content-between align-items-start">
                <div class="feature-icon"><i class="bi bi-shield-check"></i></div>
                <i class="bi bi-chevron-down feature-chevron"></i>
            </div>
            <h3 class="h6 mb-1">Úsala de forma segura</h3>
            <p class="small text-muted mb-0">Conoce los límites éticos y legales antes de usarla en tus proyectos.</p>
            <div class="collapse" id="detalle2">
                <p class="small text-muted mb-0 pt-2 mt-2 border-top">
                    Antes de usar IA en el trabajo o la escuela, revisa la sección de
                    <a href="normatividad.jsp">Normatividad</a>: ahí verás qué hacer y qué evitar
                    en temas de privacidad, derechos de autor y transparencia.
                </p>
            </div>
        </div>
    </div>
    <div class="col-md-3 col-6 fade-in delay-3">
        <div class="feature-card accent-3 feature-clicable" data-bs-toggle="collapse" data-bs-target="#detalle3" role="button" aria-expanded="false">
            <div class="d-flex justify-content-between align-items-start">
                <div class="feature-icon"><i class="bi bi-lightbulb"></i></div>
                <i class="bi bi-chevron-down feature-chevron"></i>
            </div>
            <h3 class="h6 mb-1">Mejora tus resultados</h3>
            <p class="small text-muted mb-0">Tips prácticos para escribir mejores prompts y obtener mejores respuestas.</p>
            <div class="collapse" id="detalle3">
                <p class="small text-muted mb-0 pt-2 mt-2 border-top">
                    Pequeños cambios -ser específico, dar ejemplos, pedir que la IA explique su
                    razonamiento- mejoran mucho la calidad de la respuesta. Revisa la sección de
                    <a href="tips.jsp">Tips</a> para más consejos por nivel.
                </p>
            </div>
        </div>
    </div>
    <div class="col-md-3 col-6 fade-in delay-4">
        <div class="feature-card accent-4 feature-clicable" data-bs-toggle="collapse" data-bs-target="#detalle4" role="button" aria-expanded="false">
            <div class="d-flex justify-content-between align-items-start">
                <div class="feature-icon"><i class="bi bi-people"></i></div>
                <i class="bi bi-chevron-down feature-chevron"></i>
            </div>
            <h3 class="h6 mb-1">Para todos los niveles</h3>
            <p class="small text-muted mb-0">Contenido pensado desde cero, sin necesidad de conocimientos técnicos previos.</p>
            <div class="collapse" id="detalle4">
                <p class="small text-muted mb-0 pt-2 mt-2 border-top">
                    Empieza por los tips de nivel Principiante y avanza a tu ritmo hasta Avanzado.
                    No necesitas experiencia previa en programación ni en inteligencia artificial
                    para comenzar.
                </p>
            </div>
        </div>
    </div>
</div>

<!-- ===================== CATEGORIAS ===================== -->
<h2 id="categorias" class="h4 mb-3 fade-in">Explora por categorías</h2>
<p class="text-muted small fade-in mb-3">Toca una categoría para filtrar los contenidos de abajo.</p>
<div class="row g-3 mb-5">
<%
    // ---- Consulta: traer las categorias ----
    String[] acentos = {"accent-1", "accent-2", "accent-3", "accent-4"};

    // ---- Leemos si hay un filtro de categoria activo, ej: index.jsp?categoria=2 ----
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
                <h3 class="h6 mb-1"><%= rs.getString("nombre") %></h3>
                <p class="small text-muted mb-0"><%= rs.getString("descripcion") %></p>
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

<!-- ===================== ULTIMOS / FILTRADOS CONTENIDOS ===================== -->
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
    <h2 class="h4 mb-0">Contenidos de "<%= nombreCategoriaActiva %>"</h2>
    <a href="index.jsp#categorias" class="btn btn-sm btn-outline-secondary">
        <i class="bi bi-x-lg"></i> Quitar filtro
    </a>
<%
    } else {
%>
    <h2 class="h4 mb-0">Últimos contenidos</h2>
<%
    }
%>
</div>

<div class="row g-3">
<%
    // ---- Consulta: si hay filtro, trae los contenidos de esa categoria; si no, los mas recientes ----
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
        <div class="card h-100">
            <div class="card-body d-flex flex-column">
                <h3 class="h6"><%= rs.getString("titulo") %></h3>
                <p class="small text-muted flex-grow-1"><%= rs.getString("resumen") %></p>
                <p class="small text-muted"><i class="bi bi-clock"></i> <%= rs.getInt("tiempo_lectura_min") %> min de lectura</p>
                <a href="articulo.jsp?id=<%= rs.getInt("id_contenido") %>" class="btn btn-sm btn-outline-primary">Leer más</a>
            </div>
        </div>
    </div>
<%
        }
        if (!hayContenidos) {
%>
    <div class="col-12">
        <div class="alert alert-light border text-center">
            Todavía no hay contenidos publicados en esta categoría.
        </div>
    </div>
<%
        }
    } catch (Exception e) {
%>
    <div class="col-12"><div class="alert alert-danger">Error al cargar contenidos: <%= e.getMessage() %></div></div>
<%
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>
</div>

<%@ include file="includes/footer.jsp" %>
