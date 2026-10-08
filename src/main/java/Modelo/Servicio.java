/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Modelo;

/**
 *
 * @author Internet
 */
public class Servicio {
    
    private String idServicio;
    private String idCliente;
    private String idFuente;
    private double metrosCubicosConsumidos;
    private String fechaLectura;
    
    public Servicio(){}
    
    public Servicio(String idServicio, String idCliente, String idFuente, double metrosCubicosConsumidos, String fechaLectura) {
        this.idServicio = idServicio;
        this.idCliente = idCliente;
        this.idFuente = idFuente;
        this.metrosCubicosConsumidos = metrosCubicosConsumidos;
        this.fechaLectura = fechaLectura; 
    }
    
    public String getIdServicio() { return idServicio; }
    public void setIdServicio(String idServicio) { this.idServicio = idServicio; }
    public String getIdCliente() { return idCliente; }
    public void setIdCliente(String idCliente) { this.idCliente = idCliente; }
    public String getIdFuente() { return idFuente; }
    public void setIdFuente(String idFuente) { this.idFuente = idFuente; }
    public double getMetrosCubicosConsumidos() { return metrosCubicosConsumidos; }
    public void setMetrosCubicosConsumidos(double metrosCubicosConsumidos) { this.metrosCubicosConsumidos = metrosCubicosConsumidos; }
    public String getFechaLectura() { return fechaLectura; }
    public void setFechaLectura(String fechaLectura){ this.fechaLectura = fechaLectura; }
}
