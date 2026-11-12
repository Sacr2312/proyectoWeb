<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, Modelo.FuenteHidrica, Modelo.MedicionCalidad, Modelo.Usuario, logica.MedicionDAO"%>
<%!
    String e(Object o) { return logica.Util.esc(o); }

    // 6.5 se queda como 6.5 y 2.0 se muestra como 2
    String num(double d) { return d == Math.floor(d) ? String.valueOf((long) d) : String.valueOf(d); }
%>
<%
    // Esta pagina se alimenta desde MedicionServlet. Si alguien entra directo, se manda al servlet.
    if (request.getAttribute("desdeServlet") == null) {
        response.sendRedirect("medicionServlet");
        return;
    }
    @SuppressWarnings("unchecked")
    List<FuenteHidrica> fuentes = (List<FuenteHidrica>) request.getAttribute("fuentes");
    @SuppressWarnings("unchecked")
    List<Usuario> usuarios = (List<Usuario>) request.getAttribute("usuarios");
    @SuppressWarnings("unchecked")
    List<MedicionCalidad> mediciones = (List<MedicionCalidad>) request.getAttribute("mediciones");
    String mensaje = (String) request.getAttribute("mensaje");
    String error = (String) request.getAttribute("error");

    boolean puedeMedir = Servlets.Auth.puedeMedir(request);
    Usuario yo = Servlets.Auth.actual(request);

    // lo que la persona habia escogido, para no perderlo si hubo un error
    String fuenteSel = (String) request.getAttribute("fuenteSel");
    String usuarioSel = (String) request.getAttribute("usuarioSel");
    String parametroSel = (String) request.getAttribute("parametroSel");
    String valorSel = (String) request.getAttribute("valorSel");
    if (usuarioSel == null && yo != null) {
        usuarioSel = String.valueOf(yo.getId()); // por defecto el responsable es quien tiene la sesion
    }
%>
<jsp:include page="lib/header.jsp"/>

<main class="container mb-5">
    <h2 class="fw-bold text-primary mb-3">Calidad del agua</h2>

    <% if (mensaje != null) { %>
        <div class="alert alert-success alert-dismissible fade show"><%= e(mensaje) %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
    <% } %>
    <% if (error != null) { %>
        <div class="alert alert-danger alert-dismissible fade show"><%= e(error) %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
    <% } %>

    <div class="row g-4">
        <div class="col-lg-5">
            <!-- Registrar una medicion: une un usuario con una fuente -->
            <div class="card shadow-sm border-0 p-3 mb-4">
                <h5 class="fw-bold mb-3">Registrar medición</h5>
                <% if (!puedeMedir) { %>
                    <div class="alert alert-info mb-0">Tu rol solo permite consultar las mediciones. Pueden registrarlas el administrador y el operador.</div>
                <% } else if (fuentes.isEmpty()) { %>
                    <div class="alert alert-warning mb-0">Primero hay que registrar una fuente hídrica.</div>
                <% } else { %>
                <form action="medicionServlet" method="POST">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Fuente hídrica</label>
                        <select name="fuenteId" class="form-select" required>
                            <option value="">Seleccione una fuente...</option>
                            <% for (FuenteHidrica f : fuentes) { %>
                                <option value="<%= f.getId() %>" <%= String.valueOf(f.getId()).equals(fuenteSel) ? "selected" : "" %>><%= e(f.getCodigo()) %> - <%= e(f.getNombre()) %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Usuario responsable</label>
                        <select name="usuarioId" class="form-select" required>
                            <% for (Usuario u : usuarios) { %>
                                <option value="<%= u.getId() %>" <%= String.valueOf(u.getId()).equals(usuarioSel) ? "selected" : "" %>><%= e(u.getCodigo()) %> - <%= e(u.getNombre()) %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Parámetro</label>
                        <select name="parametro" class="form-select" required>
                            <option value="">Seleccione un parámetro...</option>
                            <% for (String p : MedicionDAO.PARAMETROS) { %>
                                <option value="<%= e(p) %>" <%= p.equals(parametroSel) ? "selected" : "" %>><%= e(p) %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Valor medido</label>
                        <input type="text" name="valor" class="form-control" inputmode="decimal" placeholder="Ejemplo: 7.2" required
                               value="<%= e(valorSel) %>">
                    </div>
                    <button type="submit" class="btn btn-primary w-100">Registrar medición</button>
                </form>
                <% } %>
            </div>

            <!-- Valores de referencia -->
            <div class="card shadow-sm border-0 p-3">
                <h5 class="fw-bold mb-1">Valores de referencia</h5>
                <p class="text-muted small">Valores aceptables para agua de consumo humano, según la Resolución 2115 de 2007.</p>
                <table class="table table-sm mb-0">
                    <thead class="table-light"><tr><th>Parámetro</th><th>Rango aceptable</th></tr></thead>
                    <tbody>
                    <% for (int i = 0; i < MedicionDAO.PARAMETROS.length; i++) { %>
                        <tr>
                            <td><%= e(MedicionDAO.PARAMETROS[i]) %></td>
                            <td><%= num(MedicionDAO.MINIMOS[i]) %> a <%= num(MedicionDAO.MAXIMOS[i]) %> <%= e(MedicionDAO.UNIDADES[i]) %></td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Mediciones registradas -->
        <div class="col-lg-7">
            <div class="card shadow-sm border-0 p-3">
                <h5 class="fw-bold mb-3">Mediciones registradas</h5>
                <% if (mediciones.isEmpty()) { %>
                    <p class="text-muted text-center my-4">Todavía no hay mediciones registradas.</p>
                <% } else { %>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr><th>Fecha</th><th>Fuente</th><th>Responsable</th><th>Parámetro</th><th>Valor</th><th>Resultado</th></tr>
                        </thead>
                        <tbody>
                        <% for (MedicionCalidad m : mediciones) { %>
                            <tr>
                                <td class="text-nowrap"><%= e(m.getFecha()) %></td>
                                <td><%= e(m.getCodigoFuente()) %> - <%= e(m.getNombreFuente()) %></td>
                                <td><%= e(m.getNombreUsuario()) %></td>
                                <td><%= e(m.getParametro()) %></td>
                                <td class="text-nowrap"><%= num(m.getValor()) %> <%= e(m.getUnidad()) %></td>
                                <td><span class="badge <%= "Cumple".equals(m.getResultado()) ? "bg-success" : "bg-danger" %>"><%= e(m.getResultado()) %></span></td>
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
