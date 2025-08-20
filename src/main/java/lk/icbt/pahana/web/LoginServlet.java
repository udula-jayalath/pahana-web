package lk.icbt.pahana.web;

import lk.icbt.pahana.model.AuthResult;
import lk.icbt.pahana.model.User;
import lk.icbt.pahana.service.AuthenticationService;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import java.io.IOException;
import java.util.Arrays;

public class LoginServlet extends HttpServlet {
    private final AuthenticationService auth = new AuthenticationService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String username = req.getParameter("username");
        char[] password = req.getParameter("password") != null
                ? req.getParameter("password").toCharArray()
                : new char[0];

        try {
            AuthResult res = auth.authenticate(username, password);
            if (res != null) {
                User u = res.getUser();
                HttpSession s = req.getSession(true);
                s.setAttribute("userId", u.getId());
                s.setAttribute("username", u.getUsername());
                s.setAttribute("role", u.getRole());
                s.setAttribute("loginAuditId", res.getLoginAuditId()); // useful for logout

                resp.sendRedirect(req.getContextPath() + "/views/dashboard.jsp");
            } else {
                req.setAttribute("error", "Invalid credentials");
                req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        } finally {
            Arrays.fill(password, '\0');
        }
    }
}
