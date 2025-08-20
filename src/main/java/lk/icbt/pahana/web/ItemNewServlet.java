package lk.icbt.pahana.web;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import java.io.IOException;

public class ItemNewServlet extends HttpServlet {
    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("mode", "create");
        req.getRequestDispatcher("/views/item_form.jsp").forward(req, resp);
    }
}
