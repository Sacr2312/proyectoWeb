<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, Modelo.Usuario, Modelo.FuenteHidrica, logica.FuenteDAO, logica.UsuarioDAO"%>
<%!
    String e(Object o) { return logica.Util.esc(o); }
%>
<%
    Usuario actual = Servlets.Auth.actual(request);

    // Datos para los contadores y las vistas previas
    FuenteDAO fuenteDao = FuenteDAO.getInstancia();
    int totalFuentes = fuenteDao.contar();
    int totalUsuarios = UsuarioDAO.getInstancia().contar();
    List<FuenteHidrica> ultimas = fuenteDao.ultimas(3);

    String[] tipos = {"Río", "Laguna", "Manantial", "Quebrada"};
    int[] cantidades = new int[tipos.length];
    int tiposConFuentes = 0;
    for (int i = 0; i < tipos.length; i++) {
        cantidades[i] = fuenteDao.contarPorTipo(tipos[i]);
        if (cantidades[i] > 0) {
            tiposConFuentes++;
        }
    }
%>
<jsp:include page="lib/header.jsp"/>

<main class="container mb-5">
    <!-- Banner -->
    <div class="row mb-4">
        <div class="col-12 text-center">
            <img src="images/Bannner.jpg" alt="Banner Fuentes Hídricas" class="img-fluid rounded shadow-sm w-100" style="max-height: 220px; object-fit: cover;">
        </div>
    </div>

    <!-- Presentación -->
    <section class="text-center my-4">
        <h1 class="fw-bold text-primary display-6">SISTEMA DE GESTIÓN HÍDRICA</h1>
        <p class="text-muted fs-5 mb-4">Plataforma para el registro y monitoreo de recursos hídricos</p>

        <% if (actual == null) { %>
            <a href="login.jsp" class="btn btn-primary btn-lg px-4 me-2">Iniciar sesión</a>
            <a href="registro.jsp" class="btn btn-outline-primary btn-lg px-4">Crear cuenta</a>
        <% } else { %>
            <div class="alert alert-success d-inline-block mb-3">
                Bienvenido, <strong><%= e(actual.getNombre()) %></strong>. Tu rol es <%= e(actual.getRol()) %>.
            </div>
            <div>
                <a href="fuenteServlet" class="btn btn-success px-4 me-2">Fuentes Hídricas</a>
                <a href="usuarioServlet" class="btn btn-primary px-4 me-2">Usuarios</a>
                <a href="medicionServlet" class="btn btn-info px-4 me-2">Calidad del agua</a>
                <a href="reporteServlet" class="btn btn-secondary px-4">Reportes</a>
            </div>
        <% } %>
    </section>

    <!-- ¿Qué es HydroMetric? -->
    <section class="my-5">
        <div class="card border-0 shadow-sm p-4">
            <h3 class="fw-bold text-dark">¿Qué es HydroMetric?</h3>
            <p class="text-secondary mb-0">
                HydroMetric es una plataforma web pensada para centralizar la información de las fuentes
                hídricas de la región: ríos, lagunas, manantiales y quebradas. Su objetivo es facilitar el
                registro, la consulta y el seguimiento de estos recursos para apoyar el cuidado y el uso
                responsable del agua.
            </p>
        </div>
    </section>

    <!-- Contadores en vivo -->
    <section class="my-5">
        <div class="row g-3 text-center">
            <div class="col-md-4">
                <div class="card border-0 shadow-sm p-3">
                    <div class="display-5 fw-bold text-primary"><%= totalFuentes %></div>
                    <div class="text-secondary">Fuentes hídricas registradas</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm p-3">
                    <div class="display-5 fw-bold text-success"><%= totalUsuarios %></div>
                    <div class="text-secondary">Usuarios registrados</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm p-3">
                    <div class="display-5 fw-bold text-info"><%= tiposConFuentes %> de <%= tipos.length %></div>
                    <div class="text-secondary">Tipos de fuente con registros</div>
                </div>
            </div>
        </div>
    </section>

    <!-- Vista previa: últimas fuentes -->
    <section class="my-5">
        <h3 class="fw-bold text-dark text-center mb-4">Últimas fuentes registradas</h3>
        <% if (ultimas.isEmpty()) { %>
            <p class="text-muted text-center">Todavía no hay fuentes registradas.</p>
        <% } else { %>
            <div class="row g-4">
                <% for (FuenteHidrica f : ultimas) { %>
                    <div class="col-md-4">
                        <div class="card border-0 shadow-sm h-100 p-3">
                            <span class="badge bg-info text-dark align-self-start mb-2"><%= e(f.getTipo()) %></span>
                            <h5 class="fw-bold"><%= e(f.getNombre()) %></h5>
                            <p class="text-secondary small mb-0"><%= e(f.getUbicacion()) %></p>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
        <div class="text-center mt-4">
            <a href="fuenteServlet" class="btn btn-outline-success px-4">Ver todas las fuentes</a>
        </div>
    </section>

    <!-- Fuentes por tipo -->
    <section class="my-5">
        <h3 class="fw-bold text-dark text-center mb-4">Fuentes por tipo</h3>
        <div class="card border-0 shadow-sm p-4">
            <% for (int i = 0; i < tipos.length; i++) {
                   int porcentaje = totalFuentes > 0 ? cantidades[i] * 100 / totalFuentes : 0; %>
                <div class="mb-3">
                    <div class="d-flex justify-content-between">
                        <span class="fw-bold"><%= tipos[i] %></span>
                        <span class="text-secondary"><%= cantidades[i] %></span>
                    </div>
                    <div class="progress">
                        <div class="progress-bar bg-success" style="width: <%= porcentaje %>%"></div>
                    </div>
                </div>
            <% } %>
        </div>
    </section>

    <!-- Módulos -->
    <section class="my-5">
        <h3 class="fw-bold text-dark text-center mb-4">¿Qué ofrece la plataforma?</h3>
        <div class="row g-4">
            <div class="col-md-6 col-lg-3">
                <div class="card border-0 shadow-sm h-100 p-3">
                    <span class="badge bg-success align-self-start mb-2">Disponible</span>
                    <h5 class="fw-bold">Fuentes hídricas</h5>
                    <p class="text-secondary small mb-0">Registro y consulta de ríos, lagunas, manantiales y quebradas, con su código, tipo y ubicación.</p>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="card border-0 shadow-sm h-100 p-3">
                    <span class="badge bg-success align-self-start mb-2">Disponible</span>
                    <h5 class="fw-bold">Usuarios y roles</h5>
                    <p class="text-secondary small mb-0">Cuentas de acceso con distintos perfiles: el administrador gestiona la información y los demás perfiles la consultan.</p>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="card border-0 shadow-sm h-100 p-3">
                    <span class="badge bg-success align-self-start mb-2">Disponible</span>
                    <h5 class="fw-bold">Calidad del agua</h5>
                    <p class="text-secondary small mb-0">Registro de mediciones de pH, turbidez y conductividad, que se comparan con los valores de referencia.</p>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="card border-0 shadow-sm h-100 p-3">
                    <span class="badge bg-success align-self-start mb-2">Disponible</span>
                    <h5 class="fw-bold">Reportes</h5>
                    <p class="text-secondary small mb-0">Resumen de las mediciones por fuente y descarga del archivo reporte.txt.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Cómo funciona -->
    <section class="my-5">
        <h3 class="fw-bold text-dark text-center mb-4">¿Cómo funciona?</h3>
        <div class="row g-4 text-center">
            <div class="col-md-4">
                <div class="display-6 fw-bold text-primary">1</div>
                <h5 class="fw-bold">Crea tu cuenta</h5>
                <p class="text-secondary small">Regístrate con tu correo. Las cuentas nuevas tienen rol de Estudiante.</p>
            </div>
            <div class="col-md-4">
                <div class="display-6 fw-bold text-primary">2</div>
                <h5 class="fw-bold">Inicia sesión</h5>
                <p class="text-secondary small">Con tu sesión iniciada se habilitan las secciones de Fuentes Hídricas y Usuarios.</p>
            </div>
            <div class="col-md-4">
                <div class="display-6 fw-bold text-primary">3</div>
                <h5 class="fw-bold">Consulta o gestiona</h5>
                <p class="text-secondary small">Según tu rol, puedes solo consultar la información o también modificarla.</p>
            </div>
        </div>
    </section>

    <!-- Roles y permisos -->
    <section class="my-5">
        <h3 class="fw-bold text-dark text-center mb-4">Roles y permisos</h3>
        <div class="card border-0 shadow-sm">
            <div class="table-responsive">
                <table class="table table-borderless align-middle text-center mb-0">
                    <thead class="table-light">
                        <tr><th class="text-start">Rol</th><th>Consultar</th><th>Administrar usuarios y fuentes</th><th>Registrar mediciones</th></tr>
                    </thead>
                    <tbody>
                        <tr><td class="text-start fw-bold">Administrador</td><td>Sí</td><td>Sí</td><td>Sí</td></tr>
                        <tr><td class="text-start fw-bold">Operador</td><td>Sí</td><td>No</td><td>Sí</td></tr>
                        <tr><td class="text-start fw-bold">Estudiante</td><td>Sí</td><td>No</td><td>No</td></tr>
                    </tbody>
                </table>
            </div>
        </div>
    </section>

    <!-- Cuidemos el agua -->
    <section class="my-5">
        <h3 class="fw-bold text-dark text-center mb-4">Cuidemos el agua</h3>
        <div class="row g-4">
            <div class="col-md-6 col-lg-3">
                <div class="card border-0 shadow-sm h-100 p-3">
                    <h5 class="fw-bold text-primary">Revisa las fugas</h5>
                    <p class="text-secondary small mb-0">Una llave o una tubería que gotea gasta agua todos los días. Arreglarla a tiempo es de lo más sencillo que puedes hacer.</p>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="card border-0 shadow-sm h-100 p-3">
                    <h5 class="fw-bold text-primary">Cierra la llave</h5>
                    <p class="text-secondary small mb-0">Mientras te cepillas los dientes o te enjabonas no necesitas el agua corriendo.</p>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="card border-0 shadow-sm h-100 p-3">
                    <h5 class="fw-bold text-primary">Cuida las fuentes</h5>
                    <p class="text-secondary small mb-0">No botes basura, aceite ni químicos en quebradas, ríos o desagües. Todo eso termina en el agua que usan otras personas.</p>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="card border-0 shadow-sm h-100 p-3">
                    <h5 class="fw-bold text-primary">Reutiliza el agua</h5>
                    <p class="text-secondary small mb-0">El agua con la que lavas las verduras, por ejemplo, sirve para regar las plantas.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Sobre el proyecto -->
    <section class="my-5 text-center">
        <h3 class="fw-bold text-dark">Sobre el proyecto</h3>
        <p class="text-secondary mb-0">Proyecto académico desarrollado en la clase de Algoritmos y Programación III.</p>
    </section>
</main>

<jsp:include page="lib/footer.jsp"/>
