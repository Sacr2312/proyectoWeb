<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, Modelo.FuenteHidrica, Modelo.Usuario"%>
<%!
    String e(Object o) { return logica.Util.esc(o); }
%>
<%
    // Esta pagina se alimenta desde fuenteServlet. Si alguien entra directo, se manda al servlet.
    if (request.getAttribute("desdeServlet") == null) {
        response.sendRedirect("fuenteServlet");
        return;
    }
    @SuppressWarnings("unchecked")
    List<FuenteHidrica> fuentes = (List<FuenteHidrica>) request.getAttribute("fuentes");
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
        <h2 class="fw-bold text-success mb-0">Fuentes Hídricas</h2>
        <% if (esAdmin) { %><a href="fuenteServlet?accion=nuevo" class="btn btn-success">Agregar fuente</a><% } %>
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
        <form action="fuenteServlet" method="GET" class="row g-2 mb-3">
            <div class="col-md-3">
                <select name="campo" class="form-select">
                    <option value="codigo" <%= "codigo".equals(campo) ? "selected" : "" %>>Código</option>
                    <option value="nombre" <%= "nombre".equals(campo) ? "selected" : "" %>>Nombre</option>
                    <option value="tipo" <%= "tipo".equals(campo) ? "selected" : "" %>>Tipo</option>
                    <option value="ubicacion" <%= "ubicacion".equals(campo) ? "selected" : "" %>>Ubicación</option>
                </select>
            </div>
            <div class="col-md-6">
                <input type="text" name="q" class="form-control" placeholder="Escribe lo que buscas" value="<%= e(q) %>">
            </div>
            <div class="col-md-3 d-flex gap-2">
                <button class="btn btn-outline-success flex-fill" type="submit">Filtrar</button>
                <a href="fuenteServlet" class="btn btn-outline-secondary">Ver todas</a>
            </div>
        </form>

        <% if (fuentes.isEmpty()) { %>
            <p class="text-muted text-center my-4">No se encontraron resultados</p>
        <% } else { %>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th>Código</th><th>Nombre</th><th>Tipo</th><th>Ubicación</th>
                        <% if (esAdmin) { %><th class="text-end">Acciones</th><% } %>
                    </tr>
                </thead>
                <tbody>
                <% for (FuenteHidrica f : fuentes) { %>
                    <tr>
                        <td><%= e(f.getCodigo()) %></td>
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
</main>

<jsp:include page="lib/footer.jsp"/>
