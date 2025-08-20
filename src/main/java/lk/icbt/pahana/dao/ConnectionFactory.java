package lk.icbt.pahana.dao;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public final class ConnectionFactory {
    private static ConnectionFactory instance;
    private final String url, user, pass;

    private ConnectionFactory() {
        try {
            Properties p = new Properties();
            try (InputStream in = getClass().getClassLoader().getResourceAsStream("db.properties")) {
                if (in == null) throw new IllegalStateException("db.properties not found");
                p.load(in);
            }
            url = p.getProperty("db.url");
            user = p.getProperty("db.user");
            pass = p.getProperty("db.password");
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (Exception e) {
            throw new RuntimeException("DB init failed", e);
        }
    }

    public static synchronized ConnectionFactory getInstance() {
        if (instance == null) instance = new ConnectionFactory();
        return instance;
    }

    public Connection getConnection() throws java.sql.SQLException {
        return DriverManager.getConnection(url, user, pass);
    }
}
