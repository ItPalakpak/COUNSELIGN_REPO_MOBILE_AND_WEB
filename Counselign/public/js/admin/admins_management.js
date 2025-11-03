document.addEventListener('DOMContentLoaded', function() {
    // Get the logout button
    const logoutButton = document.querySelector('button.bg-gray-300');

    // Add click event listener for logout
    if (logoutButton) {
        logoutButton.addEventListener('click', function() {
            const confirmDialog = document.createElement('div');
            confirmDialog.className = 'fixed inset-0 bg-gray-800 bg-opacity-50 flex items-center justify-center z-50';
            confirmDialog.innerHTML = `
                <div class="bg-white rounded-lg p-6 max-w-sm mx-auto">
                    <h3 class="text-lg font-bold mb-4">Confirm Logout</h3>
                    <p class="mb-6">Are you sure you want to logout?</p>
                    <div class="flex justify-end space-x-3">
                        <button id="cancelLogout" class="px-4 py-2 bg-gray-200 text-gray-800 rounded hover:bg-gray-300">Cancel</button>
                        <button id="confirmLogout" class="px-4 py-2 bg-blue-900 text-white rounded hover:bg-blue-700">Logout</button>
                    </div>
                </div>
            `;

            document.body.appendChild(confirmDialog);

            document.getElementById('cancelLogout').addEventListener('click', function() {
                document.body.removeChild(confirmDialog);
            });

            document.getElementById('confirmLogout').addEventListener('click', function() {
                window.location.href = (window.BASE_URL || '/') + 'auth/logout';
            });
        });
    }

    // Load counselor schedules on page load
    loadCounselorSchedules();

    // Auto-refresh every 5 minutes
    setInterval(loadCounselorSchedules, 300000);
});

function confirmLogout() {
    if (confirm("Are you sure you want to log out?")) {
        window.location.href = (window.BASE_URL || '/') + 'auth/logout';
    }
}

function loadCounselorSchedules() {
    const baseUrl = window.BASE_URL || '/';
    
    SecureLogger.info('Loading counselor schedules...');
    
    fetch(baseUrl + 'admin/admins-management/schedules')
        .then(response => {
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            return response.json();
        })
        .then(data => {
            if (data.success) {
                displayCounselorSchedules(data.schedules);
                SecureLogger.info(`Loaded schedules for ${data.total_counselors} counselors`);
            } else {
                console.error('Failed to load counselor schedules:', data.message);
                showScheduleError(data.message);
                showEmptySchedules();
            }
        })
        .catch(error => {
            console.error('Error loading counselor schedules:', error);
            showScheduleError('Failed to load counselor schedules. Please try again.');
            showEmptySchedules();
        });
}

function displayCounselorSchedules(scheduleData) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    
    // Deterministic color assignment per counselor ID
    const __counselorColorCache = new Map();
    function hashStringToInt(str) {
        let hash = 0;
        for (let i = 0; i < String(str).length; i++) {
            hash = (hash << 5) - hash + String(str).charCodeAt(i);
            hash |= 0; // Convert to 32bit integer
        }
        return Math.abs(hash);
    }
    function hslToHex(h, s, l) {
        s /= 100; l /= 100;
        const k = n => (n + h / 30) % 12;
        const a = s * Math.min(l, 1 - l);
        const f = n => l - a * Math.max(-1, Math.min(k(n) - 3, Math.min(9 - k(n), 1)));
        const toHex = x => Math.round(255 * x).toString(16).padStart(2, '0');
        return `#${toHex(f(0))}${toHex(f(8))}${toHex(f(4))}`;
    }
    function getCounselorGradient(counselorId, counselorName) {
        if (__counselorColorCache.has(counselorId)) return __counselorColorCache.get(counselorId);
        const key = counselorId || counselorName || 'default';
        const hash = hashStringToInt(key);
        const hue = hash % 360; // 0..359 full spectrum
        // Bright pastel tuning
        const sat = 45 + (hash % 21); // 45..66
        const light1 = 82 + (hash % 9); // 82..90
        const light2 = 94 + (hash % 5); // 94..98
        const c1 = hslToHex(hue, sat, light1);
        const c2 = hslToHex(hue, Math.max(40, sat - 8), light2);
        const gradient = `linear-gradient(135deg, ${c1} 0%, ${c2} 100%)`;
        __counselorColorCache.set(counselorId, gradient);
        return gradient;
    }

    SecureLogger.info('Processing counselor schedules...', scheduleData);

    days.forEach(day => {
        const dayLower = day.toLowerCase();
        const container = document.getElementById(`${dayLower}-schedule`);
        
        if (!container) {
            console.warn(`Container not found for ${day}`);
            return;
        }

        const counselors = scheduleData[day] || [];
        
        if (counselors.length === 0) {
            container.innerHTML = `
                <div class="empty-schedule">
                    <i class="fas fa-calendar-times"></i>
                    <p>No counselors scheduled</p>
                </div>
            `;
            return;
        }

        // Clear container
        container.innerHTML = '';

        // Create cards for each counselor with a unique, consistent gradient
        counselors.forEach((counselor) => {
            const gradient = getCounselorGradient(counselor.counselor_id, counselor.name);
            const card = createCounselorCard(counselor, gradient, day);
            container.appendChild(card);
        });
    });
}

