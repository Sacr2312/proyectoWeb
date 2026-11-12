<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Modelo.FuenteHidrica, logica.FuenteDAO"%>
<%!
    String e(Object o) { return logica.Util.esc(o); }
%>
<%
    // Esta pagina se abre desde fuenteServlet. Si alguien entra directo, se manda al servlet.
    if (request.getAttribute("desdeServlet") == null) {
        response.sendRedirect("fuenteServlet?accion=nuevo");
        return;
    }
    FuenteHidrica editando = (FuenteHidrica) request.getAttribute("editando");
    boolean modoEditar = editando != null && editando.getId() > 0;
    String error = (String) request.getAttribute("error");
    String tipoSel = editando != null && editando.getTipo() != null ? editando.getTipo() : "";
%>
<jsp:include page="lib/header.jsp"/>

<main class="container mb-5" style="max-width: 620px;">
    <h2 class="fw-bold text-success mb-3"><%= modoEditar ? "Editar fuente hídrica" : "Agregar fuente hídrica" %></h2>

    <% if (error != null) { %>
        <div class="alert alert-danger alert-dismissible fade show"><%= e(error) %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
    <% } %>

    <div class="card shadow-sm border-0 p-4">
        <form action="fuenteServlet" method="POST">
            <input type="hidden" name="accion" value="<%= modoEditar ? "actualizar" : "insertar" %>">
            <% if (modoEditar) { %><input type="hidden" name="id" value="<%= editando.getId() %>"><% } %>

            <div class="mb-3">
                <label class="form-label fw-bold">Código único</label>
                <input type="text" name="codigo" class="form-control" placeholder="Ejemplo: FH-010" required
                       minlength="3" maxlength="15" pattern="[A-Za-z0-9_\-]{3,15}"
                       title="Entre 3 y 15 letras, números o guiones"
                       value="<%= editando != null ? e(editando.getCodigo()) : "" %>">
                <div class="form-text">Entre 3 y 15 letras, números o guiones. No se puede repetir.</div>
            </div>
            <div class="mb-3">
                <label class="form-label fw-bold">Nombre de la fuente</label>
                <input type="text" name="nombre" class="form-control" placeholder="Ejemplo: Río Guaitara" required
                       value="<%= editando != null ? e(editando.getNombre()) : "" %>">
            </div>
            <div class="mb-3">
                <label class="form-label fw-bold">Tipo de fuente</label>
                <select name="tipo" class="form-select" required>
                    <option value="">Seleccione un tipo...</option>
                    <% for (String t : FuenteDAO.TIPOS) { %>
                        <option value="<%= e(t) %>" <%= t.equals(tipoSel) ? "selected" : "" %>><%= e(t) %></option>
                    <% } %>
                </select>
            </div>
            <div class="mb-3">
                <label class="form-label fw-bold">Ubicación o municipio</label>
                <input type="text" name="ubicacion" class="form-control" placeholder="Ejemplo: Pasto, Nariño" required
                       value="<%= editando != null ? e(editando.getUbicacion()) : "" %>">
            </div>
            <div class="d-flex gap-2">
                <button type="submit" class="btn btn-success flex-fill"><%= modoEditar ? "Guardar cambios" : "Guardar fuente" %></button>
                <a href="fuenteServlet" class="btn btn-outline-secondary">Cancelar</a>
            </div>
        </form>
    </div>
</main>

<jsp:include page="lib/footer.jsp"/>
