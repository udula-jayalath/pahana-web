package lk.icbt.pahana.dao;

import lk.icbt.pahana.model.Item;
import java.sql.*;
import java.util.*;
import java.math.BigDecimal;

public class ItemDAO {

    public int create(Item it, String createdBy) throws SQLException {
        String sql = "INSERT INTO items (name, unit_price, status, created_by) VALUES (?,?,?,?)";
        try (Connection con = ConnectionFactory.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, it.getName());
            ps.setBigDecimal(2, it.getUnitPrice());
            ps.setString(3, it.getStatus());
            ps.setString(4, createdBy);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                return rs.next() ? rs.getInt(1) : -1;
            }
        }
    }

    public void update(Item it, String updatedBy) throws SQLException {
        String sql = "UPDATE items SET name=?, unit_price=?, status=?, updated_by=? WHERE id=?";
        try (Connection con = ConnectionFactory.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, it.getName());
            ps.setBigDecimal(2, it.getUnitPrice());
            ps.setString(3, it.getStatus());
            ps.setString(4, updatedBy);
            ps.setInt(5, it.getId());
            ps.executeUpdate();
        }
    }

    public void deleteById(int id) throws SQLException {
        String sql = "DELETE FROM items WHERE id=?";
        try (Connection con = ConnectionFactory.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public Item findById(int id) throws SQLException {
        String sql = "SELECT id,name,unit_price,status,created_at,created_by,updated_at,updated_by FROM items WHERE id=?";
        try (Connection con = ConnectionFactory.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public List<Item> findAll(String q) throws SQLException {
        boolean hasQ = q != null && !q.trim().isEmpty();
        String base = "SELECT id,name,unit_price,status,created_at,created_by,updated_at,updated_by FROM items ";
        String sql = hasQ ? base + "WHERE name LIKE ? ORDER BY created_at DESC"
                : base + "ORDER BY created_at DESC";
        try (Connection con = ConnectionFactory.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            if (hasQ) ps.setString(1, "%" + q.trim() + "%");
            try (ResultSet rs = ps.executeQuery()) {
                List<Item> list = new ArrayList<>();
                while (rs.next()) list.add(map(rs));
                return list;
            }
        }
    }

    private Item map(ResultSet rs) throws SQLException {
        Item it = new Item();
        it.setId(rs.getInt("id"));
        it.setName(rs.getString("name"));
        it.setUnitPrice(rs.getBigDecimal("unit_price"));
        it.setStatus(rs.getString("status"));
        it.setCreatedAt(rs.getTimestamp("created_at"));
        it.setCreatedBy(rs.getString("created_by"));
        it.setUpdatedAt(rs.getTimestamp("updated_at"));
        it.setUpdatedBy(rs.getString("updated_by"));
        return it;
    }
}
