package Modelo;

public class Usuario {
    private int id;
    private String codigo;
    private String nombre;
    private String email;
    private String passwordHash;
    private String rol; // Administrador, Operador, Estudiante

    public Usuario() {}

    public Usuario(int id, String codigo, String nombre, String email, String passwordHash, String rol) {
        this.id = id;
        this.codigo = codigo;
        this.nombre = nombre;
        this.email = email;
        this.passwordHash = passwordHash;
        this.rol = rol;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getCodigo() { return codigo; }
    public void setCodigo(String codigo) { this.codigo = codigo; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
    public String getRol() { return rol; }
    public void setRol(String rol) { this.rol = rol; }
}
