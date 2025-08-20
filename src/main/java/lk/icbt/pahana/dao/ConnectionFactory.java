package lk.icbt.pahana.dao;

import lk.icbt.pahana.util.AppConfig;
import java.sql.Connection;
import java.sql.DriverManager;

public final class ConnectionFactory {
    private static ConnectionFactory instance;
    private final String url, user, pass;

    private ConnectionFactory() {
        try {
            this.url  = AppConfig.get().url();
            this.user = AppConfig.get().user();
            this.pass = AppConfig.get().pass();
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
