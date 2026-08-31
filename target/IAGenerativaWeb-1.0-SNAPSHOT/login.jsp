<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="conexion.ConexionBD" %>
<%
    // ---- Este bloque procesa el formulario ANTES de dibujar el HTML ----
    // (importante: si el login es correcto, redirigimos, y eso debe pasar
    //  antes de que se empiece a escribir cualquier HTML en la respuesta)
    String mensaje = "";

    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("ingresar") != null) {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConexionBD.obtenerConexion();
            ps = con.prepareStatement("SELECT id_usuario, nombre, password FROM usuarios WHERE email = ?");
            ps.setString(1, email);
            rs = ps.executeQuery();

            if (rs.next()) {
                String passwordGuardada = rs.getString("password");
                if (passwordGuardada.equals(password)) {
                    session.setAttribute("idUsuario", rs.getInt("id_usuario"));
                    session.setAttribute("nombreUsuario", rs.getString("nombre"));
                    response.sendRedirect("index.jsp");
                    return; // detiene la ejecucion del JSP aqui mismo
                } else {
                    mensaje = "Contraseña incorrecta.";
                }
            } else {
                mensaje = "No existe una cuenta con ese correo.";
            }
        } catch (Exception e) {
            mensaje = "Error al iniciar sesión: " + e.getMessage();
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        }
    }
%>
<%@ include file="includes/header.jsp" %>

<div class="row justify-content-center">
    <div class="col-md-5">
        <h1 class="h3 mb-4 text-center">Iniciar sesión</h1>

        <% if (!mensaje.isEmpty()) { %>
            <div class="alert alert-danger"><%= mensaje %></div>
        <% } %>

        <form method="post" action="login.jsp" class="card p-4">
            <div class="mb-3">
                <label class="form-label">Correo electrónico</label>
                <input type="email" name="email" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Contraseña</label>
                <input type="password" name="password" class="form-control" required>
            </div>
            <button type="submit" name="ingresar" value="1" class="btn btn-primary w-100">Ingresar</button>
            <p class="text-center small mt-3 mb-0">
                ¿No tienes cuenta? <a href="registro.jsp">Regístrate</a>
            </p>
        </form>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>
