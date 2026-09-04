<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="utilidades.Seguridad" %>
<!DOCTYPE html>
<html lang="es" data-bs-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IA Generativa | Portal Educativo de Vanguardia</title>
    <!-- Script para evitar destellos al cargar el modo oscuro -->
    <script>
        (function() {
            var savedTheme = localStorage.getItem('theme') || (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
            document.documentElement.setAttribute('data-bs-theme', savedTheme);
        })();
    </script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="css/estilo.css" rel="stylesheet">
</head>
<body>

<!-- Formas de fondo decorativas (gradiente orgánico) -->
<div class="blob-decor blob-1"></div>
<div class="blob-decor blob-2"></div>
<div class="blob-decor blob-3"></div>

<nav class="navbar navbar-expand-xl navbar-glass sticky-top shadow-sm py-2">
  <div class="container">
    <a class="navbar-brand fw-bold text-primary d-flex align-items-center gap-2" href="index.jsp">
        <span class="avatar-tech" style="width:36px; height:36px; border-radius:.6rem;">
            <i class="bi bi-robot text-primary"></i>
        </span>
        <span>IA Generativa <span class="badge bg-primary-subtle text-primary small fs-6 fw-bold">PRO</span></span>
    </a>
    <button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#menuPrincipal">
      <span class="navbar-toggler-icon"></span>
    </button>
    
    <div class="collapse navbar-collapse" id="menuPrincipal">
      <ul class="navbar-nav mx-auto mb-2 mb-xl-0 gap-1">
        <li class="nav-item"><a class="nav-link nav-link-animado px-2" href="index.jsp"><i class="bi bi-house-door me-1"></i> Inicio</a></li>
        <li class="nav-item"><a class="nav-link nav-link-animado px-2" href="articulos.jsp"><i class="bi bi-journal-text me-1"></i> Artículos</a></li>
        <li class="nav-item"><a class="nav-link nav-link-animado px-2" href="tips.jsp"><i class="bi bi-lightbulb me-1"></i> Tips</a></li>
        <li class="nav-item"><a class="nav-link nav-link-animado px-2" href="normatividad.jsp"><i class="bi bi-shield-check me-1"></i> Normatividad</a></li>
        <li class="nav-item">
            <a class="nav-link nav-link-animado px-2 text-primary fw-semibold" href="prompt-builder.jsp">
                <i class="bi bi-stars"></i> Prompt Builder
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link nav-link-animado px-2" href="quiz.jsp">
                <i class="bi bi-trophy me-1"></i> Quiz IA
            </a>
        </li>
      </ul>

      <!-- Buscador y Acciones -->
      <div class="d-flex align-items-center gap-2">
        <form class="d-none d-lg-flex" action="buscar.jsp" method="get">
            <div class="input-group input-group-sm">
                <input type="text" name="q" class="form-control border-end-0" placeholder="Buscar en el portal..." style="max-width: 170px; border-radius: .5rem 0 0 .5rem;">
                <button class="btn btn-outline-secondary border-start-0" type="submit" style="border-radius: 0 .5rem .5rem 0;">
                    <i class="bi bi-search"></i>
                </button>
            </div>
        </form>

        <!-- Botón Modo Oscuro / Claro -->
        <button class="theme-toggle-btn" id="themeToggleBtn" type="button" title="Cambiar tema claro/oscuro">
            <i class="bi bi-moon-stars" id="themeToggleIcon"></i>
        </button>

        <%
            String nombreUsuarioNav = (String) session.getAttribute("nombreUsuario");
            String rolUsuarioNav = (String) session.getAttribute("rol");
            if (nombreUsuarioNav != null) {
                String nombreCorto = nombreUsuarioNav.split(" ")[0];
        %>
            <div class="dropdown">
                <button class="btn btn-outline-primary btn-sm dropdown-toggle d-flex align-items-center gap-1" type="button" data-bs-toggle="dropdown">
                    <i class="bi bi-person-circle"></i>
                    <span><%= Seguridad.escapeHtml(nombreCorto) %></span>
                    <% if ("administrador".equals(rolUsuarioNav)) { %>
                        <span class="badge bg-danger text-white ms-1" style="font-size:0.65rem;">ADMIN</span>
                    <% } %>
                </button>
                <ul class="dropdown-menu dropdown-menu-end shadow-sm">
                    <li><h6 class="dropdown-header">Mi Cuenta</h6></li>
                    <li><a class="dropdown-item" href="perfil.jsp"><i class="bi bi-person me-2"></i> Mi Perfil</a></li>
                    <li><a class="dropdown-item" href="favoritos.jsp"><i class="bi bi-heart me-2 text-danger"></i> Mis Favoritos</a></li>
                    <% if ("administrador".equals(rolUsuarioNav)) { %>
                        <li><hr class="dropdown-divider"></li>
                        <li><h6 class="dropdown-header text-danger">Administración</h6></li>
                        <li><a class="dropdown-item fw-semibold text-primary" href="admin.jsp"><i class="bi bi-gear-wide-connected me-2"></i> Panel Admin</a></li>
                    <% } %>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item text-danger" href="logout.jsp"><i class="bi bi-box-arrow-right me-2"></i> Cerrar sesión</a></li>
                </ul>
            </div>
        <%
            } else {
        %>
            <a href="login.jsp" class="btn btn-outline-primary btn-sm px-3">Ingresar</a>
            <a href="registro.jsp" class="btn btn-primary btn-sm px-3 btn-glow">Registro</a>
        <%
            }
        %>
      </div>
    </div>
  </div>
</nav>

<div class="container my-4">
