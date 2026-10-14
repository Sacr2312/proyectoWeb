package controlador;

import Modelo.Usuario;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import logica.UsuarioDAO;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        Usuario u = UsuarioDAO.getInstancia().autenticar(
                request.getParameter("email"), request.getParameter("password"));

        if (u == null) {
            // Mismo mensaje exista o no el correo, para no revelar que cuentas existen.
            request.setAttribute("error", "Correo o contraseña incorrectos.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        HttpSession sesion = request.getSession();
        request.changeSessionId(); // nuevo ID de sesion al iniciar sesion (evita fijacion de sesion)
        sesion.setAttribute(Auth.ATTR_ID, u.getId());

        String destino = (String) sesion.getAttribute(Auth.ATTR_DESTINO);
        sesion.removeAttribute(Auth.ATTR_DESTINO);
        response.sendRedirect(request.getContextPath() + (destino != null ? destino : "/index.jsp"));
    }
}
