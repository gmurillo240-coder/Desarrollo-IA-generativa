<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="conexion.ConexionBD" %>
<%@ page import="utilidades.Seguridad" %>
<%
    // ---- Este bloque procesa el formulario ANTES de dibujar el HTML ----
    String mensaje = "";
    String tipoAlerta = "";

    // Si ya está logueado, redirigir al inicio
    if (session.getAttribute("idUsuario") != null) {
        response.sendRedirect("index.jsp");
        return;
    }

    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("registrar") != null) {
        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String password2 = request.getParameter("password2");

        if (nombre == null || nombre.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            mensaje = "Por favor, completa todos los campos requeridos.";
            tipoAlerta = "warning";
        } else if (password.length() < 6) {
            mensaje = "La contraseña debe tener al menos 6 caracteres.";
            tipoAlerta = "warning";
        } else if (!password.equals(password2)) {
            mensaje = "Las contraseñas no coinciden. Por favor verifica.";
            tipoAlerta = "warning";
        } else {
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            try {
                con = ConexionBD.obtenerConexion();

                // 1) Verificar que el correo no este ya registrado
                ps = con.prepareStatement("SELECT id_usuario FROM usuarios WHERE email = ?");
                ps.setString(1, email.trim());
                rs = ps.executeQuery();

                if (rs.next()) {
                    mensaje = "Ya existe una cuenta con ese correo electrónico.";
                    tipoAlerta = "danger";
                } else {
                    // 2) Insertar el nuevo usuario con contraseña cifrada (SHA-256 + Salt)
                    String passwordHash = Seguridad.hashPassword(password);
                    ps.close();
                    ps = con.prepareStatement(
                        "INSERT INTO usuarios (nombre, email, password, rol) VALUES (?, ?, ?, 'usuario')");
                    ps.setString(1, nombre.trim());
                    ps.setString(2, email.trim());
                    ps.setString(3, passwordHash);
                    ps.executeUpdate();

                    mensaje = "¡Cuenta creada con éxito! Ahora puedes iniciar sesión.";
                    tipoAlerta = "success";
                }
            } catch (Exception e) {
                mensaje = "Error al registrar la cuenta: " + e.getMessage();
                tipoAlerta = "danger";
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            }
        }
    }
%>
<%@ include file="includes/header.jsp" %>

<div class="row justify-content-center my-5">
    <div class="col-md-6 col-lg-5">
        <div class="card shadow-lg border-0 glass-card p-4 p-md-5">
            <div class="text-center mb-4">
                <div class="avatar-tech mx-auto mb-3">
                    <i class="bi bi-person-plus text-primary" style="font-size: 2rem;"></i>
                </div>
                <h1 class="h3 fw-bold mb-1">Crea tu cuenta</h1>
                <p class="text-muted small">Únete a la comunidad de aprendizaje en IA Generativa</p>
            </div>

            <% if (!mensaje.isEmpty()) { %>
                <div class="alert alert-<%= tipoAlerta %> d-flex align-items-center gap-2 py-2 mb-3">
                    <i class="bi <%= "success".equals(tipoAlerta) ? "bi-check-circle-fill" : "bi-exclamation-circle-fill" %> flex-shrink-0"></i>
                    <div><%= mensaje %></div>
                </div>
            <% } %>

            <% if (!"success".equals(tipoAlerta)) { %>
            <form method="post" action="registro.jsp">
                <div class="mb-3">
                    <label class="form-label small fw-semibold">Nombre completo</label>
                    <div class="input-group">
                        <span class="input-group-text bg-transparent border-end-0"><i class="bi bi-person text-muted"></i></span>
                        <input type="text" name="nombre" class="form-control border-start-0" placeholder="Ej. Arturo Murillo" required>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label small fw-semibold">Correo electrónico</label>
                    <div class="input-group">
                        <span class="input-group-text bg-transparent border-end-0"><i class="bi bi-envelope text-muted"></i></span>
                        <input type="email" name="email" class="form-control border-start-0" placeholder="tu@correo.com" required>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label small fw-semibold">Contraseña (mínimo 6 caracteres)</label>
                    <div class="input-group">
                        <span class="input-group-text bg-transparent border-end-0"><i class="bi bi-key text-muted"></i></span>
                        <input type="password" name="password" class="form-control border-start-0" placeholder="••••••••" required>
                    </div>
                </div>
                <div class="mb-4">
                    <label class="form-label small fw-semibold">Confirmar contraseña</label>
                    <div class="input-group">
                        <span class="input-group-text bg-transparent border-end-0"><i class="bi bi-shield-check text-muted"></i></span>
                        <input type="password" name="password2" class="form-control border-start-0" placeholder="••••••••" required>
                    </div>
                </div>
                <button type="submit" name="registrar" value="1" class="btn btn-primary w-100 py-2 fw-semibold btn-glow">
                    <i class="bi bi-check2-circle me-1"></i> Registrarme ahora
                </button>
                <div class="text-center mt-4 pt-3 border-top">
                    <p class="small text-muted mb-0">
                        ¿Ya tienes una cuenta? <a href="login.jsp" class="text-primary fw-semibold text-decoration-none">Inicia sesión</a>
                    </p>
                </div>
            </form>
            <% } else { %>
                <div class="text-center py-3">
                    <a href="login.jsp" class="btn btn-primary btn-glow px-4 py-2">
                        <i class="bi bi-box-arrow-in-right me-1"></i> Ir al Inicio de Sesión
                    </a>
                </div>
            <% } %>
        </div>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>
