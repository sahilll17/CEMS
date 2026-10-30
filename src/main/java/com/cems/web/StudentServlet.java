package com.cems.web;

import com.cems.dao.EventDao;
import com.cems.dao.NotificationDao;
import com.cems.dao.RegistrationDao;
import com.cems.model.AttendanceStatus;
import com.cems.model.Event;
import com.cems.model.Notification;
import com.cems.model.Registration;
import com.cems.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;

@WebServlet("/student/*")
public class StudentServlet extends HttpServlet {

    private final EventDao eventDao = new EventDao();
    private final RegistrationDao registrationDao = new RegistrationDao();
    private final NotificationDao notificationDao = new NotificationDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null || "/".equals(path) || "/dashboard".equalsIgnoreCase(path)) {
            showDashboard(req, resp);
        } else if ("/events".equalsIgnoreCase(path)) {
            showEvents(req, resp);
        } else if ("/event-details".equalsIgnoreCase(path)) {
            showEventDetails(req, resp);
        } else if ("/my-tickets".equalsIgnoreCase(path)) {
            showMyTickets(req, resp);
        } else if ("/ticket".equalsIgnoreCase(path)) {
            showTicket(req, resp);
        } else if ("/certificate".equalsIgnoreCase(path)) {
            showCertificate(req, resp);
        } else if ("/notifications".equalsIgnoreCase(path)) {
            showNotifications(req, resp);
        } else if ("/mark-notification-read".equalsIgnoreCase(path)) {
            handleMarkNotification(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/student/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if ("/register-event".equalsIgnoreCase(path)) {
            handleRegisterEvent(req, resp);
        } else if ("/cancel-registration".equalsIgnoreCase(path)) {
            handleCancelRegistration(req, resp);
        } else {
            doGet(req, resp);
        }
    }

    private User getLoggedUser(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return (session != null) ? (User) session.getAttribute("currentUser") : null;
    }

    private void updateUnreadNotificationCount(HttpServletRequest req, Long userId) {
        HttpSession session = req.getSession(false);
        if (session != null && userId != null) {
            long count = notificationDao.getUnreadCount(userId);
            session.setAttribute("unreadNotificationsCount", count);
        }
    }

    private void showDashboard(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = getLoggedUser(req);
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        updateUnreadNotificationCount(req, user.getId());

        List<Registration> upcomingRegistrations = registrationDao.getUpcomingUserRegistrations(user.getId());
        List<Registration> pastRegistrations = registrationDao.getPastUserRegistrations(user.getId());
        List<Event> upcomingEvents = eventDao.getUpcomingApprovedEvents();
        List<Notification> recentNotifs = notificationDao.getUserNotifications(user.getId());

        req.setAttribute("upcomingRegistrations", upcomingRegistrations);
        req.setAttribute("pastRegistrations", pastRegistrations);
        req.setAttribute("upcomingEvents", upcomingEvents);
        req.setAttribute("recentNotifications", recentNotifs.size() > 5 ? recentNotifs.subList(0, 5) : recentNotifs);
        req.setAttribute("totalRegisteredCount", upcomingRegistrations.size() + pastRegistrations.size());

        req.getRequestDispatcher("/WEB-INF/views/student/dashboard.jsp").forward(req, resp);
    }

    private void showEvents(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("q");
        String category = req.getParameter("category");
        String fromStr = req.getParameter("from");
        String toStr = req.getParameter("to");

        LocalDate fromDate = null;
        LocalDate toDate = null;
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        try {
            if (fromStr != null && !fromStr.trim().isEmpty()) {
                fromDate = LocalDate.parse(fromStr.trim(), dtf);
            }
            if (toStr != null && !toStr.trim().isEmpty()) {
                toDate = LocalDate.parse(toStr.trim(), dtf);
            }
        } catch (Exception ignored) {
        }

        List<Event> events = eventDao.searchAndFilter(keyword, category, fromDate, toDate);

        req.setAttribute("events", events);
        req.setAttribute("selectedCategory", category != null ? category : "ALL");
        req.setAttribute("searchKeyword", keyword != null ? keyword : "");
        req.setAttribute("fromDate", fromStr != null ? fromStr : "");
        req.setAttribute("toDate", toStr != null ? toStr : "");

        req.getRequestDispatcher("/WEB-INF/views/student/events.jsp").forward(req, resp);
    }

    private void showEventDetails(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/student/events");
            return;
        }

        try {
            Long eventId = Long.parseLong(idStr.trim());
            Event event = eventDao.findById(eventId);
            if (event == null) {
                resp.sendRedirect(req.getContextPath() + "/student/events?error=event_not_found");
                return;
            }

            User user = getLoggedUser(req);
            boolean isRegistered = false;
            Registration userRegistration = null;

            if (user != null) {
                isRegistered = registrationDao.isStudentRegistered(eventId, user.getId());
                if (isRegistered) {
                    List<Registration> userRegs = registrationDao.getUserRegistrations(user.getId());
                    for (Registration r : userRegs) {
                        if (r.getEvent().getId().equals(eventId) && r.getAttendanceStatus() != AttendanceStatus.CANCELLED) {
                            userRegistration = r;
                            break;
                        }
                    }
                }
            }

            req.setAttribute("event", event);
            req.setAttribute("isRegistered", isRegistered);
            req.setAttribute("userRegistration", userRegistration);

            req.getRequestDispatcher("/WEB-INF/views/student/event-details.jsp").forward(req, resp);
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/student/events?error=invalid_id");
        }
    }

    private void handleRegisterEvent(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = getLoggedUser(req);
        String eventIdStr = req.getParameter("eventId");
        String contextPath = req.getContextPath();

        if (user == null || eventIdStr == null || eventIdStr.trim().isEmpty()) {
            resp.sendRedirect(contextPath + "/login.jsp");
            return;
        }

        try {
            Long eventId = Long.parseLong(eventIdStr.trim());
            Event event = eventDao.findById(eventId);
            if (event == null || !event.isApproved()) {
                resp.sendRedirect(contextPath + "/student/events?error=event_unavailable");
                return;
            }

            // Check if student already registered
            if (registrationDao.isStudentRegistered(eventId, user.getId())) {
                resp.sendRedirect(contextPath + "/student/event-details?id=" + eventId + "&error=already_registered");
                return;
            }

            // Atomic capacity check and increment
            boolean reserved = eventDao.incrementRegistration(eventId);
            if (!reserved) {
                resp.sendRedirect(contextPath + "/student/event-details?id=" + eventId + "&error=capacity_full");
                return;
            }

            // read team details if group registration
            String participationType = req.getParameter("participationType");
            String teamName = req.getParameter("teamName");
            String teamMembers = req.getParameter("teamMembers");

            // generate unique ticket code
            String ticketCode = "CEMS-TKT-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            String qrData = "CEMS_PASS|TICKET:" + ticketCode + "|UID:" + user.getUid() + "|EVENT:" + event.getId() + "|NAME:" + user.getName();

            // create registration instance
            Registration registration = new Registration(ticketCode, event, user, qrData);
            if ("TEAM".equalsIgnoreCase(participationType) && teamName != null && !teamName.trim().isEmpty()) {
                registration.setTeamName(teamName.trim());
                registration.setTeamMembers(teamMembers != null ? teamMembers.trim() : "");
            }

            boolean saved = registrationDao.save(registration);

            if (saved) {
                // send confirmation notification to student
                Notification notif = new Notification(
                    user,
                    event,
                    "Registration Confirmed: " + event.getTitle(),
                    "Your ticket " + ticketCode + " is confirmed for " + event.getTitle() + " on " + event.getEventDate() + " at " + event.getVenue().getName() + ".",
                    "REGISTRATION"
                );
                notificationDao.save(notif);
                updateUnreadNotificationCount(req, user.getId());

                resp.sendRedirect(contextPath + "/student/ticket?id=" + registration.getId() + "&msg=registration_success");
            } else {
                // rollback seat reservation if registration save fails
                eventDao.decrementRegistration(eventId);
                resp.sendRedirect(contextPath + "/student/event-details?id=" + eventId + "&error=registration_failed");
            }

        } catch (Exception e) {
            resp.sendRedirect(contextPath + "/student/events?error=server_error");
        }
    }

    private void handleCancelRegistration(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = getLoggedUser(req);
        String regIdStr = req.getParameter("registrationId");
        String contextPath = req.getContextPath();

        if (user == null || regIdStr == null || regIdStr.trim().isEmpty()) {
            resp.sendRedirect(contextPath + "/login.jsp");
            return;
        }

        try {
            Long regId = Long.parseLong(regIdStr.trim());
            Registration reg = registrationDao.findById(regId);
            if (reg != null && reg.getUser().getId().equals(user.getId())) {
                registrationDao.cancelRegistration(regId);

                // Notify student
                Notification notif = new Notification(
                    user,
                    reg.getEvent(),
                    "Registration Cancelled",
                    "Your registration for " + reg.getEvent().getTitle() + " (Ticket: " + reg.getTicketCode() + ") has been successfully cancelled.",
                    "CANCELLATION"
                );
                notificationDao.save(notif);
                updateUnreadNotificationCount(req, user.getId());

                resp.sendRedirect(contextPath + "/student/my-tickets?msg=cancelled_success");
            } else {
                resp.sendRedirect(contextPath + "/student/my-tickets?error=invalid_ticket");
            }
        } catch (Exception e) {
            resp.sendRedirect(contextPath + "/student/my-tickets?error=server_error");
        }
    }

    private void showMyTickets(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = getLoggedUser(req);
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        List<Registration> upcoming = registrationDao.getUpcomingUserRegistrations(user.getId());
        List<Registration> past = registrationDao.getPastUserRegistrations(user.getId());

        req.setAttribute("upcomingRegistrations", upcoming);
        req.setAttribute("pastRegistrations", past);

        req.getRequestDispatcher("/WEB-INF/views/student/my-tickets.jsp").forward(req, resp);
    }

    private void showTicket(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = getLoggedUser(req);
        String regIdStr = req.getParameter("id");
        String ticketCode = req.getParameter("code");

        Registration registration = null;
        if (regIdStr != null && !regIdStr.trim().isEmpty()) {
            try {
                registration = registrationDao.findById(Long.parseLong(regIdStr.trim()));
            } catch (Exception ignored) {
            }
        } else if (ticketCode != null && !ticketCode.trim().isEmpty()) {
            registration = registrationDao.findByTicketCode(ticketCode.trim());
        }

        if (registration == null) {
            resp.sendRedirect(req.getContextPath() + "/student/my-tickets?error=ticket_not_found");
            return;
        }

        // Allow ticket view if user owns it or if user is Admin/Organizer
        if (!registration.getUser().getId().equals(user.getId()) &&
            user.getRole() != com.cems.model.Role.ADMIN &&
            user.getRole() != com.cems.model.Role.ORGANIZER) {
            resp.sendRedirect(req.getContextPath() + "/student/my-tickets?error=unauthorized_access");
            return;
        }

        req.setAttribute("registration", registration);
        req.setAttribute("event", registration.getEvent());
        req.setAttribute("student", registration.getUser());

        req.getRequestDispatcher("/WEB-INF/views/student/ticket-view.jsp").forward(req, resp);
    }

    // display digital participation or merit certificate for attended students
    private void showCertificate(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = getLoggedUser(req);
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String regIdStr = req.getParameter("id");
        if (regIdStr == null || regIdStr.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/student/my-tickets");
            return;
        }

        try {
            Long regId = Long.parseLong(regIdStr.trim());
            Registration registration = registrationDao.findById(regId);

            if (registration == null) {
                resp.sendRedirect(req.getContextPath() + "/student/my-tickets?error=ticket_not_found");
                return;
            }

            // check ownership unless user is admin or coordinator
            if (!registration.getUser().getId().equals(user.getId()) &&
                user.getRole() != com.cems.model.Role.ADMIN &&
                user.getRole() != com.cems.model.Role.ORGANIZER) {
                resp.sendRedirect(req.getContextPath() + "/student/my-tickets?error=unauthorized_access");
                return;
            }

            // verify student was marked present / attended
            if (registration.getAttendanceStatus() != AttendanceStatus.ATTENDED) {
                resp.sendRedirect(req.getContextPath() + "/student/my-tickets?error=certificate_not_eligible");
                return;
            }

            req.setAttribute("registration", registration);
            req.setAttribute("event", registration.getEvent());
            req.setAttribute("student", registration.getUser());

            req.getRequestDispatcher("/WEB-INF/views/student/certificate.jsp").forward(req, resp);
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/student/my-tickets?error=server_error");
        }
    }

    private void showNotifications(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = getLoggedUser(req);
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        List<Notification> notifications = notificationDao.getUserNotifications(user.getId());
        req.setAttribute("notifications", notifications);

        req.getRequestDispatcher("/WEB-INF/views/student/notifications.jsp").forward(req, resp);
    }

    private void handleMarkNotification(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = getLoggedUser(req);
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String all = req.getParameter("all");
        String idStr = req.getParameter("id");

        if ("true".equalsIgnoreCase(all)) {
            notificationDao.markAllAsRead(user.getId());
        } else if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                notificationDao.markAsRead(Long.parseLong(idStr.trim()));
            } catch (Exception ignored) {
            }
        }

        updateUnreadNotificationCount(req, user.getId());
        resp.sendRedirect(req.getContextPath() + "/student/notifications");
    }
}
