<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    String e(Object o) { return logica.Util.esc(o); }
%>
<%
    if (Servlets.Auth.actual(request) != null) { // ya inicio sesion
        response.sendRedirect("index.jsp");
        return;
    }
    String error = (String) request.getAttribute("error");
    String aviso = null;
    String tipoAviso = "info";
    if ("1".equals(request.getParameter("requiere"))) {
        aviso = "Debes iniciar sesión para acceder a esa sección.";
        tipoAviso = "warning";
    } else if ("1".equals(request.getParameter("registrado"))) {
        aviso = "Cuenta creada correctamente. Ya puedes iniciar sesión.";
        tipoAviso = "success";
    } else if ("1".equals(request.getParameter("salio"))) {
        aviso = "Cerraste sesión correctamente.";
    }
    String email = request.getParameter("email");
%>
<jsp:include page="lib/header.jsp"/>

<div class="container my-5" style="max-width: 450px;">
    <div class="card shadow-sm border-0 p-4">
        <h3 class="text-center fw-bold text-dark mb-4">Iniciar Sesión</h3>

        <% if (error != null) { %><div class="alert alert-danger"><%= e(error) %></div><% } %>
        <% if (aviso != null && error == null) { %><div class="alert alert-<%= tipoAviso %>"><%= e(aviso) %></div><% } %>

        <form action="login" method="POST">
            <div class="mb-3">
                <label class="form-label fw-bold">Correo Electrónico</label>
                <input type="email" name="email" class="form-control" placeholder="correo@ejemplo.com" required
                       value="<%= e(email) %>">
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Contraseña</label>
                <input type="password" name="password" class="form-control" placeholder="********" required>
            </div>

            <button type="submit" class="btn btn-primary w-100 py-2 fw-bold mt-3">Ingresar</button>
            <div class="text-center mt-3">
                <a href="registro.jsp" class="small text-decoration-none">¿No tienes cuenta? Regístrate</a>
            </div>
        </form>
    </div>
</div>

<jsp:include page="lib/footer.jsp"/>
