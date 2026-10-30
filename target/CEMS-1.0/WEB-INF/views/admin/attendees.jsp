<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    request.setAttribute("pageTitle", "Registered Attendees | CEMS");
    request.setAttribute("activeNav", "admin-attendees");
%>

<jsp:include page="/WEB-INF/includes/header.jsp" />
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="main-content">
    <div class="container">
        <jsp:include page="/WEB-INF/includes/alerts.jsp" />

        <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem; margin-bottom: 1.5rem;" class="no-print">
            <div>
                <h1 style="font-size: 1.85rem; color: #1e293b;">Event Attendees & Attendance</h1>
                <p style="color: var(--text-muted); font-size: 0.95rem; margin-top: 0.25rem;">
                    View registered students for each campus event and mark attendance.
                </p>
            </div>

            <div style="display: flex; gap: 0.5rem;">
                <button type="button" class="btn btn-outline btn-sm" onclick="window.print()">
                    <i class="fa-solid fa-print"></i> Print Attendee List
                </button>
            </div>
        </div>

        <!-- Event Selector & Search Controls -->
        <div class="filter-bar no-print">
            <form action="${pageContext.request.contextPath}/admin/attendees" method="GET" style="display: flex; gap: 0.75rem; flex: 1; align-items: center; flex-wrap: wrap;">
                <label style="font-weight: 600; color: #1e293b; display: flex; align-items: center; gap: 0.35rem; font-size: 0.9rem;">
                    <i class="fa-solid fa-calendar-check" style="color: var(--primary);"></i> Select Event:
                </label>
                <select name="eventId" class="form-control" style="max-width: 380px;" onchange="this.form.submit()">
                    <c:forEach var="ev" items="${allEvents}">
                        <option value="${ev.id}" ${selectedEvent != null && selectedEvent.id == ev.id ? 'selected' : ''}>
                            ${ev.title} (${ev.eventDate})
                        </option>
                    </c:forEach>
                </select>
                <noscript><button type="submit" class="btn btn-sm btn-secondary">Load</button></noscript>
            </form>

            <div style="position: relative; min-width: 240px;">
                <input type="text" id="participantSearchInput" class="form-control" placeholder="Search UID or Name..." onkeyup="filterParticipantsTable()">
                <i class="fa-solid fa-magnifying-glass" style="position: absolute; right: 0.75rem; top: 50%; transform: translateY(-50%); color: var(--text-muted);"></i>
            </div>
        </div>

        <!-- Event Details Bar -->
        <c:if test="${selectedEvent != null}">
            <div class="card" style="padding: 1.25rem; margin-bottom: 1.5rem; background-color: #f8fafc;">
                <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
                    <div>
                        <div style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.25rem;">
                            <span class="badge badge-${selectedEvent.category.toLowerCase()}">${selectedEvent.category}</span>
                            <span class="badge badge-${selectedEvent.status.name().toLowerCase()}">${selectedEvent.status}</span>
                        </div>
                        <h2 style="font-size: 1.35rem; color: #1e293b;">${selectedEvent.title}</h2>
                        <div style="font-size: 0.85rem; color: var(--text-muted); display: flex; gap: 1.25rem; margin-top: 0.25rem; flex-wrap: wrap;">
                            <span><i class="fa-regular fa-calendar"></i> ${selectedEvent.eventDate}</span>
                            <span><i class="fa-regular fa-clock"></i> ${selectedEvent.startTime} - ${selectedEvent.endTime}</span>
                            <span><i class="fa-solid fa-location-dot"></i> ${selectedEvent.venue.name}</span>
                        </div>
                    </div>

                    <div style="display: flex; gap: 1.5rem; background: #ffffff; padding: 0.65rem 1.25rem; border-radius: var(--radius-sm); border: 1px solid var(--border-color);">
                        <div style="text-align: center;">
                            <div style="font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase;">Registrations</div>
                            <div style="font-size: 1.35rem; font-weight: 700; color: var(--primary);">${selectedEvent.currentRegistrations}</div>
                        </div>
                        <div style="text-align: center;">
                            <div style="font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase;">Seats Left</div>
                            <div style="font-size: 1.35rem; font-weight: 700; color: var(--success);">${selectedEvent.remainingSeats}</div>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Attendees Table -->
        <div class="card">
            <div class="table-responsive">
                <table class="table" id="attendeesTable">
                    <thead>
                        <tr>
                            <th>Ticket No</th>
                            <th>Student UID</th>
                            <th>Student Name / Team</th>
                            <th>Department & Semester</th>
                            <th>Status</th>
                            <th>Score / Merit Rank</th>
                            <th class="no-print">Update Attendance & Scoring</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty attendees}">
                                <tr>
                                    <td colspan="7" style="text-align: center; padding: 2.5rem; color: var(--text-muted);">
                                        No registered students for this event yet.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="reg" items="${attendees}">
                                    <tr class="participant-row">
                                        <td style="font-family: monospace; font-weight: 600; color: #1a365d;">${reg.ticketCode}</td>
                                        <td style="font-family: monospace; font-weight: 600;">${reg.user.uid}</td>
                                        <td>
                                            <div style="font-weight: 600;">${reg.user.name}</div>
                                            <c:if test="${not empty reg.teamName}">
                                                <div style="font-size: 0.78rem; color: #475569; margin-top: 0.2rem;">
                                                    <i class="fa-solid fa-users"></i> <strong>Team:</strong> ${reg.teamName}
                                                    <c:if test="${not empty reg.teamMembers}">
                                                        <span style="color: var(--text-muted);">(${reg.teamMembers})</span>
                                                    </c:if>
                                                </div>
                                            </c:if>
                                        </td>
                                        <td>
                                            <div>${reg.user.department}</div>
                                            <div style="font-size: 0.75rem; color: var(--text-muted);">${reg.user.semester}</div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${reg.attendanceStatus == 'ATTENDED'}">
                                                    <span class="badge badge-approved"><i class="fa-solid fa-check"></i> Present</span>
                                                </c:when>
                                                <c:when test="${reg.attendanceStatus == 'ABSENT'}">
                                                    <span class="badge badge-rejected"><i class="fa-solid fa-xmark"></i> Absent</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-pending">Registered</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:if test="${not empty reg.meritRank && reg.meritRank != 'PARTICIPANT'}">
                                                <div style="margin-bottom: 0.25rem;">
                                                    <span class="badge" style="background: #fef3c7; color: #b45309; border: 1px solid #fde68a;">
                                                        <i class="fa-solid fa-trophy"></i> ${reg.meritRank.replace('_', ' ')}
                                                    </span>
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty reg.score}">
                                                <div style="font-size: 0.8rem; color: #4b5563;">
                                                    Score: <strong>${reg.score}</strong>
                                                </div>
                                            </c:if>
                                            <c:if test="${empty reg.meritRank && empty reg.score}">
                                                <span style="color: var(--text-muted); font-size: 0.8rem;">Pending evaluation</span>
                                            </c:if>
                                        </td>
                                        <td class="no-print">
                                            <form action="${pageContext.request.contextPath}/admin/mark-attendance" method="POST" style="display: flex; gap: 0.4rem; align-items: center; flex-wrap: wrap;">
                                                <input type="hidden" name="registrationId" value="${reg.id}">
                                                <input type="hidden" name="eventId" value="${selectedEvent.id}">
                                                
                                                <select name="status" class="form-control" style="font-size: 0.8rem; padding: 0.25rem 0.5rem; height: 32px; width: 105px;">
                                                    <option value="ATTENDED" ${reg.attendanceStatus == 'ATTENDED' ? 'selected' : ''}>Present</option>
                                                    <option value="ABSENT" ${reg.attendanceStatus == 'ABSENT' ? 'selected' : ''}>Absent</option>
                                                    <option value="REGISTERED" ${reg.attendanceStatus == 'REGISTERED' ? 'selected' : ''}>Registered</option>
                                                </select>

                                                <select name="meritRank" class="form-control" style="font-size: 0.8rem; padding: 0.25rem 0.5rem; height: 32px; width: 125px;">
                                                    <option value="PARTICIPANT" ${reg.meritRank == 'PARTICIPANT' || empty reg.meritRank ? 'selected' : ''}>Participant</option>
                                                    <option value="WINNER" ${reg.meritRank == 'WINNER' ? 'selected' : ''}>Winner (1st)</option>
                                                    <option value="1ST_RUNNER_UP" ${reg.meritRank == '1ST_RUNNER_UP' ? 'selected' : ''}>1st Runner-Up</option>
                                                    <option value="2ND_RUNNER_UP" ${reg.meritRank == '2ND_RUNNER_UP' ? 'selected' : ''}>2nd Runner-Up</option>
                                                </select>

                                                <input type="text" name="score" value="${reg.score}" placeholder="Score" class="form-control" style="font-size: 0.8rem; padding: 0.25rem 0.5rem; height: 32px; width: 75px;">

                                                <button type="submit" class="btn btn-sm btn-primary" style="padding: 0.25rem 0.6rem; height: 32px;" title="Save Attendance & Result">
                                                    <i class="fa-solid fa-save"></i> Save
                                                </button>
                                            </form>
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

<script>
function filterParticipantsTable() {
    const input = document.getElementById("participantSearchInput");
    const filter = input.value.toUpperCase();
    const table = document.getElementById("attendeesTable");
    const tr = table.getElementsByClassName("participant-row");

    for (let i = 0; i < tr.length; i++) {
        const text = tr[i].textContent || tr[i].innerText;
        if (text.toUpperCase().indexOf(filter) > -1) {
            tr[i].style.display = "";
        } else {
            tr[i].style.display = "none";
        }
    }
}
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
