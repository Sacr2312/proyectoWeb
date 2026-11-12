package Servlets;

import Modelo.FuenteHidrica;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import logica.FuenteDAO;

// Controla el CRUD de fuentes hidricas, que son los items del proyecto.
// GET sin accion muestra listItems.jsp, GET con accion=nuevo o editar muestra addItems.jsp.
// POST guarda, actualiza o elimina.
@WebServlet("/fuenteServlet")
public class fuenteServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final transient FuenteDAO dao = FuenteDAO.getInstancia();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        pasarMensajes(request);
        String accion = request.getParameter("accion");

        if ("nuevo".equals(accion) || "editar".equals(accion)) {
            if (!Auth.esAdmin(request)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Solo el administrador puede agregar o editar fuentes hídricas.");
                return;
            }
            FuenteHidrica f = null;
            if ("editar".equals(accion)) {
                try {
                    f = dao.buscar(Integer.parseInt(request.getParameter("id")));
                } catch (NumberFormatException e) {
                    f = null;
                }
                if (f == null) {
                    request.getSession().setAttribute("error", "La fuente hídrica no existe.");
                    response.sendRedirect("fuenteServlet");
                    return;
                }
            }
            request.setAttribute("editando", f);
            request.setAttribute("desdeServlet", "si");
            request.getRequestDispatcher("/addItems.jsp").forward(request, response);
            return;
        }

        // listar y filtrar por un campo
        String campo = request.getParameter("campo");
        String q = request.getParameter("q");
        request.setAttribute("fuentes", dao.filtrar(campo, q));
        request.setAttribute("campo", campo == null ? "nombre" : campo);
        request.setAttribute("q", q == null ? "" : q);
        request.setAttribute("desdeServlet", "si");
        request.getRequestDispatcher("/listItems.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        if (!Auth.esAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Solo el administrador puede agregar, editar o eliminar fuentes hídricas.");
            return;
        }

        String accion = request.getParameter("accion");
        String id = request.getParameter("id");
        String codigo = request.getParameter("codigo");
        String nombre = request.getParameter("nombre");
        String tipo = request.getParameter("tipo");
        String ubicacion = request.getParameter("ubicacion");
        HttpSession sesion = request.getSession();

        try {
            if ("insertar".equals(accion)) {
                dao.agregar(codigo, nombre, tipo, ubicacion);
                sesion.setAttribute("mensaje", "Fuente hídrica registrada exitosamente");
            } else if ("actualizar".equals(accion)) {
                dao.actualizar(Integer.parseInt(id), codigo, nombre, tipo, ubicacion);
                sesion.setAttribute("mensaje", "Fuente hídrica actualizada exitosamente");
            } else if ("eliminar".equals(accion)) {
                dao.eliminar(Integer.parseInt(id));
                sesion.setAttribute("mensaje", "Fuente hídrica eliminada exitosamente");
            }
            response.sendRedirect("fuenteServlet"); // vuelve al listado, asi F5 no repite el formulario
        } catch (IllegalArgumentException | IllegalStateException e) {
            String mensaje = e instanceof NumberFormatException ? "Identificador no válido." : e.getMessage();
            if ("eliminar".equals(accion)) {
                sesion.setAttribute("error", mensaje);
                response.sendRedirect("fuenteServlet");
                return;
            }
            // error al guardar: se vuelve al formulario con lo que escribio la persona
            int idNumero = id != null && id.matches("\\d{1,9}") ? Integer.parseInt(id) : 0;
            request.setAttribute("error", mensaje);
            request.setAttribute("editando", new FuenteHidrica(idNumero, codigo, nombre, tipo, ubicacion));
            request.setAttribute("desdeServlet", "si");
            request.getRequestDispatcher("/addItems.jsp").forward(request, response);
        }
    }

    // Pasa los mensajes guardados en la sesion a la pagina, una sola vez
    private void pasarMensajes(HttpServletRequest request) {
        HttpSession s = request.getSession();
        request.setAttribute("mensaje", s.getAttribute("mensaje"));
        request.setAttribute("error", s.getAttribute("error"));
        s.removeAttribute("mensaje");
        s.removeAttribute("error");
    }
}
