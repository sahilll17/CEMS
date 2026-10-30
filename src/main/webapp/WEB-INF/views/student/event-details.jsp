<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    request.setAttribute("pageTitle", "Event Details | CEMS");
    request.setAttribute("activeNav", "events");
%>

<jsp:include page="/WEB-INF/includes/header.jsp" />
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="main-content">
    <div class="container">
        <jsp:include page="/WEB-INF/includes/alerts.jsp" />

        <div style="margin-bottom: 1.25rem;">
            <a href="${pageContext.request.contextPath}/student/events" class="btn btn-outline btn-sm">
                <i class="fa-solid fa-arrow-left"></i> Back to Events Catalog
            </a>
        </div>

        <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 2rem; align-items: start;">
            
            <!-- Left Column: Details -->
            <div>
                <!-- Banner Image -->
                <div class="card" style="padding: 0; overflow: hidden; margin-bottom: 1.5rem;">
                    <div style="height: 300px; width: 100%; position: relative; background-color: #e2e8f0;">
                        <img src="${event.bannerUrl}" alt="${event.title}" style="width: 100%; height: 100%; object-fit: cover;">
                        <div style="position: absolute; top: 1rem; left: 1rem;">
                            <span class="badge badge-${event.category.toLowerCase()}" style="font-size: 0.85rem; padding: 0.35rem 0.75rem;">
                                ${event.category}
                            </span>
                        </div>
                    </div>
                    <div style="padding: 1.5rem;">
                        <h1 style="font-size: 1.85rem; color: #1e293b; margin-bottom: 0.5rem;">
                            ${event.title}
                        </h1>
                        <div style="display: flex; gap: 1.25rem; font-size: 0.9rem; color: var(--text-muted); flex-wrap: wrap;">
                            <span><i class="fa-regular fa-calendar" style="color: var(--primary);"></i> ${event.eventDate}</span>
                            <span><i class="fa-regular fa-clock" style="color: var(--primary);"></i> ${event.startTime} - ${event.endTime}</span>
                            <span><i class="fa-solid fa-location-dot" style="color: var(--primary);"></i> ${event.venue.name}</span>
                        </div>
                    </div>
                </div>

                <!-- Event Description -->
                <div class="card" style="padding: 1.5rem; margin-bottom: 1.5rem;">
                    <h2 style="font-size: 1.3rem; margin-bottom: 0.75rem; color: #1e293b;">
                        <i class="fa-solid fa-align-left" style="color: var(--primary);"></i> About this Event
                    </h2>
                    <p style="color: #4b5563; font-size: 0.95rem; line-height: 1.7; white-space: pre-line;">
                        ${event.description}
                    </p>
                </div>

                <!-- Event Rules and Guidelines -->
                <c:if test="${not empty event.rules}">
                    <div class="card" style="padding: 1.5rem; margin-bottom: 1.5rem;">
                        <h2 style="font-size: 1.3rem; margin-bottom: 0.75rem; color: #1e293b;">
                            <i class="fa-solid fa-list-check" style="color: var(--primary);"></i> Rules & Guidelines
                        </h2>
                        <p style="color: #4b5563; font-size: 0.95rem; line-height: 1.7; white-space: pre-line;">
                            ${event.rules}
                        </p>
                    </div>
                </c:if>

                <!-- Venue & Location Details -->
                <div class="card" style="padding: 1.5rem;">
                    <h2 style="font-size: 1.3rem; margin-bottom: 1rem; color: #1e293b;">
                        <i class="fa-solid fa-landmark" style="color: var(--primary);"></i> Venue Information
                    </h2>
                    
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                        <div>
                            <span class="ticket-field-label">Allocated Hall / Lab</span>
                            <div class="ticket-field-value">${event.venue.name}</div>
                            <div style="color: var(--text-muted); font-size: 0.85rem; margin-top: 0.25rem;">
                                Location: ${event.venue.location}
                            </div>
                        </div>

                        <div>
                            <span class="ticket-field-label">Facilities Available</span>
                            <div style="color: #4b5563; font-size: 0.9rem; margin-top: 0.25rem;">
                                ${event.venue.facilities}
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Column: Registration Box -->
            <div>
                <div class="card" style="padding: 1.5rem; position: sticky; top: 80px; border-top: 4px solid var(--primary);">
                    <div style="border-bottom: 1px solid var(--border-color); padding-bottom: 1rem; margin-bottom: 1.25rem;">
                        <span style="font-size: 0.78rem; font-weight: 700; text-transform: uppercase; color: var(--success);">
                            Student Registration
                        </span>
                        <div style="font-size: 1.4rem; font-weight: 700; color: #1e293b; margin-top: 0.25rem;">
                            Free Entry Pass
                        </div>
                    </div>

                    <div style="display: flex; flex-direction: column; gap: 1rem; margin-bottom: 1.5rem;">
                        <div>
                            <span class="ticket-field-label">Event Date</span>
                            <div class="ticket-field-value" style="font-size: 0.95rem;">${event.eventDate}</div>
                        </div>

                        <div>
                            <span class="ticket-field-label">Event Timings</span>
                            <div class="ticket-field-value" style="font-size: 0.95rem;">${event.startTime} - ${event.endTime}</div>
                        </div>

                        <c:if test="${not empty event.registrationDeadline}">
                            <div>
                                <span class="ticket-field-label">Registration Deadline</span>
                                <div class="ticket-field-value" style="font-size: 0.95rem; color: #dc2626;">
                                    <i class="fa-regular fa-clock"></i> ${event.registrationDeadline}
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${event.maxTeamSize > 1}">
                            <div>
                                <span class="ticket-field-label">Team Participation</span>
                                <div class="ticket-field-value" style="font-size: 0.95rem;">
                                    <i class="fa-solid fa-users"></i> Up to ${event.maxTeamSize} members
                                </div>
                            </div>
                        </c:if>

                        <div>
                            <span class="ticket-field-label">Faculty Coordinator</span>
                            <div class="ticket-field-value" style="font-size: 0.95rem;">${event.organizer.name}</div>
                            <div style="font-size: 0.8rem; color: var(--text-muted);">${event.organizer.department}</div>
                        </div>
                    </div>

                    <!-- Available Seats -->
                    <div style="background-color: #f8fafc; padding: 1rem; border-radius: var(--radius-sm); border: 1px solid var(--border-color); margin-bottom: 1.5rem;">
                        <div style="display: flex; justify-content: space-between; font-size: 0.88rem; margin-bottom: 0.35rem;">
                            <span>Available Seats:</span>
                            <span><strong>${event.remainingSeats} / ${event.maxCapacity}</strong></span>
                        </div>
                        <div class="progress-bar-bg" style="height: 8px;">
                            <div class="progress-fill ${event.full ? 'full' : ''}"
                                 style="width: ${event.capacityPercentage}%;"></div>
                        </div>
                        <div style="margin-top: 0.4rem; font-size: 0.78rem; color: var(--text-muted); text-align: right;">
                            ${event.currentRegistrations} registered students
                        </div>
                    </div>

                    <!-- Action Button State -->
                    <c:choose>
                        <c:when test="${empty sessionScope.currentUser}">
                            <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary btn-block btn-lg">
                                <i class="fa-solid fa-right-to-bracket"></i> Login to Register
                            </a>
                        </c:when>
                        <c:when test="${isRegistered}">
                            <div class="alert alert-success" style="margin-bottom: 1rem; text-align: center; display: block; padding: 0.75rem;">
                                <i class="fa-solid fa-circle-check"></i> <strong>You are registered!</strong>
                                <div style="font-size: 0.82rem; margin-top: 0.25rem;">Pass No: ${userRegistration.ticketCode}</div>
                            </div>
                            <div style="display: flex; flex-direction: column; gap: 0.5rem;">
                                <a href="${pageContext.request.contextPath}/student/ticket?id=${userRegistration.id}" class="btn btn-success btn-block">
                                    <i class="fa-solid fa-ticket"></i> View Registration Pass
                                </a>
                                <c:if test="${userRegistration.attendanceStatus == 'ATTENDED'}">
                                    <a href="${pageContext.request.contextPath}/student/certificate?id=${userRegistration.id}" class="btn btn-primary btn-block">
                                        <i class="fa-solid fa-award"></i> Download Certificate
                                    </a>
                                </c:if>
                            </div>
                        </c:when>
                        <c:when test="${event.full}">
                            <button class="btn btn-secondary btn-block" disabled style="opacity: 0.7; cursor: not-allowed;">
                                <i class="fa-solid fa-ban"></i> Capacity Full
                            </button>
                        </c:when>
                        <c:otherwise>
                            <form action="${pageContext.request.contextPath}/student/register-event" method="POST" id="eventRegForm">
                                <input type="hidden" name="eventId" value="${event.id}">

                                <c:if test="${event.maxTeamSize > 1}">
                                    <!-- Team registration options -->
                                    <div style="margin-bottom: 1rem; padding: 0.75rem; background: #f8fafc; border: 1px solid var(--border-color); border-radius: var(--radius-sm);">
                                        <label style="font-size: 0.85rem; font-weight: 600; display: block; margin-bottom: 0.4rem;">Participation Type:</label>
                                        <div style="display: flex; gap: 1rem; margin-bottom: 0.6rem;">
                                            <label style="font-size: 0.85rem; cursor: pointer;">
                                                <input type="radio" name="participationType" value="INDIVIDUAL" checked onchange="toggleTeamFields(false)"> Individual
                                            </label>
                                            <label style="font-size: 0.85rem; cursor: pointer;">
                                                <input type="radio" name="participationType" value="TEAM" onchange="toggleTeamFields(true)"> Team Registration
                                            </label>
                                        </div>

                                        <div id="teamFields" style="display: none;">
                                            <div style="margin-bottom: 0.5rem;">
                                                <label style="font-size: 0.8rem; font-weight: 600; color: #4b5563;">Team Name *</label>
                                                <input type="text" name="teamName" id="teamNameInput" class="form-control" placeholder="e.g. Code Warriors" style="font-size: 0.85rem;">
                                            </div>
                                            <div>
                                                <label style="font-size: 0.8rem; font-weight: 600; color: #4b5563;">Team Member Names & UIDs</label>
                                                <textarea name="teamMembers" id="teamMembersInput" class="form-control" rows="2" placeholder="e.g. Aman Verma (26MC110245), Priya Kaur (26MCI10220)" style="font-size: 0.85rem;"></textarea>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>

                                <button type="submit" class="btn btn-primary btn-block btn-lg" id="confirmRegisterBtn">
                                    <i class="fa-solid fa-ticket"></i> Register for Event
                                </button>
                            </form>
                            <div style="font-size: 0.78rem; color: var(--text-muted); text-align: center; margin-top: 0.65rem;">
                                Registering as: <strong>${sessionScope.currentUser.name}</strong> (${sessionScope.currentUser.uid})
                            </div>
                        </c:otherwise>
                    </c:choose>

                </div>
            </div>

        </div>
    </div>
</main>

<script>
// toggle team registration input fields
function toggleTeamFields(show) {
    const fields = document.getElementById("teamFields");
    const nameInput = document.getElementById("teamNameInput");
    if (fields) {
        fields.style.display = show ? "block" : "none";
        if (nameInput) {
            nameInput.required = show;
        }
    }
}
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
