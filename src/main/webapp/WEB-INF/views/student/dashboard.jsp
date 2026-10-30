<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    request.setAttribute("pageTitle", "Student Dashboard | CEMS");
    request.setAttribute("activeNav", "dashboard");
%>

<jsp:include page="/WEB-INF/includes/header.jsp" />
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="main-content">
    <div class="container">
        <jsp:include page="/WEB-INF/includes/alerts.jsp" />

        <!-- Student Profile Welcome Banner -->
        <div class="card" style="background: linear-gradient(to right, #1a365d, #1e40af); color: #ffffff; padding: 2rem; margin-bottom: 2rem; border: none;">
            <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
                <div>
                    <span style="background: rgba(255,255,255,0.2); padding: 0.2rem 0.6rem; border-radius: 4px; font-size: 0.8rem; font-weight: 600; text-transform: uppercase;">
                        Student Portal
                    </span>
                    <h1 style="color: #ffffff; font-size: 1.85rem; margin-top: 0.5rem; margin-bottom: 0.25rem;">
                        Welcome, ${sessionScope.currentUser.name}!
                    </h1>
                    <p style="color: #cbd5e1; font-size: 0.95rem;">
                        UID: <strong>${sessionScope.currentUser.uid}</strong> &bull; ${sessionScope.currentUser.department} &bull; ${sessionScope.currentUser.semester}
                    </p>
                </div>

                <div style="display: flex; gap: 0.75rem;">
                    <a href="${pageContext.request.contextPath}/student/events" class="btn btn-primary" style="background-color: #ffffff; color: #1a365d; font-weight: 600; border: none;">
                        <i class="fa-solid fa-calendar-days"></i> Browse Events
                    </a>
                    <a href="${pageContext.request.contextPath}/student/my-tickets" class="btn btn-secondary" style="background-color: rgba(255,255,255,0.2); color: #ffffff; border: 1px solid rgba(255,255,255,0.4);">
                        <i class="fa-solid fa-ticket"></i> My Registrations
                    </a>
                </div>
            </div>
        </div>

        <!-- Metric Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fa-solid fa-ticket"></i>
                </div>
                <div class="stat-info">
                    <span class="stat-value">${upcomingRegistrations.size()}</span>
                    <span class="stat-label">Upcoming Event Passes</span>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fa-solid fa-clipboard-check"></i>
                </div>
                <div class="stat-info">
                    <span class="stat-value">${totalRegisteredCount}</span>
                    <span class="stat-label">Total Registrations</span>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fa-solid fa-id-card"></i>
                </div>
                <div class="stat-info">
                    <span class="stat-value" style="font-size: 1.15rem; font-family: monospace;">${sessionScope.currentUser.uid}</span>
                    <span class="stat-label">Student Roll Number</span>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fa-solid fa-calendar-plus"></i>
                </div>
                <div class="stat-info">
                    <span class="stat-value">${upcomingEvents.size()}</span>
                    <span class="stat-label">New Events Available</span>
                </div>
            </div>
        </div>

        <!-- Upcoming Registrations Section -->
        <div style="margin-top: 1.5rem;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                <h2 style="font-size: 1.35rem; color: #1e293b;">
                    <i class="fa-solid fa-ticket" style="color: var(--primary);"></i> My Confirmed Event Passes
                </h2>
                <a href="${pageContext.request.contextPath}/student/my-tickets" class="btn btn-outline btn-sm">
                    View Full History
                </a>
            </div>

            <c:choose>
                <c:when test="${empty upcomingRegistrations}">
                    <div class="card" style="padding: 2.5rem; text-align: center;">
                        <i class="fa-solid fa-calendar-xmark" style="font-size: 2.5rem; color: var(--text-muted); margin-bottom: 0.75rem;"></i>
                        <h3 style="font-size: 1.2rem; color: #1e293b;">No Active Event Passes</h3>
                        <p style="color: var(--text-muted); margin: 0.4rem 0 1.25rem;">You have not registered for any upcoming events yet.</p>
                        <a href="${pageContext.request.contextPath}/student/events" class="btn btn-primary btn-sm">
                            <i class="fa-solid fa-compass"></i> Find Events to Join
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="display: flex; flex-direction: column; gap: 1rem;">
                        <c:forEach var="reg" items="${upcomingRegistrations}">
                            <div class="card card-hover" style="padding: 1.25rem; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
                                <div style="flex: 1; min-width: 250px;">
                                    <div style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.25rem;">
                                        <span class="badge badge-${reg.event.category.toLowerCase()}">${reg.event.category}</span>
                                        <span style="font-family: monospace; font-size: 0.8rem; color: #1a365d; background: #e0f2fe; padding: 0.15rem 0.5rem; border-radius: 4px; font-weight: bold;">
                                            ${reg.ticketCode}
                                        </span>
                                    </div>
                                    <h3 style="font-size: 1.15rem; color: #1e293b; margin-bottom: 0.25rem;">${reg.event.title}</h3>
                                    <div style="display: flex; gap: 1.25rem; font-size: 0.85rem; color: var(--text-muted); flex-wrap: wrap;">
                                        <span><i class="fa-regular fa-calendar"></i> ${reg.event.eventDate}</span>
                                        <span><i class="fa-regular fa-clock"></i> ${reg.event.startTime} - ${reg.event.endTime}</span>
                                        <span><i class="fa-solid fa-location-dot"></i> ${reg.event.venue.name}</span>
                                    </div>
                                </div>

                                <div style="display: flex; gap: 0.5rem; align-items: center;">
                                    <a href="${pageContext.request.contextPath}/student/ticket?id=${reg.id}" class="btn btn-primary btn-sm">
                                        <i class="fa-solid fa-receipt"></i> View Pass
                                    </a>
                                    <form action="${pageContext.request.contextPath}/student/cancel-registration" method="POST" onsubmit="return confirm('Cancel registration for this event?');">
                                        <input type="hidden" name="registrationId" value="${reg.id}">
                                        <button type="submit" class="btn btn-outline btn-sm" title="Cancel">
                                            <i class="fa-solid fa-trash-can"></i>
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </div>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
