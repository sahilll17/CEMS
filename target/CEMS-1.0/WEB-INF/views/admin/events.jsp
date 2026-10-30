<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    request.setAttribute("pageTitle", "Manage Events | CEMS");
    request.setAttribute("activeNav", "admin-events");
%>

<jsp:include page="/WEB-INF/includes/header.jsp" />
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="main-content">
    <div class="container">
        <jsp:include page="/WEB-INF/includes/alerts.jsp" />

        <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem; margin-bottom: 1.5rem;">
            <div>
                <h1 style="font-size: 1.85rem; color: #1e293b;">Campus Event Catalog</h1>
                <p style="color: var(--text-muted); font-size: 0.95rem; margin-top: 0.25rem;">
                    Manage event listings, review schedules, and track attendee registration numbers.
                </p>
            </div>

            <div style="display: flex; gap: 0.5rem;">
                <a href="${pageContext.request.contextPath}/admin/create-event" class="btn btn-primary btn-sm">
                    <i class="fa-solid fa-plus"></i> Add New Event
                </a>
            </div>
        </div>

        <div class="card">
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Event Title</th>
                            <th>Category</th>
                            <th>Venue & Location</th>
                            <th>Schedule</th>
                            <th>Booked Seats</th>
                            <th>Status</th>
                            <th>Organizer</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty events}">
                                <tr>
                                    <td colspan="9" style="text-align: center; padding: 2.5rem; color: var(--text-muted);">
                                        No events found in the database.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="ev" items="${events}">
                                    <tr>
                                        <td style="color: var(--text-muted); font-size: 0.85rem;">#${ev.id}</td>
                                        <td style="font-weight: 600; max-width: 240px;">
                                            <a href="${pageContext.request.contextPath}/student/event-details?id=${ev.id}" style="color: #1e293b;">
                                                ${ev.title}
                                            </a>
                                        </td>
                                        <td>
                                            <span class="badge badge-${ev.category.toLowerCase()}">${ev.category}</span>
                                        </td>
                                        <td>
                                            <div><strong>${ev.venue.name}</strong></div>
                                            <div style="font-size: 0.78rem; color: var(--text-muted);">${ev.venue.location}</div>
                                        </td>
                                        <td>
                                            <div><i class="fa-regular fa-calendar"></i> ${ev.eventDate}</div>
                                            <div style="font-size: 0.78rem; color: var(--text-muted);">${ev.startTime} - ${ev.endTime}</div>
                                        </td>
                                        <td>
                                            <div style="display: flex; align-items: center; gap: 0.5rem;">
                                                <span>${ev.currentRegistrations} / ${ev.maxCapacity}</span>
                                                <div class="progress-bar-bg" style="width: 50px; height: 5px;">
                                                    <div class="progress-fill ${ev.full ? 'full' : ''}" style="width: ${ev.capacityPercentage}%;"></div>
                                                </div>
                                            </div>
                                            <div style="font-size: 0.75rem; color: ${ev.full ? 'var(--danger)' : 'var(--success)'};">
                                                ${ev.remainingSeats} remaining
                                            </div>
                                        </td>
                                        <td>
                                            <span class="badge badge-${ev.status.name().toLowerCase()}">${ev.status}</span>
                                        </td>
                                        <td>
                                            <div style="font-size: 0.88rem;">${ev.organizer.name}</div>
                                            <div style="font-size: 0.75rem; color: var(--text-muted);">${ev.organizer.role}</div>
                                        </td>
                                        <td>
                                            <div style="display: flex; gap: 0.35rem;">
                                                <a href="${pageContext.request.contextPath}/admin/attendees?eventId=${ev.id}" class="btn btn-sm btn-outline" title="View Registered Attendees">
                                                    <i class="fa-solid fa-users"></i> Attendees
                                                </a>
                                                <a href="${pageContext.request.contextPath}/student/event-details?id=${ev.id}" class="btn btn-sm btn-secondary" title="View Public Page">
                                                    <i class="fa-solid fa-eye"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
