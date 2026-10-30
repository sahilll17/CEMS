package com.cems.web;

import com.cems.dao.NotificationDao;
import com.cems.dao.UserDao;
import com.cems.model.Notification;
import com.cems.model.Role;
import com.cems.model.User;
import com.cems.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {

    private final UserDao userDao = new UserDao();
    private final NotificationDao notificationDao = new NotificationDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("logout".equalsIgnoreCase(action)) {
            handleLogout(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("login".equalsIgnoreCase(action)) {
            handleLogin(req, resp);
        } else if ("register".equalsIgnoreCase(action)) {
            handleRegister(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String contextPath = req.getContextPath();

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            resp.sendRedirect(contextPath + "/login.jsp?error=missing_credentials");
            return;
        }

        User user = userDao.findByEmail(email.trim().toLowerCase());
        if (user == null) {
            user = userDao.findByUid(email.trim().toUpperCase());
        }
        if (user == null || !PasswordUtil.checkPassword(password, user.getPasswordHash())) {
            resp.sendRedirect(contextPath + "/login.jsp?error=invalid_credentials");
            return;
        }

        if (!user.isActive()) {
            resp.sendRedirect(contextPath + "/login.jsp?error=account_suspended");
            return;
        }

        HttpSession session = req.getSession(true);
        session.setAttribute("currentUser", user);

        // Track unread notifications count in session
        long unreadCount = notificationDao.getUnreadCount(user.getId());
        session.setAttribute("unreadNotificationsCount", unreadCount);

        if (user.getRole() == Role.ADMIN || user.getRole() == Role.ORGANIZER) {
            resp.sendRedirect(contextPath + "/admin/dashboard");
        } else {
            resp.sendRedirect(contextPath + "/student/dashboard");
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // get form parameters
        String uid = req.getParameter("uid");
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String department = req.getParameter("department");
        String semester = req.getParameter("semester");
        String phone = req.getParameter("phone");
        String contextPath = req.getContextPath();

        // check if any required field is empty
        if (uid == null || uid.trim().isEmpty() ||
            name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            resp.sendRedirect(contextPath + "/register.jsp?error=invalid_inputs");
            return;
        }

        // validate student uid format (alphanumeric, 5 to 20 characters)
        if (!uid.trim().matches("^[a-zA-Z0-9]{5,20}$")) {
            resp.sendRedirect(contextPath + "/register.jsp?error=invalid_uid");
            return;
        }

        // validate student name format (letters and spaces only)
        if (!name.trim().matches("^[a-zA-Z ]{3,50}$")) {
            resp.sendRedirect(contextPath + "/register.jsp?error=invalid_name");
            return;
        }

        // validate email format
        String emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
        if (!email.trim().matches(emailRegex)) {
            resp.sendRedirect(contextPath + "/register.jsp?error=invalid_email");
            return;
        }

        // validate 10 digit mobile phone number
        if (phone == null || !phone.trim().matches("^[6-9]\\d{9}$")) {
            resp.sendRedirect(contextPath + "/register.jsp?error=invalid_phone");
            return;
        }

        // validate department selection
        if (department == null || department.trim().isEmpty()) {
            resp.sendRedirect(contextPath + "/register.jsp?error=invalid_department");
            return;
        }

        // validate semester length
        if (semester == null || semester.trim().length() < 2) {
            resp.sendRedirect(contextPath + "/register.jsp?error=invalid_semester");
            return;
        }

        // check if password matches confirm password
        if (confirmPassword == null || !password.equals(confirmPassword)) {
            resp.sendRedirect(contextPath + "/register.jsp?error=password_mismatch");
            return;
        }

        // check minimum password length
        if (password.length() < 6) {
            resp.sendRedirect(contextPath + "/register.jsp?error=weak_password");
            return;
        }

        // check if email already registered in database
        if (userDao.findByEmail(email.trim().toLowerCase()) != null) {
            resp.sendRedirect(contextPath + "/register.jsp?error=email_exists");
            return;
        }

        // check if student uid already registered in database
        if (userDao.findByUid(uid.trim().toUpperCase()) != null) {
            resp.sendRedirect(contextPath + "/register.jsp?error=uid_exists");
            return;
        }

        // hash plain password using bcrypt
        String passwordHash = PasswordUtil.hashPassword(password);

        // create new student user object
        User newStudent = new User(
            uid.trim().toUpperCase(),
            name.trim(),
            email.trim().toLowerCase(),
            passwordHash,
            Role.STUDENT,
            department.trim(),
            semester.trim(),
            phone.trim()
        );

        // save student to database
        boolean saved = userDao.save(newStudent);
        if (saved) {
            // send welcome notification to student
            Notification welcomeNotif = new Notification(
                newStudent,
                null,
                "Welcome to Chandigarh University Event Management Portal",
                "Hello " + newStudent.getName() + ", your student account is successfully registered. You can now explore campus events and register.",
                "GENERAL"
            );
            notificationDao.save(welcomeNotif);

            // redirect to login page
            resp.sendRedirect(contextPath + "/login.jsp?msg=registered_successfully");
        } else {
            // redirect with error if save fails
            resp.sendRedirect(contextPath + "/register.jsp?error=registration_failed");
        }
    }

    private void handleLogout(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        resp.sendRedirect(req.getContextPath() + "/login.jsp?msg=logged_out");
    }
}
