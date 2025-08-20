package lk.icbt.pahana.dao;

import lk.icbt.pahana.model.User;
import java.sql.*;

public class UserDAO {

    public User findByUsername(String username) throws SQLException {
        String sql = "SELECT id, username, password_hash, role, status FROM users WHERE username=?";
        try (Connection con = ConnectionFactory.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setPasswordHash(rs.getString("password_hash")); // HEX string from VARCHAR
                u.setRole(rs.getString("role"));
                u.setStatus(rs.getString("status"));
                return u;
            }
        }
    }

    /** Inserts a login record and returns the generated audit id. */
    public long insertLoginAudit(int userId) throws SQLException {
        String sql = "INSERT INTO login_audit (user_id, login_at) VALUES (?, NOW())";
        try (Connection con = ConnectionFactory.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                return keys.next() ? keys.getLong(1) : -1L;
            }
        }
    }

    public void closeLatestLogin(int userId) throws SQLException {
        String sql = "UPDATE login_audit SET logout_at = NOW() " +
                "WHERE user_id=? AND logout_at IS NULL ORDER BY id DESC LIMIT 1";
        try (Connection con = ConnectionFactory.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }
}
