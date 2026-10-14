<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, Modelo.Usuario"%>
<%!
    String e(Object o) { return logica.Util.esc(o); }
%>
<%
    // Esta pagina se alimenta desde UsuarioServlet; si se abre directo, redirigimos.
    if (request.getAttribute("usuarios") == null) {
        response.sendRedirect("usuarioServlet");
        return;
    }
    @SuppressWarnings("unchecked")
    List<Usuario> usuarios = (List<Usuario>) request.getAttribute("usuarios");
    Usuario editando = (Usuario) request.getAttribute("editando");
    boolean modoEditar = editando != null && editando.getId() > 0;
    String mensaje = (String) request.getAttribute("mensaje");
    String error = (String) request.getAttribute("error");
    String q = (String) request.getAttribute("q");
    String rolSel = editando != null && editando.getRol() != null ? editando.getRol() : "";
    boolean esAdmin = controlador.Auth.esAdmin(request);
    Modelo.Usuario yo = controlador.Auth.actual(request);
%>
<jsp:include page="lib/header.jsp"/>

<main class="container mb-5">
    <h2 class="fw-bold text-primary mb-3">Gestión de Usuarios</h2>

    <% if (mensaje != null) { %>
        <div class="alert alert-success alert-dismissible fade show"><%= e(mensaje) %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
    <% } %>
    <% if (error != null) { %>
        <div class="alert alert-danger alert-dismissible fade show"><%= e(error) %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
    <% } %>

    <% if (!esAdmin && yo != null) { %>
        <div class="alert alert-info">Tu rol (<strong><%= e(yo.getRol()) %></strong>) solo permite consultar. Solo el administrador puede crear, editar o eliminar.</div>
    <% } %>

    <div class="row g-4">
        <% if (esAdmin) { %>
        <!-- Formulario crear / editar -->
        <div class="col-lg-4">
            <div class="card shadow-sm border-0 p-3">
                <h5 class="fw-bold mb-3"><%= modoEditar ? "Editar usuario #" + editando.getId() : "Registrar usuario" %></h5>
                <form action="usuarioServlet" method="POST">
                    <input type="hidden" name="accion" value="<%= modoEditar ? "actualizar" : "insertar" %>">
                    <% if (modoEditar) { %><input type="hidden" name="id" value="<%= editando.getId() %>"><% } %>

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
                        <input type="password" name="password" class="form-control"
                               <%= modoEditar ? "placeholder=\"(dejar vacío para no cambiarla)\"" : "required" %>>
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
                        <button type="submit" class="btn btn-primary flex-fill"><%= modoEditar ? "Guardar cambios" : "Registrar" %></button>
                        <% if (editando != null) { %><a href="usuarioServlet" class="btn btn-outline-secondary">Cancelar</a><% } %>
                    </div>
                </form>
            </div>
        </div>

        <% } %>

        <!-- Listado + busqueda -->
        <div class="<%= esAdmin ? "col-lg-8" : "col-lg-12" %>">
            <div class="card shadow-sm border-0 p-3">
                <form action="usuarioServlet" method="GET" class="d-flex gap-2 mb-3">
                    <input type="text" name="q" class="form-control" placeholder="Buscar por nombre, correo o rol" value="<%= e(q) %>">
                    <button class="btn btn-outline-primary" type="submit">Buscar</button>
                    <% if (q != null && !q.isEmpty()) { %><a href="usuarioServlet" class="btn btn-outline-secondary">Limpiar</a><% } %>
                </form>

                <% if (usuarios.isEmpty()) { %>
                    <p class="text-muted text-center my-4">No se encontraron resultados</p>
                <% } else { %>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr><th>ID</th><th>Nombre</th><th>Correo</th><th>Rol</th><% if (esAdmin) { %><th class="text-end">Acciones</th><% } %></tr>
                        </thead>
                        <tbody>
                        <% for (Usuario u : usuarios) { %>
                            <tr>
                                <td><%= u.getId() %></td>
                                <td><%= e(u.getNombre()) %></td>
                                <td><%= e(u.getEmail()) %></td>
                                <td><span class="badge bg-secondary"><%= e(u.getRol()) %></span></td>
                                <% if (esAdmin) { %>
                                <td class="text-end">
                                    <a href="usuarioServlet?accion=editar&id=<%= u.getId() %>" class="btn btn-sm btn-outline-primary">Editar</a>
                                    <form action="usuarioServlet" method="POST" class="d-inline"
                                          onsubmit="return confirm('¿Eliminar al usuario <%= e(u.getNombre()).replace("\\", "\\\\").replace("&#39;", "\\'") %>?');">
                                        <input type="hidden" name="accion" value="eliminar">
                                        <input type="hidden" name="id" value="<%= u.getId() %>">
                                        <button type="submit" class="btn btn-sm btn-outline-danger">Eliminar</button>
                                    </form>
                                </td>
                                <% } %>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</main>

<jsp:include page="lib/footer.jsp"/>
