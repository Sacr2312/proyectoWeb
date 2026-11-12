<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, Modelo.Usuario"%>
<%!
    String e(Object o) { return logica.Util.esc(o); }
%>
<%
    // Esta pagina se alimenta desde UsuarioServlet. Si alguien entra directo, se manda al servlet.
    if (request.getAttribute("desdeServlet") == null) {
        response.sendRedirect("usuarioServlet");
        return;
    }
    @SuppressWarnings("unchecked")
    List<Usuario> usuarios = (List<Usuario>) request.getAttribute("usuarios");
    String mensaje = (String) request.getAttribute("mensaje");
    String error = (String) request.getAttribute("error");
    String campo = (String) request.getAttribute("campo");
    String q = (String) request.getAttribute("q");
    boolean esAdmin = Servlets.Auth.esAdmin(request);
    Usuario yo = Servlets.Auth.actual(request);
%>
<jsp:include page="lib/header.jsp"/>

<main class="container mb-5">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="fw-bold text-primary mb-0">Usuarios</h2>
        <% if (esAdmin) { %><a href="usuarioServlet?accion=nuevo" class="btn btn-primary">Agregar usuario</a><% } %>
    </div>

    <% if (mensaje != null) { %>
        <div class="alert alert-success alert-dismissible fade show"><%= e(mensaje) %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
    <% } %>
    <% if (error != null) { %>
        <div class="alert alert-danger alert-dismissible fade show"><%= e(error) %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
    <% } %>
    <% if (!esAdmin && yo != null) { %>
        <div class="alert alert-info">Tu rol es <strong><%= e(yo.getRol()) %></strong> y solo permite consultar. Solo el administrador puede agregar, editar o eliminar.</div>
    <% } %>

    <div class="card shadow-sm border-0 p-3">
        <!-- Filtro por un campo -->
        <form action="usuarioServlet" method="GET" class="row g-2 mb-3">
            <div class="col-md-3">
                <select name="campo" class="form-select">
                    <option value="codigo" <%= "codigo".equals(campo) ? "selected" : "" %>>Código</option>
                    <option value="nombre" <%= "nombre".equals(campo) ? "selected" : "" %>>Nombre</option>
                    <option value="email" <%= "email".equals(campo) ? "selected" : "" %>>Correo</option>
                    <option value="rol" <%= "rol".equals(campo) ? "selected" : "" %>>Rol</option>
                </select>
            </div>
            <div class="col-md-6">
                <input type="text" name="q" class="form-control" placeholder="Escribe lo que buscas" value="<%= e(q) %>">
            </div>
            <div class="col-md-3 d-flex gap-2">
                <button class="btn btn-outline-primary flex-fill" type="submit">Filtrar</button>
                <a href="usuarioServlet" class="btn btn-outline-secondary">Ver todos</a>
            </div>
        </form>

        <% if (usuarios.isEmpty()) { %>
            <p class="text-muted text-center my-4">No se encontraron resultados</p>
        <% } else { %>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th>Código</th><th>Nombre</th><th>Correo</th><th>Rol</th>
                        <% if (esAdmin) { %><th class="text-end">Acciones</th><% } %>
                    </tr>
                </thead>
                <tbody>
                <% for (Usuario u : usuarios) { %>
                    <tr>
                        <td><%= e(u.getCodigo()) %></td>
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
</main>

<jsp:include page="lib/footer.jsp"/>
