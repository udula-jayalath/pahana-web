package lk.icbt.pahana.web;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import java.io.IOException;

public class CustomerNewServlet extends HttpServlet {
    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("mode", "create");
        req.getRequestDispatcher("/views/customer_form.jsp").forward(req, resp);
    }
}
