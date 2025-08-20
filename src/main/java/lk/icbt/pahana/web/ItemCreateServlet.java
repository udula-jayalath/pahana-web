package lk.icbt.pahana.web;

import lk.icbt.pahana.model.Item;
import lk.icbt.pahana.service.ItemService;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import java.io.IOException;
import java.math.BigDecimal;

public class ItemCreateServlet extends HttpServlet {
    private final ItemService service = new ItemService();

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Item it = new Item();
        it.setName(req.getParameter("name"));
        it.setStatus(req.getParameter("status"));
        try { it.setUnitPrice(new BigDecimal(req.getParameter("unit_price"))); }
        catch (Exception e) { it.setUnitPrice(null); }

        String createdBy = String.valueOf(req.getSession().getAttribute("username"));
        try {
            service.create(it, createdBy);
            resp.sendRedirect(req.getContextPath()+"/items?msg=created");
        } catch (Exception ex) {
            req.setAttribute("mode", "create");
            req.setAttribute("error", ex.getMessage());
            req.setAttribute("item", it);
            req.getRequestDispatcher("/views/item_form.jsp").forward(req, resp);
        }
    }
}
