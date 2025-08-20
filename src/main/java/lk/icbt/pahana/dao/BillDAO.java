package lk.icbt.pahana.dao;

import lk.icbt.pahana.model.Bill;
import lk.icbt.pahana.model.BillItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BillDAO {

    public int create(Bill b, String createdBy) throws SQLException {
        String insertBill = "INSERT INTO bills (bill_no, customer_id, bill_date, subtotal, discount, tax, total, status, created_by) " +
                "VALUES (?, ?, NOW(), ?, ?, ?, ?, ?, ?)";
        String insertItem = "INSERT INTO bill_items (bill_id, item_id, qty, unit_price, line_total) VALUES (?,?,?,?,?)";

        try (Connection con = ConnectionFactory.getInstance().getConnection()) {
            boolean old = con.getAutoCommit();
            con.setAutoCommit(false);
            try (PreparedStatement pb = con.prepareStatement(insertBill, Statement.RETURN_GENERATED_KEYS)) {
                pb.setString(1, b.getBillNo());
                pb.setInt(2, b.getCustomerId());
                pb.setBigDecimal(3, b.getSubtotal());
                pb.setBigDecimal(4, b.getDiscount());
                pb.setBigDecimal(5, b.getTax());
                pb.setBigDecimal(6, b.getTotal());
                pb.setString(7, b.getStatus());
                pb.setString(8, createdBy);
                pb.executeUpdate();
                int billId;
                try (ResultSet keys = pb.getGeneratedKeys()) {
                    billId = keys.next() ? keys.getInt(1) : -1;
                }
                try (PreparedStatement pi = con.prepareStatement(insertItem)) {
                    for (BillItem it : b.getItems()) {
                        pi.setInt(1, billId);
                        pi.setInt(2, it.getItemId());
                        pi.setInt(3, it.getQty());
                        pi.setBigDecimal(4, it.getUnitPrice());
                        pi.setBigDecimal(5, it.getLineTotal());
                        pi.addBatch();
                    }
                    pi.executeBatch();
                }
                con.commit();
                con.setAutoCommit(old);
                return billId;
            } catch (SQLException e) {
                con.rollback();
                throw e;
            }
        }
    }

    public Bill findById(int id) throws SQLException {
        String billSql = "SELECT b.id,b.bill_no,b.customer_id,c.name AS customer_name,b.bill_date," +
                "b.subtotal,b.discount,b.tax,b.total,b.status " +
                "FROM bills b JOIN customers c ON c.id=b.customer_id WHERE b.id=?";
        String itemsSql = "SELECT bi.id,bi.item_id,i.name AS item_name,bi.qty,bi.unit_price,bi.line_total " +
                "FROM bill_items bi JOIN items i ON i.id=bi.item_id WHERE bi.bill_id=?";
        try (Connection con = ConnectionFactory.getInstance().getConnection()) {
            Bill b = null;
            try (PreparedStatement ps = con.prepareStatement(billSql)) {
                ps.setInt(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        b = new Bill();
                        b.setId(rs.getInt("id"));
                        b.setBillNo(rs.getString("bill_no"));
                        b.setCustomerId(rs.getInt("customer_id"));
                        b.setCustomerName(rs.getString("customer_name"));
                        b.setBillDate(rs.getTimestamp("bill_date"));
                        b.setSubtotal(rs.getBigDecimal("subtotal"));
                        b.setDiscount(rs.getBigDecimal("discount"));
                        b.setTax(rs.getBigDecimal("tax"));
                        b.setTotal(rs.getBigDecimal("total"));
                        b.setStatus(rs.getString("status"));
                    }
                }
            }
            if (b == null) return null;
            List<BillItem> items = new ArrayList<>();
            try (PreparedStatement ps = con.prepareStatement(itemsSql)) {
                ps.setInt(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        BillItem it = new BillItem();
                        it.setId(rs.getInt("id"));
                        it.setBillId(id);
                        it.setItemId(rs.getInt("item_id"));
                        it.setItemName(rs.getString("item_name"));
                        it.setQty(rs.getInt("qty"));
                        it.setUnitPrice(rs.getBigDecimal("unit_price"));
                        it.setLineTotal(rs.getBigDecimal("line_total"));
                        items.add(it);
                    }
                }
            }
            b.setItems(items);
            return b;
        }
    }

    public List<Bill> list(String q) throws SQLException {
        boolean has = q != null && !q.trim().isEmpty();
        String base = "SELECT b.id,b.bill_no,b.bill_date,b.total,b.status,c.name AS customer_name " +
                "FROM bills b JOIN customers c ON c.id=b.customer_id ";
        String sql = has ? base + "WHERE b.bill_no LIKE ? OR c.name LIKE ? ORDER BY b.bill_date DESC"
                : base + "ORDER BY b.bill_date DESC";
        try (Connection con = ConnectionFactory.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            if (has) {
                String like = "%" + q.trim() + "%";
                ps.setString(1, like);
                ps.setString(2, like);
            }
            try (ResultSet rs = ps.executeQuery()) {
                List<Bill> list = new ArrayList<>();
                while (rs.next()) {
                    Bill b = new Bill();
                    b.setId(rs.getInt("id"));
                    b.setBillNo(rs.getString("bill_no"));
                    b.setBillDate(rs.getTimestamp("bill_date"));
                    b.setTotal(rs.getBigDecimal("total"));
                    b.setStatus(rs.getString("status"));
                    b.setCustomerName(rs.getString("customer_name"));
                    list.add(b);
                }
                return list;
            }
        }
    }
}
