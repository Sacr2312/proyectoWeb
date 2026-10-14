package logica;

import Modelo.Usuario;
import java.util.ArrayList;
import java.util.List;

/**
 * Almacenamiento en memoria (se pierde al reiniciar el servidor).
 * Para usar base de datos, solo hay que reemplazar el cuerpo de estos
 * metodos; los servlets y JSP no cambian.
 */
public class UsuarioDAO {

    public static final String ADMIN = "Administrador";
    private static final int CLAVE_MIN = 6;
    // Hash de relleno: se verifica contra el cuando el correo no existe, para que el login
    // tarde lo mismo exista o no la cuenta.
    private static final String HASH_FALSO = Util.hash("relleno-sin-uso");

    private static final UsuarioDAO INSTANCIA = new UsuarioDAO();
    public static UsuarioDAO getInstancia() { return INSTANCIA; }

    private final List<Usuario> datos = new ArrayList<>();
    private int siguienteId = 1;

    private UsuarioDAO() {
        // Cuentas de prueba (una por rol). Quitarlas antes de usar el sistema "de verdad".
        crear("Administrador", "admin@hydrometric.co", "admin123", ADMIN);
        crear("Operador de Campo", "operador@hydrometric.co", "operador123", "Operador");
        crear("Estudiante Demo", "estudiante@hydrometric.co", "estudiante123", "Estudiante");
    }

    /** Devuelve el usuario si el correo y la contraseña son correctos; si no, null. */
    public Usuario autenticar(String email, String password) {
        if (email == null || password == null) return null;
        Usuario u = buscarPorEmail(email);
        // La verificacion (lenta a proposito) se hace fuera del bloqueo para no frenar a los demas.
        boolean ok = Util.verificar(password, u != null ? u.getPasswordHash() : HASH_FALSO);
        return (u != null && ok) ? u : null;
    }

    public synchronized Usuario buscarPorEmail(String email) {
        for (Usuario u : datos) if (u.getEmail().equalsIgnoreCase(email.trim())) return u;
        return null;
    }

    public synchronized List<Usuario> listar(String criterio) {
        List<Usuario> r = new ArrayList<>();
        String c = criterio == null ? "" : criterio.trim().toLowerCase();
        for (Usuario u : datos) {
            if (c.isEmpty() || u.getNombre().toLowerCase().contains(c)
                    || u.getEmail().toLowerCase().contains(c)
                    || u.getRol().toLowerCase().contains(c)) {
                r.add(u);
            }
        }
        return r;
    }

    public synchronized Usuario buscar(int id) {
        for (Usuario u : datos) if (u.getId() == id) return u;
        return null;
    }

    public synchronized void crear(String nombre, String email, String password, String rol) {
        validar(nombre, email, rol);
        validarClave(password, true);
        if (correoEnUso(email, 0)) throw new IllegalArgumentException("El usuario ya existe: ese correo ya está registrado.");
        datos.add(new Usuario(siguienteId++, nombre.trim(), email.trim(), Util.hash(password), rol));
    }

    public synchronized void actualizar(int id, String nombre, String email, String password, String rol) {
        Usuario u = buscar(id);
        if (u == null) throw new IllegalArgumentException("El usuario no existe.");
        validar(nombre, email, rol);
        validarClave(password, false);
        if (correoEnUso(email, id)) throw new IllegalArgumentException("Ese correo ya pertenece a otro usuario.");
        if (ADMIN.equals(u.getRol()) && !ADMIN.equals(rol) && contarAdmins() == 1)
            throw new IllegalArgumentException("Debe existir al menos un administrador: no se puede quitar el rol al único que hay.");
        u.setNombre(nombre.trim());
        u.setEmail(email.trim());
        u.setRol(rol);
        if (!Util.vacio(password)) u.setPasswordHash(Util.hash(password)); // contraseña opcional al editar
    }

    public synchronized void eliminar(int id) {
        Usuario u = buscar(id);
        if (u == null) throw new IllegalArgumentException("El usuario no existe.");
        if (ADMIN.equals(u.getRol()) && contarAdmins() == 1)
            throw new IllegalArgumentException("Debe existir al menos un administrador: no se puede eliminar al único que hay.");
        datos.remove(u);
    }

    private int contarAdmins() {
        int n = 0;
        for (Usuario u : datos) if (ADMIN.equals(u.getRol())) n++;
        return n;
    }

    private void validar(String nombre, String email, String rol) {
        if (Util.vacio(nombre) || Util.vacio(email) || Util.vacio(rol))
            throw new IllegalArgumentException("Faltan datos obligatorios.");
        if (!email.trim().matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$"))
            throw new IllegalArgumentException("El correo no tiene un formato válido.");
        if (!rol.equals(ADMIN) && !rol.equals("Operador") && !rol.equals("Estudiante"))
            throw new IllegalArgumentException("Rol no válido.");
    }

    private void validarClave(String password, boolean obligatoria) {
        if (Util.vacio(password)) {
            if (obligatoria) throw new IllegalArgumentException("La contraseña es obligatoria.");
            return;
        }
        if (password.length() < CLAVE_MIN)
            throw new IllegalArgumentException("La contraseña debe tener al menos " + CLAVE_MIN + " caracteres.");
    }

    private boolean correoEnUso(String email, int exceptoId) {
        for (Usuario u : datos)
            if (u.getId() != exceptoId && u.getEmail().equalsIgnoreCase(email.trim())) return true;
        return false;
    }
}
