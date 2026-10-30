<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="navbar">
    <div class="container navbar-inner">
        <!-- Logo / Brand -->
        <a href="${pageContext.request.contextPath}/" class="brand">
            <div class="brand-logo-icon">
                <i class="fa-solid fa-calendar-check"></i>
            </div>
            <div class="brand-text">
                <span class="brand-title">CU <span>CEMS</span></span>
                <span class="brand-subtitle">Chandigarh University Event System</span>
            </div>
        </a>

        <!-- Mobile Menu Toggle Button -->
        <button type="button" class="mobile-toggle" id="mobileMenuToggle" aria-label="Toggle navigation">
            <i class="fa-solid fa-bars"></i>
        </button>

        <!-- Navigation Links -->
        <ul class="nav-links" id="navLinksMenu">
            <li>
                <a href="${pageContext.request.contextPath}/" class="nav-link ${activeNav == 'home' ? 'active' : ''}">
                    <i class="fa-solid fa-house"></i> Home
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/student/events" class="nav-link ${activeNav == 'events' ? 'active' : ''}">
                    <i class="fa-solid fa-list-check"></i> Events
                </a>
            </li>

            <c:choose>
                <c:when test="${not empty sessionScope.currentUser}">
                    <c:if test="${sessionScope.currentUser.role == 'STUDENT'}">
                        <li>
                            <a href="${pageContext.request.contextPath}/student/dashboard" class="nav-link ${activeNav == 'dashboard' ? 'active' : ''}">
                                <i class="fa-solid fa-user"></i> Dashboard
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/student/my-tickets" class="nav-link ${activeNav == 'tickets' ? 'active' : ''}">
                                <i class="fa-solid fa-ticket"></i> My Registrations
                            </a>
                        </li>
                    </c:if>

                    <c:if test="${sessionScope.currentUser.role == 'ADMIN' or sessionScope.currentUser.role == 'ORGANIZER'}">
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link ${activeNav == 'admin-dashboard' ? 'active' : ''}">
                                <i class="fa-solid fa-gauge"></i> Admin Dashboard
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/events" class="nav-link ${activeNav == 'admin-events' ? 'active' : ''}">
                                <i class="fa-solid fa-calendar-days"></i> Manage Events
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/venues" class="nav-link ${activeNav == 'admin-venues' ? 'active' : ''}">
                                <i class="fa-solid fa-landmark"></i> Venues
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/attendees" class="nav-link ${activeNav == 'admin-attendees' ? 'active' : ''}">
                                <i class="fa-solid fa-users"></i> Attendees
                            </a>
                        </li>
                    </c:if>

                    <!-- User Info & Logout -->
                    <li class="user-nav-dropdown">
                        <div class="user-avatar" title="${sessionScope.currentUser.name} (${sessionScope.currentUser.role})">
                            ${sessionScope.currentUser.name.substring(0, 1)}
                        </div>
                        <div style="display: flex; flex-direction: column; line-height: 1.2;">
                            <span style="font-size: 0.85rem; font-weight: 600; color: #fff;">${sessionScope.currentUser.name}</span>
                            <span style="font-size: 0.7rem; color: #93c5fd;">${sessionScope.currentUser.role}</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/auth?action=logout" class="btn btn-sm btn-secondary" style="margin-left: 0.4rem; padding: 0.25rem 0.6rem; font-size: 0.8rem;" title="Logout">
                            <i class="fa-solid fa-right-from-bracket"></i> Logout
                        </a>
                    </li>
                </c:when>
                <c:otherwise>
                    <!-- Guest links -->
                    <li>
                        <a href="${pageContext.request.contextPath}/login.jsp" class="nav-link ${activeNav == 'login' ? 'active' : ''}">
                            <i class="fa-solid fa-right-to-bracket"></i> Login
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-sm btn-primary" style="margin-left: 0.4rem;">
                            <i class="fa-solid fa-user-plus"></i> Student Register
                        </a>
                    </li>
                </c:otherwise>
            </c:choose>
        </ul>
    </div>
</nav>
