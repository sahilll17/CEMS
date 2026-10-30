<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    request.setAttribute("pageTitle", "Campus Events | CEMS");
    request.setAttribute("activeNav", "events");
%>

<jsp:include page="/WEB-INF/includes/header.jsp" />
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="main-content">
    <div class="container">
        <jsp:include page="/WEB-INF/includes/alerts.jsp" />

        <div style="margin-bottom: 1.5rem;">
            <h1 style="font-size: 1.85rem; color: #1e293b;">Campus Events Catalog</h1>
            <p style="color: var(--text-muted); font-size: 0.95rem; margin-top: 0.25rem;">
                Search events by category, date, or keyword and register online.
            </p>
        </div>

        <!-- Filter & Search Bar -->
        <form action="${pageContext.request.contextPath}/student/events" method="GET" id="eventsFilterForm" class="filter-bar">
            <input type="hidden" name="category" id="filterCategoryInput" value="${selectedCategory}">

            <div style="flex: 1; min-width: 240px; position: relative;">
                <input type="text" name="q" value="${searchKeyword}" class="form-control"
                       placeholder="Search by event title, venue, or keyword..." style="padding-left: 2.25rem;">
                <i class="fa-solid fa-magnifying-glass" style="position: absolute; left: 0.75rem; top: 50%; transform: translateY(-50%); color: var(--text-muted);"></i>
            </div>

            <div style="display: flex; gap: 0.5rem; align-items: center; flex-wrap: wrap;">
                <div style="display: flex; align-items: center; gap: 0.35rem;">
                    <label style="font-size: 0.85rem; color: var(--text-muted);">From:</label>
                    <input type="date" name="from" value="${fromDate}" class="form-control" style="width: auto; padding: 0.45rem 0.65rem;">
                </div>
                <div style="display: flex; align-items: center; gap: 0.35rem;">
                    <label style="font-size: 0.85rem; color: var(--text-muted);">To:</label>
                    <input type="date" name="to" value="${toDate}" class="form-control" style="width: auto; padding: 0.45rem 0.65rem;">
                </div>
                <button type="submit" class="btn btn-primary btn-sm">
                    <i class="fa-solid fa-filter"></i> Search
                </button>
                <c:if test="${not empty searchKeyword or selectedCategory != 'ALL' or not empty fromDate or not empty toDate}">
                    <a href="${pageContext.request.contextPath}/student/events" class="btn btn-outline btn-sm">
                        <i class="fa-solid fa-rotate-left"></i> Reset
                    </a>
                </c:if>
            </div>
        </form>

        <!-- Category Filter Pills -->
        <div class="filter-categories" style="margin-bottom: 2rem;">
            <button type="button" class="filter-pill ${selectedCategory == 'ALL' ? 'active' : ''}" data-category="ALL">All Categories</button>
            <button type="button" class="filter-pill ${selectedCategory == 'HACKATHON' ? 'active' : ''}" data-category="HACKATHON">Hackathons</button>
            <button type="button" class="filter-pill ${selectedCategory == 'WORKSHOP' ? 'active' : ''}" data-category="WORKSHOP">Workshops</button>
            <button type="button" class="filter-pill ${selectedCategory == 'TECHNICAL' ? 'active' : ''}" data-category="TECHNICAL">Technical</button>
            <button type="button" class="filter-pill ${selectedCategory == 'CULTURAL' ? 'active' : ''}" data-category="CULTURAL">Cultural</button>
            <button type="button" class="filter-pill ${selectedCategory == 'SPORTS' ? 'active' : ''}" data-category="SPORTS">Sports</button>
            <button type="button" class="filter-pill ${selectedCategory == 'SEMINAR' ? 'active' : ''}" data-category="SEMINAR">Seminars</button>
        </div>

        <!-- Event Cards Grid -->
        <c:choose>
            <c:when test="${empty events}">
                <div class="card" style="padding: 3rem 1.5rem; text-align: center;">
                    <i class="fa-solid fa-calendar-xmark" style="font-size: 3rem; color: var(--text-muted); margin-bottom: 0.75rem;"></i>
                    <h2 style="font-size: 1.5rem;">No Events Found</h2>
                    <p style="color: var(--text-muted); max-width: 480px; margin: 0.5rem auto 1.25rem;">
                        No campus events matched your search criteria. Try clearing the filter or search keyword.
                    </p>
                    <a href="${pageContext.request.contextPath}/student/events" class="btn btn-secondary btn-sm">
                        Show All Events
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="event-grid">
                    <c:forEach var="event" items="${events}">
                        <div class="event-card">
                            <div class="event-image-wrap">
                                <img src="${event.bannerUrl}" alt="${event.title}" loading="lazy">
                                <span class="badge badge-${event.category.toLowerCase()} event-category-badge">
                                    ${event.category}
                                </span>
                                <div class="event-date-chip">
                                    <i class="fa-regular fa-calendar"></i>
                                    <span>${event.eventDate}</span>
                                </div>
                            </div>

                            <div class="event-content">
                                <h3 class="event-title">${event.title}</h3>
                                
                                <div class="event-meta">
                                    <div class="meta-item">
                                        <i class="fa-solid fa-location-dot meta-icon"></i>
                                        <span>${event.venue.name}</span>
                                    </div>
                                    <div class="meta-item">
                                        <i class="fa-regular fa-clock meta-icon"></i>
                                        <span>${event.startTime} - ${event.endTime}</span>
                                    </div>
                                    <div class="meta-item">
                                        <i class="fa-solid fa-user meta-icon"></i>
                                        <span>Organizer: ${event.organizer.name}</span>
                                    </div>
                                </div>

                                <!-- Capacity Bar -->
                                <div style="margin-bottom: 1rem; font-size: 0.85rem;">
                                    <div style="display: flex; justify-content: space-between; margin-bottom: 0.35rem;">
                                        <span>Registered:</span>
                                        <span>
                                            <c:choose>
                                                <c:when test="${event.full}">
                                                    <strong style="color: var(--danger);">FULL</strong>
                                                </c:when>
                                                <c:otherwise>
                                                    <strong>${event.currentRegistrations} / ${event.maxCapacity}</strong>
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div class="progress-bar-bg" style="height: 6px;">
                                        <div class="progress-fill ${event.full ? 'full' : ''}"
                                             style="width: ${event.capacityPercentage}%;"></div>
                                    </div>
                                </div>

                                <div style="margin-top: auto;">
                                    <a href="${pageContext.request.contextPath}/student/event-details?id=${event.id}" class="btn btn-primary btn-block">
                                        View Details & Register
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

    </div>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
