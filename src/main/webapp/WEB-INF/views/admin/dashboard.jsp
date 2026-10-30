<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    request.setAttribute("pageTitle", "Admin Dashboard | CEMS");
    request.setAttribute("activeNav", "admin-dashboard");
%>

<jsp:include page="/WEB-INF/includes/header.jsp" />
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="main-content">
    <div class="container">
        <jsp:include page="/WEB-INF/includes/alerts.jsp" />

        <!-- Header Row -->
        <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem; margin-bottom: 1.75rem;">
            <div>
                <h1 style="font-size: 1.85rem; color: #1e293b; margin-bottom: 0.25rem;">Admin & Organizer Dashboard</h1>
                <p style="color: var(--text-muted); font-size: 0.95rem;">Manage campus events, review bookings, and monitor venue allocations.</p>
            </div>

            <div style="display: flex; gap: 0.6rem; flex-wrap: wrap;">
                <a href="${pageContext.request.contextPath}/admin/create-event" class="btn btn-primary btn-sm">
                    <i class="fa-solid fa-plus"></i> Add New Event
                </a>
                <a href="${pageContext.request.contextPath}/admin/events" class="btn btn-outline btn-sm">
                    <i class="fa-solid fa-calendar-days"></i> All Events
                </a>
                <a href="${pageContext.request.contextPath}/admin/venues" class="btn btn-outline btn-sm">
                    <i class="fa-solid fa-landmark"></i> Venues
                </a>
            </div>
        </div>

        <!-- Metric Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fa-solid fa-calendar-days"></i>
                </div>
                <div class="stat-info">
                    <span class="stat-value">${totalEvents}</span>
                    <span class="stat-label">Total Events</span>
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
                    <i class="fa-solid fa-user-graduate"></i>
                </div>
                <div class="stat-info">
                    <span class="stat-value">${totalStudents}</span>
                    <span class="stat-label">Registered Students</span>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fa-solid fa-landmark"></i>
                </div>
                <div class="stat-info">
                    <span class="stat-value">${activeVenues}</span>
                    <span class="stat-label">Campus Venues</span>
                </div>
            </div>
        </div>

        <!-- Section: Pending Event Proposals (if any) -->
        <c:if test="${not empty pendingEvents}">
            <div style="margin-bottom: 2rem;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.75rem;">
                    <h2 style="font-size: 1.25rem; color: #b45309;"><i class="fa-solid fa-hourglass-half"></i> Pending Event Proposals Awaiting Approval</h2>
                    <a href="${pageContext.request.contextPath}/admin/proposals" class="btn btn-outline btn-sm">Review All</a>
                </div>

                <div class="card">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Event Title</th>
                                    <th>Category</th>
                                    <th>Proposed By</th>
                                    <th>Venue</th>
                                    <th>Date & Time</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="prop" items="${pendingEvents}">
                                    <tr>
                                        <td style="font-weight: 600;">${prop.title}</td>
                                        <td><span class="badge badge-${prop.category.toLowerCase()}">${prop.category}</span></td>
                                        <td>${prop.organizer.name}</td>
                                        <td>${prop.venue.name}</td>
                                        <td>${prop.eventDate} (${prop.startTime})</td>
                                        <td>
                                            <div style="display: flex; gap: 0.4rem;">
                                                <form action="${pageContext.request.contextPath}/admin/approve-event" method="POST" style="display: inline;">
                                                    <input type="hidden" name="eventId" value="${prop.id}">
                                                    <button type="submit" class="btn btn-sm btn-success" title="Approve">
                                                        <i class="fa-solid fa-check"></i> Approve
                                                    </button>
                                                </form>
                                                <form action="${pageContext.request.contextPath}/admin/reject-event" method="POST" style="display: inline;" onsubmit="return confirm('Reject this proposal?');">
                                                    <input type="hidden" name="eventId" value="${prop.id}">
                                                    <input type="hidden" name="reason" value="Venue / Schedule limitation">
                                                    <button type="submit" class="btn btn-sm btn-danger" title="Reject">
                                                        <i class="fa-solid fa-xmark"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Section: Campus Event Directory -->
        <div>
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.75rem;">
                <h2 style="font-size: 1.25rem; color: #1e293b;"><i class="fa-solid fa-list-check" style="color: var(--primary);"></i> Campus Event Catalog</h2>
                <a href="${pageContext.request.contextPath}/admin/events" class="btn btn-outline btn-sm">Manage All Events</a>
            </div>

            <div class="card">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Event Title</th>
                                <th>Category</th>
                                <th>Venue</th>
                                <th>Date & Time</th>
                                <th>Seats Booked</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="ev" items="${recentEvents}">
                                <tr>
                                    <td style="font-weight: 600;">
                                        <a href="${pageContext.request.contextPath}/student/event-details?id=${ev.id}">
                                            ${ev.title}
                                        </a>
                                    </td>
                                    <td><span class="badge badge-${ev.category.toLowerCase()}">${ev.category}</span></td>
                                    <td>${ev.venue.name}</td>
                                    <td>${ev.eventDate} (${ev.startTime})</td>
                                    <td>
                                        <div style="display: flex; align-items: center; gap: 0.5rem;">
                                            <span>${ev.currentRegistrations} / ${ev.maxCapacity}</span>
                                            <div class="progress-bar-bg" style="width: 50px; height: 5px;">
                                                <div class="progress-fill ${ev.full ? 'full' : ''}" style="width: ${ev.capacityPercentage}%;"></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="badge badge-${ev.status.name().toLowerCase()}">${ev.status}</span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/attendees?eventId=${ev.id}" class="btn btn-sm btn-outline">
                                            <i class="fa-solid fa-users"></i> Attendees
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

    </div>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
