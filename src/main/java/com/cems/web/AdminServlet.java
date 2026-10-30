package com.cems.web;

import com.cems.dao.*;
import com.cems.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {

    private final EventDao eventDao = new EventDao();
    private final VenueDao venueDao = new VenueDao();
    private final UserDao userDao = new UserDao();
    private final RegistrationDao registrationDao = new RegistrationDao();
    private final NotificationDao notificationDao = new NotificationDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null || "/".equals(path) || "/dashboard".equalsIgnoreCase(path)) {
            showDashboard(req, resp);
        } else if ("/events".equalsIgnoreCase(path)) {
            showEvents(req, resp);
        } else if ("/create-event".equalsIgnoreCase(path)) {
            showCreateEventForm(req, resp);
        } else if ("/proposals".equalsIgnoreCase(path)) {
            showProposals(req, resp);
        } else if ("/venues".equalsIgnoreCase(path)) {
            showVenues(req, resp);
        } else if ("/attendees".equalsIgnoreCase(path)) {
            showAttendees(req, resp);
        } else if ("/users".equalsIgnoreCase(path)) {
            showUsers(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if ("/save-event".equalsIgnoreCase(path)) {
            handleSaveEvent(req, resp);
        } else if ("/approve-event".equalsIgnoreCase(path)) {
            handleApproveEvent(req, resp);
        } else if ("/reject-event".equalsIgnoreCase(path)) {
            handleRejectEvent(req, resp);
        } else if ("/save-venue".equalsIgnoreCase(path)) {
            handleSaveVenue(req, resp);
        } else if ("/toggle-venue".equalsIgnoreCase(path)) {
            handleToggleVenue(req, resp);
        } else if ("/mark-attendance".equalsIgnoreCase(path)) {
            handleMarkAttendance(req, resp);
        } else if ("/toggle-user".equalsIgnoreCase(path)) {
            handleToggleUser(req, resp);
        } else {
            doGet(req, resp);
        }
    }

    private User getLoggedUser(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return (session != null) ? (User) session.getAttribute("currentUser") : null;
    }

    private void showDashboard(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        long totalEvents = eventDao.countTotalEvents();
        long pendingProposals = eventDao.countPendingProposals();
        long totalStudents = userDao.countStudents();
        long totalRegistrations = registrationDao.countTotalRegistrations();
        long activeVenues = venueDao.countVenues();

        List<Event> recentEvents = eventDao.getAllEvents();
        List<Event> pendingEvents = eventDao.getPendingProposals();
        List<Venue> venues = venueDao.getActiveVenues();

        req.setAttribute("totalEvents", totalEvents);
        req.setAttribute("pendingProposals", pendingProposals);
        req.setAttribute("totalStudents", totalStudents);
        req.setAttribute("totalRegistrations", totalRegistrations);
        req.setAttribute("activeVenues", activeVenues);
        req.setAttribute("recentEvents", recentEvents.size() > 6 ? recentEvents.subList(0, 6) : recentEvents);
        req.setAttribute("pendingEvents", pendingEvents);
        req.setAttribute("venues", venues);

        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }

    private void showEvents(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Event> events = eventDao.getAllEvents();
        req.setAttribute("events", events);
        req.getRequestDispatcher("/WEB-INF/views/admin/events.jsp").forward(req, resp);
    }

    private void showCreateEventForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Venue> venues = venueDao.getActiveVenues();
        req.setAttribute("venues", venues);
        req.getRequestDispatcher("/WEB-INF/views/admin/event-form.jsp").forward(req, resp);
    }

    private void handleSaveEvent(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = getLoggedUser(req);
        String title = req.getParameter("title");
        String category = req.getParameter("category");
        String description = req.getParameter("description");
        String venueIdStr = req.getParameter("venueId");
        String dateStr = req.getParameter("eventDate");
        String startTimeStr = req.getParameter("startTime");
        String endTimeStr = req.getParameter("endTime");
        String maxCapacityStr = req.getParameter("maxCapacity");
        String bannerUrl = req.getParameter("bannerUrl");
        String autoApproveStr = req.getParameter("autoApprove");

        String contextPath = req.getContextPath();

        if (title == null || title.trim().isEmpty() ||
            venueIdStr == null || dateStr == null ||
            startTimeStr == null || endTimeStr == null) {
            resp.sendRedirect(contextPath + "/admin/create-event?error=missing_fields");
            return;
        }

        try {
            Long venueId = Long.parseLong(venueIdStr.trim());
            Venue venue = venueDao.findById(venueId);
            if (venue == null) {
                resp.sendRedirect(contextPath + "/admin/create-event?error=invalid_venue");
                return;
            }

            LocalDate eventDate = LocalDate.parse(dateStr.trim());
            LocalTime startTime = LocalTime.parse(startTimeStr.trim());
            LocalTime endTime = LocalTime.parse(endTimeStr.trim());

            // check if event date is in the past
            if (eventDate.isBefore(LocalDate.now())) {
                resp.sendRedirect(contextPath + "/admin/create-event?error=past_date");
                return;
            }

            // check if end time is after start time
            if (!endTime.isAfter(startTime)) {
                resp.sendRedirect(contextPath + "/admin/create-event?error=invalid_time_range");
                return;
            }

            // check venue availability to prevent double-booking conflicts
            Event conflict = venueDao.findConflictingEvent(venueId, eventDate, startTime, endTime, null);
            if (conflict != null) {
                resp.sendRedirect(contextPath + "/admin/create-event?error=venue_conflict&conflictTitle=" +
                        java.net.URLEncoder.encode(conflict.getTitle(), "UTF-8") +
                        "&conflictTime=" + java.net.URLEncoder.encode(conflict.getStartTime() + "-" + conflict.getEndTime(), "UTF-8"));
                return;
            }

            int capacity = (maxCapacityStr != null && !maxCapacityStr.trim().isEmpty())
                    ? Integer.parseInt(maxCapacityStr.trim())
                    : venue.getCapacity();

            // limit capacity to venue capacity if higher
            if (capacity > venue.getCapacity()) {
                capacity = venue.getCapacity();
            }

            EventStatus status = EventStatus.PENDING_APPROVAL;
            if (user.getRole() == Role.ADMIN && "true".equalsIgnoreCase(autoApproveStr)) {
                status = EventStatus.APPROVED;
            }

            if (bannerUrl == null || bannerUrl.trim().isEmpty()) {
                bannerUrl = "https://images.unsplash.com/photo-1540575467063-178a50c2df87?auto=format&fit=crop&w=1200&q=80";
            }

            Event newEvent = new Event(
                title.trim(),
                category != null ? category.trim().toUpperCase() : "GENERAL",
                description != null ? description.trim() : "",
                venue,
                eventDate,
                startTime,
                endTime,
                capacity,
                status,
                user,
                bannerUrl.trim()
            );

            // set event rules
            String rules = req.getParameter("rules");
            if (rules != null && !rules.trim().isEmpty()) {
                newEvent.setRules(rules.trim());
            }

            // set registration deadline
            String deadlineStr = req.getParameter("registrationDeadline");
            if (deadlineStr != null && !deadlineStr.trim().isEmpty()) {
                newEvent.setRegistrationDeadline(LocalDate.parse(deadlineStr.trim()));
            }

            // set maximum team size
            String maxTeamSizeStr = req.getParameter("maxTeamSize");
            if (maxTeamSizeStr != null && !maxTeamSizeStr.trim().isEmpty()) {
                try {
                    int teamSize = Integer.parseInt(maxTeamSizeStr.trim());
                    if (teamSize >= 1) {
                        newEvent.setMaxTeamSize(teamSize);
                    }
                } catch (Exception ignored) {
                }
            }

            boolean saved = eventDao.save(newEvent);
            if (saved) {
                if (status == EventStatus.APPROVED) {
                    resp.sendRedirect(contextPath + "/admin/events?msg=event_published");
                } else {
                    resp.sendRedirect(contextPath + "/admin/events?msg=proposal_submitted");
                }
            } else {
                resp.sendRedirect(contextPath + "/admin/create-event?error=save_failed");
            }

        } catch (Exception e) {
            resp.sendRedirect(contextPath + "/admin/create-event?error=server_error");
        }
    }

    private void showProposals(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Event> proposals = eventDao.getPendingProposals();
        req.setAttribute("proposals", proposals);
        req.getRequestDispatcher("/WEB-INF/views/admin/proposals.jsp").forward(req, resp);
    }

    private void handleApproveEvent(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = getLoggedUser(req);
        if (user.getRole() != Role.ADMIN) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard?error=admin_only");
            return;
        }

        String eventIdStr = req.getParameter("eventId");
        if (eventIdStr != null && !eventIdStr.trim().isEmpty()) {
            try {
                Long eventId = Long.parseLong(eventIdStr.trim());
                Event event = eventDao.findById(eventId);
                if (event != null) {
                    // Double check venue availability one last time before approval
                    Event conflict = venueDao.findConflictingEvent(
                        event.getVenue().getId(),
                        event.getEventDate(),
                        event.getStartTime(),
                        event.getEndTime(),
                        event.getId()
                    );

                    if (conflict != null) {
                        resp.sendRedirect(req.getContextPath() + "/admin/proposals?error=conflict_exists");
                        return;
                    }

                    eventDao.updateStatus(eventId, EventStatus.APPROVED, null);

                    // Notify organizer that event is approved
                    Notification notif = new Notification(
                        event.getOrganizer(),
                        event,
                        "Event Proposal Approved: " + event.getTitle(),
                        "Congratulations! Your proposed event '" + event.getTitle() + "' has been officially approved by the Head Administrator and is now published for student registrations.",
                        "EVENT_APPROVED"
                    );
                    notificationDao.save(notif);

                    resp.sendRedirect(req.getContextPath() + "/admin/proposals?msg=approved_success");
                    return;
                }
            } catch (Exception ignored) {
            }
        }
        resp.sendRedirect(req.getContextPath() + "/admin/proposals?error=action_failed");
    }

    private void handleRejectEvent(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = getLoggedUser(req);
        if (user.getRole() != Role.ADMIN) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard?error=admin_only");
            return;
        }

        String eventIdStr = req.getParameter("eventId");
        String reason = req.getParameter("reason");

        if (eventIdStr != null && !eventIdStr.trim().isEmpty()) {
            try {
                Long eventId = Long.parseLong(eventIdStr.trim());
                Event event = eventDao.findById(eventId);
                if (event != null) {
                    eventDao.updateStatus(eventId, EventStatus.REJECTED, reason);

                    Notification notif = new Notification(
                        event.getOrganizer(),
                        event,
                        "Event Proposal Update: " + event.getTitle(),
                        "Your event proposal '" + event.getTitle() + "' could not be approved. Reason: " +
                                (reason != null && !reason.trim().isEmpty() ? reason : "Venue/Schedule limitation"),
                        "CANCELLATION"
                    );
                    notificationDao.save(notif);

                    resp.sendRedirect(req.getContextPath() + "/admin/proposals?msg=rejected_success");
                    return;
                }
            } catch (Exception ignored) {
            }
        }
        resp.sendRedirect(req.getContextPath() + "/admin/proposals?error=action_failed");
    }

    private void showVenues(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Venue> venues = venueDao.getAllVenues();
        req.setAttribute("venues", venues);
        req.getRequestDispatcher("/WEB-INF/views/admin/venues.jsp").forward(req, resp);
    }

    private void handleSaveVenue(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String name = req.getParameter("name");
        String location = req.getParameter("location");
        String capacityStr = req.getParameter("capacity");
        String description = req.getParameter("description");
        String facilities = req.getParameter("facilities");

        if (name == null || name.trim().isEmpty() || location == null || capacityStr == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/venues?error=missing_fields");
            return;
        }

        try {
            int capacity = Integer.parseInt(capacityStr.trim());
            Venue venue = new Venue(name.trim(), location.trim(), capacity, description, facilities);
            venueDao.save(venue);
            resp.sendRedirect(req.getContextPath() + "/admin/venues?msg=venue_added");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/admin/venues?error=save_failed");
        }
    }

    private void handleToggleVenue(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String venueIdStr = req.getParameter("venueId");
        if (venueIdStr != null) {
            try {
                Long id = Long.parseLong(venueIdStr.trim());
                Venue venue = venueDao.findById(id);
                if (venue != null) {
                    venue.setActive(!venue.isActive());
                    venueDao.update(venue);
                }
            } catch (Exception ignored) {
            }
        }
        resp.sendRedirect(req.getContextPath() + "/admin/venues?msg=status_updated");
    }

    private void showAttendees(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String eventIdStr = req.getParameter("eventId");
        List<Event> allEvents = eventDao.getAllEvents();
        req.setAttribute("allEvents", allEvents);

        Event selectedEvent = null;
        List<Registration> attendees = Collections.emptyList();

        if (eventIdStr != null && !eventIdStr.trim().isEmpty()) {
            try {
                Long eventId = Long.parseLong(eventIdStr.trim());
                selectedEvent = eventDao.findById(eventId);
                if (selectedEvent != null) {
                    attendees = registrationDao.getEventRegistrations(eventId);
                }
            } catch (Exception ignored) {
            }
        } else if (!allEvents.isEmpty()) {
            selectedEvent = allEvents.get(0);
            attendees = registrationDao.getEventRegistrations(selectedEvent.getId());
        }

        req.setAttribute("selectedEvent", selectedEvent);
        req.setAttribute("attendees", attendees);

        req.getRequestDispatcher("/WEB-INF/views/admin/attendees.jsp").forward(req, resp);
    }

    // handle marking attendance, entering score, and awarding merit rankings
    private void handleMarkAttendance(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String regIdStr = req.getParameter("registrationId");
        String statusStr = req.getParameter("status");
        String score = req.getParameter("score");
        String meritRank = req.getParameter("meritRank");
        String eventIdStr = req.getParameter("eventId");

        if (regIdStr != null && !regIdStr.trim().isEmpty()) {
            try {
                Long regId = Long.parseLong(regIdStr.trim());
                AttendanceStatus status = null;
                if (statusStr != null && !statusStr.trim().isEmpty()) {
                    status = AttendanceStatus.valueOf(statusStr.trim().toUpperCase());
                }

                // update attendance, score, and rank in database
                boolean updated = registrationDao.updateAttendanceAndScore(regId, status, score, meritRank);

                // send notification if merit rank is awarded
                if (updated && meritRank != null && !meritRank.trim().isEmpty() && !"PARTICIPANT".equalsIgnoreCase(meritRank.trim())) {
                    Registration reg = registrationDao.findById(regId);
                    if (reg != null) {
                        Notification notif = new Notification(
                            reg.getUser(),
                            reg.getEvent(),
                            "Winner Announced: " + reg.getEvent().getTitle(),
                            "Congratulations " + reg.getUser().getName() + "! You have been awarded " + meritRank.replace("_", " ") + " in " + reg.getEvent().getTitle() + ". Your Digital Merit Certificate is now available.",
                            "ANNOUNCEMENT"
                        );
                        notificationDao.save(notif);
                    }
                }
            } catch (Exception ignored) {
            }
        }

        resp.sendRedirect(req.getContextPath() + "/admin/attendees?eventId=" + (eventIdStr != null ? eventIdStr : "") + "&msg=attendance_updated");
    }

    private void showUsers(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<User> users = userDao.getAllUsers();
        req.setAttribute("users", users);
        req.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(req, resp);
    }

    private void handleToggleUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String userIdStr = req.getParameter("userId");
        if (userIdStr != null) {
            try {
                Long userId = Long.parseLong(userIdStr.trim());
                User user = userDao.findById(userId);
                if (user != null && user.getRole() != Role.ADMIN) {
                    String newStatus = "ACTIVE".equalsIgnoreCase(user.getStatus()) ? "SUSPENDED" : "ACTIVE";
                    userDao.updateStatus(userId, newStatus);
                }
            } catch (Exception ignored) {
            }
        }
        resp.sendRedirect(req.getContextPath() + "/admin/users?msg=user_status_changed");
    }
}
