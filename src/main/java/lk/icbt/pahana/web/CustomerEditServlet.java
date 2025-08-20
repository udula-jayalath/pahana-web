package lk.icbt.pahana.web;

import lk.icbt.pahana.model.Customer;
import lk.icbt.pahana.service.CustomerService;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import java.io.IOException;

public class CustomerEditServlet extends HttpServlet {
    private final CustomerService service = new CustomerService();

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idStr = req.getParameter("id");
        try {
            int id = Integer.parseInt(idStr);
            Customer c = service.find(id);
            if (c == null) { resp.sendRedirect(req.getContextPath()+"/customers?err=notfound"); return; }
            req.setAttribute("mode", "edit");
            req.setAttribute("customer", c);
            req.getRequestDispatcher("/views/customer_form.jsp").forward(req, resp);
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath()+"/customers?err=bad_id");
        }
    }

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Customer c = new Customer();
        try { c.setId(Integer.parseInt(req.getParameter("id"))); } catch (Exception ignored) { c.setId(0); }
        c.setAccountNo(req.getParameter("account_no"));  // readonly in form
        c.setName(req.getParameter("name"));
        c.setAddress(req.getParameter("address"));
        c.setTelephone(req.getParameter("telephone"));
        try { c.setUnits(Integer.parseInt(req.getParameter("units"))); } catch (Exception ignored) { c.setUnits(0); }

        String updatedBy = String.valueOf(req.getSession().getAttribute("username"));
        try {
            service.update(c, updatedBy);
            resp.sendRedirect(req.getContextPath() + "/customers?msg=updated");
        } catch (Exception ex) {
            req.setAttribute("mode", "edit");
            req.setAttribute("error", ex.getMessage());
            req.setAttribute("customer", c);
            req.getRequestDispatcher("/views/customer_form.jsp").forward(req, resp);
        }
    }
}
