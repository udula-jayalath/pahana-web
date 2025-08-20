package lk.icbt.pahana.web;

import lk.icbt.pahana.model.Bill;
import lk.icbt.pahana.service.BillingService;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import java.io.IOException;

public class BillViewServlet extends HttpServlet {
    private final BillingService service = new BillingService();

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            Bill b = service.find(id);
            if (b == null) { resp.sendRedirect(req.getContextPath()+"/bills?err=notfound"); return; }
            req.setAttribute("bill", b);
            req.getRequestDispatcher("/views/bill_view.jsp").forward(req, resp);
        } catch (Exception e) { resp.sendRedirect(req.getContextPath()+"/bills?err=bad_id"); }
    }
}
