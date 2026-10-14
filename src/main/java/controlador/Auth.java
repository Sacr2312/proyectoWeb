package controlador;

import Modelo.Usuario;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import logica.UsuarioDAO;

/**
 * Utilidades de sesion. En la sesion solo se guarda el ID del usuario; el usuario y su rol se
 * consultan en cada peticion, asi que si un administrador elimina o cambia de rol a alguien,
 * el cambio se aplica de inmediato aunque esa persona tenga la sesion abierta.
 */
public final class Auth {

    public static final String ATTR_ID = "usuarioId";
    public static final String ATTR_DESTINO = "destinoPostLogin";

    private Auth() {}

    /** Usuario con sesion iniciada, o null. No crea sesion si no existia. */
    public static Usuario actual(HttpServletRequest request) {
        HttpSession s = request.getSession(false);
        if (s == null) return null;
        Object id = s.getAttribute(ATTR_ID);
        if (!(id instanceof Integer)) return null;
        return UsuarioDAO.getInstancia().buscar((Integer) id);
    }

    public static boolean esAdmin(HttpServletRequest request) {
        Usuario u = actual(request);
        return u != null && UsuarioDAO.ADMIN.equals(u.getRol());
    }
}
