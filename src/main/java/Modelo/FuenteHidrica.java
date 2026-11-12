package Modelo;

public class FuenteHidrica {
    private int id;
    private String codigo;
    private String nombre;
    private String tipo; // Río, Laguna, Manantial o Quebrada
    private String ubicacion;

    public FuenteHidrica() {}

    public FuenteHidrica(int id, String codigo, String nombre, String tipo, String ubicacion) {
        this.id = id;
        this.codigo = codigo;
        this.nombre = nombre;
        this.tipo = tipo;
        this.ubicacion = ubicacion;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getCodigo() { return codigo; }
    public void setCodigo(String codigo) { this.codigo = codigo; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }
    public String getUbicacion() { return ubicacion; }
    public void setUbicacion(String ubicacion) { this.ubicacion = ubicacion; }
}
