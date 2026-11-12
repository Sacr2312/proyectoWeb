package logica;

import Modelo.Usuario;
import java.util.ArrayList;
import java.util.List;

// Aqui estan los metodos del CRUD de usuarios. Los datos viven en un ArrayList
// y cada cambio se guarda en usuarios.txt.
public class UsuarioDAO {

    public static final String ADMIN = "Administrador";
    private static final String ARCHIVO = "usuarios.txt";
    private static final int CLAVE_MIN = 6;
    // Se usa cuando el correo no existe, para que el login tarde igual
    private static final String HASH_FALSO = Util.hash("relleno-sin-uso");

    private static final UsuarioDAO INSTANCIA = new UsuarioDAO();
    public static UsuarioDAO getInstancia() { return INSTANCIA; }

    private final List<Usuario> datos = new ArrayList<>();
    private int siguienteId = 1;

    private UsuarioDAO() {
        cargar();
        // La primera vez, cuando todavia no existe el archivo, se crean las cuentas de prueba
        if (!Archivos.existe(ARCHIVO)) {
            try {
                agregar("USR-001", "Administrador", "admin@hydrometric.co", "admin123", ADMIN);
                agregar("USR-002", "Operador de Campo", "operador@hydrometric.co", "operador123", "Operador");
                agregar("USR-003", "Estudiante Demo", "estudiante@hydrometric.co", "estudiante123", "Estudiante");
            } catch (IllegalStateException e) {
                System.out.println(e.getMessage());
            }
        }
    }

    // ---------- archivo ----------

    private void cargar() {
        try {
            for (String linea : Archivos.leer(ARCHIVO)) {
                String[] p = linea.split(";", -1);
                if (p.length != 6) {
                    continue; // linea mal escrita, se salta
                }
                try {
                    int id = Integer.parseInt(p[0]);
                    datos.add(new Usuario(id, p[1], p[2], p[3], p[4], p[5]));
                    if (id >= siguienteId) {
                        siguienteId = id + 1;
                    }
                } catch (NumberFormatException e) {
                    // el id no era un numero, se salta la linea
                }
            }
        } catch (IllegalStateException e) {
            System.out.println(e.getMessage());
        }
    }

    private void guardar() {
        List<String> lineas = new ArrayList<>();
        for (Usuario u : datos) {
            lineas.add(u.getId() + ";" + u.getCodigo() + ";" + u.getNombre() + ";" + u.getEmail()
                    + ";" + u.getPasswordHash() + ";" + u.getRol());
        }
        Archivos.escribir(ARCHIVO, lineas);
    }

    // ---------- login ----------

    // Devuelve el usuario si el correo y la clave son correctos, si no devuelve null
    public Usuario autenticar(String email, String password) {
        if (email == null || password == null) {
            return null;
        }
        Usuario u = buscarPorEmail(email);
        boolean ok = Util.verificar(password, u != null ? u.getPasswordHash() : HASH_FALSO);
        return (u != null && ok) ? u : null;
    }

    public synchronized Usuario buscarPorEmail(String email) {
        for (Usuario u : datos) {
            if (u.getEmail().equalsIgnoreCase(email.trim())) {
                return u;
            }
        }
        return null;
    }

    // ---------- CRUD ----------

    public synchronized List<Usuario> listar() {
        return new ArrayList<>(datos);
    }

    // Filtra por un solo campo: codigo, nombre, email o rol
    public synchronized List<Usuario> filtrar(String campo, String valor) {
        List<Usuario> r = new ArrayList<>();
        String v = valor == null ? "" : valor.trim().toLowerCase();
        for (Usuario u : datos) {
            String texto;
            if ("codigo".equals(campo)) {
                texto = u.getCodigo();
            } else if ("email".equals(campo)) {
                texto = u.getEmail();
            } else if ("rol".equals(campo)) {
                texto = u.getRol();
            } else {
                texto = u.getNombre();
            }
            if (v.isEmpty() || texto.toLowerCase().contains(v)) {
                r.add(u);
            }
        }
        return r;
    }

    public synchronized Usuario buscar(int id) {
        for (Usuario u : datos) {
            if (u.getId() == id) {
                return u;
            }
        }
        return null;
    }

