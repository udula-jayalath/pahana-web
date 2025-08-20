package lk.icbt.pahana.service;

import lk.icbt.pahana.dao.ItemDAO;
import lk.icbt.pahana.model.Item;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

public class ItemService {
    private final ItemDAO dao = new ItemDAO();

    public int create(Item it, String createdBy) throws Exception {
        validateNew(it);
        return dao.create(it, createdBy);
    }

    public void update(Item it, String updatedBy) throws Exception {
        if (it.getId() <= 0) throw new Exception("Invalid item id.");
        validateCommon(it);
        dao.update(it, updatedBy);
    }

    public void deleteById(int id) throws SQLException { dao.deleteById(id); }
    public Item find(int id) throws SQLException { return dao.findById(id); }
    public List<Item> list(String q) throws SQLException { return dao.findAll(q); }

    private void validateNew(Item it) throws Exception { validateCommon(it); }
    private void validateCommon(Item it) throws Exception {
        if (it.getName() == null || it.getName().trim().length() < 2)
            throw new Exception("Item name must be at least 2 characters.");
        if (it.getUnitPrice() == null || it.getUnitPrice().compareTo(BigDecimal.ZERO) < 0)
            throw new Exception("Unit price cannot be negative.");
        if (it.getStatus() == null || !(it.getStatus().equals("ACTIVE") || it.getStatus().equals("INACTIVE")))
            throw new Exception("Status must be ACTIVE or INACTIVE.");
    }
}
