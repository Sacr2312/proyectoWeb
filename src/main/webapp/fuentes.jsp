<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, Modelo.FuenteHidrica"%>
<%!
    String e(Object o) { return logica.Util.esc(o); }
%>
<%
    // Esta pagina se alimenta desde fuenteServlet; si se abre directo, redirigimos.
    if (request.getAttribute("fuentes") == null) {
        response.sendRedirect("fuenteServlet");
        return;
    }
    @SuppressWarnings("unchecked")
    List<FuenteHidrica> fuentes = (List<FuenteHidrica>) request.getAttribute("fuentes");
    FuenteHidrica editando = (FuenteHidrica) request.getAttribute("editando");
    boolean modoEditar = editando != null && editando.getId() > 0;
    String mensaje = (String) request.getAttribute("mensaje");
    String error = (String) request.getAttribute("error");
    String q = (String) request.getAttribute("q");
    String tipoSel = editando != null && editando.getTipo() != null ? editando.getTipo() : "";
    boolean esAdmin = Servlets.Auth.esAdmin(request);
    Modelo.Usuario yo = Servlets.Auth.actual(request);
%>
<jsp:include page="lib/header.jsp"/>

<main class="container mb-5">
    <h2 class="fw-bold text-success mb-3">Gestión de Fuentes Hídricas</h2>

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
                <h5 class="fw-bold mb-3"><%= modoEditar ? "Editar fuente #" + editando.getId() : "Registrar fuente hídrica" %></h5>
                <form action="fuenteServlet" method="POST">
                    <input type="hidden" name="accion" value="<%= modoEditar ? "actualizar" : "insertar" %>">
                    <% if (modoEditar) { %><input type="hidden" name="id" value="<%= editando.getId() %>"><% } %>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Nombre de la fuente</label>
                        <input type="text" name="nombre" class="form-control" placeholder="Ej: Río Guaitara" required
                               value="<%= editando != null ? e(editando.getNombre()) : "" %>">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Tipo de fuente</label>
                        <select name="tipo" class="form-select" required>
                            <option value="">Seleccione un tipo...</option>
                            <option value="Río" <%= "Río".equals(tipoSel) ? "selected" : "" %>>Río</option>
                            <option value="Laguna" <%= "Laguna".equals(tipoSel) ? "selected" : "" %>>Laguna</option>
                            <option value="Manantial" <%= "Manantial".equals(tipoSel) ? "selected" : "" %>>Manantial</option>
                            <option value="Quebrada" <%= "Quebrada".equals(tipoSel) ? "selected" : "" %>>Quebrada</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Ubicación / Municipio</label>
                        <input type="text" name="ubicacion" class="form-control" placeholder="Ej: Pasto, Nariño" required
                               value="<%= editando != null ? e(editando.getUbicacion()) : "" %>">
                    </div>
                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-success flex-fill"><%= modoEditar ? "Guardar cambios" : "Guardar fuente" %></button>
                        <% if (editando != null) { %><a href="fuenteServlet" class="btn btn-outline-secondary">Cancelar</a><% } %>
                    </div>
                </form>
            </div>
        </div>

        <% } %>

        <!-- Listado + busqueda -->
        <div class="<%= esAdmin ? "col-lg-8" : "col-lg-12" %>">
            <div class="card shadow-sm border-0 p-3">
                <form action="fuenteServlet" method="GET" class="d-flex gap-2 mb-3">
                    <input type="text" name="q" class="form-control" placeholder="Buscar por nombre, tipo o ubicación" value="<%= e(q) %>">
                    <button class="btn btn-outline-success" type="submit">Buscar</button>
                    <% if (q != null && !q.isEmpty()) { %><a href="fuenteServlet" class="btn btn-outline-secondary">Limpiar</a><% } %>
                </form>

                <% if (fuentes.isEmpty()) { %>
                    <p class="text-muted text-center my-4">No se encontraron resultados</p>
                <% } else { %>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr><th>ID</th><th>Nombre</th><th>Tipo</th><th>Ubicación</th><% if (esAdmin) { %><th class="text-end">Acciones</th><% } %></tr>
                        </thead>
                        <tbody>
                        <% for (FuenteHidrica f : fuentes) { %>
                            <tr>
                                <td><%= f.getId() %></td>
                                <td><%= e(f.getNombre()) %></td>
                                <td><span class="badge bg-info text-dark"><%= e(f.getTipo()) %></span></td>
                                <td><%= e(f.getUbicacion()) %></td>
                                <% if (esAdmin) { %>
                                <td class="text-end">
                                    <a href="fuenteServlet?accion=editar&id=<%= f.getId() %>" class="btn btn-sm btn-outline-primary">Editar</a>
                                    <form action="fuenteServlet" method="POST" class="d-inline"
                                          onsubmit="return confirm('¿Eliminar la fuente <%= e(f.getNombre()).replace("\\", "\\\\").replace("&#39;", "\\'") %>?');">
                                        <input type="hidden" name="accion" value="eliminar">
                                        <input type="hidden" name="id" value="<%= f.getId() %>">
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
