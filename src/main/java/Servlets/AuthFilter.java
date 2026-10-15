package Servlets;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/** Solo deja pasar a los CRUD a quien tenga la sesion iniciada; al resto lo manda al login. */
@WebFilter(urlPatterns = {"/usuarioServlet", "/fuenteServlet", "/usuarios.jsp", "/fuentes.jsp"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        // Que el navegador no guarde estas paginas: al cerrar sesion y darle "atras" no deben verse.
        response.setHeader("Cache-Control", "no-store");

        if (Auth.actual(request) == null) {
            if ("GET".equals(request.getMethod())) {
                // Se recuerda a donde queria ir (solo rutas de esta app) para llevarlo ahi tras el login.
                String destino = request.getRequestURI().substring(request.getContextPath().length());
                if (request.getQueryString() != null) destino += "?" + request.getQueryString();
                request.getSession().setAttribute(Auth.ATTR_DESTINO, destino);
            }
            response.sendRedirect(request.getContextPath() + "/login.jsp?requiere=1");
            return;
        }
        chain.doFilter(req, res);
    }
}
