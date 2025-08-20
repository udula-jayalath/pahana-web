package lk.icbt.pahana.web;

import lk.icbt.pahana.service.AuthenticationService;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import java.io.IOException;

public class LogoutServlet extends HttpServlet {
    private final AuthenticationService auth = new AuthenticationService();

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        if (s != null) {
            Integer userId = (Integer) s.getAttribute("userId");
            if (userId != null) {
                try { auth.logout(userId); } catch (Exception ignored) {}
            }
            s.invalidate();
        }
        resp.sendRedirect(req.getContextPath() + "/views/login.jsp");
    }
}
