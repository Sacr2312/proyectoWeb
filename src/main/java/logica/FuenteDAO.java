package logica;

import Modelo.FuenteHidrica;
import java.util.ArrayList;
import java.util.List;

// Aqui estan los metodos del CRUD de fuentes hidricas. Los datos viven en un ArrayList
// y cada cambio se guarda en items.txt.
public class FuenteDAO {

    public static final String[] TIPOS = {"Río", "Laguna", "Manantial", "Quebrada"};
    private static final String ARCHIVO = "items.txt";

    private static final FuenteDAO INSTANCIA = new FuenteDAO();
    public static FuenteDAO getInstancia() { return INSTANCIA; }

    private final List<FuenteHidrica> datos = new ArrayList<>();
    private int siguienteId = 1;

    private FuenteDAO() {
        cargar();
        // La primera vez, cuando todavia no existe el archivo, se crean dos fuentes de ejemplo
        if (!Archivos.existe(ARCHIVO)) {
            try {
                agregar("FH-001", "Río Pasto", "Río", "Pasto, Nariño");
                agregar("FH-002", "Laguna de la Cocha", "Laguna", "Pasto, Nariño");
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
                if (p.length != 5) {
                    continue; // linea mal escrita, se salta
                }
                try {
                    int id = Integer.parseInt(p[0]);
                    datos.add(new FuenteHidrica(id, p[1], p[2], p[3], p[4]));
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
        for (FuenteHidrica f : datos) {
            lineas.add(f.getId() + ";" + f.getCodigo() + ";" + f.getNombre() + ";" + f.getTipo()
                    + ";" + f.getUbicacion());
        }
        Archivos.escribir(ARCHIVO, lineas);
    }

    // ---------- CRUD ----------

    public synchronized List<FuenteHidrica> listar() {
        return new ArrayList<>(datos);
    }

    // Filtra por un solo campo: codigo, nombre, tipo o ubicacion
    public synchronized List<FuenteHidrica> filtrar(String campo, String valor) {
        List<FuenteHidrica> r = new ArrayList<>();
        String v = valor == null ? "" : valor.trim().toLowerCase();
        for (FuenteHidrica f : datos) {
            String texto;
            if ("codigo".equals(campo)) {
                texto = f.getCodigo();
            } else if ("tipo".equals(campo)) {
                texto = f.getTipo();
            } else if ("ubicacion".equals(campo)) {
                texto = f.getUbicacion();
            } else {
                texto = f.getNombre();
            }
            if (v.isEmpty() || texto.toLowerCase().contains(v)) {
                r.add(f);
            }
        }
        return r;
    }

    public synchronized FuenteHidrica buscar(int id) {
        for (FuenteHidrica f : datos) {
            if (f.getId() == id) {
                return f;
            }
        }
        return null;
    }

    public synchronized void agregar(String codigo, String nombre, String tipo, String ubicacion) {
        codigo = Util.limpiar(codigo);
        nombre = Util.limpiar(nombre);
        ubicacion = Util.limpiar(ubicacion);
        validar(codigo, nombre, tipo, ubicacion);
        if (codigoEnUso(codigo, 0)) {
            throw new IllegalArgumentException("Ya existe una fuente con ese código.");
        }
        datos.add(new FuenteHidrica(siguienteId++, codigo, nombre, tipo, ubicacion));
        guardar();
    }

    public synchronized void actualizar(int id, String codigo, String nombre, String tipo, String ubicacion) {
        FuenteHidrica f = buscar(id);
        if (f == null) {
            throw new IllegalArgumentException("La fuente hídrica no existe.");
        }
        codigo = Util.limpiar(codigo);
        nombre = Util.limpiar(nombre);
        ubicacion = Util.limpiar(ubicacion);
        validar(codigo, nombre, tipo, ubicacion);
        if (codigoEnUso(codigo, id)) {
            throw new IllegalArgumentException("Ya existe otra fuente con ese código.");
        }
        f.setCodigo(codigo);
        f.setNombre(nombre);
        f.setTipo(tipo);
        f.setUbicacion(ubicacion);
        guardar();
    }

    public synchronized void eliminar(int id) {
        FuenteHidrica f = buscar(id);
        if (f == null) {
            throw new IllegalArgumentException("La fuente hídrica no existe.");
        }
        datos.remove(f);
        guardar();
    }

    // ---------- datos para la pagina principal ----------

    // cuantas fuentes hay en total
    public synchronized int contar() {
        return datos.size();
    }

    // cuantas fuentes hay de un tipo, por ejemplo Río
    public synchronized int contarPorTipo(String tipo) {
        int cantidad = 0;
        for (FuenteHidrica f : datos) {
            if (f.getTipo().equals(tipo)) {
                cantidad++;
            }
        }
        return cantidad;
    }

    // las ultimas fuentes registradas, la mas nueva primero
    public synchronized List<FuenteHidrica> ultimas(int cantidad) {
        List<FuenteHidrica> r = new ArrayList<>();
        for (int i = datos.size() - 1; i >= 0 && r.size() < cantidad; i--) {
            r.add(datos.get(i));
        }
        return r;
    }

    // ---------- validaciones ----------

    private void validar(String codigo, String nombre, String tipo, String ubicacion) {
        if (Util.vacio(codigo) || Util.vacio(nombre) || Util.vacio(tipo) || Util.vacio(ubicacion)) {
            throw new IllegalArgumentException("Faltan datos obligatorios.");
        }
        if (Util.tienePuntoYComa(codigo, nombre, ubicacion)) {
            throw new IllegalArgumentException("No uses el signo punto y coma en los campos.");
        }
        if (!codigo.matches("[A-Za-z0-9_-]{3,15}")) {
            throw new IllegalArgumentException("El código debe tener entre 3 y 15 letras, números o guiones.");
        }
        boolean tipoValido = false;
        for (String t : TIPOS) {
            if (t.equals(tipo)) {
                tipoValido = true;
            }
        }
        if (!tipoValido) {
            throw new IllegalArgumentException("Tipo de fuente no válido.");
        }
    }

    private boolean codigoEnUso(String codigo, int exceptoId) {
        for (FuenteHidrica f : datos) {
            if (f.getId() != exceptoId && f.getCodigo().equalsIgnoreCase(codigo)) {
                return true;
            }
        }
        return false;
    }
}
