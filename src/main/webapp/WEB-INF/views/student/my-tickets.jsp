<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    request.setAttribute("pageTitle", "My Registrations | CEMS");
    request.setAttribute("activeNav", "tickets");
%>

<jsp:include page="/WEB-INF/includes/header.jsp" />
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="main-content">
    <div class="container">
        <jsp:include page="/WEB-INF/includes/alerts.jsp" />

        <div style="margin-bottom: 1.75rem;">
            <h1 style="font-size: 1.85rem; color: #1e293b;">My Event Registrations</h1>
            <p style="color: var(--text-muted); font-size: 0.95rem; margin-top: 0.25rem;">
                View your registered campus events, print admission passes, or cancel bookings.
            </p>
        </div>

        <!-- Section 1: Upcoming Event Passes -->
        <div style="margin-bottom: 2.5rem;">
            <h2 style="font-size: 1.3rem; margin-bottom: 1rem; color: #1e293b; display: flex; align-items: center; gap: 0.5rem;">
                <i class="fa-solid fa-ticket" style="color: var(--primary);"></i> Active Upcoming Registrations
                <span style="font-size: 0.85rem; font-weight: normal; color: var(--text-muted);">(${upcomingRegistrations.size()})</span>
            </h2>

            <c:choose>
                <c:when test="${empty upcomingRegistrations}">
                    <div class="card" style="padding: 2.5rem; text-align: center;">
                        <i class="fa-solid fa-ticket" style="font-size: 2.5rem; color: var(--text-muted); margin-bottom: 0.75rem;"></i>
                        <h3 style="font-size: 1.25rem; color: #1e293b;">No Active Event Registrations</h3>
                        <p style="color: var(--text-muted); margin: 0.4rem 0 1.25rem;">You have not registered for any upcoming college events yet.</p>
                        <a href="${pageContext.request.contextPath}/student/events" class="btn btn-primary btn-sm">
                            <i class="fa-solid fa-calendar-days"></i> Browse Events
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="display: flex; flex-direction: column; gap: 1rem;">
                        <c:forEach var="reg" items="${upcomingRegistrations}">
                            <div class="card card-hover" style="padding: 1.25rem; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
                                <div style="display: flex; gap: 1.25rem; align-items: center;">
                                    <div style="width: 64px; height: 64px; border-radius: var(--radius-sm); overflow: hidden; background: #e2e8f0; flex-shrink: 0;">
                                        <img src="${reg.event.bannerUrl}" alt="${reg.event.title}" style="width: 100%; height: 100%; object-fit: cover;">
                                    </div>
                                    <div>
                                        <div style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.25rem;">
                                            <span class="badge badge-${reg.event.category.toLowerCase()}">${reg.event.category}</span>
                                            <span class="badge badge-approved">${reg.attendanceStatus}</span>
                                        </div>
                                        <h3 style="font-size: 1.15rem; color: #1e293b; margin-bottom: 0.25rem;">${reg.event.title}</h3>
                                        <div style="display: flex; gap: 1.25rem; font-size: 0.85rem; color: var(--text-muted); flex-wrap: wrap;">
                                            <span><i class="fa-regular fa-calendar"></i> ${reg.event.eventDate}</span>
                                            <span><i class="fa-regular fa-clock"></i> ${reg.event.startTime} - ${reg.event.endTime}</span>
                                            <span><i class="fa-solid fa-location-dot"></i> ${reg.event.venue.name}</span>
                                        </div>
                                    </div>
                                </div>

                                <div style="display: flex; align-items: center; gap: 0.65rem;">
                                    <div style="text-align: right; margin-right: 0.5rem;">
                                        <div style="font-size: 0.72rem; color: var(--text-muted); text-transform: uppercase;">Pass Number</div>
                                        <div style="font-family: monospace; font-size: 0.95rem; font-weight: 700; color: #1a365d;">${reg.ticketCode}</div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/student/ticket?id=${reg.id}" class="btn btn-primary btn-sm">
                                        <i class="fa-solid fa-receipt"></i> View Pass
                                    </a>
                                    <form action="${pageContext.request.contextPath}/student/cancel-registration" method="POST" onsubmit="return confirm('Cancel registration for this event? Your seat will be freed up.');">
                                        <input type="hidden" name="registrationId" value="${reg.id}">
                                        <button type="submit" class="btn btn-outline btn-sm" title="Cancel Registration">
                                            <i class="fa-solid fa-trash-can"></i> Cancel
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Section 2: Past Events History -->
        <div>
            <h2 style="font-size: 1.3rem; margin-bottom: 1rem; color: #1e293b; display: flex; align-items: center; gap: 0.5rem;">
                <i class="fa-solid fa-clock-rotate-left" style="color: var(--secondary);"></i> Past Participation History
                <span style="font-size: 0.85rem; font-weight: normal; color: var(--text-muted);">(${pastRegistrations.size()})</span>
            </h2>

            <c:choose>
                <c:when test="${empty pastRegistrations}">
                    <div class="card" style="padding: 1.5rem; text-align: center; color: var(--text-muted);">
                        No past event records found.
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card">
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Ticket No</th>
                                        <th>Event Name</th>
                                        <th>Category</th>
                                        <th>Date</th>
                                        <th>Venue</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="past" items="${pastRegistrations}">
                                        <tr>
                                            <td style="font-family: monospace; font-weight: 600; color: #1a365d;">${past.ticketCode}</td>
                                            <td style="font-weight: 600;">
                                                ${past.event.title}
                                                <c:if test="${not empty past.teamName}">
                                                    <div style="font-size: 0.75rem; color: var(--text-muted); font-weight: normal;">
                                                        <i class="fa-solid fa-users"></i> Team: ${past.teamName}
                                                    </div>
                                                </c:if>
                                                <c:if test="${not empty past.meritRank && past.meritRank != 'PARTICIPANT'}">
                                                    <div style="margin-top: 0.2rem;">
                                                        <span class="badge" style="background: #fef3c7; color: #b45309; border: 1px solid #fde68a; font-size: 0.75rem;">
                                                            <i class="fa-solid fa-trophy"></i> ${past.meritRank.replace('_', ' ')}
                                                        </span>
                                                    </div>
                                                </c:if>
                                            </td>
                                            <td><span class="badge badge-${past.event.category.toLowerCase()}">${past.event.category}</span></td>
                                            <td>${past.event.eventDate}</td>
                                            <td>${past.event.venue.name}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${past.attendanceStatus == 'ATTENDED'}">
                                                        <span class="badge badge-approved"><i class="fa-solid fa-check"></i> Attended</span>
                                                    </c:when>
                                                    <c:when test="${past.attendanceStatus == 'ABSENT'}">
                                                        <span class="badge badge-rejected"><i class="fa-solid fa-xmark"></i> Absent</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-cancelled">${past.attendanceStatus}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div style="display: flex; gap: 0.35rem; align-items: center;">
                                                    <c:if test="${past.attendanceStatus == 'ATTENDED'}">
                                                        <a href="${pageContext.request.contextPath}/student/certificate?id=${past.id}" class="btn btn-sm btn-success" title="Download Certificate">
                                                            <i class="fa-solid fa-award"></i> Certificate
                                                        </a>
                                                    </c:if>
                                                    <a href="${pageContext.request.contextPath}/student/ticket?id=${past.id}" class="btn btn-sm btn-outline">
                                                        <i class="fa-solid fa-receipt"></i> Pass
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </div>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
