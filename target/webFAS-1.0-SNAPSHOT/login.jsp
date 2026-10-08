<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:include page="lib/header.jsp"/>

<div class="container my-5" style="max-width: 450px;">
    <div class="card shadow-sm border-0 p-4">
        <h3 class="text-center fw-bold text-dark mb-4">Iniciar Sesión</h3>
        
        <form action="login" method="POST">
            <div class="mb-3">
                <label class="form-label fw-bold">Correo Electrónico</label>
                <input type="email" name="email" class="form-control" placeholder="correo@ejemplo.com" required>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Contraseña</label>
                <input type="password" name="password" class="form-control" placeholder="********" required>
            </div>

            <button type="submit" class="btn btn-primary w-100 py-2 fw-bold mt-3">Ingresar</button>
        </form>
    </div>
</div>

<jsp:include page="lib/footer.jsp"/>