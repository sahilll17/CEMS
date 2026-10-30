<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<footer class="footer">
    <div class="container footer-inner">
        <div class="footer-copy">
            <div style="display: flex; align-items: center; gap: 0.5rem; color: #fff; font-weight: 700; font-size: 1.05rem;">
                <i class="fa-solid fa-graduation-cap" style="color: #60a5fa;"></i> Chandigarh University
            </div>
            <p style="color: #cbd5e1; font-size: 0.85rem; margin-top: 0.25rem;">
                College Event Management System (CEMS) &bull; University Institute of Computing (UIC)
            </p>
            <p style="color: #94a3b8; font-size: 0.8rem; margin-top: 0.2rem;">
                MCA Semester 1 Mini Project &bull; Submitted by: <strong>Sahil Sharma</strong> (UID: 26MCI10257, MAM-4B) &bull; Guide: <strong>Ms. Shruti Sharma</strong>
            </p>
        </div>

        <div style="display: flex; gap: 1.25rem; align-items: center; flex-wrap: wrap;">
            <a href="${pageContext.request.contextPath}/student/events">Upcoming Events</a>
            <a href="${pageContext.request.contextPath}/login.jsp">Login Portal</a>
            <span style="color: #94a3b8; font-size: 0.82rem;">&copy; 2026 Chandigarh University</span>
        </div>
    </div>
</footer>

<!-- CEMS Core Script -->
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
