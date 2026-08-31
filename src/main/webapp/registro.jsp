<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="conexion.ConexionBD" %>
<%
    // ---- Este bloque procesa el formulario ANTES de dibujar el HTML ----
    String mensaje = "";
    String tipoAlerta = "";

    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("registrar") != null) {
        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String password2 = request.getParameter("password2");

        if (nombre == null || nombre.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            mensaje = "Por favor llena todos los campos.";
            tipoAlerta = "warning";
        } else if (!password.equals(password2)) {
            mensaje = "Las contraseñas no coinciden.";
            tipoAlerta = "warning";
        } else {
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            try {
                con = ConexionBD.obtenerConexion();

                // 1) Verificar que el correo no este ya registrado
                ps = con.prepareStatement("SELECT id_usuario FROM usuarios WHERE email = ?");
                ps.setString(1, email);
                rs = ps.executeQuery();

                if (rs.next()) {
                    mensaje = "Ya existe una cuenta con ese correo.";
                    tipoAlerta = "danger";
                } else {
                    // 2) Insertar el nuevo usuario
                    ps = con.prepareStatement(
                        "INSERT INTO usuarios (nombre, email, password, rol) VALUES (?, ?, ?, 'usuario')");
                    ps.setString(1, nombre);
                    ps.setString(2, email);
                    ps.setString(3, password); // En un proyecto real esto debe ir encriptado (ej. BCrypt)
                    ps.executeUpdate();

                    mensaje = "¡Registro exitoso! Ya puedes iniciar sesión.";
                    tipoAlerta = "success";
                }
            } catch (Exception e) {
                mensaje = "Error al registrar: " + e.getMessage();
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

<div class="row justify-content-center">
    <div class="col-md-6">
        <h1 class="h3 mb-4 text-center">Crear cuenta</h1>

        <% if (!mensaje.isEmpty()) { %>
            <div class="alert alert-<%= tipoAlerta %>"><%= mensaje %></div>
        <% } %>

        <form method="post" action="registro.jsp" class="card p-4">
            <div class="mb-3">
                <label class="form-label">Nombre completo</label>
                <input type="text" name="nombre" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Correo electrónico</label>
                <input type="email" name="email" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Contraseña</label>
                <input type="password" name="password" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Confirmar contraseña</label>
                <input type="password" name="password2" class="form-control" required>
            </div>
            <button type="submit" name="registrar" value="1" class="btn btn-primary w-100">Registrarme</button>
            <p class="text-center small mt-3 mb-0">
                ¿Ya tienes cuenta? <a href="login.jsp">Inicia sesión</a>
            </p>
        </form>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>
