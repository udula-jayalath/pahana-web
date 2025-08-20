package lk.icbt.pahana.dao;

import lk.icbt.pahana.model.Customer;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {

    /** Create and return generated id */
    public int create(Customer c, String createdBy) throws SQLException {
        String sql = "INSERT INTO customers (account_no,name,address,telephone,units,created_by) " +
                "VALUES (?,?,?,?,?,?)";
        try (Connection con = ConnectionFactory.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, c.getAccountNo());
            ps.setString(2, c.getName());
            ps.setString(3, c.getAddress());
            ps.setString(4, c.getTelephone());
            ps.setInt(5, c.getUnits());
            ps.setString(6, createdBy);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        }
        return -1;
    }

    /** Update by id (account_no stays immutable after create) */
    public void update(Customer c, String updatedBy) throws SQLException {
        String sql = "UPDATE customers SET name=?, address=?, telephone=?, units=?, updated_by=? WHERE id=?";
        try (Connection con = ConnectionFactory.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, c.getName());
            ps.setString(2, c.getAddress());
            ps.setString(3, c.getTelephone());
            ps.setInt(4, c.getUnits());
            ps.setString(5, updatedBy);
            ps.setInt(6, c.getId());
            ps.executeUpdate();
        }
    }

    public void deleteById(int id) throws SQLException {
        String sql = "DELETE FROM customers WHERE id=?";
        try (Connection con = ConnectionFactory.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public Customer findById(int id) throws SQLException {
        String sql = "SELECT id,account_no,name,address,telephone,units,created_at,created_by,updated_at,updated_by " +
                "FROM customers WHERE id=?";
        try (Connection con = ConnectionFactory.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public Customer findByAccountNo(String accountNo) throws SQLException {
        String sql = "SELECT id,account_no,name,address,telephone,units,created_at,created_by,updated_at,updated_by " +
                "FROM customers WHERE account_no=?";
        try (Connection con = ConnectionFactory.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, accountNo);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public List<Customer> findAll(String q) throws SQLException {
        boolean hasQ = q != null && !q.trim().isEmpty();
        String base = "SELECT id,account_no,name,address,telephone,units,created_at,created_by,updated_at,updated_by FROM customers ";
        String sql  = hasQ ? base + "WHERE account_no LIKE ? OR name LIKE ? ORDER BY created_at DESC"
                : base + "ORDER BY created_at DESC";
        try (Connection con = ConnectionFactory.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            if (hasQ) {
                String like = "%" + q.trim() + "%";
                ps.setString(1, like);
                ps.setString(2, like);
            }
            try (ResultSet rs = ps.executeQuery()) {
                List<Customer> list = new ArrayList<>();
                while (rs.next()) list.add(map(rs));
                return list;
            }
        }
    }

    private Customer map(ResultSet rs) throws SQLException {
        Customer c = new Customer();
        c.setId(rs.getInt("id")); // NEW
        c.setAccountNo(rs.getString("account_no"));
        c.setName(rs.getString("name"));
        c.setAddress(rs.getString("address"));
        c.setTelephone(rs.getString("telephone"));
        c.setUnits(rs.getInt("units"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        c.setCreatedBy(rs.getString("created_by"));
        c.setUpdatedAt(rs.getTimestamp("updated_at"));
        c.setUpdatedBy(rs.getString("updated_by"));
        return c;
    }
}
