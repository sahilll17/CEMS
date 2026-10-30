// cems portal main javascript file
document.addEventListener('DOMContentLoaded', () => {
    // 1. Mobile Navigation Toggle
    const mobileToggle = document.getElementById('mobileMenuToggle');
    const navLinks = document.getElementById('navLinksMenu');
    if (mobileToggle && navLinks) {
        mobileToggle.addEventListener('click', () => {
            navLinks.classList.toggle('show');
        });
    }

    // 2. Alert Dismissal
    const alertCloseBtns = document.querySelectorAll('.alert-close');
    alertCloseBtns.forEach(btn => {
        btn.addEventListener('click', (e) => {
            const alert = e.target.closest('.alert');
            if (alert) {
                alert.style.transition = 'opacity 0.25s ease, transform 0.25s ease';
                alert.style.opacity = '0';
                alert.style.transform = 'translateY(-10px)';
                setTimeout(() => alert.remove(), 260);
            }
        });
    });

    // 3. Category Filter Pills
    const filterPills = document.querySelectorAll('.filter-pill');
    filterPills.forEach(pill => {
        pill.addEventListener('click', (e) => {
            const category = pill.getAttribute('data-category');
            const categoryInput = document.getElementById('filterCategoryInput');
            const form = document.getElementById('eventsFilterForm');
            if (categoryInput && form) {
                categoryInput.value = category;
                form.submit();
            }
        });
    });
});
