package lk.icbt.pahana.web;

import lk.icbt.pahana.service.ItemService;
import javax.servlet.http.*;
import javax.servlet.ServletException;
import java.io.IOException;

    public class ItemListServlet extends HttpServlet {
    private final ItemService service = new ItemService();
    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String q = req.getParameter("q");
        try {
            req.setAttribute("items", service.list(q));
            req.setAttribute("q", q == null ? "" : q);
            req.getRequestDispatcher("/views/items.jsp").forward(req, resp);
        } catch (Exception e) { throw new ServletException(e); }
    }
}
