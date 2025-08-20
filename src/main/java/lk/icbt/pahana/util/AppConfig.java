package lk.icbt.pahana.util;

public final class AppConfig {
    private static final AppConfig INSTANCE = new AppConfig();
    private String url, user, pass;
    private volatile boolean initialized;

    private AppConfig() {}

    public static AppConfig get() { return INSTANCE; }

    public synchronized void setDb(String url, String user, String pass) {
        this.url = url; this.user = user; this.pass = pass; this.initialized = true;
    }
    public String url()  { check(); return url; }
    public String user() { check(); return user; }
    public String pass() { check(); return pass; }
    private void check() { if (!initialized) throw new IllegalStateException("AppConfig not initialized"); }
}
