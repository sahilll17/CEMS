<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Flash Notifications & Alert Handler -->
<c:if test="${not empty param.msg}">
    <div class="alert alert-success">
        <div style="display: flex; align-items: center; gap: 0.75rem;">
            <i class="fa-solid fa-circle-check" style="font-size: 1.25rem;"></i>
            <span>
                <c:choose>
                    <c:when test="${param.msg == 'registered_successfully'}">Student registration completed! You can now log in.</c:when>
                    <c:when test="${param.msg == 'logged_out'}">You have been logged out successfully.</c:when>
                    <c:when test="${param.msg == 'registration_success'}">Event registration confirmed! Digital pass generated.</c:when>
                    <c:when test="${param.msg == 'cancelled_success'}">Registration cancelled and seat released.</c:when>
                    <c:when test="${param.msg == 'event_published'}">Event has been published successfully!</c:when>
                    <c:when test="${param.msg == 'proposal_submitted'}">Event proposal submitted for Head Administrator approval.</c:when>
                    <c:when test="${param.msg == 'approved_success'}">Event proposal approved and published to students.</c:when>
                    <c:when test="${param.msg == 'rejected_success'}">Event proposal has been marked rejected.</c:when>
                    <c:when test="${param.msg == 'venue_added'}">New campus venue added successfully.</c:when>
                    <c:when test="${param.msg == 'attendance_updated'}">Attendance status updated successfully.</c:when>
                    <c:when test="${param.msg == 'score_updated'}">Participant score and merit rank updated successfully.</c:when>
                    <c:when test="${param.msg == 'user_status_changed'}">User account status updated.</c:when>
                    <c:otherwise>${param.msg}</c:otherwise>
                </c:choose>
            </span>
        </div>
        <button type="button" class="alert-close" aria-label="Close">&times;</button>
    </div>
</c:if>

<c:if test="${not empty param.error}">
    <div class="alert alert-danger">
        <div style="display: flex; align-items: center; gap: 0.75rem;">
            <i class="fa-solid fa-triangle-exclamation" style="font-size: 1.25rem;"></i>
            <span>
                <c:choose>
                    <c:when test="${param.error == 'missing_credentials'}">Please enter both email and password.</c:when>
                    <c:when test="${param.error == 'invalid_credentials'}">Invalid email or password. Please try again.</c:when>
                    <c:when test="${param.error == 'account_suspended'}">This account has been suspended by campus administration.</c:when>
                    <c:when test="${param.error == 'session_expired'}">Your session has expired. Please log in again.</c:when>
                    <c:when test="${param.error == 'access_denied'}">Access restricted to authorized personnel.</c:when>
                    <c:when test="${param.error == 'email_exists'}">An account with this email address already exists. Please sign in.</c:when>
                    <c:when test="${param.error == 'uid_exists'}">An account with this Student UID already exists.</c:when>
                    <c:when test="${param.error == 'invalid_uid'}">Student UID must be alphanumeric (letters and numbers only) between 5 to 20 characters.</c:when>
                    <c:when test="${param.error == 'invalid_name'}">Full Name must contain only alphabets and spaces (between 3 to 50 characters).</c:when>
                    <c:when test="${param.error == 'invalid_email'}">Please enter a valid institutional or personal email address.</c:when>
                    <c:when test="${param.error == 'invalid_phone'}">Mobile number must be a valid 10-digit number starting with 6, 7, 8, or 9.</c:when>
                    <c:when test="${param.error == 'invalid_department'}">Please select a valid academic department from the list.</c:when>
                    <c:when test="${param.error == 'invalid_semester'}">Please enter your semester and section (at least 2 characters).</c:when>
                    <c:when test="${param.error == 'certificate_not_eligible'}">Certificate is available only for students marked Present / Attended for this event.</c:when>
                    <c:when test="${param.error == 'capacity_full'}">Sorry, this event has reached maximum capacity!</c:when>
                    <c:when test="${param.error == 'already_registered'}">You have already registered for this event.</c:when>
                    <c:when test="${param.error == 'venue_conflict'}">
                        <strong>Venue Double-Booking Conflict:</strong> The venue is already reserved during this time for 
                        <em>"${param.conflictTitle}"</em> (${param.conflictTime}). Please choose another venue or time slot.
                    </c:when>
                    <c:when test="${param.error == 'password_mismatch'}">Passwords do not match. Please ensure both password fields are identical.</c:when>
                    <c:when test="${param.error == 'weak_password'}">Password must be at least 6 characters long.</c:when>
                    <c:when test="${param.error == 'invalid_inputs'}">Please fill in all required fields correctly.</c:when>
                    <c:when test="${param.error == 'registration_failed'}">Registration could not be completed. Please try again.</c:when>
                    <c:otherwise>${param.error}</c:otherwise>
                </c:choose>
            </span>
        </div>
        <button type="button" class="alert-close" aria-label="Close">&times;</button>
    </div>
</c:if>
