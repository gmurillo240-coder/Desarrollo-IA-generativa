package utilidades;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;

/**
 * Utilidades de seguridad para IAGenerativaWeb:
 * - Hashing seguro de contraseñas con SHA-256 + Salt aleatorio criptográfico.
 * - Verificación retrocompatible (soporta contraseñas antiguas en texto plano y hashes).
 * - Sanitización de cadenas para prevención de Cross-Site Scripting (XSS).
 */
public class Seguridad {

    private static final SecureRandom RANDOM = new SecureRandom();

    /**
     * Genera un hash seguro para la contraseña con una sal criptográfica de 16 bytes.
     * Retorna en formato: <salt_en_hex>:<hash_en_hex>
     */
    public static String hashPassword(String password) {
        if (password == null || password.isEmpty()) {
            return "";
        }
        byte[] salt = new byte[16];
        RANDOM.nextBytes(salt);
        byte[] hash = calcularHash(salt, password);
        return bytesToHex(salt) + ":" + bytesToHex(hash);
    }

    /**
     * Verifica si la contraseña ingresada coincide con la almacenada.
     * Si la almacenada contiene ':', se valida como hash con salt.
     * Si no contiene ':', valida en texto plano para mantener retrocompatibilidad con cuentas previas.
     */
    public static boolean verificarPassword(String passwordIngresada, String passwordAlmacenada) {
        if (passwordIngresada == null || passwordAlmacenada == null) {
            return false;
        }

        // Si es un hash generado por nuestra clase
        if (passwordAlmacenada.contains(":")) {
            String[] partes = passwordAlmacenada.split(":");
            if (partes.length != 2) {
                return false;
            }
            byte[] salt = hexToBytes(partes[0]);
            byte[] hashEsperado = hexToBytes(partes[1]);
            byte[] hashCalculado = calcularHash(salt, passwordIngresada);
            return MessageDigest.isEqual(hashEsperado, hashCalculado);
        }

        // Retrocompatibilidad con contraseñas en texto plano
        return passwordIngresada.equals(passwordAlmacenada);
    }

    /**
     * Comprueba si una contraseña almacenada aún está en texto plano (necesita actualización).
     */
    public static boolean esTextoPlano(String passwordAlmacenada) {
        return passwordAlmacenada != null && !passwordAlmacenada.contains(":");
    }

    /**
     * Sanitiza cadenas de texto para prevenir inyección XSS al mostrarlas en páginas HTML.
     */
    public static String escapeHtml(String input) {
        if (input == null) return "";
        StringBuilder sb = new StringBuilder(input.length() + 16);
        for (int i = 0; i < input.length(); i++) {
            char c = input.charAt(i);
            switch (c) {
                case '<': sb.append("&lt;"); break;
                case '>': sb.append("&gt;"); break;
                case '&': sb.append("&amp;"); break;
                case '"': sb.append("&quot;"); break;
                case '\'': sb.append("&#x27;"); break;
                case '/': sb.append("&#x2F;"); break;
                default: sb.append(c); break;
            }
        }
        return sb.toString();
    }

    private static byte[] calcularHash(byte[] salt, String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(salt);
            byte[] hashed = md.digest(password.getBytes(StandardCharsets.UTF_8));
            // Hashing múltiple (1000 iteraciones) para resistencia ante ataques de fuerza bruta
            for (int i = 0; i < 999; i++) {
                md.reset();
                hashed = md.digest(hashed);
            }
            return hashed;
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error al calcular hash de contraseña", e);
        }
    }

    private static String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder(bytes.length * 2);
        for (byte b : bytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }

    private static byte[] hexToBytes(String hex) {
        int len = hex.length();
        byte[] data = new byte[len / 2];
        for (int i = 0; i < len; i += 2) {
            data[i / 2] = (byte) ((Character.digit(hex.charAt(i), 16) << 4)
                    + Character.digit(hex.charAt(i + 1), 16));
        }
        return data;
    }
}
