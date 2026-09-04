</div><!-- /container -->

<footer class="bg-body-tertiary border-top py-4 mt-5">
    <div class="container">
        <div class="row g-3 align-items-center">
            <div class="col-md-6 text-center text-md-start">
                <p class="mb-1 fw-semibold text-primary">
                    <i class="bi bi-robot me-1"></i> IA Generativa &mdash; Portal Educativo
                </p>
                <p class="text-muted small mb-0">
                    Universidad de Londres &bull; Licenciatura en Informática<br>
                    Desarrollado con dedicación por <strong>Arturo Murillo</strong> &bull; &copy; 2026
                </p>
            </div>
            <div class="col-md-6 text-center text-md-end">
                <div class="d-flex justify-content-center justify-content-md-end gap-3 small text-muted">
                    <a href="articulos.jsp" class="text-decoration-none text-muted">Artículos</a>
                    <a href="tips.jsp" class="text-decoration-none text-muted">Tips</a>
                    <a href="prompt-builder.jsp" class="text-decoration-none text-muted">Prompt Builder</a>
                    <a href="quiz.jsp" class="text-decoration-none text-muted">Quiz</a>
                    <a href="normatividad.jsp" class="text-decoration-none text-muted">Normatividad</a>
                </div>
            </div>
        </div>
    </div>
</footer>

<!-- Toast para notificaciones rápidas -->
<div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 9999;">
    <div id="appToast" class="toast align-items-center text-bg-primary border-0" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body d-flex align-items-center gap-2">
                <i class="bi bi-check2-circle fs-5"></i>
                <span id="toastMessage">Operación realizada con éxito.</span>
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
// Manejador interactivo del Modo Oscuro
document.addEventListener('DOMContentLoaded', function() {
    const toggleBtn = document.getElementById('themeToggleBtn');
    const toggleIcon = document.getElementById('themeToggleIcon');
    
    function updateIcon(theme) {
        if (!toggleIcon) return;
        if (theme === 'dark') {
            toggleIcon.className = 'bi bi-sun-fill text-warning';
        } else {
            toggleIcon.className = 'bi bi-moon-stars text-primary';
        }
    }

    const currentTheme = document.documentElement.getAttribute('data-bs-theme') || 'light';
    updateIcon(currentTheme);

    if (toggleBtn) {
        toggleBtn.addEventListener('click', function() {
            const activeTheme = document.documentElement.getAttribute('data-bs-theme') === 'dark' ? 'light' : 'dark';
            document.documentElement.setAttribute('data-bs-theme', activeTheme);
            localStorage.setItem('theme', activeTheme);
            updateIcon(activeTheme);
        });
    }
});

// Función global para mostrar Toasts
function mostrarToast(mensaje, tipo) {
    const toastEl = document.getElementById('appToast');
    const toastMsg = document.getElementById('toastMessage');
    if (!toastEl || !toastMsg) return;

    toastEl.className = 'toast align-items-center border-0 text-bg-' + (tipo || 'primary');
    toastMsg.textContent = mensaje;
    const bsToast = new bootstrap.Toast(toastEl, { delay: 3000 });
    bsToast.show();
}
</script>
</body>
</html>
