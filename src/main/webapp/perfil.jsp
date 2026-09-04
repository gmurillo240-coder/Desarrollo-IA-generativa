<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="conexion.ConexionBD" %>
<%@ page import="utilidades.Seguridad" %>
<%
    Integer idUsuarioLogueado = (Integer) session.getAttribute("idUsuario");
    if (idUsuarioLogueado == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String mensaje = "";
    String tipoAlerta = "info";

    // ---- Procesar actualización de nombre ----
    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("actualizar_perfil") != null) {
        String nuevoNombre = request.getParameter("nombre");
        if (nuevoNombre == null || nuevoNombre.trim().isEmpty()) {
            mensaje = "El nombre no puede estar vacío.";
            tipoAlerta = "warning";
        } else {
            Connection conUp = null;
            PreparedStatement psUp = null;
            try {
                conUp = ConexionBD.obtenerConexion();
                psUp = conUp.prepareStatement("UPDATE usuarios SET nombre = ? WHERE id_usuario = ?");
                psUp.setString(1, nuevoNombre.trim());
                psUp.setInt(2, idUsuarioLogueado);
                psUp.executeUpdate();

                session.setAttribute("nombreUsuario", nuevoNombre.trim());
                mensaje = "¡Nombre actualizado con éxito!";
                tipoAlerta = "success";
            } catch (Exception e) {
                mensaje = "Error al actualizar perfil: " + e.getMessage();
                tipoAlerta = "danger";
            } finally {
                if (psUp != null) psUp.close();
                if (conUp != null) conUp.close();
            }
        }
    }

    // ---- Procesar cambio de contraseña ----
    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("cambiar_password") != null) {
        String passActual = request.getParameter("pass_actual");
        String passNueva = request.getParameter("pass_nueva");
        String passNueva2 = request.getParameter("pass_nueva2");

        if (passActual == null || passNueva == null || passNueva2 == null ||
            passActual.isEmpty() || passNueva.isEmpty()) {
            mensaje = "Por favor completa todos los campos de contraseña.";
            tipoAlerta = "warning";
        } else if (passNueva.length() < 6) {
            mensaje = "La nueva contraseña debe contener al menos 6 caracteres.";
            tipoAlerta = "warning";
        } else if (!passNueva.equals(passNueva2)) {
            mensaje = "Las nuevas contraseñas no coinciden.";
            tipoAlerta = "warning";
        } else {
            Connection conPass = null;
            PreparedStatement psPass = null;
            ResultSet rsPass = null;
            try {
                conPass = ConexionBD.obtenerConexion();
                psPass = conPass.prepareStatement("SELECT password FROM usuarios WHERE id_usuario = ?");
                psPass.setInt(1, idUsuarioLogueado);
                rsPass = psPass.executeQuery();

                if (rsPass.next()) {
                    String passGuardada = rsPass.getString("password");
                    if (Seguridad.verificarPassword(passActual, passGuardada)) {
                        String nuevoHash = Seguridad.hashPassword(passNueva);
                        rsPass.close();
                        psPass.close();

                        psPass = conPass.prepareStatement("UPDATE usuarios SET password = ? WHERE id_usuario = ?");
                        psPass.setString(1, nuevoHash);
                        psPass.setInt(2, idUsuarioLogueado);
                        psPass.executeUpdate();

                        mensaje = "¡Contraseña actualizada de forma segura!";
                        tipoAlerta = "success";
                    } else {
                        mensaje = "La contraseña actual es incorrecta.";
                        tipoAlerta = "danger";
                    }
                }
            } catch (Exception e) {
                mensaje = "Error al cambiar contraseña: " + e.getMessage();
                tipoAlerta = "danger";
            } finally {
                if (rsPass != null) rsPass.close();
                if (psPass != null) psPass.close();
                if (conPass != null) conPass.close();
            }
        }
    }

    // Consultar datos del usuario
    String nombreUser = "";
    String emailUser = "";
    String rolUser = "usuario";
    Timestamp fechaReg = null;
    int totalFavs = 0;
    int totalComs = 0;

    Connection conInfo = null;
    PreparedStatement psInfo = null;
    ResultSet rsInfo = null;
    try {
        conInfo = ConexionBD.obtenerConexion();
        psInfo = conInfo.prepareStatement(
            "SELECT nombre, email, rol, fecha_registro FROM usuarios WHERE id_usuario = ?");
        psInfo.setInt(1, idUsuarioLogueado);
        rsInfo = psInfo.executeQuery();
        if (rsInfo.next()) {
            nombreUser = rsInfo.getString("nombre");
            emailUser = rsInfo.getString("email");
            rolUser = rsInfo.getString("rol");
            fechaReg = rsInfo.getTimestamp("fecha_registro");
        }
        rsInfo.close();
        psInfo.close();

        // Contar favoritos
        psInfo = conInfo.prepareStatement("SELECT COUNT(*) FROM favoritos WHERE id_usuario = ?");
        psInfo.setInt(1, idUsuarioLogueado);
        rsInfo = psInfo.executeQuery();
        if (rsInfo.next()) totalFavs = rsInfo.getInt(1);
        rsInfo.close();
        psInfo.close();

        // Contar comentarios
        psInfo = conInfo.prepareStatement("SELECT COUNT(*) FROM comentarios WHERE id_usuario = ?");
        psInfo.setInt(1, idUsuarioLogueado);
        rsInfo = psInfo.executeQuery();
        if (rsInfo.next()) totalComs = rsInfo.getInt(1);

    } catch (Exception e) {
        // ignore
    } finally {
        if (rsInfo != null) rsInfo.close();
        if (psInfo != null) psInfo.close();
        if (conInfo != null) conInfo.close();
    }
