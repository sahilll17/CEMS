package com.cems.web;

import com.cems.model.Role;
import com.cems.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {"/student/*", "/admin/*"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();

        // Prevent browser caching for secured pages
        res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        res.setHeader("Pragma", "no-cache");
        res.setDateHeader("Expires", 0);

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (user == null || !user.isActive()) {
            res.sendRedirect(contextPath + "/login.jsp?error=session_expired");
            return;
        }

        // Check Admin/Organizer path access
        if (uri.startsWith(contextPath + "/admin/")) {
            if (user.getRole() != Role.ADMIN && user.getRole() != Role.ORGANIZER) {
                res.sendRedirect(contextPath + "/student/dashboard?error=access_denied");
                return;
            }
        }

        chain.doFilter(request, response);
    }
}
