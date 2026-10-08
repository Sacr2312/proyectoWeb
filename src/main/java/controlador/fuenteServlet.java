package controlador;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Modelo.FuenteHidrica;

@WebServlet("/fuenteServlet")
public class fuenteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");

        if ("insertar".equals(accion)) {
            String nombre = request.getParameter("nombre");
            String tipo = request.getParameter("tipo");
            String ubicacion = request.getParameter("ubicacion");

            // Crear el objeto del modelo
            FuenteHidrica fuente = new FuenteHidrica(0, nombre, tipo, ubicacion);
            
            // Aquí puedes llamar a tu conexión o clase DAO para guardar en DB
            // System.out.println("Fuente guardada: " + fuente.getNombre());

            // Redirigir de nuevo al inicio
            response.sendRedirect("index.jsp");
        }
    }
}