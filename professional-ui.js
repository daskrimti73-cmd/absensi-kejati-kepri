/* ============================================
   PROFESSIONAL UI/UX UTILITIES v3.2.0
   Kejaksaan Tinggi Kepulauan Riau
   ============================================ */

// ============================================
// TOAST NOTIFICATIONS
// ============================================
class Toast {
    constructor() {
        this.container = this.createContainer();
    }
    
    createContainer() {
        let container = document.getElementById('toast-container');
        if (!container) {
            container = document.createElement('div');
            container.id = 'toast-container';
            container.style.cssText = `
                position: fixed;
                bottom: 24px;
                right: 24px;
                z-index: 9999;
                display: flex;
                flex-direction: column;
                gap: 12px;
            `;
            document.body.appendChild(container);
        }
        return container;
    }
    
    show(message, type = 'info', duration = 3000) {
        const toast = document.createElement('div');
        toast.className = `toast toast-${type}`;
        
        const icons = {
            success: '✅',
            error: '❌',
            warning: '⚠️',
            info: 'ℹ️'
        };
        
        toast.innerHTML = `
            <span style="font-size: 20px;">${icons[type]}</span>
            <span style="flex: 1;">${message}</span>
            <button onclick="this.parentElement.remove()" style="
                background: none;
                border: none;
                font-size: 20px;
                cursor: pointer;
                color: var(--gray-600);
                padding: 0;
                width: 24px;
                height: 24px;
                display: flex;
                align-items: center;
                justify-content: center;
            ">×</button>
        `;
        
        this.container.appendChild(toast);
        
        // Auto remove
        setTimeout(() => {
            toast.classList.add('toast-exit');
            setTimeout(() => toast.remove(), 300);
        }, duration);
        
        return toast;
    }
    
    success(message, duration) {
        return this.show(message, 'success', duration);
    }
    
    error(message, duration) {
        return this.show(message, 'error', duration);
    }
    
    warning(message, duration) {
        return this.show(message, 'warning', duration);
    }
    
    info(message, duration) {
        return this.show(message, 'info', duration);
    }
}

// Global toast instance
const toast = new Toast();

// ============================================
// RIPPLE EFFECT
// ============================================
function addRippleEffect(element) {
    element.addEventListener('click', function(e) {
        const ripple = document.createElement('span');
        const rect = this.getBoundingClientRect();
        const size = Math.max(rect.width, rect.height);
        const x = e.clientX - rect.left - size / 2;
        const y = e.clientY - rect.top - size / 2;
        
        ripple.style.cssText = `
            position: absolute;
            width: ${size}px;
            height: ${size}px;
            left: ${x}px;
            top: ${y}px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.5);
            pointer-events: none;
            animation: ripple-animation 0.6s ease-out;
        `;
        
        this.appendChild(ripple);
        setTimeout(() => ripple.remove(), 600);
    });
}

// Add ripple to all buttons
document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.btn').forEach(btn => {
        addRippleEffect(btn);
    });
});

// Add ripple animation CSS
const rippleStyle = document.createElement('style');
rippleStyle.textContent = `
    @keyframes ripple-animation {
        to {
            transform: scale(4);
            opacity: 0;
        }
    }
`;
document.head.appendChild(rippleStyle);

// ============================================
// SMOOTH SCROLL
// ============================================
document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
});

// ============================================
// INTERSECTION OBSERVER - Animate on Scroll
// ============================================
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -100px 0px'
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.classList.add('animate-in');
            observer.unobserve(entry.target);
        }
    });
}, observerOptions);

document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.animate-on-scroll').forEach(el => {
        observer.observe(el);
    });
});

// ============================================
// DARK MODE TOGGLE
// ============================================
class DarkMode {
    constructor() {
        this.theme = localStorage.getItem('theme') || 'light';
        this.init();
    }
    
    init() {
        this.applyTheme();
        this.createToggle();
    }
    
    applyTheme() {
        document.documentElement.setAttribute('data-theme', this.theme);
    }
    
    toggle() {
        this.theme = this.theme === 'light' ? 'dark' : 'light';
        localStorage.setItem('theme', this.theme);
        this.applyTheme();
        
        // Dispatch event for other components
        window.dispatchEvent(new CustomEvent('themechange', { detail: this.theme }));
    }
    
    createToggle() {
        const toggle = document.createElement('button');
        toggle.id = 'dark-mode-toggle';
        toggle.className = 'btn btn-ghost';
        toggle.style.cssText = `
            position: fixed;
            bottom: 24px;
            left: 24px;
            z-index: 1000;
            width: 48px;
            height: 48px;
            border-radius: 50%;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            box-shadow: var(--shadow-lg);
            background: white;
        `;
        toggle.innerHTML = this.theme === 'light' ? '🌙' : '☀️';
        toggle.title = 'Toggle Dark Mode';
        
        toggle.addEventListener('click', () => {
            this.toggle();
            toggle.innerHTML = this.theme === 'light' ? '🌙' : '☀️';
        });
        
        document.body.appendChild(toggle);
    }
}

