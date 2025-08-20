package lk.icbt.pahana.model;

public class AuthResult {
    private final User user;
    private final long loginAuditId;

    public AuthResult(User user, long loginAuditId) {
        this.user = user;
        this.loginAuditId = loginAuditId;
    }
    public User getUser() { return user; }
    public long getLoginAuditId() { return loginAuditId; }
}
