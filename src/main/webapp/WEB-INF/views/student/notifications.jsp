<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    request.setAttribute("pageTitle", "Notifications | CEMS");
    request.setAttribute("activeNav", "notifications");
%>

<jsp:include page="/WEB-INF/includes/header.jsp" />
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="main-content">
    <div class="container" style="max-width: 750px;">
        <jsp:include page="/WEB-INF/includes/alerts.jsp" />

        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
            <div>
                <h1 style="font-size: 1.85rem; color: #1e293b;">Notifications</h1>
                <p style="color: var(--text-muted); font-size: 0.95rem; margin-top: 0.25rem;">
                    Registration confirmations and campus updates.
                </p>
            </div>

            <c:if test="${not empty notifications}">
                <a href="${pageContext.request.contextPath}/student/mark-notification-read?all=true" class="btn btn-outline btn-sm">
                    <i class="fa-solid fa-check-double"></i> Mark All as Read
                </a>
            </c:if>
        </div>

        <c:choose>
            <c:when test="${empty notifications}">
                <div class="card" style="padding: 2.5rem; text-align: center;">
                    <i class="fa-regular fa-bell-slash" style="font-size: 2.5rem; color: var(--text-muted); margin-bottom: 0.75rem;"></i>
                    <h2 style="font-size: 1.3rem; color: #1e293b;">No Notifications</h2>
                    <p style="color: var(--text-muted); margin-top: 0.25rem;">You have no new messages.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div style="display: flex; flex-direction: column; gap: 0.75rem;">
                    <c:forEach var="notif" items="${notifications}">
                        <div class="card" style="padding: 1.25rem; ${notif.read ? 'opacity: 0.7;' : 'border-left: 4px solid var(--primary);'}">
                            <div style="display: flex; justify-content: space-between; align-items: flex-start; gap: 1rem;">
                                <div>
                                    <div style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.25rem;">
                                        <h3 style="font-size: 1.05rem; color: #1e293b;">${notif.title}</h3>
                                        <c:if test="${not notif.read}">
                                            <span class="badge badge-technical" style="font-size: 0.65rem;">NEW</span>
                                        </c:if>
                                    </div>
                                    <p style="color: #4b5563; font-size: 0.9rem; line-height: 1.5;">
                                        ${notif.message}
                                    </p>
                                    <div style="font-size: 0.75rem; color: var(--text-muted); margin-top: 0.35rem;">
                                        <i class="fa-regular fa-clock"></i> ${notif.createdAt}
                                    </div>
                                </div>

                                <c:if test="${not notif.read}">
                                    <a href="${pageContext.request.contextPath}/student/mark-notification-read?id=${notif.id}" class="btn btn-outline btn-sm" title="Mark as Read">
                                        <i class="fa-solid fa-check"></i>
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

    </div>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
