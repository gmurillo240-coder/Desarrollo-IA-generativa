package conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Clase encargada UNICAMENTE de abrir la conexion a la base de datos MySQL.
 * La llamamos desde los JSP cada vez que necesitamos leer o guardar datos,
 * por eso no necesitamos Servlets: cada JSP hace su propia consulta.
 *
 * IMPORTANTE: ajusta USUARIO y PASSWORD segun tu configuracion local de MySQL.
 */
public class ConexionBD {

    private static final String URL =
        "jdbc:mysql://localhost:3306/ia_generativa?useSSL=false&serverTimezone=America/Mexico_City&characterEncoding=UTF-8&useUnicode=true";
    private static final String USUARIO = "root";
    private static final String PASSWORD = "";

    public static Connection obtenerConexion() throws SQLException {
        try {
            // Carga el driver de MySQL (debe estar agregado como libreria del proyecto)
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException(
                "No se encontro el driver de MySQL. Verifica que agregaste el "
                + "conector JDBC (mysql-connector-j-x.x.x.jar) a las librerias del proyecto.", e);
        }
        return DriverManager.getConnection(URL, USUARIO, PASSWORD);
    }
}
