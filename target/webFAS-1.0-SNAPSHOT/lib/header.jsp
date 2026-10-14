<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Modelo.Usuario"%>
<%
    // Usuario con sesion iniciada (null si es visitante). No crea sesion para visitantes.
    Usuario usuarioNav = controlador.Auth.actual(request);
%>
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
                    <% if (usuarioNav != null) { %>
                    <li class="nav-item"><a class="nav-link text-white" href="fuenteServlet">Fuentes Hídricas</a></li>
                    <li class="nav-item"><a class="nav-link text-white" href="usuarioServlet">Usuarios</a></li>
                    <% } %>
                </ul>
                <div class="d-flex align-items-center gap-2">
                    <% if (usuarioNav != null) { %>
                        <span class="text-white small me-2">
                            <%= logica.Util.esc(usuarioNav.getNombre()) %>
                            <span class="badge bg-light text-primary ms-1"><%= logica.Util.esc(usuarioNav.getRol()) %></span>
                        </span>
                        <form action="logout" method="POST" class="m-0">
                            <button type="submit" class="btn btn-outline-light btn-sm px-3">Cerrar Sesión</button>
                        </form>
                    <% } else { %>
                        <a href="registro.jsp" class="btn btn-light btn-sm px-3">Registrarse</a>
                        <a href="login.jsp" class="btn btn-outline-light btn-sm px-3">Iniciar Sesión</a>
                    <% } %>
                </div>
            </div>
        </div>
    </nav>
