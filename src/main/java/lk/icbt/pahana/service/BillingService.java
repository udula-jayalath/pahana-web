package lk.icbt.pahana.service;

import lk.icbt.pahana.dao.BillDAO;
import lk.icbt.pahana.dao.ItemDAO;
import lk.icbt.pahana.model.Bill;
import lk.icbt.pahana.model.BillItem;
import lk.icbt.pahana.model.Item;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class BillingService {
    private final BillDAO billDAO = new BillDAO();
    private final ItemDAO itemDAO = new ItemDAO();

    public int createBill(int customerId, int[] itemIds, int[] qtys,
                          BigDecimal discountPct, BigDecimal taxPct, String createdBy) throws Exception {
        if (customerId <= 0) throw new Exception("Customer is required.");
        if (itemIds == null || itemIds.length == 0) throw new Exception("At least one line item is required.");
        if (qtys == null || qtys.length != itemIds.length) throw new Exception("Item/quantity mismatch.");

        Bill bill = new Bill();
        bill.setBillNo(generateBillNo());
        bill.setCustomerId(customerId);
        bill.setStatus("ISSUED");

        BigDecimal subtotal = BigDecimal.ZERO;
        List<BillItem> lines = new ArrayList<>();

        for (int i = 0; i < itemIds.length; i++) {
            if (qtys[i] <= 0) continue; // skip zero/negative rows
            Item item = itemDAO.findById(itemIds[i]);
            if (item == null) throw new Exception("Item not found: id=" + itemIds[i]);

            BigDecimal unit = item.getUnitPrice().setScale(2, RoundingMode.HALF_UP);
            BigDecimal qty = new BigDecimal(qtys[i]);
            BigDecimal line = unit.multiply(qty).setScale(2, RoundingMode.HALF_UP);

            BillItem bi = new BillItem();
            bi.setItemId(item.getId());
            bi.setQty(qtys[i]);
            bi.setUnitPrice(unit);
            bi.setLineTotal(line);
            lines.add(bi);

            subtotal = subtotal.add(line);
        }

        if (lines.isEmpty()) throw new Exception("No valid items with quantity.");

        BigDecimal disc = pct(subtotal, nz(discountPct));
        BigDecimal taxable = subtotal.subtract(disc);
        BigDecimal tax = pct(taxable, nz(taxPct));
        BigDecimal total = taxable.add(tax).setScale(2, RoundingMode.HALF_UP);

        bill.setSubtotal(subtotal.setScale(2, RoundingMode.HALF_UP));
        bill.setDiscount(disc.setScale(2, RoundingMode.HALF_UP));
        bill.setTax(tax.setScale(2, RoundingMode.HALF_UP));
        bill.setTotal(total);
        bill.setItems(lines);

        return billDAO.create(bill, createdBy);
    }

    public Bill find(int id) throws SQLException { return billDAO.findById(id); }

    public List<Bill> list(String q) throws SQLException { return billDAO.list(q); }

    private static BigDecimal pct(BigDecimal base, BigDecimal percent) {
        return base.multiply(percent).divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
    }
    private static BigDecimal nz(BigDecimal x) { return x == null ? BigDecimal.ZERO : x; }

    private static String generateBillNo() {
        // Simple, unique bill no: INV-<8 hex>
        return "INV-" + UUID.randomUUID().toString().substring(0,8).toUpperCase();
    }
}
