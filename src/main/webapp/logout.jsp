<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Elimina la sesion del usuario y lo regresa al inicio
    session.invalidate();
    response.sendRedirect("index.jsp");
%>
