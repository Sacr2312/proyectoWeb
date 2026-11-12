package logica;

import Modelo.FuenteHidrica;
import Modelo.MedicionCalidad;
import Modelo.Usuario;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

// Registra las mediciones de calidad: une un usuario con una fuente.
// Cada medicion se agrega como una linea nueva en reporte.txt.
public class MedicionDAO {

    public static final String ARCHIVO = "reporte.txt";

    // Valores de referencia para agua de consumo humano, Resolucion 2115 de 2007
    public static final String[] PARAMETROS = {"pH", "Turbidez", "Conductividad"};
    public static final String[] UNIDADES = {"unidades", "NTU", "µS/cm"};
    public static final double[] MINIMOS = {6.5, 0, 0};
    public static final double[] MAXIMOS = {9.0, 2, 1000};

    private static final MedicionDAO INSTANCIA = new MedicionDAO();
    public static MedicionDAO getInstancia() { return INSTANCIA; }

    private final List<MedicionCalidad> datos = new ArrayList<>();

    private MedicionDAO() {
        cargar();
    }

    private void cargar() {
        try {
            for (String linea : Archivos.leer(ARCHIVO)) {
                String[] p = linea.split(";", -1);
                if (p.length != 9) {
                    continue; // linea mal escrita, se salta
                }
                try {
                    datos.add(new MedicionCalidad(p[0], p[1], p[2], p[3], p[4], p[5],
                            Double.parseDouble(p[6]), p[7], p[8]));
                } catch (NumberFormatException e) {
                    // el valor no era un numero, se salta la linea
                }
            }
        } catch (IllegalStateException e) {
            System.out.println(e.getMessage());
        }
    }

    // Todas las mediciones, la mas nueva primero
    public synchronized List<MedicionCalidad> listar() {
        List<MedicionCalidad> r = new ArrayList<>();
        for (int i = datos.size() - 1; i >= 0; i--) {
            r.add(datos.get(i));
        }
        return r;
    }

    public synchronized int contar() {
        return datos.size();
    }

    public synchronized MedicionCalidad registrar(FuenteHidrica fuente, Usuario usuario, String parametro, String valorTexto) {
        if (fuente == null) {
            throw new IllegalArgumentException("Selecciona una fuente hídrica.");
        }
        if (usuario == null) {
            throw new IllegalArgumentException("Selecciona el usuario responsable.");
        }
        int pos = -1;
        for (int i = 0; i < PARAMETROS.length; i++) {
            if (PARAMETROS[i].equals(parametro)) {
                pos = i;
            }
        }
        if (pos < 0) {
            throw new IllegalArgumentException("Selecciona un parámetro de calidad.");
        }

        double valor;
        try {
            valor = Double.parseDouble(valorTexto.trim().replace(",", "."));
        } catch (NumberFormatException | NullPointerException e) {
            throw new IllegalArgumentException("El valor medido debe ser un número.");
        }
        if (Double.isNaN(valor) || Double.isInfinite(valor)) {
            throw new IllegalArgumentException("El valor medido debe ser un número.");
        }
        if (valor < 0) {
            throw new IllegalArgumentException("El valor medido no puede ser negativo.");
        }
        if (pos == 0 && valor > 14) {
            throw new IllegalArgumentException("El pH debe estar entre 0 y 14.");
        }

        String resultado = (valor >= MINIMOS[pos] && valor <= MAXIMOS[pos]) ? "Cumple" : "No cumple";
        String fecha = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
        MedicionCalidad m = new MedicionCalidad(fecha, fuente.getCodigo(), fuente.getNombre(),
                usuario.getCodigo(), usuario.getNombre(), parametro, valor, UNIDADES[pos], resultado);

        // primero el archivo, si falla no queda nada a medias en la lista
        Archivos.agregarLinea(ARCHIVO, m.getFecha() + ";" + m.getCodigoFuente() + ";" + m.getNombreFuente()
                + ";" + m.getCodigoUsuario() + ";" + m.getNombreUsuario() + ";" + m.getParametro()
                + ";" + m.getValor() + ";" + m.getUnidad() + ";" + m.getResultado());
        datos.add(m);
        return m;
    }
}
