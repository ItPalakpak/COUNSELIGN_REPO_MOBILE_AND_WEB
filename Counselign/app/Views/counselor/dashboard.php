<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description"
        content="University Guidance Counseling Services - Your safe space for support and guidance" />
    <meta name="keywords" content="counseling, guidance, university, support, mental health, student wellness" />
    <title>Counselign</title>
    <link rel="icon" href="<?= base_url('Photos/counselign.ico') ?>" sizes="16x16 32x32" type="image/x-icon">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<?= base_url('css/counselor/counselor_dashboard.css') ?>">


</head>

<body>
    <header class="text-white p-1" style="background-color: #060E57;">
        <div class="container-fluid px-4">
            <div class="row align-items-center">
                <div class="d-flex align-items-center">
                    <div class="logo-title-container">
                        <img src="<?= base_url('Photos/counselign_logo.png') ?>" alt="Counselign logo" class="logo" />
                        <h1 class="h4 fw-bold ms-2 mb-0">Counselign</h1>
                    </div>
                    <button class="custom-navbar-toggler align-items-center" type="button" id="navbarDrawerToggler">
                        <span class="navbar-toggler-icon"><i class="fas fa-gear"></i></span>
                    </button>
                </div>
            </div>
        </div>
    </header>

    <!-- Navbar Drawer (always available) -->
    <div class="navbar-drawer" id="navbarDrawer">
        <div class="drawer-header d-flex justify-content-between align-items-center p-3 text-white" style="background-color: #060E57;">
            <h5 class="m-0">Counselor Menu</h5>
            <button class="btn-close btn-close-white" id="navbarDrawerClose" aria-label="Close"></button>
        </div>
        <ul class="navbar-nav nav-links p-3">
            <li class="nav-item"><a class="nav-link" href="<?= base_url('counselor/announcements') ?>"><i class="fas fa-bullhorn"></i> Announcements</a></li>
            <li class="nav-item"><a class="nav-link" href="<?= base_url('counselor/appointments/scheduled') ?>"><i class="fas fa-calendar-alt"></i> Scheduled Appointments</a></li>
            <li class="nav-item"><a class="nav-link" href="<?= base_url('counselor/follow-up') ?>"><i class="fas fa-clipboard-list"></i>For Follow-up Session</a></li>
            <li class="nav-item"><a class="nav-link" href="<?= base_url('counselor/profile') ?>"><i class="fas fa-user"></i> Profile</a></li>
            <li class="nav-item"><a class="nav-link" href="#" id="logoutFromDrawer"><i class="fas fa-sign-out-alt"></i> Log Out</a></li>
        </ul>
    </div>

    <!-- Overlay for Navbar Drawer -->
    <div class="navbar-overlay" id="navbarOverlay"></div>

    <main class="flex-grow py-4 px-8">
        <!-- Interactive Profile Picture Section -->

        <div class="profile-display flex justify-between items-center">
            <div class="flex items-center space-x-4"></div>
            <button class="profile-avatar" type="button">
                <img id="profile-img" src="<?= base_url('Photos/profile.png') ?>" alt="User Avatar" class="profile-img" />
            </button>
            <div class="profile-details-wrapper">
                <?php
                $userDisplayHelper = new \App\Helpers\UserDisplayHelper();
                $userInfo = $userDisplayHelper->getUserDisplayInfo(session()->get('user_id_display'), session()->get('role'));
                ?>
                <div class="fs-12 fw-bold" style="color: #003366;">
                    Hello!
                    <span class="text-primary">
                        <i><?= $userInfo['display_name'] ?></i>
                    </span>
                    <?php if ($userInfo['has_name']): ?>
                        <span class="small text-muted" style="display: none;" id="user-id-display"><?= $userInfo['user_id_display'] ?></span>
                    <?php endif; ?>
                </div>
                <div class="small text-secondary">Last login: <?php
                                                                $lastLogin = session()->get('last_login');
                                                                if ($lastLogin) {
                                                                    $dateTime = new \DateTime($lastLogin);
                                                                    echo $dateTime->format('M j, g:i A');
                                                                } else {
                                                                    echo 'N/A';
                                                                }
                                                                ?></div>
            </div>

           

            <div class="ml-auto flex items-center space-x-6">
                <!-- Quote Button -->
                <div class="relative">
                    <i class="fas fa-quote-right text-2xl" id="openQuoteModalBtn" title="Quotes"
                        style="color: #003366; cursor: pointer;"></i>
                </div>

                <!-- Notification Icon -->
                <div class="relative notification-icon-container">
                    <i class="fas fa-bell text-2xl" id="notificationIcon" title="Notifications"
                        style="color: #003366; cursor: pointer;"></i>
                    <span id="notificationBadge" class="notification-badge hidden">0</span>
                </div>
            </div>
        </div>

        <!-- Content Panel -->
        <div class="content-panel mt-4">
            <h3 class="text-2xl font-extrabold mb-4">Welcome to Your Workspace, Counselor!</h3>
            <div class="row g-4">
                <div class="col-md-6">
                    <div class="card h-70 p-4 shadow text-decoration-none dashboard-card position-relative d-flex flex-column" id="messagesCard" style="cursor: pointer;">
                        <h3 class="h3 fw-bold mb-4 title-color">
                            <i class="fas fa-envelope me-2"></i> Messages
                            <span id="messagesBadge" class="badge bg-danger messages-badge" style="display:none;" aria-label="New messages">0</span>
                        </h3>
                        <div class="d-flex flex-column gap-3 flex-grow-1">
                            <div class="p-3 bg-light rounded shadow-sm">
                                <p class="text-body-secondary">Message content goes here...</p>
                                <p class="small text-secondary mt-2">Received on:</p>
                            </div>
                            <div class="p-3 bg-light rounded shadow-sm">
                                <p class="text-body-secondary">Message content goes here...</p>
                                <p class="small text-secondary mt-2">Received on:</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card h-70 p-4 shadow dashboard-card" id="appointments-container">
                        <h3 class="h3 fw-bold mb-4 title-color"><i class="fas fa-list-alt me-2"></i> Appointments</h3>
                        <div class="d-flex flex-column gap-3">
                            <div class="p-3 bg-light rounded shadow-sm">
                                <p class="text-body-secondary">User ID: </p>
                                <p class="text-body-secondary">Appointment Date: </p>
                                <p class="text-body-secondary">Time: </p>
                            </div>
                            <div class="p-3 bg-light rounded shadow-sm">
                                <p class="text-body-secondary">User ID: </p>
                                <p class="text-body-secondary">Appointment Date: </p>
                                <p class="text-body-secondary">Time: </p>
                            </div>
                        </div>
                        <div class="d-flex justify-content-start mt-3 gap-2" style="position: relative; z-index: 10;">
                            <a href="<?= base_url('counselor/appointments/view-all') ?>" class="btn btn-primary" style="pointer-events: auto;">
                                <i class="fas fa-chart-line me-1"></i> Reports
                            </a>
                            <a href="<?= base_url('counselor/appointments') ?>" class="btn btn-success" style="pointer-events: auto;">
                                <i class="fas fa-list-alt me-1"></i> Manage
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="wave"></div>
        </div>

        <!-- Add this section after line 129 in dashboard.php, after the </div> that closes the row with Messages and Appointments -->



        <!-- Notifications Dropdown -->
        <div id="notificationsDropdown" class="absolute bg-white rounded-lg shadow-lg border">
            <div class="p-3 border-b border-gray-200 flex justify-between items-center">
                <h3 class="text-lg font-bold text-blue-800">Notifications</h3>
                <button id="markAllReadBtn" class="btn btn-sm btn-outline-primary" title="Mark all as read">
                    <i class="fas fa-check-double"></i> Clear All
                </button>
            </div>
            <div class="notifications-list max-h-64 overflow-y-auto">
                <!-- Notifications will be dynamically populated here -->
            </div>
        </div>

        <!-- Resources Accordion Section -->
        <section class="resources-section mt-5 mb-4">
            <div class="container-fluid px-0">
                <div class="accordion" id="resourcesParentAccordion">
                    <div class="accordion-item">
                        <h2 class="accordion-header" id="resourcesParentHeading">
                            <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#resourcesParentCollapse" aria-expanded="true" aria-controls="resourcesParentCollapse">
                                <i class="fas fa-folder-open me-2"></i>
                                <span class="fw-bold">Resources</span>
                            </button>
                        </h2>
                        <div id="resourcesParentCollapse" class="accordion-collapse collapse show" aria-labelledby="resourcesParentHeading" data-bs-parent="#resourcesParentAccordion">
                            <div class="accordion-body">
                                <div class="accordion" id="resourcesAccordion">
                                    <div id="resourcesAccordionContent">
                                        <div class="text-center py-4">
                                            <div class="spinner-border text-primary" role="status">
                                                <span class="visually-hidden">Loading resources...</span>
                                            </div>
                                            <p class="mt-2 text-muted">Loading resources...</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <!-- Chat Popup -->
    <div id="chatPopup" class="chat-popup">
        <div class="chat-header">
            <div class="font-bold">Send A Message to the Admin</div>
            <button id="closeChat" class="text-white">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="chat-body" id="chatMessages">
            <div class="text-center text-gray-500 text-sm mb-4">
                Your conversation is private and confidential
            </div>
            <div id="messagesContainer">
                <!-- Messages will be loaded here -->
            </div>
        </div>
        <div class="chat-footer">
            <form id="messageForm" class="message-form">
                <div class="message-input-wrapper">
                    <textarea
                        id="messageInput"
                        name="messageInput"
                        class="message-input"
                        placeholder="Type your message here..."
                        rows="2"
                        required>
                    </textarea>
                </div>
                <button type="submit" class="send-button" id="sendMessage">
                    <i class="fas fa-paper-plane"></i>
                </button>
            </form>
        </div>
    </div>

    <footer>
        <div class="footer-content">
            <div class="copyright">
                <b>© 2025 Counselign Team. All rights reserved.</b>
            </div>

        </div>
    </footer>

    <!-- Appointment Details Modal -->
    <div class="modal fade" id="appointmentDetailsModal" tabindex="-1" aria-labelledby="appointmentDetailsLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="appointmentDetailsLabel">Appointment Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="appointmentDetailsBody">
                    <!-- Appointment details will be injected here -->
                </div>

                <div class="d-flex justify-content-end mt-3 gap-2 p-3" style="position: relative; z-index: 10;">
                    <a href="<?= base_url('counselor/appointments') ?>" class="btn btn-primary" style="pointer-events: auto;">
                        <i class="fas fa-list-alt me-1"></i> Manage
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Shared Confirmation Modal (used for logout and other confirms) -->
    <div class="modal fade" id="confirmationModal" tabindex="-1" aria-labelledby="confirmationModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="confirmationModalLabel">Confirm Action</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="confirmationMessageContent">Are you sure?</div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="confirmationConfirmBtn">Confirm</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Shared Alert Modal (utility compatible) -->
    <div class="modal fade" id="alertModal" tabindex="-1" aria-labelledby="alertModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="alertModalLabel">Information</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body d-flex align-items-start gap-2">
                    <span id="alertIcon"><i class="fas fa-info-circle text-primary"></i></span>
                    <span id="alertMessageContent">Message</span>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-bs-dismiss="modal">OK</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Shared Notice Modal (utility compatible) -->
    <div class="modal fade" id="noticeModal" tabindex="-1" aria-labelledby="noticeModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="noticeModalLabel">Notice</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body d-flex align-items-start gap-2">
                    <span id="noticeIcon"><i class="fas fa-bell text-warning"></i></span>
                    <span id="noticeMessageContent">Notice</span>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Daily Quote Submission Modal -->
    <div class="modal fade" id="quoteSubmissionModal" tabindex="-1" aria-labelledby="quoteSubmissionModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header" style="background: linear-gradient(135deg, #060E57, #0A1875); color: white;">
                    <h5 class="modal-title" id="quoteSubmissionModalLabel">
                        <i class="fas fa-quote-left me-2"></i>Share a Daily Quote
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p class="text-muted mb-4">
                        <i class="fas fa-info-circle me-1"></i>
                        Inspire students by submitting motivational quotes. Your submissions will be reviewed by admins before being displayed.
                    </p>

                    <form id="quoteSubmissionForm">
                        <div class="row g-3">
                            <div class="col-12">
                                <label for="quoteText" class="form-label fw-bold">
                                    Quote <span class="text-danger">*</span>
                                </label>
                                <textarea
                                    class="form-control"
                                    id="quoteText"
                                    name="quote_text"
                                    rows="4"
                                    maxlength="500"
                                    placeholder="Enter an inspirational quote..."
                                    required></textarea>
                                <div class="form-text d-flex justify-content-between">
                                    <span>Share wisdom that inspires and motivates</span>
                                    <span class="fw-bold"><span id="charCount">0</span>/500</span>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label for="authorName" class="form-label fw-bold">
                                    Author <span class="text-danger">*</span>
                                </label>
                                <input
                                    type="text"
                                    class="form-control"
                                    id="authorName"
                                    name="author_name"
                                    maxlength="255"
                                    placeholder="e.g., Maya Angelou"
                                    required>
                            </div>

                            <div class="col-md-6">
                                <label for="category" class="form-label fw-bold">
                                    Category <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" id="category" name="category" required>
                                    <option value="" disabled selected>Select a category</option>
                                    <option value="Inspirational">✨ Inspirational</option>
                                    <option value="Motivational">💪 Motivational</option>
                                    <option value="Wisdom">🦉 Wisdom</option>
                                    <option value="Life">🌱 Life</option>
                                    <option value="Success">🎯 Success</option>
                                    <option value="Education">📚 Education</option>
                                    <option value="Perseverance">🏔️ Perseverance</option>
                                    <option value="Courage">🦁 Courage</option>
                                    <option value="Hope">🌟 Hope</option>
                                    <option value="Kindness">💝 Kindness</option>
                                </select>
                            </div>

                            <div class="col-12">
                                <label for="source" class="form-label fw-bold">
                                    Source <span class="text-muted">(Optional)</span>
                                </label>
                                <input
                                    type="text"
                                    class="form-control"
                                    id="source"
                                    name="source"
                                    maxlength="255"
                                    placeholder="e.g., Book title, Speech, Movie">
                                <div class="form-text">Where this quote is from (optional)</div>
                            </div>
                        </div>

                        <!-- Alert Container -->
                        <div id="quoteAlertContainer" class="mt-3"></div>
                    </form>
                </div>
                <div class="modal-footer d-flex justify-content-between">
                    <button type="button" class="btn btn-outline-primary" id="viewMyQuotesBtn">
                        <i class="fas fa-history me-2"></i>My Submissions
                    </button>
                    <div>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-2"></i>Cancel
                        </button>
                        <button type="submit" class="btn btn-primary" id="submitQuoteBtn" form="quoteSubmissionForm">
                            <i class="fas fa-paper-plane me-2"></i>Submit Quote
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- My Quotes List Modal -->
    <div class="modal fade" id="myQuotesModal" tabindex="-1" aria-labelledby="myQuotesModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header" style="background: linear-gradient(135deg, #060E57, #0A1875); color: white;">
                    <h5 class="modal-title" id="myQuotesModalLabel">
                        <i class="fas fa-history me-2"></i>My Submitted Quotes
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3 alert alert-info">
                        <i class="fas fa-info-circle me-2"></i>
                        <strong>Status Guide:</strong>
                        <span class="badge bg-warning ms-2">Pending Review</span>
                        <span class="badge bg-success ms-1">Approved</span>
                        <span class="badge bg-danger ms-1">Rejected</span>
                    </div>

                    <div id="myQuotesList" class="d-flex flex-column gap-3">
                        <!-- Quotes will be loaded here -->
                        <div class="text-center py-4">
                            <i class="fas fa-spinner fa-spin fa-2x text-primary"></i>
                            <p class="mt-2 text-muted">Loading your quotes...</p>
                        </div>
                    </div>
                </div>
                <div class="modal-footer d-flex justify-content-between align-items-center">
                    <button type="button" class="btn btn-outline-primary" id="openQuoteSubmissionFromMyQuotes">
                        <i class="fas fa-plus me-2"></i>New Quote
                    </button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-2"></i>Close
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="<?= base_url('js/modals/student_dashboard_modals.js') ?>"></script>
    <script src="<?= base_url('js/counselor/logout.js') ?>"></script>
    <script src="<?= base_url('js/counselor/counselor_dashboard.js') ?>"></script>
    <script src="<?= base_url('js/utils/secureLogger.js') ?>"></script>
    <script>
        window.BASE_URL = "<?= base_url() ?>";
    </script>


</body>

</html>