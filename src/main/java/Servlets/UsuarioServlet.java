package Servlets;

import Modelo.Usuario;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import logica.UsuarioDAO;

// Controla el CRUD de usuarios.
// GET sin accion muestra listUsers.jsp, GET con accion=nuevo o editar muestra addUsers.jsp.
// POST guarda, actualiza o elimina.
@WebServlet("/usuarioServlet")
public class UsuarioServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final transient UsuarioDAO dao = UsuarioDAO.getInstancia();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        pasarMensajes(request);
        String accion = request.getParameter("accion");

        if ("nuevo".equals(accion) || "editar".equals(accion)) {
            if (!Auth.esAdmin(request)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Solo el administrador puede agregar o editar usuarios.");
                return;
            }
            Usuario u = null;
            if ("editar".equals(accion)) {
                try {
                    u = dao.buscar(Integer.parseInt(request.getParameter("id")));
                } catch (NumberFormatException e) {
                    u = null;
                }
                if (u == null) {
                    request.getSession().setAttribute("error", "El usuario no existe.");
                    response.sendRedirect("usuarioServlet");
                    return;
                }
            }
            request.setAttribute("editando", u);
            request.setAttribute("desdeServlet", "si");
            request.getRequestDispatcher("/addUsers.jsp").forward(request, response);
            return;
        }

        // listar y filtrar por un campo
        String campo = request.getParameter("campo");
        String q = request.getParameter("q");
        request.setAttribute("usuarios", dao.filtrar(campo, q));
        request.setAttribute("campo", campo == null ? "nombre" : campo);
        request.setAttribute("q", q == null ? "" : q);
        request.setAttribute("desdeServlet", "si");
        request.getRequestDispatcher("/listUsers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        if (!Auth.esAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Solo el administrador puede modificar usuarios.");
            return;
        }

        String accion = request.getParameter("accion");
        String id = request.getParameter("id");
        String codigo = request.getParameter("codigo");
        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String rol = request.getParameter("rol");
        HttpSession sesion = request.getSession();

        try {
            if ("insertar".equals(accion)) {
                dao.agregar(codigo, nombre, email, password, rol);
                sesion.setAttribute("mensaje", "Usuario registrado exitosamente");
            } else if ("actualizar".equals(accion)) {
                dao.actualizar(Integer.parseInt(id), codigo, nombre, email, password, rol);
                sesion.setAttribute("mensaje", "Usuario actualizado exitosamente");
            } else if ("eliminar".equals(accion)) {
                dao.eliminar(Integer.parseInt(id));
                sesion.setAttribute("mensaje", "Usuario eliminado exitosamente");
            }
            response.sendRedirect("usuarioServlet"); // vuelve al listado, asi F5 no repite el formulario
        } catch (IllegalArgumentException | IllegalStateException e) {
            String mensaje = e instanceof NumberFormatException ? "Identificador no válido." : e.getMessage();
            if ("eliminar".equals(accion)) {
                sesion.setAttribute("error", mensaje);
                response.sendRedirect("usuarioServlet");
                return;
            }
            // error al guardar: se vuelve al formulario con lo que escribio la persona
            Usuario u = new Usuario();
            u.setId(id != null && id.matches("\\d{1,9}") ? Integer.parseInt(id) : 0);
            u.setCodigo(codigo);
            u.setNombre(nombre);
            u.setEmail(email);
            u.setRol(rol);
            request.setAttribute("error", mensaje);
            request.setAttribute("editando", u);
            request.setAttribute("desdeServlet", "si");
            request.getRequestDispatcher("/addUsers.jsp").forward(request, response);
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
