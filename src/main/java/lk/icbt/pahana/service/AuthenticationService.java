package lk.icbt.pahana.service;

import lk.icbt.pahana.dao.UserDAO;
import lk.icbt.pahana.model.AuthResult;
import lk.icbt.pahana.model.User;
import lk.icbt.pahana.util.PasswordUtil;

import java.util.Arrays;

public class AuthenticationService {
    private final UserDAO userDAO = new UserDAO();

    public AuthResult authenticate(String username, char[] password) throws Exception {
        User u = userDAO.findByUsername(username);
        if (u == null) return null;

        // Compute SHA-256(password) and compare to stored HEX
        byte[] calc = PasswordUtil.hashNoSalt(password);
        String calcHex = java.util.HexFormat.of().formatHex(calc);       // JDK 17
        boolean ok = calcHex.equalsIgnoreCase(u.getPasswordHash());
        if (!ok) return null;

        long auditId = userDAO.insertLoginAudit(u.getId());
        return new AuthResult(u, auditId);
    }


    public void logout(int userId) throws Exception {
        userDAO.closeLatestLogin(userId);
    }
}
