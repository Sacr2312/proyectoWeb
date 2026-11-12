package Modelo;

// Une un usuario con una fuente hidrica: quien midio, donde y que valor dio.
// Guarda los codigos y nombres tal como estaban al medir, asi el reporte no cambia
// aunque despues se edite o se elimine el usuario o la fuente.
public class MedicionCalidad {
    private String fecha;
    private String codigoFuente;
    private String nombreFuente;
    private String codigoUsuario;
    private String nombreUsuario;
    private String parametro;
    private double valor;
    private String unidad;
    private String resultado; // Cumple o No cumple

    public MedicionCalidad(String fecha, String codigoFuente, String nombreFuente, String codigoUsuario,
            String nombreUsuario, String parametro, double valor, String unidad, String resultado) {
        this.fecha = fecha;
        this.codigoFuente = codigoFuente;
        this.nombreFuente = nombreFuente;
        this.codigoUsuario = codigoUsuario;
        this.nombreUsuario = nombreUsuario;
        this.parametro = parametro;
        this.valor = valor;
        this.unidad = unidad;
        this.resultado = resultado;
    }

    public String getFecha() { return fecha; }
    public String getCodigoFuente() { return codigoFuente; }
    public String getNombreFuente() { return nombreFuente; }
    public String getCodigoUsuario() { return codigoUsuario; }
    public String getNombreUsuario() { return nombreUsuario; }
    public String getParametro() { return parametro; }
    public double getValor() { return valor; }
    public String getUnidad() { return unidad; }
    public String getResultado() { return resultado; }
}
