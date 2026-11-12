<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Modelo.Usuario"%>
<%!
    String e(Object o) { return logica.Util.esc(o); }
%>
<%
    // Esta pagina se abre desde UsuarioServlet. Si alguien entra directo, se manda al servlet.
    if (request.getAttribute("desdeServlet") == null) {
        response.sendRedirect("usuarioServlet?accion=nuevo");
        return;
    }
    Usuario editando = (Usuario) request.getAttribute("editando");
    boolean modoEditar = editando != null && editando.getId() > 0;
    String error = (String) request.getAttribute("error");
    String rolSel = editando != null && editando.getRol() != null ? editando.getRol() : "";
%>
<jsp:include page="lib/header.jsp"/>

<main class="container mb-5" style="max-width: 620px;">
    <h2 class="fw-bold text-primary mb-3"><%= modoEditar ? "Editar usuario" : "Agregar usuario" %></h2>

    <% if (error != null) { %>
        <div class="alert alert-danger alert-dismissible fade show"><%= e(error) %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
    <% } %>

    <div class="card shadow-sm border-0 p-4">
        <form action="usuarioServlet" method="POST">
            <input type="hidden" name="accion" value="<%= modoEditar ? "actualizar" : "insertar" %>">
            <% if (modoEditar) { %><input type="hidden" name="id" value="<%= editando.getId() %>"><% } %>

            <div class="mb-3">
                <label class="form-label fw-bold">Código único</label>
                <input type="text" name="codigo" class="form-control" placeholder="Ejemplo: USR-010" required
                       minlength="3" maxlength="15" pattern="[A-Za-z0-9_\-]{3,15}"
                       title="Entre 3 y 15 letras, números o guiones"
                       value="<%= editando != null ? e(editando.getCodigo()) : "" %>">
                <div class="form-text">Entre 3 y 15 letras, números o guiones. No se puede repetir.</div>
            </div>
            <div class="mb-3">
                <label class="form-label fw-bold">Nombre completo</label>
                <input type="text" name="nombre" class="form-control" required
                       value="<%= editando != null ? e(editando.getNombre()) : "" %>">
            </div>
            <div class="mb-3">
                <label class="form-label fw-bold">Correo electrónico</label>
                <input type="email" name="email" class="form-control" required
                       value="<%= editando != null ? e(editando.getEmail()) : "" %>">
            </div>
            <div class="mb-3">
                <label class="form-label fw-bold">Contraseña</label>
                <input type="password" name="password" class="form-control" minlength="6"
                       <%= modoEditar ? "placeholder=\"Dejar vacío para no cambiarla\"" : "placeholder=\"Mínimo 6 caracteres\" required" %>>
            </div>
            <div class="mb-3">
                <label class="form-label fw-bold">Rol</label>
                <select name="rol" class="form-select" required>
                    <option value="">Seleccione un rol...</option>
                    <option value="Administrador" <%= "Administrador".equals(rolSel) ? "selected" : "" %>>Administrador</option>
                    <option value="Operador" <%= "Operador".equals(rolSel) ? "selected" : "" %>>Operador</option>
                    <option value="Estudiante" <%= "Estudiante".equals(rolSel) ? "selected" : "" %>>Estudiante</option>
                </select>
            </div>
            <div class="d-flex gap-2">
                <button type="submit" class="btn btn-primary flex-fill"><%= modoEditar ? "Guardar cambios" : "Guardar usuario" %></button>
                <a href="usuarioServlet" class="btn btn-outline-secondary">Cancelar</a>
            </div>
        </form>
    </div>
</main>

<jsp:include page="lib/footer.jsp"/>
