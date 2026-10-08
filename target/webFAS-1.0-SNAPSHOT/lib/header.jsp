<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HydroMetric - Portal Hídrico</title>
    <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="styles/style.css">
</head>
<body class="bg-light d-flex flex-column min-vh-100">

    <!-- Navegación -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm mb-4">
        <div class="container">
            <a class="navbar-brand fw-bold fs-4" href="index.jsp">HydroMetric</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item"><a class="nav-link text-white" href="index.jsp">Inicio</a></li>
                    <li class="nav-item"><a class="nav-link text-white" href="registrarFuentes.jsp">Fuentes Hídricas</a></li>
                    <li class="nav-item"><a class="nav-link text-white" href="registro.jsp">Registrar Usuario</a></li>
                </ul>
                <div class="d-flex">
                    <a href="login.jsp" class="btn btn-outline-light btn-sm px-3">Iniciar Sesión</a>
                </div>
            </div>
        </div>
    </nav>