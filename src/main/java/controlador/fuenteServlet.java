package controlador;

import Modelo.FuenteHidrica;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import logica.FuenteDAO;

/** CRUD de fuentes hidricas: listar/buscar (GET), insertar, actualizar y eliminar (POST). */
@WebServlet("/fuenteServlet")
public class fuenteServlet extends HttpServlet {

    private final FuenteDAO dao = FuenteDAO.getInstancia();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession s = request.getSession();
        request.setAttribute("mensaje", s.getAttribute("mensaje"));
        s.removeAttribute("mensaje");

        if ("editar".equals(request.getParameter("accion")) && Auth.esAdmin(request)) {
            try {
                FuenteHidrica f = dao.buscar(Integer.parseInt(request.getParameter("id")));
                if (f == null) request.setAttribute("error", "La fuente hídrica no existe.");
                request.setAttribute("editando", f);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Identificador no válido.");
            }
        }
        mostrar(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        if (!Auth.esAdmin(request)) { // la interfaz ya oculta los botones; esto bloquea peticiones manipuladas
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Solo el administrador puede agregar, editar o eliminar fuentes hídricas.");
            return;
        }
        String accion = request.getParameter("accion");
        String nombre = request.getParameter("nombre");
        String tipo = request.getParameter("tipo");
        String ubicacion = request.getParameter("ubicacion");
        HttpSession sesion = request.getSession();

        try {
            if ("insertar".equals(accion)) {
                dao.crear(nombre, tipo, ubicacion);
                sesion.setAttribute("mensaje", "Fuente hídrica registrada exitosamente");
            } else if ("actualizar".equals(accion)) {
                dao.actualizar(Integer.parseInt(request.getParameter("id")), nombre, tipo, ubicacion);
                sesion.setAttribute("mensaje", "Fuente hídrica actualizada exitosamente");
            } else if ("eliminar".equals(accion)) {
                dao.eliminar(Integer.parseInt(request.getParameter("id")));
                sesion.setAttribute("mensaje", "Fuente hídrica eliminada exitosamente");
            }
            response.sendRedirect("fuenteServlet"); // Post/Redirect/Get
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e instanceof NumberFormatException ? "Identificador no válido." : e.getMessage());
            String id = request.getParameter("id");
            request.setAttribute("editando", new FuenteHidrica(
                    id != null && id.matches("\\d+") ? Integer.parseInt(id) : 0, nombre, tipo, ubicacion));
            mostrar(request, response);
        }
    }

    private void mostrar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String q = request.getParameter("q");
        request.setAttribute("q", q == null ? "" : q);
        request.setAttribute("fuentes", dao.listar(q));
        request.getRequestDispatcher("/fuentes.jsp").forward(request, response);
    }
}
