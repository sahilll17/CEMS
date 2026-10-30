<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    request.setAttribute("pageTitle", "Student & Staff Login | CEMS");
    request.setAttribute("activeNav", "login");
%>

<jsp:include page="/WEB-INF/includes/header.jsp" />
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="main-content" style="display: flex; align-items: center; justify-content: center; min-height: 70vh;">
    <div class="container" style="max-width: 480px;">
        <jsp:include page="/WEB-INF/includes/alerts.jsp" />

        <div class="card" style="padding: 2rem; border-top: 4px solid var(--primary);">
            <div style="text-align: center; margin-bottom: 1.75rem;">
                <div class="brand-logo-icon" style="margin: 0 auto 0.75rem; width: 48px; height: 48px; font-size: 1.4rem; background-color: #eef2ff; color: var(--primary);">
                    <i class="fa-solid fa-lock"></i>
                </div>
                <h2 style="font-size: 1.6rem; color: #1e293b; margin-bottom: 0.25rem;">Portal Login</h2>
                <p style="color: var(--text-muted); font-size: 0.9rem;">
                    Sign in to your Chandigarh University account
                </p>
            </div>

            <form action="${pageContext.request.contextPath}/auth" method="POST" id="loginForm">
                <input type="hidden" name="action" value="login">

                <div class="form-group">
                    <label class="form-label" for="loginEmail">
                        <i class="fa-solid fa-envelope"></i> Email Address
                    </label>
                    <input type="email" id="loginEmail" name="email" class="form-control"
                           placeholder="e.g. student@cems.edu" required autocomplete="email">
                </div>

                <div class="form-group">
                    <label class="form-label" for="loginPassword">
                        <i class="fa-solid fa-key"></i> Password
                    </label>
                    <input type="password" id="loginPassword" name="password" class="form-control"
                           placeholder="Enter your password" required autocomplete="current-password">
                </div>

                <div style="margin: 1.5rem 0 1rem;">
                    <button type="submit" class="btn btn-primary btn-block btn-lg" id="submitLoginBtn">
                        <i class="fa-solid fa-right-to-bracket"></i> Login
                    </button>
                </div>
            </form>

            <!-- Quick Demo Credentials for Viva / Testing -->
            <div style="background-color: #f8fafc; border: 1px dashed var(--border-color); border-radius: var(--radius-sm); padding: 0.85rem; margin-top: 1.25rem;">
                <span style="font-size: 0.75rem; font-weight: 700; text-transform: uppercase; color: #4b5563; display: block; margin-bottom: 0.5rem;">
                    <i class="fa-solid fa-bolt" style="color: #f59e0b;"></i> Quick Demo Logins:
                </span>
                <div style="display: flex; gap: 0.4rem; flex-wrap: wrap;">
                    <button type="button" class="btn btn-sm btn-outline" onclick="fillCreds('26MCI10257@cuchd.in', 'Sahil@123')">
                        Student (Sahil)
                    </button>
                    <button type="button" class="btn btn-sm btn-outline" onclick="fillCreds('organizer@cems.edu', 'organizer123')">
                        Faculty Organizer
                    </button>
                    <button type="button" class="btn btn-sm btn-outline" onclick="fillCreds('admin@cems.edu', 'admin123')">
                        Admin
                    </button>
                </div>
            </div>

            <div style="text-align: center; margin-top: 1.25rem; font-size: 0.9rem; color: var(--text-muted);">
                Don't have an account? 
                <a href="${pageContext.request.contextPath}/register.jsp" style="font-weight: 600;">Register here</a>
            </div>
        </div>
    </div>
</main>

<script>
function fillCreds(email, password) {
    document.getElementById('loginEmail').value = email;
    document.getElementById('loginPassword').value = password;
}
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
