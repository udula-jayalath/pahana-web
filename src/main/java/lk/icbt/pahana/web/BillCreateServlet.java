package lk.icbt.pahana.web;

import lk.icbt.pahana.service.BillingService;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import java.io.IOException;
import java.math.BigDecimal;

public class BillCreateServlet extends HttpServlet {
    private final BillingService service = new BillingService();

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String createdBy = String.valueOf(req.getSession().getAttribute("username"));
        try {
            int customerId = Integer.parseInt(req.getParameter("customer_id"));

            String[] itemIdStr = req.getParameterValues("item_id");
            String[] qtyStr    = req.getParameterValues("qty");

            if (itemIdStr == null || qtyStr == null) throw new Exception("No line items provided.");
            int[] itemIds = new int[itemIdStr.length];
            int[] qtys    = new int[qtyStr.length];
            for (int i=0;i<itemIdStr.length;i++) itemIds[i] = Integer.parseInt(itemIdStr[i]);
            for (int i=0;i<qtyStr.length;i++)    qtys[i]    = Integer.parseInt(qtyStr[i]);

            BigDecimal discPct = parseDecimal(req.getParameter("discount_pct"));
            BigDecimal taxPct  = parseDecimal(req.getParameter("tax_pct"));

            int billId = service.createBill(customerId, itemIds, qtys, discPct, taxPct, createdBy);
            resp.sendRedirect(req.getContextPath()+"/bills/view?id="+billId+"&msg=created");
        } catch (Exception ex) {
            req.setAttribute("error", ex.getMessage());
            // Re-load dropdown data
            try { new BillNewServlet().doGet(req, resp); }
            catch (Exception ignored) { throw new ServletException(ex); }
        }
    }

    private static java.math.BigDecimal parseDecimal(String s) {
        try { return new java.math.BigDecimal(s); } catch (Exception e) { return java.math.BigDecimal.ZERO; }
    }
}
