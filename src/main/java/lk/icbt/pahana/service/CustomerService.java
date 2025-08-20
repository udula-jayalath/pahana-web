package lk.icbt.pahana.service;

import lk.icbt.pahana.dao.CustomerDAO;
import lk.icbt.pahana.model.Customer;

import java.sql.SQLException;
import java.util.regex.Pattern;
import java.util.List;

public class CustomerService {
    private final CustomerDAO dao = new CustomerDAO();
    private static final Pattern ACCT  = Pattern.compile("^[A-Za-z0-9\\-]{3,20}$");
    private static final Pattern PHONE = Pattern.compile("^[0-9+]{7,15}$");

    public int create(Customer c, String createdBy) throws Exception {
        validateNew(c);
        return dao.create(c, createdBy);
    }

    public void update(Customer c, String updatedBy) throws Exception {
        if (c.getId() <= 0) throw new Exception("Invalid customer id.");
        validateCommon(c);
        dao.update(c, updatedBy);
    }

    public void deleteById(int id) throws SQLException {
        dao.deleteById(id);
    }

    public Customer find(int id) throws SQLException { return dao.findById(id); }

    public List<Customer> list(String q) throws SQLException { return dao.findAll(q); }

    private void validateNew(Customer c) throws Exception {
        if (c.getAccountNo() == null || !ACCT.matcher(c.getAccountNo()).matches())
            throw new Exception("Invalid account number (3-20 chars, letters/digits/-).");
        validateCommon(c);
    }
    private void validateCommon(Customer c) throws Exception {
        if (c.getName() == null || c.getName().trim().length() < 3)
            throw new Exception("Name must be at least 3 characters.");
        if (c.getTelephone() != null && !c.getTelephone().isBlank()
                && !PHONE.matcher(c.getTelephone()).matches())
            throw new Exception("Telephone must be digits or +, 7–15 chars.");
        if (c.getUnits() < 0) throw new Exception("Units cannot be negative.");
    }
}
