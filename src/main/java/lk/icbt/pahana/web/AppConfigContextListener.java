package lk.icbt.pahana.web;

import lk.icbt.pahana.util.AppConfig;
import javax.servlet.*;
import java.io.InputStream;
import java.util.Properties;

public class AppConfigContextListener implements ServletContextListener {
    @Override public void contextInitialized(ServletContextEvent sce) {
        try {
            Properties p = new Properties();
            // 1) /WEB-INF/db.properties
            try (InputStream in = sce.getServletContext().getResourceAsStream("/WEB-INF/db.properties")) {
                if (in != null) p.load(in);
            }
            // 2) fallback: classpath
            if (p.isEmpty()) {
                ClassLoader cl = Thread.currentThread().getContextClassLoader();
                try (InputStream in = (cl!=null?cl:null).getResourceAsStream("db.properties")) {
                    if (in != null) p.load(in);
                } catch (Exception ignored) {}
            }
            String url  = p.getProperty("db.url", System.getenv("DB_URL"));
            String user = p.getProperty("db.user", System.getenv("DB_USER"));
            String pass = p.getProperty("db.password", System.getenv("DB_PASSWORD"));
            if (url == null || user == null)
                throw new IllegalStateException("Missing db.url/db.user in db.properties or env.");
            AppConfig.get().setDb(url, user, pass);
        } catch (Exception e) {
            throw new RuntimeException("Failed to load DB config", e);
        }
    }
}
