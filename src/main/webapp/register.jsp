<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    // set page title and active navigation menu
    request.setAttribute("pageTitle", "Student Registration | CEMS - Chandigarh University");
    request.setAttribute("activeNav", "register");
%>

<jsp:include page="/WEB-INF/includes/header.jsp" />
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="main-content">
    <div class="container" style="max-width: 600px;">
        <jsp:include page="/WEB-INF/includes/alerts.jsp" />

        <div class="card" style="padding: 2rem; border-top: 4px solid var(--primary);">
            <div style="text-align: center; margin-bottom: 1.5rem;">
                <div class="brand-logo-icon" style="margin: 0 auto 0.75rem; width: 44px; height: 44px; font-size: 1.3rem; background-color: #eef2ff; color: var(--primary);">
                    <i class="fa-solid fa-user-plus"></i>
                </div>
                <h2 style="font-size: 1.5rem; color: #1e293b; margin-bottom: 0.25rem;">Student Registration</h2>
                <p style="color: var(--text-muted); font-size: 0.9rem;">
                    Enter your details to create a student portal account
                </p>
            </div>

            <!-- Student registration form with validation on submit -->
            <form action="${pageContext.request.contextPath}/auth" method="POST" id="registerForm" onsubmit="return validateRegisterForm();">
                <input type="hidden" name="action" value="register">

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="regUid">
                            <i class="fa-solid fa-id-card"></i> Student UID *
                        </label>
                        <input type="text" id="regUid" name="uid" class="form-control"
                               placeholder="e.g. 26MCI10257"
                               value="${param.uid}" required maxlength="20">
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="regName">
                            <i class="fa-solid fa-user"></i> Full Name *
                        </label>
                        <input type="text" id="regName" name="name" class="form-control"
                               placeholder="e.g. Sahil Sharma"
                               value="${param.name}" required maxlength="50">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="regEmail">
                            <i class="fa-solid fa-envelope"></i> Email Address *
                        </label>
                        <input type="email" id="regEmail" name="email" class="form-control"
                               placeholder="e.g. 26MCI10257@cuchd.in"
                               value="${param.email}" required maxlength="100">
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="regPhone">
                            <i class="fa-solid fa-phone"></i> Mobile Number *
                        </label>
                        <input type="tel" id="regPhone" name="phone" class="form-control"
                               placeholder="10-digit number" maxlength="10"
                               value="${param.phone}" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="regDept">
                            <i class="fa-solid fa-building-columns"></i> Department *
                        </label>
                        <select id="regDept" name="department" class="form-control" required>
                            <option value="">-- Select Department --</option>
                            <option value="MCA (AI ML)">MCA (AI ML)</option>
                            <option value="MCA (General)">MCA (General)</option>
                            <option value="B.Tech Computer Science & Eng.">B.Tech Computer Science & Eng.</option>
                            <option value="B.Tech Information Technology">B.Tech Information Technology</option>
                            <option value="MBA Marketing & Finance">MBA Marketing & Finance</option>
                            <option value="University Institute of Computing">University Institute of Computing</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="regSem">
                            <i class="fa-solid fa-layer-group"></i> Semester / Section *
                        </label>
                        <input type="text" id="regSem" name="semester" class="form-control"
                               placeholder="e.g. Semester 1 (MAM-4B)"
                               value="${param.semester}" required maxlength="30">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="regPassword">
                            <i class="fa-solid fa-lock"></i> Password *
                        </label>
                        <input type="password" id="regPassword" name="password" class="form-control"
                               placeholder="Min 6 characters" required minlength="6">
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="regConfirmPassword">
                            <i class="fa-solid fa-lock"></i> Confirm Password *
                        </label>
                        <input type="password" id="regConfirmPassword" name="confirmPassword" class="form-control"
                               placeholder="Re-enter password" required minlength="6">
                    </div>
                </div>

                <div style="margin: 1.5rem 0 1rem;">
                    <button type="submit" class="btn btn-primary btn-block btn-lg" id="submitRegisterBtn">
                        <i class="fa-solid fa-user-check"></i> Register Now
                    </button>
                </div>
            </form>

            <div style="text-align: center; margin-top: 1rem; font-size: 0.9rem; color: var(--text-muted);">
                Already have an account? 
                <a href="${pageContext.request.contextPath}/login.jsp" style="font-weight: 600;">Login here</a>
            </div>
        </div>
    </div>
</main>

<script>
// simple student javascript validation function
function validateRegisterForm() {
    // get all input values
    var uid = document.getElementById("regUid").value.trim();
    var name = document.getElementById("regName").value.trim();
    var email = document.getElementById("regEmail").value.trim();
    var phone = document.getElementById("regPhone").value.trim();
    var dept = document.getElementById("regDept").value.trim();
    var sem = document.getElementById("regSem").value.trim();
    var password = document.getElementById("regPassword").value;
    var confirmPassword = document.getElementById("regConfirmPassword").value;

    // 1. validate student uid (letters and numbers only, 5 to 20 chars)
    var uidRegex = /^[a-zA-Z0-9]{5,20}$/;
    if (!uidRegex.test(uid)) {
        alert("Please enter a valid Student UID (5 to 20 letters or digits, e.g. 26MCI10257).");
        document.getElementById("regUid").focus();
        return false;
    }

    // 2. validate student name (letters and spaces only, min 3 chars)
    var nameRegex = /^[a-zA-Z ]{3,50}$/;
    if (!nameRegex.test(name)) {
        alert("Please enter a valid name using letters only (at least 3 characters).");
        document.getElementById("regName").focus();
        return false;
    }

    // 3. validate institutional email format
    var emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    if (!emailRegex.test(email)) {
        alert("Please enter a valid email address (e.g. 26MCI10257@cuchd.in).");
        document.getElementById("regEmail").focus();
        return false;
    }

    // 4. validate 10-digit mobile number starting with 6, 7, 8, or 9
    var phoneRegex = /^[6-9]\d{9}$/;
    if (!phoneRegex.test(phone)) {
        alert("Please enter a valid 10-digit mobile number starting with 6, 7, 8, or 9.");
        document.getElementById("regPhone").focus();
        return false;
    }

    // 5. validate department selection
    if (dept === "") {
        alert("Please select your department from the dropdown list.");
        document.getElementById("regDept").focus();
        return false;
    }

    // 6. validate semester / section
    if (sem.length < 2) {
        alert("Please enter your semester and section (e.g. Semester 1).");
        document.getElementById("regSem").focus();
        return false;
    }

    // 7. validate password minimum length
    if (password.length < 6) {
        alert("Password must be at least 6 characters long.");
        document.getElementById("regPassword").focus();
        return false;
    }

    // 8. validate confirm password match
    if (password !== confirmPassword) {
        alert("Passwords do not match. Please re-enter the same password.");
        document.getElementById("regConfirmPassword").focus();
        return false;
    }

    // all validations passed
    return true;
}
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
