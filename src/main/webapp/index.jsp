<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Modelo.Usuario"%>
<%!
    String e(Object o) { return logica.Util.esc(o); }
%>
<%
    Usuario actual = controlador.Auth.actual(request);
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
                Bienvenido, <strong><%= e(actual.getNombre()) %></strong> (<%= e(actual.getRol()) %>)
            </div>
            <div>
                <a href="fuenteServlet" class="btn btn-success px-4 me-2">Fuentes Hídricas</a>
                <a href="usuarioServlet" class="btn btn-primary px-4">Usuarios</a>
            </div>
        <% } %>
    </section>

    <!-- BORRADOR: ¿Qué es HydroMetric? -->
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

    <!-- BORRADOR: Módulos -->
    <section class="my-5">
        <h3 class="fw-bold text-dark text-center mb-4">¿Qué ofrece la plataforma?</h3>
        <div class="row g-4">
            <div class="col-md-6 col-lg-3">
                <div class="card border-0 shadow-sm h-100 p-3">
                    <span class="badge bg-success align-self-start mb-2">Disponible</span>
                    <h5 class="fw-bold">Fuentes hídricas</h5>
                    <p class="text-secondary small mb-0">Registro y consulta de ríos, lagunas, manantiales y quebradas, con su tipo y ubicación.</p>
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
                    <span class="badge bg-secondary align-self-start mb-2">Próximamente</span>
                    <h5 class="fw-bold">Calidad del agua</h5>
                    <p class="text-secondary small mb-0">Registro de mediciones (pH, turbidez, entre otras) y comparación con los rangos permitidos.</p>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="card border-0 shadow-sm h-100 p-3">
                    <span class="badge bg-secondary align-self-start mb-2">Próximamente</span>
                    <h5 class="fw-bold">Reportes</h5>
                    <p class="text-secondary small mb-0">Generación de reportes sobre el estado de las fuentes y su monitoreo ambiental.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- BORRADOR: Cómo funciona -->
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

    <!-- BORRADOR: Roles y permisos -->
    <section class="my-5">
        <h3 class="fw-bold text-dark text-center mb-4">Roles y permisos</h3>
        <div class="card border-0 shadow-sm">
            <div class="table-responsive">
                <table class="table table-borderless align-middle text-center mb-0">
                    <thead class="table-light">
                        <tr><th class="text-start">Rol</th><th>Consultar</th><th>Crear, editar y eliminar</th></tr>
                    </thead>
                    <tbody>
                        <tr><td class="text-start fw-bold">Administrador</td><td>Sí</td><td>Sí</td></tr>
                        <tr><td class="text-start fw-bold">Operador</td><td>Sí</td><td>No</td></tr>
                        <tr><td class="text-start fw-bold">Estudiante</td><td>Sí</td><td>No</td></tr>
                    </tbody>
                </table>
            </div>
        </div>
    </section>

    <!-- BORRADOR: Sobre el proyecto -->
    <section class="my-5 text-center">
        <h3 class="fw-bold text-dark">Sobre el proyecto</h3>
        <p class="text-secondary mb-0">Proyecto académico desarrollado en la clase de Algoritmos y Programación III.</p>
    </section>
</main>

<jsp:include page="lib/footer.jsp"/>
