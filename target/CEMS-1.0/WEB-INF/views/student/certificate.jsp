<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    // set page title and active navigation menu
    request.setAttribute("pageTitle", "Official Certificate | CEMS - Chandigarh University");
    request.setAttribute("activeNav", "tickets");
%>

<jsp:include page="/WEB-INF/includes/header.jsp" />
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<style>
/* certificate container styling */
.certificate-wrapper {
    max-width: 900px;
    margin: 2rem auto;
}

.certificate-frame {
    background: #ffffff;
    border: 12px solid #1a365d;
    padding: 2.5rem 3rem;
    position: relative;
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
    border-radius: 4px;
}

.certificate-inner-border {
    border: 2px dashed #b8860b;
    padding: 2rem 2.5rem;
    text-align: center;
    background: #fffdfa;
    position: relative;
}

.cert-header-title {
    font-size: 1.8rem;
    font-weight: 800;
    color: #c026d3;
    letter-spacing: 2px;
    text-transform: uppercase;
    margin-bottom: 0.25rem;
}

.cert-sub {
    font-size: 0.95rem;
    font-weight: 600;
    color: #1a365d;
    text-transform: uppercase;
    letter-spacing: 1.5px;
    margin-bottom: 1.25rem;
}

.cert-main-badge {
    display: inline-block;
    padding: 0.4rem 1.75rem;
    background: #1a365d;
    color: #ffffff;
    font-size: 1.25rem;
    font-weight: 700;
    letter-spacing: 2px;
    text-transform: uppercase;
    border-radius: 4px;
    margin-bottom: 1.5rem;
}

.cert-presented-to {
    font-style: italic;
    color: #64748b;
    font-size: 1.05rem;
    margin-bottom: 0.5rem;
}

.cert-student-name {
    font-size: 2.2rem;
    font-weight: 800;
    color: #0f172a;
    border-bottom: 2px solid #b8860b;
    display: inline-block;
    padding: 0 2rem 0.35rem;
    margin-bottom: 0.75rem;
    font-family: Georgia, serif;
}

.cert-student-meta {
    font-size: 0.95rem;
    color: #334155;
    font-weight: 600;
    margin-bottom: 1.5rem;
}

.cert-body-text {
    font-size: 1.05rem;
    line-height: 1.8;
    color: #334155;
    max-width: 680px;
    margin: 0 auto 1.75rem;
}

.cert-event-name {
    font-weight: 700;
    color: #1a365d;
    font-size: 1.2rem;
}

.cert-merit-highlight {
    background: #fef3c7;
    border: 1px solid #fde68a;
    color: #92400e;
    font-weight: 700;
    padding: 0.35rem 1rem;
    border-radius: 20px;
    display: inline-block;
    margin: 0.5rem 0 1.25rem;
}

.cert-signatures {
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
    margin-top: 3rem;
    padding-top: 1.5rem;
}

.cert-sig-block {
    text-align: center;
    width: 200px;
}

.cert-sig-line {
    border-top: 1px solid #64748b;
    margin-bottom: 0.35rem;
}

.cert-sig-name {
    font-weight: 700;
    font-size: 0.88rem;
    color: #0f172a;
}

.cert-sig-title {
    font-size: 0.75rem;
    color: #64748b;
}

.cert-seal {
    width: 80px;
    height: 80px;
    border: 2px dashed #b8860b;
    border-radius: 50%;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    font-size: 0.7rem;
    color: #b8860b;
    font-weight: 700;
    text-transform: uppercase;
}

.cert-footer-info {
    display: flex;
    justify-content: space-between;
    font-size: 0.75rem;
    color: #94a3b8;
    margin-top: 1.5rem;
    border-top: 1px solid #e2e8f0;
    padding-top: 0.5rem;
}

@media print {
    .no-print {
        display: none !important;
    }
    body {
        background: #ffffff !important;
    }
    .main-content {
        padding: 0 !important;
    }
    .certificate-wrapper {
        margin: 0 !important;
        max-width: 100% !important;
    }
}
</style>

