<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    request.setAttribute("pageTitle", "User Accounts | CEMS");
    request.setAttribute("activeNav", "admin-users");
%>

<jsp:include page="/WEB-INF/includes/header.jsp" />
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="main-content">
    <div class="container">
        <jsp:include page="/WEB-INF/includes/alerts.jsp" />

        <div style="margin-bottom: 1.5rem;">
            <h1 style="font-size: 1.85rem; color: #1e293b;">Registered Users & Accounts</h1>
            <p style="color: var(--text-muted); font-size: 0.95rem; margin-top: 0.25rem;">
                Directory of enrolled students, faculty organizers, and system administrators.
            </p>
        </div>

        <div class="card">
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>UID / ID</th>
                            <th>Full Name</th>
                            <th>Email Address</th>
                            <th>Role</th>
                            <th>Department & Semester</th>
                            <th>Phone</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${users}">
                            <tr>
                                <td style="font-family: monospace; font-weight: 600; color: #1a365d;">${u.uid}</td>
                                <td style="font-weight: 600;">${u.name}</td>
                                <td>${u.email}</td>
                                <td>
                                    <span class="badge ${u.role == 'ADMIN' ? 'badge-cultural' : (u.role == 'ORGANIZER' ? 'badge-workshop' : 'badge-technical')}">
                                        ${u.role}
                                    </span>
                                </td>
                                <td>
                                    <div>${u.department}</div>
                                    <div style="font-size: 0.75rem; color: var(--text-muted);">${u.semester}</div>
                                </td>
                                <td>${u.phone}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${u.status == 'ACTIVE'}">
                                            <span class="badge badge-approved"><i class="fa-solid fa-circle-check"></i> Active</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-rejected"><i class="fa-solid fa-ban"></i> Suspended</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${u.role != 'ADMIN'}">
                                        <form action="${pageContext.request.contextPath}/admin/toggle-user" method="POST" style="display: inline;">
                                            <input type="hidden" name="userId" value="${u.id}">
                                            <button type="submit" class="btn btn-sm ${u.status == 'ACTIVE' ? 'btn-danger' : 'btn-success'}"
                                                    title="${u.status == 'ACTIVE' ? 'Suspend Account' : 'Activate Account'}">
                                                <c:choose>
                                                    <c:when test="${u.status == 'ACTIVE'}">Suspend</c:when>
                                                    <c:otherwise>Activate</c:otherwise>
                                                </c:choose>
                                            </button>
                                        </form>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
