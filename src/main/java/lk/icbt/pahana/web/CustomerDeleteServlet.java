package lk.icbt.pahana.web;

import lk.icbt.pahana.service.CustomerService;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import java.io.IOException;

public class CustomerDeleteServlet extends HttpServlet {
    private final CustomerService service = new CustomerService();

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            service.deleteById(id);
            resp.sendRedirect(req.getContextPath() + "/customers?msg=deleted");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/customers?err=bad_id");
        }
    }
}