<main class="main-content">
    <div class="container certificate-wrapper">
        <jsp:include page="/WEB-INF/includes/alerts.jsp" />

        <!-- Print and back actions -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;" class="no-print">
            <a href="${pageContext.request.contextPath}/student/my-tickets" class="btn btn-outline btn-sm">
                <i class="fa-solid fa-arrow-left"></i> Back to My Registrations
            </a>
            <button onclick="window.print()" class="btn btn-primary btn-sm">
                <i class="fa-solid fa-print"></i> Print / Save PDF Certificate
            </button>
        </div>

        <!-- Official Academic Certificate Frame -->
        <div class="certificate-frame">
            <div class="certificate-inner-border">
                
                <!-- University Branding -->
                <div class="cert-header-title">
                    <i class="fa-solid fa-graduation-cap"></i> Chandigarh University
                </div>
                <div class="cert-sub">
                    University Institute of Computing (UIC) &bull; NAAC A+ Accredited
                </div>

                <!-- Certificate Title -->
                <div>
                    <c:choose>
                        <c:when test="${not empty registration.meritRank && registration.meritRank != 'PARTICIPANT'}">
                            <span class="cert-main-badge" style="background: #b45309;">
                                <i class="fa-solid fa-trophy"></i> Certificate of Merit
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="cert-main-badge">
                                <i class="fa-solid fa-award"></i> Certificate of Participation
                            </span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="cert-presented-to">This certificate is proudly awarded to</div>

                <!-- Student Name -->
                <div class="cert-student-name">
                    ${student.name}
                </div>

                <!-- Student Details -->
                <div class="cert-student-meta">
                    UID: <strong>${student.uid}</strong> &bull; Department: <strong>${student.department}</strong> &bull; ${student.semester}
                </div>

                <!-- Event Details Body -->
                <div class="cert-body-text">
                    for their valuable participation and active involvement in the university event 
                    <div class="cert-event-name" style="margin: 0.4rem 0;">
                        "${event.title}"
                    </div>
                    organized by the <strong>${event.category}</strong> committee, held on 
                    <strong>${event.eventDate}</strong> at <strong>${event.venue.name}</strong>, Chandigarh University.
                </div>

                <!-- Team information if registered as team -->
                <c:if test="${not empty registration.teamName}">
                    <div style="font-size: 0.9rem; color: #475569; margin-bottom: 0.75rem;">
                        <strong>Team:</strong> ${registration.teamName}
                    </div>
                </c:if>

                <!-- Merit Rank Badge if student is a winner -->
                <c:if test="${not empty registration.meritRank && registration.meritRank != 'PARTICIPANT'}">
                    <div>
                        <span class="cert-merit-highlight">
                            <i class="fa-solid fa-medal"></i> Awarded Position: ${registration.meritRank.replace('_', ' ')}
                            <c:if test="${not empty registration.score}">
                                &bull; Score: ${registration.score}
                            </c:if>
                        </span>
                    </div>
                </c:if>

                <!-- Signatures Block -->
                <div class="cert-signatures">
                    <div class="cert-sig-block">
                        <div class="cert-sig-line"></div>
                        <div class="cert-sig-name">${event.organizer.name}</div>
                        <div class="cert-sig-title">Faculty Event Coordinator</div>
                    </div>

                    <div class="cert-seal">
                        <i class="fa-solid fa-certificate" style="font-size: 1.25rem; margin-bottom: 0.2rem;"></i>
                        <span>CU SEAL</span>
                    </div>

                    <div class="cert-sig-block">
                        <div class="cert-sig-line"></div>
                        <div class="cert-sig-name">Head of Department</div>
                        <div class="cert-sig-title">University Institute of Computing</div>
                    </div>
                </div>

                <!-- Footer Verification Details -->
                <div class="cert-footer-info">
                    <span>Certificate ID: <strong>${registration.certificateCode}</strong></span>
                    <span>Issue Date: <strong>${event.eventDate}</strong></span>
                    <span>Status: <strong>Verified by CEMS Portal</strong></span>
                </div>

            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
