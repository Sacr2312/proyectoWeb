<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    String e(Object o) { return logica.Util.esc(o); }
%>
<%
    if (Servlets.Auth.actual(request) != null) { // ya tiene sesion
        response.sendRedirect("index.jsp");
        return;
    }
    String error = (String) request.getAttribute("error");
    String nombre = request.getParameter("nombre");
    String email = request.getParameter("email");
%>
<jsp:include page="lib/header.jsp"/>

<div class="container my-5" style="max-width: 500px;">
    <div class="card shadow-sm border-0 p-4">
        <h3 class="text-center fw-bold text-primary mb-4">Registro de Usuario</h3>

        <% if (error != null) { %><div class="alert alert-danger"><%= e(error) %></div><% } %>

        <form action="registro" method="POST">
            <div class="mb-3">
                <label class="form-label fw-bold">Nombre Completo</label>
                <input type="text" name="nombre" class="form-control" placeholder="Ingresa tu nombre" required
                       value="<%= e(nombre) %>">
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Correo Electrónico</label>
                <input type="email" name="email" class="form-control" placeholder="correo@ejemplo.com" required
                       value="<%= e(email) %>">
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Contraseña</label>
                <input type="password" name="password" class="form-control" placeholder="Mínimo 6 caracteres" minlength="6" required>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Confirmar Contraseña</label>
                <input type="password" name="confirmar" class="form-control" placeholder="Repite la contraseña" minlength="6" required>
            </div>

            <button type="submit" class="btn btn-primary w-100 py-2 fw-bold mt-3">Crear Cuenta</button>
            <p class="text-muted small text-center mt-3 mb-0">Las cuentas nuevas se crean con el rol Estudiante (solo consulta).</p>
            <div class="text-center mt-2">
                <a href="login.jsp" class="small text-decoration-none">¿Ya tienes cuenta? Inicia sesión</a>
            </div>
        </form>
    </div>
</div>

<jsp:include page="lib/footer.jsp"/>
