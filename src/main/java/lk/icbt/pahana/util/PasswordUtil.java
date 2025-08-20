package lk.icbt.pahana.util;

import java.security.MessageDigest;
import java.security.SecureRandom;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;

public final class PasswordUtil {
    private static final SecureRandom RNG = new SecureRandom();

    public static byte[] newSalt() {
        byte[] b = new byte[16];
        RNG.nextBytes(b);
        return b;
    }

    public static byte[] hashNoSalt(char[] password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] out = md.digest(new String(password).getBytes(StandardCharsets.UTF_8));
            Arrays.fill(password, '\0');
            return out;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
