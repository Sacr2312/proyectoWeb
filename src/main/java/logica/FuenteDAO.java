package logica;

import Modelo.FuenteHidrica;
import java.util.ArrayList;
import java.util.List;

/** Almacenamiento en memoria de fuentes hidricas (ver nota en UsuarioDAO). */
public class FuenteDAO {

    private static final FuenteDAO INSTANCIA = new FuenteDAO();
    public static FuenteDAO getInstancia() { return INSTANCIA; }

    private final List<FuenteHidrica> datos = new ArrayList<>();
    private int siguienteId = 1;

    private FuenteDAO() {
        crear("Río Pasto", "Río", "Pasto, Nariño");
        crear("Laguna de la Cocha", "Laguna", "Pasto, Nariño");
    }

    public synchronized List<FuenteHidrica> listar(String criterio) {
        List<FuenteHidrica> r = new ArrayList<>();
        String c = criterio == null ? "" : criterio.trim().toLowerCase();
        for (FuenteHidrica f : datos) {
            if (c.isEmpty() || f.getNombre().toLowerCase().contains(c)
                    || f.getTipo().toLowerCase().contains(c)
                    || f.getUbicacion().toLowerCase().contains(c)) {
                r.add(f);
            }
        }
        return r;
    }

    public synchronized FuenteHidrica buscar(int id) {
        for (FuenteHidrica f : datos) if (f.getId() == id) return f;
        return null;
    }

    public synchronized void crear(String nombre, String tipo, String ubicacion) {
        validar(nombre, tipo, ubicacion);
        datos.add(new FuenteHidrica(siguienteId++, nombre.trim(), tipo, ubicacion.trim()));
    }

    public synchronized void actualizar(int id, String nombre, String tipo, String ubicacion) {
        FuenteHidrica f = buscar(id);
        if (f == null) throw new IllegalArgumentException("La fuente hídrica no existe.");
        validar(nombre, tipo, ubicacion);
        f.setNombre(nombre.trim());
        f.setTipo(tipo);
        f.setUbicacion(ubicacion.trim());
    }

    public synchronized void eliminar(int id) {
        if (!datos.removeIf(f -> f.getId() == id)) throw new IllegalArgumentException("La fuente hídrica no existe.");
    }

    private void validar(String nombre, String tipo, String ubicacion) {
        if (Util.vacio(nombre) || Util.vacio(tipo) || Util.vacio(ubicacion))
            throw new IllegalArgumentException("Faltan datos obligatorios.");
        if (!tipo.equals("Río") && !tipo.equals("Laguna") && !tipo.equals("Manantial") && !tipo.equals("Quebrada"))
            throw new IllegalArgumentException("Tipo de fuente no válido.");
    }
}
