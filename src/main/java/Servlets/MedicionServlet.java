package Servlets;

import Modelo.FuenteHidrica;
import Modelo.MedicionCalidad;
import Modelo.Usuario;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import logica.FuenteDAO;
import logica.MedicionDAO;
import logica.UsuarioDAO;

// Pagina de calidad del agua: une un usuario con una fuente al registrar una medicion.
// Pueden registrar el administrador y el operador, todos pueden ver el listado.
@WebServlet("/medicionServlet")
public class MedicionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final transient MedicionDAO dao = MedicionDAO.getInstancia();
    private final transient FuenteDAO fuenteDao = FuenteDAO.getInstancia();
    private final transient UsuarioDAO usuarioDao = UsuarioDAO.getInstancia();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession s = request.getSession();
        request.setAttribute("mensaje", s.getAttribute("mensaje"));
        s.removeAttribute("mensaje");
        mostrar(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        if (!Auth.puedeMedir(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Solo el administrador y el operador pueden registrar mediciones.");
            return;
        }

        try {
            FuenteHidrica fuente = fuenteDao.buscar(numero(request.getParameter("fuenteId")));
            Usuario usuario = usuarioDao.buscar(numero(request.getParameter("usuarioId")));
            MedicionCalidad m = dao.registrar(fuente, usuario, request.getParameter("parametro"),
                    request.getParameter("valor"));
            request.getSession().setAttribute("mensaje", "Medición registrada. Resultado: " + m.getResultado());
            response.sendRedirect("medicionServlet");
        } catch (IllegalArgumentException | IllegalStateException e) {
            // error: se vuelve a mostrar la pagina con lo que escribio la persona
            request.setAttribute("error", e.getMessage());
            request.setAttribute("fuenteSel", request.getParameter("fuenteId"));
            request.setAttribute("usuarioSel", request.getParameter("usuarioId"));
            request.setAttribute("parametroSel", request.getParameter("parametro"));
            request.setAttribute("valorSel", request.getParameter("valor"));
            mostrar(request, response);
        }
    }

    private void mostrar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("fuentes", fuenteDao.listar());
        request.setAttribute("usuarios", usuarioDao.listar());
        request.setAttribute("mediciones", dao.listar());
        request.setAttribute("desdeServlet", "si");
        request.getRequestDispatcher("/calidad.jsp").forward(request, response);
    }

    // Convierte el texto en numero, si no se puede devuelve 0 que no es ningun id
    private int numero(String texto) {
        try {
            return Integer.parseInt(texto);
        } catch (NumberFormatException e) {
            return 0;
        }
    }
}
