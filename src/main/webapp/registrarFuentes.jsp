<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:include page="lib/header.jsp"/>

<div class="container my-5" style="max-width: 600px;">
    <div class="card shadow-sm border-0 p-4">
        <h3 class="text-center fw-bold text-success mb-4">Registrar Fuente Hídrica</h3>
        
        <form action="fuenteServlet" method="POST">
            <input type="hidden" name="accion" value="insertar">

            <div class="mb-3">
                <label class="form-label fw-bold">Nombre de la Fuente</label>
                <input type="text" name="nombre" class="form-control" placeholder="Ej: Río Guaitara" required>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Tipo de Fuente</label>
                <select name="tipo" class="form-select" required>
                    <option value="">Seleccione un tipo...</option>
                    <option value="Río">Río</option>
                    <option value="Laguna">Laguna</option>
                    <option value="Manantial">Manantial</option>
                    <option value="Quebrada">Quebrada</option>
                </select>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Ubicación / Municipio</label>
                <input type="text" name="ubicacion" class="form-control" placeholder="Ej: Pasto, Nariño" required>
            </div>

            <div class="d-flex gap-2 mt-4">
                <button type="submit" class="btn btn-success flex-fill">Guardar Fuente</button>
                <a href="index.jsp" class="btn btn-outline-secondary flex-fill">Volver al Inicio</a>
            </div>
        </form>
    </div>
</div>

<jsp:include page="lib/footer.jsp"/>