function createCounselorCard(counselor, gradient, day) {
    const card = document.createElement('div');
    card.className = 'counselor-card';
    card.style.background = gradient;
    
    // Format time slots for display using consistent formatting
    const timeDisplay = formatTimeSlotsForDisplay(counselor.time_slots);

    const baseUrl = window.BASE_URL || '/';
    
    // Get profile picture path with fallback
    const profilePicture = counselor.profile_picture 
        ? `${baseUrl}${counselor.profile_picture}`
        : `${baseUrl}Photos/profile.png`;

    card.innerHTML = `
        <div class="counselor-card-header">
            
            <div class="counselor-info">
                <h4 class="counselor-name">${counselor.name}</h4>
                
            </div>
        </div>
        <div class="counselor-card-body">
            <div class="time-info">
                <i class="fas fa-clock"></i>
                <span class="time-display">${timeDisplay}</span>
            </div>
            
        </div>
        <div class="counselor-card-footer">
            <button class="view-details-btn" onclick='showCounselorDetails(${JSON.stringify(counselor).replace(/'/g, "&#39;")})'>
                <i class="fas fa-info-circle"></i> View Details
            </button>
        </div>
    `;

    // Add hover effect
    card.addEventListener('mouseenter', function() {
        this.style.transform = 'translateY(-5px)';
        this.style.boxShadow = '0 8px 25px rgba(0, 0, 0, 0.2)';
    });

    card.addEventListener('mouseleave', function() {
        this.style.transform = 'translateY(0)';
        this.style.boxShadow = '0 4px 15px rgba(0, 0, 0, 0.1)';
    });

    return card;
}

function showEmptySchedules() {
    const days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday'];
    
    days.forEach(day => {
        const container = document.getElementById(`${day}-schedule`);
        if (container) {
            container.innerHTML = `
                <div class="empty-schedule">
                    <i class="fas fa-calendar-times"></i>
                    <p>No counselors scheduled</p>
                </div>
            `;
        }
    });
}

// Time formatting functions are now provided by the shared utility: timeFormatter.js

function showScheduleError(message) {
    const errorDiv = document.createElement('div');
    errorDiv.className = 'schedule-error';
    errorDiv.innerHTML = `
        <div class="error-content">
            <i class="fas fa-exclamation-triangle"></i>
            <div>
                <strong>Schedule Error</strong>
                <p>${message}</p>
            </div>
        </div>
        <button onclick="this.parentElement.remove()" class="error-close">
            <i class="fas fa-times"></i>
        </button>
    `;
    
    document.body.appendChild(errorDiv);
    
    setTimeout(() => {
        if (errorDiv.parentElement) {
            errorDiv.style.animation = 'slideOut 0.3s ease-out';
            setTimeout(() => errorDiv.remove(), 300);
        }
    }, 5000);
}

function showCounselorDetails(counselor) {
    const modal = document.createElement('div');
    modal.className = 'counselor-details-modal';
    
    const overlay = document.createElement('div');
    overlay.className = 'modal-overlay';
    
    const closeModal = () => {
        modal.style.animation = 'fadeOut 0.3s ease-out';
        overlay.style.animation = 'fadeOut 0.3s ease-out';
        setTimeout(() => {
            modal.remove();
            overlay.remove();
        }, 300);
    };

    const baseUrl = window.BASE_URL || '/';
    
    // Get profile picture path with fallback
    const profilePicture = counselor.profile_picture 
        ? `${baseUrl}${counselor.profile_picture}`
        : `${baseUrl}Photos/profile.png`;
    
    // Format time slots for display using consistent formatting
    const formattedTimeSlots = formatTimeSlotsForDisplay(counselor.time_slots);
    let timeSlotsHTML = '';
    
    if (formattedTimeSlots === 'All Day') {
        timeSlotsHTML = '<span class="time-badge all-day">All Day</span>';
    } else {
        // Split by bullet points and create individual badges
        const timeSlotArray = formattedTimeSlots.split(' • ');
        timeSlotsHTML = timeSlotArray.map(time => `<span class="time-badge">${time}</span>`).join('');
    }

    modal.innerHTML = `
        <div class="modal-header">
            <h3><i class="fas fa-user-circle"></i> Counselor Details</h3>
            <button class="close-modal-btn" id="closeModalBtn">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="modal-body">
            <div class="counselor-profile">
                <img src="${profilePicture}" 
                     alt="${counselor.name}" 
                     class="modal-avatar"
                     onerror="this.src='${baseUrl}Photos/profile.png'">
                <div class="profile-details">
                    <h4>${counselor.name}</h4>
                    <p class="degree-text">${counselor.degree || 'Counselor'}</p>
                    <p class="id-text"><i class="fas fa-id-badge"></i> ID: ${counselor.counselor_id}</p>
                </div>
            </div>
            <div class="schedule-details">
                <h5><i class="fas fa-clock"></i> Available Time Slots</h5>
                <div class="time-slots">
                    ${timeSlotsHTML}
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button class="close-btn" onclick="this.closest('.counselor-details-modal').previousElementSibling.click()">
                Close
            </button>
        </div>
    `;

    document.body.appendChild(overlay);
    document.body.appendChild(modal);

    overlay.onclick = closeModal;
    modal.querySelector('#closeModalBtn').onclick = closeModal;
    
    // Animate in
    setTimeout(() => {
        modal.style.animation = 'fadeIn 0.3s ease-out';
        overlay.style.animation = 'fadeIn 0.3s ease-out';
    }, 10);
}

// Add CSS animations
const style = document.createElement('style');
style.textContent = `
    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: scale(0.9);
        }
        to {
            opacity: 1;
            transform: scale(1);
        }
    }
    
    @keyframes fadeOut {
        from {
            opacity: 1;
            transform: scale(1);
        }
        to {
            opacity: 0;
            transform: scale(0.9);
        }
    }
    
    @keyframes slideOut {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(100%);
            opacity: 0;
        }
    }
`;
document.head.appendChild(style);