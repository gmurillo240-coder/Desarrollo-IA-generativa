<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="conexion.ConexionBD" %>
<%@ page import="utilidades.Seguridad" %>
<%
    // ---- Este bloque procesa el formulario ANTES de dibujar el HTML ----
    String mensaje = "";
    String tipoAlerta = "danger";

    // Si ya está logueado, redirigir al inicio
    if (session.getAttribute("idUsuario") != null) {
        response.sendRedirect("index.jsp");
        return;
    }

    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("ingresar") != null) {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            mensaje = "Por favor, ingresa tu correo y contraseña.";
            tipoAlerta = "warning";
        } else {
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            try {
                con = ConexionBD.obtenerConexion();
                ps = con.prepareStatement("SELECT id_usuario, nombre, password, rol FROM usuarios WHERE email = ?");
                ps.setString(1, email.trim());
                rs = ps.executeQuery();

                if (rs.next()) {
                    int idUsuario = rs.getInt("id_usuario");
                    String nombreUsuario = rs.getString("nombre");
                    String passwordGuardada = rs.getString("password");
                    String rolUsuario = rs.getString("rol");

                    if (Seguridad.verificarPassword(password, passwordGuardada)) {
                        // Si la contraseña estaba en texto plano, la actualizamos automáticamente a hash seguro
                        if (Seguridad.esTextoPlano(passwordGuardada)) {
                            PreparedStatement psUp = null;
                            try {
                                String nuevoHash = Seguridad.hashPassword(password);
                                psUp = con.prepareStatement("UPDATE usuarios SET password = ? WHERE id_usuario = ?");
                                psUp.setString(1, nuevoHash);
                                psUp.setInt(2, idUsuario);
                                psUp.executeUpdate();
                            } catch (Exception ex) {
                                // Continuar inicio de sesión aunque falle el auto-upgrade
                            } finally {
                                if (psUp != null) psUp.close();
                            }
                        }

                        // Guardar variables de sesión completas
                        session.setAttribute("idUsuario", idUsuario);
                        session.setAttribute("nombreUsuario", nombreUsuario);
                        session.setAttribute("emailUsuario", email.trim());
                        session.setAttribute("rol", rolUsuario != null ? rolUsuario : "usuario");

                        // Redireccionar
                        response.sendRedirect("index.jsp");
                        return;
                    } else {
                        mensaje = "Contraseña incorrecta. Por favor intenta de nuevo.";
                    }
                } else {
                    mensaje = "No existe una cuenta registrada con ese correo.";
                }
            } catch (Exception e) {
                mensaje = "Error al iniciar sesión: " + e.getMessage();
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
    <div class="col-md-5 col-lg-4">
        <div class="card shadow-lg border-0 glass-card p-4 p-md-5">
            <div class="text-center mb-4">
                <div class="avatar-tech mx-auto mb-3">
                    <i class="bi bi-shield-lock text-primary" style="font-size: 2rem;"></i>
                </div>
                <h1 class="h3 fw-bold mb-1">Bienvenido de nuevo</h1>
                <p class="text-muted small">Ingresa a tu cuenta para guardar favoritos y participar</p>
            </div>

            <% if (!mensaje.isEmpty()) { %>
                <div class="alert alert-<%= tipoAlerta %> d-flex align-items-center gap-2 py-2 mb-3">
                    <i class="bi bi-exclamation-circle-fill flex-shrink-0"></i>
                    <div><%= mensaje %></div>
                </div>
            <% } %>

            <form method="post" action="login.jsp">
                <div class="mb-3">
                    <label class="form-label small fw-semibold">Correo electrónico</label>
                    <div class="input-group">
                        <span class="input-group-text bg-transparent border-end-0"><i class="bi bi-envelope text-muted"></i></span>
                        <input type="email" name="email" class="form-control border-start-0" placeholder="tu@correo.com" required>
                    </div>
                </div>
                <div class="mb-4">
                    <label class="form-label small fw-semibold">Contraseña</label>
                    <div class="input-group">
                        <span class="input-group-text bg-transparent border-end-0"><i class="bi bi-key text-muted"></i></span>
                        <input type="password" name="password" class="form-control border-start-0" placeholder="••••••••" required>
                    </div>
                </div>
                <button type="submit" name="ingresar" value="1" class="btn btn-primary w-100 py-2 fw-semibold btn-glow">
                    <i class="bi bi-box-arrow-in-right me-1"></i> Iniciar sesión
                </button>
                <div class="text-center mt-4 pt-3 border-top">
                    <p class="small text-muted mb-0">
                        ¿No tienes una cuenta? <a href="registro.jsp" class="text-primary fw-semibold text-decoration-none">Crear cuenta gratis</a>
                    </p>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>
