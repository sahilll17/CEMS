<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    request.setAttribute("pageTitle", "Create Event | CEMS");
    request.setAttribute("activeNav", "admin-events");
%>

<jsp:include page="/WEB-INF/includes/header.jsp" />
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="main-content">
    <div class="container" style="max-width: 800px;">
        <jsp:include page="/WEB-INF/includes/alerts.jsp" />

        <div style="margin-bottom: 1.5rem;">
            <a href="${pageContext.request.contextPath}/admin/events" class="btn btn-outline btn-sm">
                <i class="fa-solid fa-arrow-left"></i> Back to Events Catalog
            </a>
            <h1 style="font-size: 1.85rem; color: #1e293b; margin-top: 0.75rem;">
                <c:choose>
                    <c:when test="${sessionScope.currentUser.role == 'ADMIN'}">Add New Campus Event</c:when>
                    <c:otherwise>Propose New Campus Event</c:otherwise>
                </c:choose>
            </h1>
            <p style="color: var(--text-muted); font-size: 0.95rem; margin-top: 0.25rem;">
                Enter event details below. Venue availability will be checked automatically.
            </p>
        </div>

        <div class="card" style="padding: 2rem; border-top: 4px solid var(--primary);">
            <form action="${pageContext.request.contextPath}/admin/save-event" method="POST" id="eventForm">

                <div class="form-group">
                    <label class="form-label" for="eventTitle">
                        <i class="fa-solid fa-heading"></i> Event Title *
                    </label>
                    <input type="text" id="eventTitle" name="title" class="form-control"
                           placeholder="e.g. National Level Web Development Hackathon 2026" required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="eventCategory">
                            <i class="fa-solid fa-shapes"></i> Category *
                        </label>
                        <select id="eventCategory" name="category" class="form-control" required>
                            <option value="HACKATHON">HACKATHON</option>
                            <option value="WORKSHOP">WORKSHOP</option>
                            <option value="TECHNICAL">TECHNICAL</option>
                            <option value="CULTURAL">CULTURAL</option>
                            <option value="SPORTS">SPORTS</option>
                            <option value="SEMINAR">SEMINAR</option>
                            <option value="GUEST_LECTURE">GUEST LECTURE</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="eventVenue">
                            <i class="fa-solid fa-landmark"></i> Allocated Venue *
                        </label>
                        <select id="eventVenue" name="venueId" class="form-control" required onchange="updateVenueHint(this)">
                            <c:forEach var="v" items="${venues}">
                                <option value="${v.id}" data-cap="${v.capacity}" data-loc="${v.location}">
                                    ${v.name} (Capacity: ${v.capacity})
                                </option>
                            </c:forEach>
                        </select>
                        <div id="venueHint" style="font-size: 0.8rem; color: #0369a1; margin-top: 0.35rem;"></div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="eventDate">
                            <i class="fa-regular fa-calendar-days"></i> Event Date *
                        </label>
                        <input type="date" id="eventDate" name="eventDate" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="startTime">
                            <i class="fa-regular fa-clock"></i> Start Time *
                        </label>
                        <input type="time" id="startTime" name="startTime" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="endTime">
                            <i class="fa-regular fa-clock"></i> End Time *
                        </label>
                        <input type="time" id="endTime" name="endTime" class="form-control" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="maxCapacity">
                            <i class="fa-solid fa-users"></i> Maximum Capacity *
                        </label>
                        <input type="number" id="maxCapacity" name="maxCapacity" class="form-control"
                               placeholder="e.g. 100" min="1" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="registrationDeadline">
                            <i class="fa-solid fa-calendar-xmark"></i> Registration Deadline
                        </label>
                        <input type="date" id="registrationDeadline" name="registrationDeadline" class="form-control">
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="maxTeamSize">
                            <i class="fa-solid fa-people-group"></i> Max Team Size
                        </label>
                        <input type="number" id="maxTeamSize" name="maxTeamSize" class="form-control"
                               placeholder="1 for individual" min="1" max="10" value="1" required>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="bannerUrl">
                        <i class="fa-solid fa-image"></i> Banner Image URL
                    </label>
                    <input type="url" id="bannerUrl" name="bannerUrl" class="form-control"
                           placeholder="Image URL"
                           value="https://images.unsplash.com/photo-1540575467063-178a50c2df87?auto=format&fit=crop&w=1200&q=80">
                </div>

                <div class="form-group">
                    <label class="form-label" for="eventDesc">
                        <i class="fa-solid fa-paragraph"></i> Event Description *
                    </label>
                    <textarea id="eventDesc" name="description" rows="3" class="form-control"
                              placeholder="Enter event overview and schedule..." required></textarea>
                </div>

                <div class="form-group">
                    <label class="form-label" for="eventRules">
                        <i class="fa-solid fa-list-check"></i> Rules & Participation Guidelines
                    </label>
                    <textarea id="eventRules" name="rules" rows="3" class="form-control"
                              placeholder="Enter rules, team criteria, judging rubrics, or requirements..."></textarea>
                </div>

                <c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
                    <div style="background-color: #f0fdf4; border: 1px solid #bbf7d0; border-radius: var(--radius-sm); padding: 0.85rem; margin-bottom: 1.25rem; display: flex; align-items: center; gap: 0.65rem;">
                        <input type="checkbox" id="autoApprove" name="autoApprove" value="true" checked style="width: 16px; height: 16px;">
                        <label for="autoApprove" style="font-size: 0.9rem; font-weight: 600; color: #166534; cursor: pointer; margin-bottom: 0;">
                            Directly publish event (Auto-approve)
                        </label>
                    </div>
                </c:if>

                <div style="display: flex; gap: 0.75rem; margin-top: 1.5rem;">
                    <button type="submit" class="btn btn-primary" id="submitEventBtn">
                        <i class="fa-solid fa-calendar-check"></i>
                        <c:choose>
                            <c:when test="${sessionScope.currentUser.role == 'ADMIN'}">Publish Event</c:when>
                            <c:otherwise>Submit Event</c:otherwise>
                        </c:choose>
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/events" class="btn btn-outline">
                        Cancel
                    </a>
                </div>
            </form>
        </div>

    </div>
</main>

<script>
function updateVenueHint(select) {
    const selected = select.options[select.selectedIndex];
    const cap = selected.getAttribute('data-cap');
    const loc = selected.getAttribute('data-loc');
    const hint = document.getElementById('venueHint');
    const capInput = document.getElementById('maxCapacity');
    if (cap && loc) {
        hint.innerHTML = '<i class="fa-solid fa-location-dot"></i> ' + loc + ' &bull; Max capacity: ' + cap;
        if (!capInput.value) {
            capInput.value = cap;
        }
    }
}
document.addEventListener("DOMContentLoaded", function () {
    const venueSelect = document.getElementById('eventVenue');
    if (venueSelect) updateVenueHint(venueSelect);
});
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
