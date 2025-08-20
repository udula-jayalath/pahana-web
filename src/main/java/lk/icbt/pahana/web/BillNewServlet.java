package lk.icbt.pahana.web;

import lk.icbt.pahana.service.CustomerService;
import lk.icbt.pahana.service.ItemService;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import java.io.IOException;

public class BillNewServlet extends HttpServlet {
    private final CustomerService customerService = new CustomerService();
    private final ItemService itemService = new ItemService();

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("customers", customerService.list(null));
            req.setAttribute("items", itemService.list(null));
            req.getRequestDispatcher("/views/bill_form.jsp").forward(req, resp);
        } catch (Exception e) { throw new ServletException(e); }
    }
}
