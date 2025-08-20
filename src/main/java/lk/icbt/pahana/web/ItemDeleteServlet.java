package lk.icbt.pahana.web;

import lk.icbt.pahana.service.ItemService;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import java.io.IOException;

public class ItemDeleteServlet extends HttpServlet {
    private final ItemService service = new ItemService();
    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            service.deleteById(id);
            resp.sendRedirect(req.getContextPath()+"/items?msg=deleted");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath()+"/items?err=bad_id");
        }
    }
}
