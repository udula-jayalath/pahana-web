package lk.icbt.pahana.web;

import lk.icbt.pahana.service.BillingService;
import javax.servlet.http.*;
import javax.servlet.ServletException;
import java.io.IOException;

public class BillListServlet extends HttpServlet {
    private final BillingService service = new BillingService();
    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String q = req.getParameter("q");
        try {
            req.setAttribute("bills", service.list(q));
            req.setAttribute("q", q == null ? "" : q);
            req.getRequestDispatcher("/views/bills.jsp").forward(req, resp);
        } catch (Exception e) { throw new ServletException(e); }
    }
}
