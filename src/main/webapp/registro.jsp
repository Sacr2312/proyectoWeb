<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:include page="lib/header.jsp"/>

<div class="container my-5" style="max-width: 500px;">
    <div class="card shadow-sm border-0 p-4">
        <h3 class="text-center fw-bold text-primary mb-4">Registro de Usuario</h3>
        
        <form action="registro" method="POST">
            <div class="mb-3">
                <label class="form-label fw-bold">Nombre Completo</label>
                <input type="text" name="nombre" class="form-control" placeholder="Ingresa tu nombre" required>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Correo Electrónico</label>
                <input type="email" name="email" class="form-control" placeholder="correo@ejemplo.com" required>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Contraseña</label>
                <input type="password" name="password" class="form-control" placeholder="********" required>
            </div>

            <button type="submit" class="btn btn-primary w-100 py-2 fw-bold mt-3">Crear Cuenta</button>
            <div class="text-center mt-3">
                <a href="login.jsp" class="small text-decoration-none">¿Ya tienes cuenta? Inicia sesión</a>
            </div>
        </form>
    </div>
</div>

<jsp:include page="lib/footer.jsp"/>