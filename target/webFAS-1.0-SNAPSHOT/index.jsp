<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:include page="lib/header.jsp"/>

<main class="container">
    <!-- Banner cargado desde la carpeta images -->
    <div class="row mb-4">
        <div class="col-12 text-center">
            <img src="images/Bannner.jpg" alt="Banner Fuentes Hídricas" class="img-fluid rounded shadow-sm w-100" style="max-height: 220px; object-fit: cover;">
        </div>
    </div>

    <!-- Título Principal -->
    <div class="text-center my-4">
        <h1 class="fw-bold text-primary display-6">SISTEMA DE GESTIÓN HÍDRICA</h1>
        <p class="text-muted fs-5">Plataforma para el registro y monitoreo de recursos hídricos</p>
    </div>

    <!-- Tarjetas de Navegación -->
    <div class="row justify-content-center g-4 my-2">
        <!-- Módulo de Usuarios -->
        <div class="col-md-5">
            <div class="card shadow-sm border-0 h-100 p-3 text-center">
                <div class="card-body d-flex flex-column justify-content-between">
                    <div>
                        <h4 class="fw-bold text-dark mb-2">Gestión de Usuarios</h4>
                        <p class="text-secondary small">Crea cuentas de acceso para nuevos administradores del sistema.</p>
                    </div>
                    <a href="registro.jsp" class="btn btn-primary w-100 mt-3 py-2 fw-semibold">Registrar Usuario</a>
                </div>
            </div>
        </div>

        <!-- Módulo de Fuentes Hídricas -->
        <div class="col-md-5">
            <div class="card shadow-sm border-0 h-100 p-3 text-center">
                <div class="card-body d-flex flex-column justify-content-between">
                    <div>
                        <h4 class="fw-bold text-dark mb-2">Fuentes Hídricas</h4>
                        <p class="text-secondary small">Registra ríos, lagunas, manantiales y cuencas hidrográficas.</p>
                    </div>
                    <a href="registrarFuentes.jsp" class="btn btn-success w-100 mt-3 py-2 fw-semibold">Registrar Fuentes Hídricas</a>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="lib/footer.jsp"/>