// Initialize dark mode
const darkMode = new DarkMode();

// ============================================
// LOADING OVERLAY
// ============================================
class LoadingOverlay {
    constructor() {
        this.overlay = null;
    }
    
    show(message = 'Loading...') {
        if (this.overlay) return;
        
        this.overlay = document.createElement('div');
        this.overlay.style.cssText = `
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(4px);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            z-index: 10000;
            animation: fadeIn 0.3s ease-out;
        `;
        
        this.overlay.innerHTML = `
            <div class="spinner"></div>
            <p style="color: white; margin-top: 16px; font-weight: 600;">${message}</p>
        `;
        
        document.body.appendChild(this.overlay);
        document.body.style.overflow = 'hidden';
    }
    
    hide() {
        if (!this.overlay) return;
        
        this.overlay.style.animation = 'fadeOut 0.3s ease-out';
        setTimeout(() => {
            this.overlay.remove();
            this.overlay = null;
            document.body.style.overflow = '';
        }, 300);
    }
}

// Global loading instance
const loading = new LoadingOverlay();

// ============================================
// FORM VALIDATION
// ============================================
class FormValidator {
    constructor(form) {
        this.form = form;
        this.init();
    }
    
    init() {
        this.form.addEventListener('submit', (e) => {
            if (!this.validate()) {
                e.preventDefault();
            }
        });
        
        // Real-time validation
        this.form.querySelectorAll('input, select, textarea').forEach(field => {
            field.addEventListener('blur', () => this.validateField(field));
        });
    }
    
    validate() {
        let isValid = true;
        this.form.querySelectorAll('[required]').forEach(field => {
            if (!this.validateField(field)) {
                isValid = false;
            }
        });
        return isValid;
    }
    
    validateField(field) {
        const value = field.value.trim();
        const isValid = value !== '';
        
        if (!isValid) {
            this.showError(field, 'This field is required');
        } else {
            this.clearError(field);
        }
        
        return isValid;
    }
    
    showError(field, message) {
        field.style.borderColor = 'var(--error)';
        
        let error = field.parentElement.querySelector('.error-message');
        if (!error) {
            error = document.createElement('div');
            error.className = 'error-message';
            error.style.cssText = `
                color: var(--error);
                font-size: var(--text-sm);
                margin-top: var(--space-1);
            `;
            field.parentElement.appendChild(error);
        }
        error.textContent = message;
    }
    
    clearError(field) {
        field.style.borderColor = '';
        const error = field.parentElement.querySelector('.error-message');
        if (error) error.remove();
    }
}

// ============================================
// COPY TO CLIPBOARD
// ============================================
async function copyToClipboard(text) {
    try {
        await navigator.clipboard.writeText(text);
        toast.success('Copied to clipboard!');
    } catch (err) {
        toast.error('Failed to copy');
    }
}

// ============================================
// DEBOUNCE UTILITY
// ============================================
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// ============================================
// THROTTLE UTILITY
// ============================================
function throttle(func, limit) {
    let inThrottle;
    return function(...args) {
        if (!inThrottle) {
            func.apply(this, args);
            inThrottle = true;
            setTimeout(() => inThrottle = false, limit);
        }
    };
}

// ============================================
// SCROLL TO TOP BUTTON
// ============================================
document.addEventListener('DOMContentLoaded', () => {
    const scrollBtn = document.createElement('button');
    scrollBtn.innerHTML = '↑';
    scrollBtn.className = 'btn btn-primary';
    scrollBtn.style.cssText = `
        position: fixed;
        bottom: 88px;
        right: 24px;
        z-index: 1000;
        width: 48px;
        height: 48px;
        border-radius: 50%;
        padding: 0;
        display: none;
        align-items: center;
        justify-content: center;
        font-size: 24px;
        box-shadow: var(--shadow-lg);
    `;
    scrollBtn.title = 'Scroll to Top';
    
    scrollBtn.addEventListener('click', () => {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    });
    
    // Show/hide on scroll
    const handleScroll = throttle(() => {
        if (window.scrollY > 300) {
            scrollBtn.style.display = 'flex';
        } else {
            scrollBtn.style.display = 'none';
        }
    }, 100);
    
    window.addEventListener('scroll', handleScroll);
    document.body.appendChild(scrollBtn);
});

// ============================================
// KEYBOARD SHORTCUTS
// ============================================
document.addEventListener('keydown', (e) => {
    // Ctrl/Cmd + K: Focus search
    if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
        e.preventDefault();
        const searchInput = document.querySelector('input[type="search"]');
        if (searchInput) searchInput.focus();
    }
    
    // Escape: Close modals/overlays
    if (e.key === 'Escape') {
        const modals = document.querySelectorAll('.modal, .overlay');
        modals.forEach(modal => modal.remove());
    }
});

// ============================================
// EXPORT UTILITIES
// ============================================
window.UIUtils = {
    toast,
    loading,
    darkMode,
    copyToClipboard,
    debounce,
    throttle,
    FormValidator,
    addRippleEffect
};

console.log('✨ Professional UI/UX v3.2.0 loaded successfully');
