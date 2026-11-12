package logica;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

// Lee y escribe los archivos txt. Todo error de archivo se convierte en un mensaje claro.
public class Archivos {

    // Carpeta donde quedan usuarios.txt, items.txt y reporte.txt
    public static File carpeta() {
        String ruta = System.getProperty("hydrometric.datos");
        if (ruta == null) {
            ruta = System.getProperty("user.home") + File.separator + "HydroMetric";
        }
        File carpeta = new File(ruta);
        if (!carpeta.exists()) {
            carpeta.mkdirs();
        }
        return carpeta;
    }

    public static boolean existe(String nombre) {
        return new File(carpeta(), nombre).exists();
    }

    public static List<String> leer(String nombre) {
        List<String> lineas = new ArrayList<>();
        File archivo = new File(carpeta(), nombre);
        if (!archivo.exists()) {
            return lineas;
        }
        try (BufferedReader lector = new BufferedReader(
                new InputStreamReader(new FileInputStream(archivo), StandardCharsets.UTF_8))) {
            String linea;
            while ((linea = lector.readLine()) != null) {
                if (!linea.trim().isEmpty()) {
                    lineas.add(linea);
                }
            }
        } catch (IOException e) {
            throw new IllegalStateException("No se pudo leer el archivo " + nombre);
        }
        return lineas;
    }

    // Reemplaza todo el contenido del archivo
    public static void escribir(String nombre, List<String> lineas) {
        File archivo = new File(carpeta(), nombre);
        try (BufferedWriter escritor = new BufferedWriter(
                new OutputStreamWriter(new FileOutputStream(archivo), StandardCharsets.UTF_8))) {
            for (String linea : lineas) {
                escritor.write(linea);
                escritor.newLine();
            }
        } catch (IOException e) {
            throw new IllegalStateException("No se pudo guardar el archivo " + nombre);
        }
    }

    // Agrega una linea al final del archivo
    public static void agregarLinea(String nombre, String linea) {
        File archivo = new File(carpeta(), nombre);
        try (BufferedWriter escritor = new BufferedWriter(
                new OutputStreamWriter(new FileOutputStream(archivo, true), StandardCharsets.UTF_8))) {
            escritor.write(linea);
            escritor.newLine();
        } catch (IOException e) {
            throw new IllegalStateException("No se pudo guardar el archivo " + nombre);
        }
    }
}
