<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    request.setAttribute("pageTitle", "Review Proposals | CEMS");
    request.setAttribute("activeNav", "admin-events");
%>

<jsp:include page="/WEB-INF/includes/header.jsp" />
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="main-content">
    <div class="container">
        <jsp:include page="/WEB-INF/includes/alerts.jsp" />

        <div style="margin-bottom: 1.5rem;">
            <h1 style="font-size: 1.85rem; color: #1e293b;">Event Proposals Queue</h1>
            <p style="color: var(--text-muted); font-size: 0.95rem; margin-top: 0.25rem;">
                Review incoming event submissions from faculty coordinators and organizers.
            </p>
        </div>

        <c:choose>
            <c:when test="${empty proposals}">
                <div class="card" style="padding: 3rem 1.5rem; text-align: center;">
                    <i class="fa-solid fa-circle-check" style="font-size: 3rem; color: var(--success); margin-bottom: 0.75rem;"></i>
                    <h2 style="font-size: 1.4rem; color: #1e293b;">No Pending Proposals</h2>
                    <p style="color: var(--text-muted); margin-top: 0.25rem;">There are no event proposals pending review at this time.</p>
                    <div style="margin-top: 1.25rem;">
                        <a href="${pageContext.request.contextPath}/admin/events" class="btn btn-primary btn-sm">
                            <i class="fa-solid fa-calendar-days"></i> View Active Events
                        </a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div style="display: flex; flex-direction: column; gap: 1.25rem;">
                    <c:forEach var="prop" items="${proposals}">
                        <div class="card" style="padding: 1.5rem; border-left: 4px solid var(--warning);">
                            <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 1.25rem;">
                                <div style="flex: 1; min-width: 280px;">
                                    <div style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.35rem;">
                                        <span class="badge badge-${prop.category.toLowerCase()}">${prop.category}</span>
                                        <span class="badge badge-pending">Pending Review</span>
                                    </div>

                                    <h2 style="font-size: 1.35rem; color: #1e293b; margin-bottom: 0.35rem;">${prop.title}</h2>
                                    
                                    <p style="color: #4b5563; font-size: 0.92rem; line-height: 1.5; margin-bottom: 1rem;">
                                        ${prop.description}
                                    </p>

                                    <div style="display: flex; gap: 1.5rem; font-size: 0.88rem; color: #4b5563; flex-wrap: wrap; background-color: #f8fafc; padding: 0.75rem 1rem; border-radius: var(--radius-sm); border: 1px solid var(--border-color);">
                                        <div>
                                            <span style="font-size: 0.72rem; text-transform: uppercase; color: var(--text-muted); display: block;">Venue</span>
                                            <strong>${prop.venue.name}</strong> (${prop.venue.location})
                                        </div>
                                        <div>
                                            <span style="font-size: 0.72rem; text-transform: uppercase; color: var(--text-muted); display: block;">Date & Time</span>
                                            <strong>${prop.eventDate}</strong> (${prop.startTime} - ${prop.endTime})
                                        </div>
                                        <div>
                                            <span style="font-size: 0.72rem; text-transform: uppercase; color: var(--text-muted); display: block;">Capacity</span>
                                            <strong>${prop.maxCapacity} Seats</strong>
                                        </div>
                                        <div>
                                            <span style="font-size: 0.72rem; text-transform: uppercase; color: var(--text-muted); display: block;">Organizer</span>
                                            <strong>${prop.organizer.name}</strong>
                                        </div>
                                    </div>
                                </div>

                                <div style="display: flex; flex-direction: column; gap: 0.5rem; min-width: 150px;">
                                    <form action="${pageContext.request.contextPath}/admin/approve-event" method="POST">
                                        <input type="hidden" name="eventId" value="${prop.id}">
                                        <button type="submit" class="btn btn-success btn-block btn-sm">
                                            <i class="fa-solid fa-check"></i> Approve
                                        </button>
                                    </form>

                                    <button type="button" class="btn btn-danger btn-block btn-sm" onclick="toggleRejectBox(${prop.id})">
                                        <i class="fa-solid fa-xmark"></i> Reject
                                    </button>
                                </div>
                            </div>

                            <!-- Expandable Rejection Feedback Box -->
                            <div id="rejectBox_${prop.id}" style="display: none; margin-top: 1rem; padding-top: 1rem; border-top: 1px dashed var(--border-color);">
                                <form action="${pageContext.request.contextPath}/admin/reject-event" method="POST">
                                    <input type="hidden" name="eventId" value="${prop.id}">
                                    <div class="form-group">
                                        <label class="form-label" style="color: var(--danger);">
                                            Reason for Rejection:
                                        </label>
                                        <input type="text" name="reason" class="form-control"
                                               placeholder="e.g. Venue already booked or schedule conflict..." required>
                                    </div>
                                    <div style="display: flex; gap: 0.5rem; justify-content: flex-end;">
                                        <button type="button" class="btn btn-outline btn-sm" onclick="toggleRejectBox(${prop.id})">Cancel</button>
                                        <button type="submit" class="btn btn-danger btn-sm">Confirm Rejection</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

    </div>
</main>

<script>
function toggleRejectBox(id) {
    const box = document.getElementById('rejectBox_' + id);
    if (box) {
        box.style.display = box.style.display === 'none' ? 'block' : 'none';
    }
}
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
