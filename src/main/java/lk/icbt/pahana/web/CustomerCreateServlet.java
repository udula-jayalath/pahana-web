package lk.icbt.pahana.web;

import lk.icbt.pahana.model.Customer;
import lk.icbt.pahana.service.CustomerService;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import java.io.IOException;

public class CustomerCreateServlet extends HttpServlet {
    private final CustomerService service = new CustomerService();

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Customer c = bind(req);
        String createdBy = String.valueOf(req.getSession().getAttribute("username"));
        try {
            service.create(c, createdBy);
            resp.sendRedirect(req.getContextPath() + "/customers?msg=created");
        } catch (Exception ex) {
            req.setAttribute("mode", "create");
            req.setAttribute("error", ex.getMessage());
            req.setAttribute("customer", c);
            req.getRequestDispatcher("/views/customer_form.jsp").forward(req, resp);
        }
    }

    private Customer bind(HttpServletRequest req) {
        Customer c = new Customer();
        c.setAccountNo(req.getParameter("account_no"));
        c.setName(req.getParameter("name"));
        c.setAddress(req.getParameter("address"));
        c.setTelephone(req.getParameter("telephone"));
        try { c.setUnits(Integer.parseInt(req.getParameter("units"))); }
        catch (Exception ignored) { c.setUnits(0); }
        return c;
    }
}
