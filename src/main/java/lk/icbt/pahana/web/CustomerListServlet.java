package lk.icbt.pahana.web;

import lk.icbt.pahana.service.CustomerService;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import java.io.IOException;

public class CustomerListServlet extends HttpServlet {
    private final CustomerService service = new CustomerService();

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String q = req.getParameter("q");
        try {
            req.setAttribute("customers", service.list(q));
            req.setAttribute("q", q == null ? "" : q);
            req.getRequestDispatcher("/views/customers.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
