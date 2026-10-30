<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    request.setAttribute("pageTitle", "Event Registration Pass | CEMS");
    request.setAttribute("activeNav", "tickets");
%>

<jsp:include page="/WEB-INF/includes/header.jsp" />
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="main-content">
    <div class="container ticket-wrapper">
        <jsp:include page="/WEB-INF/includes/alerts.jsp" />

        <!-- Actions Bar -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;" class="no-print">
            <a href="${pageContext.request.contextPath}/student/my-tickets" class="btn btn-outline btn-sm">
                <i class="fa-solid fa-arrow-left"></i> Back to My Registrations
            </a>
            <button onclick="window.print()" class="btn btn-primary btn-sm">
                <i class="fa-solid fa-print"></i> Print Registration Pass
            </button>
        </div>

        <!-- The Event Pass Card -->
        <div class="digital-ticket">
            <!-- Pass Header -->
            <div class="ticket-header">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem;">
                    <span class="ticket-institution">
                        <i class="fa-solid fa-graduation-cap"></i> CHANDIGARH UNIVERSITY &bull; UIC
                    </span>
                    <span class="badge badge-${event.category.toLowerCase()}">
                        ${event.category}
                    </span>
                </div>
                <h1 class="ticket-event-title">${event.title}</h1>
                <div style="font-size: 0.9rem; color: #e2e8f0; display: flex; gap: 1.5rem; flex-wrap: wrap; margin-top: 0.5rem;">
                    <span><i class="fa-regular fa-calendar-days"></i> ${event.eventDate}</span>
                    <span><i class="fa-regular fa-clock"></i> ${event.startTime} - ${event.endTime}</span>
                </div>
            </div>

            <!-- Pass Body -->
            <div class="ticket-body">
                <div class="ticket-grid">
                    <div class="ticket-field">
                        <span class="ticket-field-label">Student Name</span>
                        <div class="ticket-field-value">${student.name}</div>
                    </div>
                    <div class="ticket-field">
                        <span class="ticket-field-label">Student UID / Roll No</span>
                        <div class="ticket-field-value" style="font-family: monospace; color: #1a365d;">${student.uid}</div>
                    </div>
                    <div class="ticket-field">
                        <span class="ticket-field-label">Department</span>
                        <div class="ticket-field-value">${student.department}</div>
                    </div>
                    <div class="ticket-field">
                        <span class="ticket-field-label">Semester / Section</span>
                        <div class="ticket-field-value">${student.semester}</div>
                    </div>
                    <div class="ticket-field" style="grid-column: 1 / -1;">
                        <span class="ticket-field-label">Event Venue & Location</span>
                        <div class="ticket-field-value">
                            <i class="fa-solid fa-location-dot" style="color: var(--primary);"></i>
                            ${event.venue.name} &bull; ${event.venue.location}
                        </div>
                    </div>
                    <c:if test="${not empty registration.teamName}">
                        <div class="ticket-field" style="grid-column: 1 / -1; background-color: #f1f5f9; padding: 0.75rem; border-radius: var(--radius-sm);">
                            <span class="ticket-field-label"><i class="fa-solid fa-users"></i> Team Name</span>
                            <div class="ticket-field-value" style="font-weight: 700; color: #1e293b;">${registration.teamName}</div>
                            <c:if test="${not empty registration.teamMembers}">
                                <div style="font-size: 0.82rem; color: var(--text-muted); margin-top: 0.25rem;">
                                    Members: ${registration.teamMembers}
                                </div>
                            </c:if>
                        </div>
                    </c:if>
                </div>

                <!-- Registration Reference Section -->
                <div class="ticket-qr-section">
                    <div style="font-size: 0.8rem; text-transform: uppercase; color: var(--text-muted); font-weight: 600; margin-bottom: 0.35rem;">
                        Registration Confirmation Number
                    </div>
                    <div class="ticket-ref-code">${registration.ticketCode}</div>
                    <div style="margin-top: 0.5rem; display: flex; gap: 0.5rem; justify-content: center; flex-wrap: wrap;">
                        <span class="badge badge-approved" style="font-size: 0.85rem; padding: 0.3rem 0.8rem;">
                            <i class="fa-solid fa-circle-check"></i> Status: ${registration.attendanceStatus}
                        </span>
                        <c:if test="${registration.attendanceStatus == 'ATTENDED'}">
                            <a href="${pageContext.request.contextPath}/student/certificate?id=${registration.id}" class="btn btn-sm btn-success no-print">
                                <i class="fa-solid fa-award"></i> View Certificate
                            </a>
                        </c:if>
                    </div>
                    <div style="font-size: 0.82rem; color: var(--text-muted); margin-top: 0.75rem;">
                        Please bring this pass (printed or digital) along with your University ID card to the venue.
                    </div>
                </div>

                <!-- Footer details inside pass -->
                <div style="margin-top: 1.5rem; text-align: center; font-size: 0.8rem; color: var(--text-muted); border-top: 1px solid var(--border-color); padding-top: 0.75rem;">
                    Registration Date: ${registration.registrationDate} &bull; Faculty Organizer: ${event.organizer.name}
                </div>
            </div>
        </div>

    </div>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
