<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="com.cems.dao.EventDao" %>
<%@ page import="com.cems.dao.VenueDao" %>
<%@ page import="com.cems.dao.RegistrationDao" %>
<%@ page import="com.cems.model.Event" %>
<%@ page import="java.util.List" %>

<%
    java.util.List<Event> upcomingEvents = java.util.Collections.emptyList();
    long totalEvents = 0;
    long totalVenues = 0;
    long totalRegistrations = 0;
    String dbErrorMessage = null;

    try {
        EventDao eventDao = new EventDao();
        VenueDao venueDao = new VenueDao();
        RegistrationDao registrationDao = new RegistrationDao();

        upcomingEvents = eventDao.getUpcomingApprovedEvents();
        totalEvents = eventDao.countTotalEvents();
        totalVenues = venueDao.countVenues();
        totalRegistrations = registrationDao.countTotalRegistrations();

        if (com.cems.util.HibernateUtil.getLastErrorMessage() != null) {
            dbErrorMessage = com.cems.util.HibernateUtil.getLastErrorMessage();
        }
    } catch (Throwable t) {
        dbErrorMessage = t.getMessage();
    }

    request.setAttribute("upcomingEvents", upcomingEvents.size() > 6 ? upcomingEvents.subList(0, 6) : upcomingEvents);
    request.setAttribute("totalEvents", totalEvents);
    request.setAttribute("totalVenues", totalVenues);
    request.setAttribute("totalRegistrations", totalRegistrations);
    request.setAttribute("dbErrorMessage", dbErrorMessage);
    request.setAttribute("activeNav", "home");
    request.setAttribute("pageTitle", "Home | College Event Management System (CEMS)");
%>

