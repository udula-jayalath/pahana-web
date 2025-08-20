package lk.icbt.pahana.web;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import java.io.IOException;
import java.io.PrintWriter;

public class HelloServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = resp.getWriter()) {
            out.println("<!doctype html><html><head><title>Hello</title></head><body>");
            out.println("<h2>Pahana Edu – Setup OK ✅</h2>");
            out.println("<p><a href='"+req.getContextPath()+"/index.jsp'>Go to Home</a></p>");
            out.println("</body></html>");
        }
    }
}