%>
<%@ include file="includes/header.jsp" %>

<!-- ===================== ENCABEZADO ===================== -->
<div class="hero mb-4 fade-in">
    <div class="row align-items-center">
        <div class="col-lg-8">
            <span class="hero-badge">
                <i class="bi bi-person-badge text-primary"></i> Centro de Usuario
            </span>
            <h1 class="h3 fw-bold mb-2">Mi Perfil</h1>
            <p class="text-muted mb-0">
                Gestiona tu información personal, revisa tu actividad y actualiza tus credenciales de acceso.
            </p>
        </div>
        <div class="col-lg-4 text-center mt-3 mt-lg-0">
            <div class="avatar-tech mx-auto" style="width:72px; height:72px; font-size:2.2rem;">
                <i class="bi bi-person-fill text-primary"></i>
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

<div class="row g-4 mb-5">
    <!-- Columna Izquierda: Tarjeta de Resumen y Estadísticas -->
    <div class="col-lg-4 fade-in delay-1">
        <div class="card glass-card p-4 text-center mb-4">
            <div class="comment-avatar mx-auto mb-3" style="width:72px; height:72px; font-size:2rem;">
                <%= nombreUser.length() > 0 ? nombreUser.charAt(0) : 'U' %>
            </div>
            <h2 class="h5 fw-bold mb-1"><%= Seguridad.escapeHtml(nombreUser) %></h2>
            <p class="text-muted small mb-2"><%= Seguridad.escapeHtml(emailUser) %></p>
            <div>
                <% if ("administrador".equals(rolUser)) { %>
                    <span class="badge bg-danger px-3 py-1">Administrador del Sistema</span>
                <% } else { %>
                    <span class="badge bg-primary px-3 py-1">Estudiante / Usuario</span>
                <% } %>
            </div>
            <hr>
            <div class="text-start small text-muted">
                <div class="mb-2">
                    <i class="bi bi-calendar3 me-2 text-primary"></i>
                    Miembro desde: <%= fechaReg != null ? fechaReg.toString().substring(0, 10) : "2026" %>
                </div>
                <div>
                    <i class="bi bi-shield-check me-2 text-success"></i>
                    Protección de cuenta: Cifrado SHA-256 + Salt
                </div>
            </div>
        </div>

        <!-- Mini tarjetas de actividad -->
        <div class="row g-2">
            <div class="col-6">
                <div class="card glass-card p-3 text-center">
                    <div class="h4 fw-bold text-danger mb-0"><%= totalFavs %></div>
                    <div class="small text-muted">Favoritos</div>
                </div>
            </div>
            <div class="col-6">
                <div class="card glass-card p-3 text-center">
                    <div class="h4 fw-bold text-primary mb-0"><%= totalComs %></div>
                    <div class="small text-muted">Comentarios</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Columna Derecha: Formularios de Edición -->
    <div class="col-lg-8 fade-in delay-2">
        <!-- Formulario Actualizar Nombre -->
        <div class="card glass-card p-4 mb-4">
            <h3 class="h6 fw-bold mb-3 d-flex align-items-center gap-2">
                <i class="bi bi-pencil-square text-primary"></i> Actualizar Información Personal
            </h3>
            <form method="post" action="perfil.jsp">
                <div class="mb-3">
                    <label class="form-label small fw-bold">Nombre Completo</label>
                    <input type="text" name="nombre" class="form-control" value="<%= Seguridad.escapeHtml(nombreUser) %>" required>
                </div>
                <div class="mb-3">
                    <label class="form-label small fw-bold">Correo Electrónico</label>
                    <input type="email" class="form-control bg-body-tertiary" value="<%= Seguridad.escapeHtml(emailUser) %>" disabled>
                    <div class="form-text small">El correo es el identificador único de tu cuenta.</div>
                </div>
                <button type="submit" name="actualizar_perfil" value="1" class="btn btn-primary btn-sm btn-glow">
                    Guardar Cambios
                </button>
            </form>
        </div>

        <!-- Formulario Cambiar Contraseña -->
        <div class="card glass-card p-4">
            <h3 class="h6 fw-bold mb-3 d-flex align-items-center gap-2">
                <i class="bi bi-key text-primary"></i> Cambiar Contraseña
            </h3>
            <form method="post" action="perfil.jsp">
                <div class="mb-3">
                    <label class="form-label small fw-bold">Contraseña Actual</label>
                    <input type="password" name="pass_actual" class="form-control" placeholder="••••••••" required>
                </div>
                <div class="row g-2 mb-3">
                    <div class="col-md-6">
                        <label class="form-label small fw-bold">Nueva Contraseña</label>
                        <input type="password" name="pass_nueva" class="form-control" placeholder="Mínimo 6 caracteres" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label small fw-bold">Confirmar Nueva Contraseña</label>
                        <input type="password" name="pass_nueva2" class="form-control" placeholder="Mínimo 6 caracteres" required>
                    </div>
                </div>
                <button type="submit" name="cambiar_password" value="1" class="btn btn-outline-primary btn-sm">
                    Actualizar Contraseña
                </button>
            </form>
        </div>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>