<jsp:include page="/WEB-INF/includes/header.jsp" />
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="main-content">
    <div class="container">
        <jsp:include page="/WEB-INF/includes/alerts.jsp" />

        <c:if test="${not empty dbErrorMessage}">
            <div class="alert alert-warning" style="display: flex; align-items: flex-start; gap: 1rem; margin-bottom: 2rem;">
                <i class="fa-solid fa-triangle-exclamation" style="font-size: 1.5rem; color: #b45309; margin-top: 0.2rem;"></i>
                <div style="flex: 1;">
                    <strong style="font-size: 1.05rem; display: block; margin-bottom: 0.25rem;">
                        Database Connection Notice
                    </strong>
                    <div style="font-size: 0.92rem; margin-bottom: 0.5rem;">
                        MySQL reported: <code>${dbErrorMessage}</code>
                    </div>
                    <div style="font-size: 0.85rem; color: #6b7280;">
                        Please verify that MySQL is running on port 3306 and check credentials in <code>src/main/resources/db.properties</code>.
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Academic Hero Banner -->
        <div class="card" style="background: linear-gradient(to right, #1a365d, #2563eb); color: #ffffff; padding: 2.75rem 2rem; margin-bottom: 2rem; border: none; box-shadow: var(--shadow-md);">
            <div style="max-width: 800px;">
                <div style="display: inline-flex; align-items: center; gap: 0.5rem; background: rgba(255, 255, 255, 0.15); padding: 0.3rem 0.8rem; border-radius: var(--radius-sm); font-size: 0.85rem; font-weight: 600; margin-bottom: 1rem;">
                    <i class="fa-solid fa-graduation-cap"></i> Chandigarh University &bull; MCA Sem 1 Mini Project
                </div>

                <h1 style="color: #ffffff; font-size: 2.3rem; font-weight: 700; margin-bottom: 0.75rem; line-height: 1.2;">
                    College Event Management System (CEMS)
                </h1>

                <p style="font-size: 1.05rem; color: #e2e8f0; line-height: 1.6; margin-bottom: 1.75rem;">
                    A simple and centralized campus portal to discover events, register online, check venue schedules, and download event entry passes.
                </p>

                <div style="display: flex; gap: 0.75rem; flex-wrap: wrap;">
                    <a href="${pageContext.request.contextPath}/student/events" class="btn btn-primary" style="background-color: #ffffff; color: #1a365d; font-weight: 600; border: none;">
                        <i class="fa-solid fa-calendar-days"></i> Browse Upcoming Events
                    </a>
                    <c:choose>
                        <c:when test="${not empty sessionScope.currentUser}">
                            <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-secondary" style="background-color: rgba(255,255,255,0.2); color: #ffffff; border: 1px solid rgba(255,255,255,0.4);">
                                <i class="fa-solid fa-user"></i> My Dashboard
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-secondary" style="background-color: rgba(255,255,255,0.2); color: #ffffff; border: 1px solid rgba(255,255,255,0.4);">
                                <i class="fa-solid fa-user-plus"></i> Student Sign Up
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Summary Metric Boxes -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fa-solid fa-calendar-check"></i>
                </div>
                <div class="stat-info">
                    <span class="stat-value">${totalEvents}</span>
                    <span class="stat-label">Scheduled Events</span>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fa-solid fa-ticket"></i>
                </div>
                <div class="stat-info">
                    <span class="stat-value">${totalRegistrations}</span>
                    <span class="stat-label">Total Registrations</span>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fa-solid fa-landmark"></i>
                </div>
                <div class="stat-info">
                    <span class="stat-value">${totalVenues}</span>
                    <span class="stat-label">Campus Venues</span>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fa-solid fa-clock"></i>
                </div>
                <div class="stat-info">
                    <span class="stat-value">Active</span>
                    <span class="stat-label">System Status</span>
                </div>
            </div>
        </div>

        <!-- Section: Upcoming Campus Events -->
        <div style="margin-top: 2.5rem;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.25rem;">
                <div>
                    <h2 style="font-size: 1.6rem; color: #1e293b;">Upcoming Campus Events</h2>
                    <p style="color: var(--text-muted); font-size: 0.9rem;">Join workshops, technical competitions, and cultural events.</p>
                </div>
                <a href="${pageContext.request.contextPath}/student/events" class="btn btn-outline btn-sm">
                    View All Events <i class="fa-solid fa-arrow-right"></i>
                </a>
            </div>

            <c:choose>
                <c:when test="${empty upcomingEvents}">
                    <div class="card" style="padding: 2.5rem; text-align: center;">
                        <i class="fa-solid fa-calendar-xmark" style="font-size: 2.5rem; color: var(--text-muted); margin-bottom: 0.75rem;"></i>
                        <h3>No Upcoming Events Available</h3>
                        <p style="color: var(--text-muted); margin-top: 0.25rem;">New events will appear here once scheduled by administrators or organizers.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="event-grid">
                        <c:forEach var="event" items="${upcomingEvents}">
                            <div class="event-card">
                                <div class="event-image-wrap">
                                    <img src="${event.bannerUrl}" alt="${event.title}" loading="lazy">
                                    <span class="badge badge-${event.category.toLowerCase()} event-category-badge">
                                        ${event.category}
                                    </span>
                                    <div class="event-date-chip">
                                        <i class="fa-regular fa-calendar"></i>
                                        <span>${event.eventDate}</span>
                                    </div>
                                </div>

                                <div class="event-content">
                                    <h3 class="event-title">${event.title}</h3>
                                    
                                    <div class="event-meta">
                                        <div class="meta-item">
                                            <i class="fa-solid fa-location-dot meta-icon"></i>
                                            <span>${event.venue.name}</span>
                                        </div>
                                        <div class="meta-item">
                                            <i class="fa-regular fa-clock meta-icon"></i>
                                            <span>${event.startTime} - ${event.endTime}</span>
                                        </div>
                                        <div class="meta-item">
                                            <i class="fa-solid fa-user meta-icon"></i>
                                            <span>Organizer: ${event.organizer.name}</span>
                                        </div>
                                    </div>

                                    <!-- Capacity -->
                                    <div style="margin-bottom: 1rem; font-size: 0.85rem;">
                                        <div style="display: flex; justify-content: space-between; margin-bottom: 0.35rem;">
                                            <span>Registrations:</span>
                                            <span>
                                                <c:choose>
                                                    <c:when test="${event.full}">
                                                        <strong style="color: var(--danger);">Seats Full (${event.maxCapacity})</strong>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <strong>${event.currentRegistrations} / ${event.maxCapacity}</strong> (${event.remainingSeats} left)
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <div class="progress-bar-bg" style="height: 6px;">
                                            <div class="progress-fill ${event.full ? 'full' : ''}" style="width: ${event.capacityPercentage}%;"></div>
                                        </div>
                                    </div>

                                    <div style="margin-top: auto;">
                                        <a href="${pageContext.request.contextPath}/student/event-details?id=${event.id}" class="btn btn-primary btn-block">
                                            View Details & Register <i class="fa-solid fa-arrow-right"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Section: Key Mini Project Features -->
        <div style="margin-top: 3.5rem; padding-top: 2rem; border-top: 1px solid var(--border-color);">
            <div style="text-align: center; max-width: 650px; margin: 0 auto 2.5rem;">
                <h2 style="font-size: 1.75rem; color: #1e293b;">Project Features & Modules</h2>
                <p style="color: var(--text-muted); font-size: 0.95rem; margin-top: 0.35rem;">
                    Key components built for the MCA Semester 1 Mini Project evaluation.
                </p>
            </div>

            <div class="stats-grid" style="grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));">
                <div class="card" style="padding: 1.5rem;">
                    <div style="font-size: 1.8rem; color: var(--primary); margin-bottom: 0.75rem;">
                        <i class="fa-solid fa-magnifying-glass"></i>
                    </div>
                    <h3 style="font-size: 1.15rem; margin-bottom: 0.5rem;">Event Discovery</h3>
                    <p style="color: var(--text-muted); font-size: 0.88rem;">
                        Students can browse upcoming campus events, filter by categories (Technical, Cultural, Sports, Workshops), and view details.
                    </p>
                </div>

                <div class="card" style="padding: 1.5rem;">
                    <div style="font-size: 1.8rem; color: var(--success); margin-bottom: 0.75rem;">
                        <i class="fa-solid fa-ticket"></i>
                    </div>
                    <h3 style="font-size: 1.15rem; margin-bottom: 0.5rem;">Online Registration & Pass</h3>
                    <p style="color: var(--text-muted); font-size: 0.88rem;">
                        Instant student registration with real-time seat availability checks and downloadable/printable entry passes.
                    </p>
                </div>

                <div class="card" style="padding: 1.5rem;">
                    <div style="font-size: 1.8rem; color: #0284c7; margin-bottom: 0.75rem;">
                        <i class="fa-solid fa-landmark"></i>
                    </div>
                    <h3 style="font-size: 1.15rem; margin-bottom: 0.5rem;">Venue Management</h3>
                    <p style="color: var(--text-muted); font-size: 0.88rem;">
                        Automatic scheduling check prevents double-booking of halls and auditoriums at the same date and time.
                    </p>
                </div>

                <div class="card" style="padding: 1.5rem;">
                    <div style="font-size: 1.8rem; color: #d97706; margin-bottom: 0.75rem;">
                        <i class="fa-solid fa-users"></i>
                    </div>
                    <h3 style="font-size: 1.15rem; margin-bottom: 0.5rem;">Admin & Faculty Panel</h3>
                    <p style="color: var(--text-muted); font-size: 0.88rem;">
                        Admins and organizers can create new events, view lists of registered students, and manage campus venues.
                    </p>
                </div>
            </div>
        </div>

    </div>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
