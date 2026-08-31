<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IA Generativa</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="css/estilo.css" rel="stylesheet">
</head>
<body>

<!-- Formas de fondo decorativas (gradiente organico), no interfieren con el contenido -->
<div class="blob-decor blob-1"></div>
<div class="blob-decor blob-2"></div>
<div class="blob-decor blob-3"></div>

<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
  <div class="container">
    <a class="navbar-brand fw-bold text-primary" href="index.jsp">
        <i class="bi bi-robot"></i> IA Generativa
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#menuPrincipal">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="menuPrincipal">
      <ul class="navbar-nav mx-auto">
        <li class="nav-item"><a class="nav-link nav-link-animado" href="index.jsp">Inicio</a></li>
        <li class="nav-item"><a class="nav-link nav-link-animado" href="index.jsp#categorias">Aprende</a></li>
        <li class="nav-item"><a class="nav-link nav-link-animado" href="tips.jsp">Tips</a></li>
        <li class="nav-item"><a class="nav-link nav-link-animado" href="normatividad.jsp">Normatividad</a></li>
      </ul>
      <div class="d-flex align-items-center gap-2">
        <%
            String nombreUsuarioNav = (String) session.getAttribute("nombreUsuario");
            if (nombreUsuarioNav != null) {
        %>
            <span class="me-2 small">Hola, <%= nombreUsuarioNav %></span>
            <a href="logout.jsp" class="btn btn-outline-secondary btn-sm">Cerrar sesión</a>
        <%
            } else {
        %>
            <a href="login.jsp" class="btn btn-outline-primary btn-sm">Iniciar sesión</a>
            <a href="registro.jsp" class="btn btn-primary btn-sm">Registrarse</a>
        <%
            }
        %>
      </div>
    </div>
  </div>
</nav>

<div class="container my-4">
