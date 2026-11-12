package Servlets;

import Modelo.MedicionCalidad;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import logica.Archivos;
import logica.MedicionDAO;

// Pagina de reportes: resume las mediciones y deja descargar reporte.txt
@WebServlet("/reporteServlet")
public class ReporteServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final transient MedicionDAO dao = MedicionDAO.getInstancia();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<String> lineas = new ArrayList<>();
        try {
            lineas = Archivos.leer(MedicionDAO.ARCHIVO);
        } catch (IllegalStateException e) {
            request.setAttribute("error", e.getMessage());
        }

        if ("descargar".equals(request.getParameter("accion"))) {
            response.setContentType("text/plain; charset=UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=\"reporte.txt\"");
            PrintWriter salida = response.getWriter();
            for (String linea : lineas) {
                salida.println(linea);
            }
            return;
        }

        // resumen por fuente: total de mediciones, cuantas cumplen y cuantas no
        List<MedicionCalidad> mediciones = dao.listar();
        Map<String, int[]> resumen = new LinkedHashMap<>();
        int cumplen = 0;
        for (MedicionCalidad m : mediciones) {
            String fuente = m.getCodigoFuente() + " - " + m.getNombreFuente();
            int[] datos = resumen.get(fuente);
            if (datos == null) {
                datos = new int[3];
                resumen.put(fuente, datos);
            }
            datos[0]++;
            if ("Cumple".equals(m.getResultado())) {
                datos[1]++;
                cumplen++;
            } else {
                datos[2]++;
            }
        }

        request.setAttribute("mediciones", mediciones);
        request.setAttribute("resumen", resumen);
        request.setAttribute("cumplen", cumplen);
        request.setAttribute("noCumplen", mediciones.size() - cumplen);
        request.setAttribute("lineas", lineas);
        request.setAttribute("carpeta", Archivos.carpeta().getAbsolutePath());
        request.setAttribute("desdeServlet", "si");
        request.getRequestDispatcher("/reportes.jsp").forward(request, response);
    }
}