    public synchronized void agregar(String codigo, String nombre, String email, String password, String rol) {
        codigo = Util.limpiar(codigo);
        nombre = Util.limpiar(nombre);
        email = Util.limpiar(email);
        validar(codigo, nombre, email, rol);
        validarClave(password, true);
        if (codigoEnUso(codigo, 0)) {
            throw new IllegalArgumentException("Ya existe un usuario con ese código.");
        }
        if (correoEnUso(email, 0)) {
            throw new IllegalArgumentException("El usuario ya existe: ese correo ya está registrado.");
        }
        datos.add(new Usuario(siguienteId++, codigo, nombre, email, Util.hash(password), rol));
        guardar();
    }

    public synchronized void actualizar(int id, String codigo, String nombre, String email, String password, String rol) {
        Usuario u = buscar(id);
        if (u == null) {
            throw new IllegalArgumentException("El usuario no existe.");
        }
        codigo = Util.limpiar(codigo);
        nombre = Util.limpiar(nombre);
        email = Util.limpiar(email);
        validar(codigo, nombre, email, rol);
        validarClave(password, false);
        if (codigoEnUso(codigo, id)) {
            throw new IllegalArgumentException("Ya existe otro usuario con ese código.");
        }
        if (correoEnUso(email, id)) {
            throw new IllegalArgumentException("Ese correo ya pertenece a otro usuario.");
        }
        if (ADMIN.equals(u.getRol()) && !ADMIN.equals(rol) && contarAdmins() == 1) {
            throw new IllegalArgumentException("Debe existir al menos un administrador, no se puede quitar el rol al único que hay.");
        }
        u.setCodigo(codigo);
        u.setNombre(nombre);
        u.setEmail(email);
        u.setRol(rol);
        if (!Util.vacio(password)) {
            u.setPasswordHash(Util.hash(password)); // la clave es opcional al editar
        }
        guardar();
    }

    public synchronized void eliminar(int id) {
        Usuario u = buscar(id);
        if (u == null) {
            throw new IllegalArgumentException("El usuario no existe.");
        }
        if (ADMIN.equals(u.getRol()) && contarAdmins() == 1) {
            throw new IllegalArgumentException("Debe existir al menos un administrador, no se puede eliminar al único que hay.");
        }
        datos.remove(u);
        guardar();
    }

    public synchronized int contar() {
        return datos.size();
    }

    // Codigo nuevo para quien se registra solo, por ejemplo USR-004
    public synchronized String generarCodigo() {
        int numero = datos.size() + 1;
        String codigo = String.format("USR-%03d", numero);
        while (codigoEnUso(codigo, 0)) {
            numero++;
            codigo = String.format("USR-%03d", numero);
        }
        return codigo;
    }

    // ---------- validaciones ----------

    private int contarAdmins() {
        int n = 0;
        for (Usuario u : datos) {
            if (ADMIN.equals(u.getRol())) {
                n++;
            }
        }
        return n;
    }

    private void validar(String codigo, String nombre, String email, String rol) {
        if (Util.vacio(codigo) || Util.vacio(nombre) || Util.vacio(email) || Util.vacio(rol)) {
            throw new IllegalArgumentException("Faltan datos obligatorios.");
        }
        if (Util.tienePuntoYComa(codigo, nombre, email)) {
            throw new IllegalArgumentException("No uses el signo punto y coma en los campos.");
        }
        if (!codigo.matches("[A-Za-z0-9_-]{3,15}")) {
            throw new IllegalArgumentException("El código debe tener entre 3 y 15 letras, números o guiones.");
        }
        if (!email.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
            throw new IllegalArgumentException("El correo no tiene un formato válido.");
        }
        if (!rol.equals(ADMIN) && !rol.equals("Operador") && !rol.equals("Estudiante")) {
            throw new IllegalArgumentException("Rol no válido.");
        }
    }

    private void validarClave(String password, boolean obligatoria) {
        if (Util.vacio(password)) {
            if (obligatoria) {
                throw new IllegalArgumentException("La contraseña es obligatoria.");
            }
            return;
        }
        if (password.length() < CLAVE_MIN) {
            throw new IllegalArgumentException("La contraseña debe tener al menos " + CLAVE_MIN + " caracteres.");
        }
    }

    private boolean codigoEnUso(String codigo, int exceptoId) {
        for (Usuario u : datos) {
            if (u.getId() != exceptoId && u.getCodigo().equalsIgnoreCase(codigo)) {
                return true;
            }
        }
        return false;
    }

    private boolean correoEnUso(String email, int exceptoId) {
        for (Usuario u : datos) {
            if (u.getId() != exceptoId && u.getEmail().equalsIgnoreCase(email)) {
                return true;
            }
        }
        return false;
    }
}
