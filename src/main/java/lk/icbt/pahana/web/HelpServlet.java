package lk.icbt.pahana.web;

import lk.icbt.pahana.service.HelpService;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import java.io.IOException;

public class HelpServlet extends HttpServlet {
    private final HelpService service = new HelpService();

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("sections", service.getManualSections());
            req.getRequestDispatcher("/views/help.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
