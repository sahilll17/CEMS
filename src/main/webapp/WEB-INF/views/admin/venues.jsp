<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    request.setAttribute("pageTitle", "Venue Management | CEMS");
    request.setAttribute("activeNav", "admin-venues");
%>

<jsp:include page="/WEB-INF/includes/header.jsp" />
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="main-content">
    <div class="container">
        <jsp:include page="/WEB-INF/includes/alerts.jsp" />

        <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem; margin-bottom: 1.5rem;">
            <div>
                <h1 style="font-size: 1.85rem; color: #1e293b;">Campus Venues & Auditoriums</h1>
                <p style="color: var(--text-muted); font-size: 0.95rem; margin-top: 0.25rem;">
                    Manage hall capacity limits, available equipment, and venue active status.
                </p>
            </div>

            <button type="button" class="btn btn-primary btn-sm" onclick="toggleAddVenueForm()">
                <i class="fa-solid fa-plus"></i> Add New Venue
            </button>
        </div>

        <!-- Add Venue Form Panel -->
        <div id="addVenuePanel" class="card" style="display: none; padding: 1.75rem; margin-bottom: 2rem; border-top: 4px solid var(--primary);">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.25rem;">
                <h2 style="font-size: 1.25rem; color: #1e293b;"><i class="fa-solid fa-landmark"></i> Register New Campus Venue</h2>
                <button type="button" class="btn btn-outline btn-sm" onclick="toggleAddVenueForm()">
                    <i class="fa-solid fa-xmark"></i> Close
                </button>
            </div>

            <form action="${pageContext.request.contextPath}/admin/save-venue" method="POST">
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="vName">Venue Name *</label>
                        <input type="text" id="vName" name="name" class="form-control" placeholder="e.g. UIC Seminar Hall B" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="vLocation">Campus Location / Block *</label>
                        <input type="text" id="vLocation" name="location" class="form-control" placeholder="e.g. Block 4, 1st Floor" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="vCap">Seating Capacity *</label>
                        <input type="number" id="vCap" name="capacity" class="form-control" placeholder="e.g. 200" min="1" required>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="vFac">Facilities (Projector, AC, etc.)</label>
                    <input type="text" id="vFac" name="facilities" class="form-control" placeholder="e.g. Projector, Sound System, Central AC, Wi-Fi">
                </div>

                <div class="form-group">
                    <label class="form-label" for="vDesc">Venue Description</label>
                    <textarea id="vDesc" name="description" rows="2" class="form-control" placeholder="Briefly describe venue suitability..."></textarea>
                </div>

                <div style="display: flex; gap: 0.5rem; justify-content: flex-end;">
                    <button type="button" class="btn btn-outline" onclick="toggleAddVenueForm()">Cancel</button>
                    <button type="submit" class="btn btn-primary"><i class="fa-solid fa-save"></i> Save Venue</button>
                </div>
            </form>
        </div>

        <!-- Venues Directory Table -->
        <div class="card">
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Venue Name</th>
                            <th>Location</th>
                            <th>Capacity</th>
                            <th>Facilities</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="venue" items="${venues}">
                            <tr>
                                <td style="color: var(--text-muted); font-size: 0.85rem;">#${venue.id}</td>
                                <td style="font-weight: 600; color: #1e293b;">${venue.name}</td>
                                <td><i class="fa-solid fa-location-dot" style="color: var(--primary);"></i> ${venue.location}</td>
                                <td>
                                    <strong>${venue.capacity}</strong> Seats
                                </td>
                                <td style="color: var(--text-muted); font-size: 0.85rem; max-width: 250px;">
                                    ${venue.facilities}
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${venue.active}">
                                            <span class="badge badge-approved"><i class="fa-solid fa-circle-check"></i> ACTIVE</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-rejected">INACTIVE</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/admin/toggle-venue" method="POST" style="display: inline;">
                                        <input type="hidden" name="venueId" value="${venue.id}">
                                        <button type="submit" class="btn btn-sm btn-outline" title="${venue.active ? 'Deactivate Venue' : 'Activate Venue'}">
                                            <c:choose>
                                                <c:when test="${venue.active}">Deactivate</c:when>
                                                <c:otherwise>Activate</c:otherwise>
                                            </c:choose>
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</main>

<script>
function toggleAddVenueForm() {
    const panel = document.getElementById('addVenuePanel');
    if (panel) {
        panel.style.display = panel.style.display === 'none' ? 'block' : 'none';
        if (panel.style.display === 'block') {
            document.getElementById('vName').focus();
        }
    }
}
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
