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

/** CRUD de usuarios: listar/buscar (GET), insertar, actualizar y eliminar (POST). */
@WebServlet("/usuarioServlet")
public class UsuarioServlet extends HttpServlet {

    private final UsuarioDAO dao = UsuarioDAO.getInstancia();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        recogerMensajes(request);
        if ("editar".equals(request.getParameter("accion")) && Auth.esAdmin(request)) {
            try {
                Usuario u = dao.buscar(Integer.parseInt(request.getParameter("id")));
                if (u == null) request.setAttribute("error", "El usuario no existe.");
                request.setAttribute("editando", u);
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
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Solo el administrador puede modificar usuarios.");
            return;
        }
        String accion = request.getParameter("accion");
        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String rol = request.getParameter("rol");
        HttpSession sesion = request.getSession();

        try {
            if ("insertar".equals(accion)) {
                dao.crear(nombre, email, password, rol);
                sesion.setAttribute("mensaje", "Usuario registrado exitosamente");
            } else if ("actualizar".equals(accion)) {
                dao.actualizar(Integer.parseInt(request.getParameter("id")), nombre, email, password, rol);
                sesion.setAttribute("mensaje", "Usuario actualizado exitosamente");
            } else if ("eliminar".equals(accion)) {
                dao.eliminar(Integer.parseInt(request.getParameter("id")));
                sesion.setAttribute("mensaje", "Usuario eliminado exitosamente");
            }
            response.sendRedirect("usuarioServlet"); // Post/Redirect/Get: evita reenvio del formulario
        } catch (IllegalArgumentException e) {
            // Error de validacion: se vuelve a mostrar el formulario con lo que escribio el usuario
            request.setAttribute("error", e instanceof NumberFormatException ? "Identificador no válido." : e.getMessage());
            Usuario u = new Usuario();
            String id = request.getParameter("id");
            u.setId(id != null && id.matches("\\d+") ? Integer.parseInt(id) : 0);
            u.setNombre(nombre);
            u.setEmail(email);
            u.setRol(rol);
            request.setAttribute("editando", u);
            mostrar(request, response);
        }
    }

    private void mostrar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String q = request.getParameter("q");
        request.setAttribute("q", q == null ? "" : q);
        request.setAttribute("usuarios", dao.listar(q));
        request.getRequestDispatcher("/usuarios.jsp").forward(request, response);
    }

    /** Pasa los mensajes guardados en sesion (tras redirigir) a la peticion actual, una sola vez. */
    private void recogerMensajes(HttpServletRequest request) {
        HttpSession s = request.getSession();
        request.setAttribute("mensaje", s.getAttribute("mensaje"));
        s.removeAttribute("mensaje");
    }
}
