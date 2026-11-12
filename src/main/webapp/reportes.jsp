<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, java.util.Map"%>
<%!
    String e(Object o) { return logica.Util.esc(o); }
%>
<%
    // Esta pagina se alimenta desde ReporteServlet. Si alguien entra directo, se manda al servlet.
    if (request.getAttribute("desdeServlet") == null) {
        response.sendRedirect("reporteServlet");
        return;
    }
    @SuppressWarnings("unchecked")
    Map<String, int[]> resumen = (Map<String, int[]>) request.getAttribute("resumen");
    @SuppressWarnings("unchecked")
    List<String> lineas = (List<String>) request.getAttribute("lineas");
    int cumplen = (Integer) request.getAttribute("cumplen");
    int noCumplen = (Integer) request.getAttribute("noCumplen");
    String carpeta = (String) request.getAttribute("carpeta");
    String error = (String) request.getAttribute("error");
%>
<jsp:include page="lib/header.jsp"/>

<main class="container mb-5">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="fw-bold text-primary mb-0">Reportes de calidad del agua</h2>
        <div class="d-flex gap-2">
            <a href="reporteServlet?accion=descargar" class="btn btn-primary">Descargar reporte.txt</a>
            <button type="button" class="btn btn-outline-secondary" onclick="window.print()">Imprimir</button>
        </div>
    </div>

    <% if (error != null) { %>
        <div class="alert alert-danger"><%= e(error) %></div>
    <% } %>

    <!-- Totales -->
    <div class="row g-3 text-center mb-4">
        <div class="col-md-4">
            <div class="card border-0 shadow-sm p-3">
                <div class="display-5 fw-bold text-primary"><%= cumplen + noCumplen %></div>
                <div class="text-secondary">Mediciones registradas</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-0 shadow-sm p-3">
                <div class="display-5 fw-bold text-success"><%= cumplen %></div>
                <div class="text-secondary">Cumplen el valor de referencia</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-0 shadow-sm p-3">
                <div class="display-5 fw-bold text-danger"><%= noCumplen %></div>
                <div class="text-secondary">No cumplen</div>
            </div>
        </div>
    </div>

    <!-- Resumen por fuente -->
    <div class="card shadow-sm border-0 p-3 mb-4">
        <h5 class="fw-bold mb-3">Resumen por fuente hídrica</h5>
        <% if (resumen.isEmpty()) { %>
            <p class="text-muted text-center my-3">Todavía no hay mediciones para resumir.</p>
        <% } else { %>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr><th>Fuente</th><th class="text-center">Mediciones</th><th class="text-center">Cumplen</th><th class="text-center">No cumplen</th></tr>
                </thead>
                <tbody>
                <% for (Map.Entry<String, int[]> fila : resumen.entrySet()) { %>
                    <tr>
                        <td><%= e(fila.getKey()) %></td>
                        <td class="text-center"><%= fila.getValue()[0] %></td>
                        <td class="text-center text-success fw-bold"><%= fila.getValue()[1] %></td>
                        <td class="text-center text-danger fw-bold"><%= fila.getValue()[2] %></td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>

    <!-- Contenido del archivo -->
    <div class="card shadow-sm border-0 p-3">
        <h5 class="fw-bold mb-1">Contenido de reporte.txt</h5>
        <p class="text-muted small">Cada línea es una medición: fecha, fuente, responsable, parámetro, valor, unidad y resultado.</p>
        <% if (lineas.isEmpty()) { %>
            <p class="text-muted text-center my-3">El archivo se crea cuando se registra la primera medición.</p>
        <% } else { %>
            <pre class="bg-light border rounded p-3 small mb-2" style="overflow-x: auto;"><% for (String linea : lineas) { %><%= e(linea) %>
<% } %></pre>
        <% } %>
        <div class="text-muted small">Los archivos usuarios.txt, items.txt y reporte.txt se guardan en la carpeta <strong><%= e(carpeta) %></strong></div>
    </div>
</main>

<jsp:include page="lib/footer.jsp"/>
