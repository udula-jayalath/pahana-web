package lk.icbt.pahana.web;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class AuthFilter implements Filter {
    @Override public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req  = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        // Allow login page and static assets
        boolean allow = uri.endsWith("/views/login.jsp")
                || uri.endsWith("/hello")
                || uri.contains("/assets/");
        if (!allow) {
            HttpSession s = req.getSession(false);
            if (s == null || s.getAttribute("userId") == null) {
                resp.sendRedirect(req.getContextPath() + "/views/login.jsp");
                return;
            }
        }
        chain.doFilter(request, response);
    }
}
