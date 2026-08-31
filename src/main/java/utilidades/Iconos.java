package utilidades;

/**
 * Funciones pequeñas que se reutilizan en más de una página JSP,
 * para no repetir el mismo código en varios archivos.
 */
public class Iconos {

    /**
     * Elige un ícono de Bootstrap Icons segun palabras clave en el título de un tip.
     * Se usa tanto en tips.jsp como en index.jsp (tip destacado).
     */
    public static String obtenerIconoTip(String titulo) {
        String t = titulo.toLowerCase();
        if (t.contains("indicaciones") || t.contains("prompt"))       return "bi-chat-square-text";
        if (t.contains("privacidad") || t.contains("sensible"))       return "bi-shield-lock";
        if (t.contains("ejemplos") || t.contains("few-shot"))         return "bi-collection";
        if (t.contains("razonamiento") || t.contains("explique"))     return "bi-diagram-3";
        if (t.contains("itera") || t.contains("primera"))             return "bi-arrow-repeat";
        if (t.contains("rol") || t.contains("contexto"))              return "bi-person-badge";
        if (t.contains("combina") || t.contains("fortaleza"))         return "bi-tools";
        if (t.contains("plantillas"))                                 return "bi-file-earmark-text";
        if (t.contains("sesgo"))                                      return "bi-exclamation-diamond";
        if (t.contains("api") || t.contains("automatiza"))            return "bi-cpu";
        if (t.contains("documenta"))                                  return "bi-journal-check";
        if (t.contains("tono") || t.contains("público"))              return "bi-megaphone";
        if (t.contains("verifica") || t.contains("información generada")) return "bi-patch-check";
        return "bi-lightbulb";
    }

    /**
     * Devuelve el color de Bootstrap (success/warning/danger) segun el nivel de un tip.
     */
    public static String obtenerColorNivel(String nivel) {
        if ("Principiante".equals(nivel)) return "success";
        if ("Intermedio".equals(nivel))   return "warning";
        if ("Avanzado".equals(nivel))     return "danger";
        return "secondary";
    }
}