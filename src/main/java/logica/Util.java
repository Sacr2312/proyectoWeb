package logica;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public class Util {

    /** Escapa texto para mostrarlo de forma segura dentro de HTML (evita XSS). */
    public static String esc(Object o) {
        if (o == null) return "";
        return o.toString()
                .replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#39;");
    }

    public static boolean vacio(String s) {
        return s == null || s.trim().isEmpty();
    }

    /** Hash PBKDF2 con sal aleatoria. Formato: salt:hash (Base64). */
    public static String hash(String password) {
        byte[] salt = new byte[16];
        new SecureRandom().nextBytes(salt);
        return Base64.getEncoder().encodeToString(salt) + ":" + derivar(password, salt);
    }

    public static boolean verificar(String password, String almacenado) {
        String[] p = almacenado.split(":");
        if (p.length != 2) return false;
        return derivar(password, Base64.getDecoder().decode(p[0])).equals(p[1]);
    }

    private static String derivar(String password, byte[] salt) {
        try {
            PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, 65536, 256);
            byte[] h = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256").generateSecret(spec).getEncoded();
            return Base64.getEncoder().encodeToString(h);
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new IllegalStateException(e);
        }
    }
}
