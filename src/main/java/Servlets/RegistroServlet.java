package Servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import logica.UsuarioDAO;

/** Registro abierto al publico. El rol NO se lee del formulario: toda cuenta nueva es "Estudiante". */
@WebServlet("/registro")
public class RegistroServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/registro.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        if (Auth.actual(request) != null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        String password = request.getParameter("password");
        try {
            if (password == null || !password.equals(request.getParameter("confirmar")))
                throw new IllegalArgumentException("Las contraseñas no coinciden.");
            UsuarioDAO.getInstancia().crear(request.getParameter("nombre"), request.getParameter("email"),
                    password, "Estudiante");
            response.sendRedirect(request.getContextPath() + "/login.jsp?registrado=1");
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/registro.jsp").forward(request, response);
        }
    }
}
