package lk.icbt.pahana.web;

import lk.icbt.pahana.model.Item;
import lk.icbt.pahana.service.ItemService;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import java.io.IOException;
import java.math.BigDecimal;

public class ItemEditServlet extends HttpServlet {
    private final ItemService service = new ItemService();

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            Item it = service.find(id);
            if (it == null) { resp.sendRedirect(req.getContextPath()+"/items?err=notfound"); return; }
            req.setAttribute("mode", "edit");
            req.setAttribute("item", it);
            req.getRequestDispatcher("/views/item_form.jsp").forward(req, resp);
        } catch (Exception e) { resp.sendRedirect(req.getContextPath()+"/items?err=bad_id"); }
    }

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Item it = new Item();
        try { it.setId(Integer.parseInt(req.getParameter("id"))); } catch (Exception ignored) {}
        it.setName(req.getParameter("name"));
        it.setStatus(req.getParameter("status"));
        try { it.setUnitPrice(new BigDecimal(req.getParameter("unit_price"))); }
        catch (Exception e) { it.setUnitPrice(null); }

        String updatedBy = String.valueOf(req.getSession().getAttribute("username"));
        try {
            service.update(it, updatedBy);
            resp.sendRedirect(req.getContextPath()+"/items?msg=updated");
        } catch (Exception ex) {
            req.setAttribute("mode", "edit");
            req.setAttribute("error", ex.getMessage());
            req.setAttribute("item", it);
            req.getRequestDispatcher("/views/item_form.jsp").forward(req, resp);
        }
    }
}
