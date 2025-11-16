<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    <meta name="description" content="Counselign">
    <title>Counselign</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="icon" href="<?= base_url('Photos/counselign.ico') ?>" type="image/x-icon">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<?= base_url('css/admin/header.css') ?>">
    <link rel="stylesheet" href="<?= base_url('css/admin/admin_dashboard.css') ?>">
    <link rel="stylesheet" href="<?= base_url('css/admin/view_all_appointments.css') ?>">

</head>

<body>
    <header class="admin-header text-white p-1" style="background-color: #060E57;">
        <div class="container-fluid px-4">
            <div class="row align-items-center">
                <div class="d-flex align-items-center">
                    <img src="<?= base_url('Photos/counselign_logo.png') ?>" alt="UGC Logo" class="logo" />
                    <h1 class="h4 fw-bold ms-2 mb-0">Counselign</h1>

                    <button class="admin-navbar-toggler d-lg-none align-items-center" type="button" id="adminNavbarDrawerToggler">
                        <span class="navbar-toggler-icon"><i class="fas fa-bars"></i></span>
                    </button>

                    <nav class="navbar navbar-expand-lg navbar-dark">
                        <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
                            <ul class="navbar-nav nav-links">
                                <li class="nav-item"><a class="nav-link" onclick="confirmLogout()"><i class="fas fa-sign-out-alt"></i> Log Out</a></li>
                            </ul>
                        </div>
                    </nav>
                </div>
            </div>
        </div>
    </header>

    <!-- Admin Navbar Drawer for Small Screens -->
    <div class="admin-navbar-drawer d-lg-none" id="adminNavbarDrawer">
        <div class="drawer-header d-flex justify-content-between align-items-center p-3 text-white" style="background-color: #060E57;">
            <h5 class="m-0">Admin Menu</h5>
            <button class="btn-close btn-close-white" id="adminNavbarDrawerClose" aria-label="Close"></button>
        </div>
        <ul class="navbar-nav nav-links p-3">
            <li class="nav-item"><a class="nav-link" onclick="confirmLogout()"><i class="fas fa-sign-out-alt"></i> Log Out</a></li>
        </ul>
    </div>

    <!-- Overlay for Admin Navbar Drawer -->
    <div class="admin-navbar-overlay d-lg-none" id="adminNavbarOverlay"></div>

    <div class="container pt-3 mb-3">
        <div class="profile-display flex justify-between items-center">
            <div class="col-12">
                <div class="flex-container">
                    <!-- Profile Row (Line 1) -->
                    <div class="profile-row">
                        <a class="profile-avatar" href="<?= base_url('admin/account-settings') ?>" onclick="redirectToProfilePage()"
                            onKeyPress="if(event.key === 'Enter') redirectToProfilePage()">
                            <img id="profile-img" src="<?= base_url('Photos/UGC-Logo.png') ?>"
                                alt="User Avatar" class="profile-img admin-avatar" />
                            <div class="overlay">
                                <p>Profile</p>
                            </div>
                        </a>
                        <div class="profile-details-wrapper">
                            <div class="fs-12 fw-bold" style="color: #003366;">Hello! <span
                                    class="text-primary"><i id="adminName">Admin</i></span></div>
                            <div id="lastLogin" class="small text-secondary">Login at: Loading...</div>
                        </div>
                    </div>

                    <!-- Action Buttons Row (Line 2) - Mobile/Tablet Only -->
                    <div class="actions-row d-lg-none">
                        <a href="<?= base_url('admin/admins-management') ?>" class="btn btn-primary action-btn" title="Management">
                            <i class="fas fa-users-cog me-1"></i><span class="btn-text">Management</span>
                        </a>
                        <a href="<?= base_url('admin/appointments') ?>" class="btn btn-success action-btn" title="Manage Appointments">
                            <i class="fas fa-calendar-check me-1"></i><span class="btn-text">Recent Appointments</span>
                        </a>
                        <a href="<?= base_url('admin/follow-up-sessions') ?>" class="btn btn-warning action-btn" title="Follow-up Sessions">
                            <i class="fas fa-calendar-days me-1"></i><span class="btn-text">Follow-up Sessions</span>
                        </a>

                        <a href="<?= base_url('admin/resources') ?>" class="btn btn-secondary action-btn" title="Manage Resources">
                            <i class="fas fa-folder-open me-1"></i><span class="btn-text">Resources</span>
                        </a>

                        <a href="<?= base_url('admin/announcements') ?>" class="btn btn-info action-btn" title="Manage Announcements">
                            <i class="fa-solid fa-bullhorn me-1"></i><span class="btn-text">Announcements</span>
                        </a>

                        <button type="button" class="btn btn-primary action-btn" id="openQuotesModalBtnMobile" title="Manage Quotes">
                            <i class="fas fa-quote-right me-1"></i><span class="btn-text">Quotes</span>
                        </button>

                        

                    </div>

                    <!-- Desktop Action Buttons (Original Layout) -->
                    <div class="d-none d-lg-flex ms-auto">
                        <a href="<?= base_url('admin/admins-management') ?>" class="btn btn-primary ms-auto" title="Management">
                            <i class="fas fa-users-cog me-1"></i>Management
                        </a>
                        <a href="<?= base_url('admin/appointments') ?>" class="btn btn-success ms-3" title="Manage Appointments">
                            <i class="fas fa-list-alt me-1"></i>All Appointments
                        </a>
                        <a href="<?= base_url('admin/follow-up-sessions') ?>" class="btn btn-warning ms-3" title="Follow-up Sessions">
                            <i class="fas fa-calendar-check me-1"></i>Follow-up Sessions
                        </a>

                        <a href="<?= base_url('admin/resources') ?>" class="btn btn-secondary ms-3" title="Manage Resources">
                            <i class="fas fa-folder-open me-1"></i>Resources
                        </a>
                        
                        <a href="<?= base_url('admin/announcements') ?>" class="ms-3" title="Manage Announcements">
                            <i class="fa-solid fa-bullhorn announcement-dashboard-icon"></i>
                        </a>
                        <button type="button" class="btn btn-primary ms-3" id="openQuotesModalBtn" title="Manage Quotes">
                            <i class="fas fa-quote-right me-1"></i>
                        </button>
                       
                    </div>
                </div>
            </div>
        </div>

        <!-- Migrated main content from admin/view_all_appointments (excluding header/footer) -->
        <div class="main-content">
            <div class="container report-container">
                <div class="page-header">
                    <h2><i class="fas fa-chart-line"></i> Appointment Reports</h2>
                    <p class="text-muted">View and analyze appointment statistics</p>
                </div>

                <!-- Filter Section -->
                <div class="filter-section">
                    <div class="row g-3 align-items-center">
                        <div class="col-md-8">
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-calendar"></i></span>
                                <select class="form-select" id="timeRange">
                                    <option value="daily">Daily Report</option>
                                    <option value="weekly" selected>Weekly Report</option>
                                    <option value="monthly">Monthly Report</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <a href="<?= base_url('admin/history-reports') ?>" class="btn btn-secondary w-100">
                                <i class="fas fa-history"></i><span class="btn-text"> View Past Reports</span>
                            </a>
                        </div>
                    </div>
                </div>

                <!-- History Modal -->
                <div class="modal fade" id="historyModal" tabindex="-1" aria-labelledby="historyModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="historyModalLabel">Report History</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Date Generated</th>
                                                <th>Report Type</th>
                                                <th>Total Appointments</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody id="historyTableBody"></tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Statistics Summary -->
                <div class="row stats-summary">
                    <div class="col-md-2">
                        <div class="stat-card completed">
                            <div class="stat-icon"><i class="fas fa-check-circle"></i></div>
                            <div class="stat-details">
                                <h3 id="completedCount">0</h3>
                                <p>Completed</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="stat-card approved">
                            <div class="stat-icon"><i class="fas fa-thumbs-up"></i></div>
                            <div class="stat-details">
                                <h3 id="approvedCount">0</h3>
                                <p>Approved</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="stat-card rejected">
                            <div class="stat-icon"><i class="fas fa-times-circle"></i></div>
                            <div class="stat-details">
                                <h3 id="rejectedCount">0</h3>
                                <p>Rejected</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="stat-card pending">
                            <div class="stat-icon"><i class="fas fa-clock"></i></div>
                            <div class="stat-details">
                                <h3 id="pendingCount">0</h3>
                                <p>Pending</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="stat-card cancelled">
                            <div class="stat-icon"><i class="fas fa-ban"></i></div>
                            <div class="stat-details">
                                <h3 id="cancelledCount">0</h3>
                                <p>Cancelled</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Charts -->
                <div class="row charts-section">
                    <div class="col-md-8">
                        <div class="chart-container trend-chart shadow rounded p-4 bg-white">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h4 class="m-0">
                                    <i class="fas fa-chart-line text-primary"></i>
                                    <span class="ms-2 fw-bold">Appointment Trends</span>
                                </h4>
                            </div>
                            <div class="chart-wrapper" style="height: 400px;">
                                <canvas id="appointmentTrendChart"></canvas>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="chart-container pie-chart">
                            <h4><i class="fas fa-chart-pie"></i> Status Distribution</h4>
                            <canvas id="statusPieChart"></canvas>
                        </div>
                    </div>
                </div>

                <div class="container mt-1">
                    <div class="appointment-container">
                        <div class="row mb-2">
                            <div class="col-12">
                                <h2 class="text-center fw-bold" style="color: #0d6efd;">All Appointment Lists</h2>
                            </div>
                        </div>

                        <!-- Navigation Tabs -->
                        <ul class="nav nav-tabs mb-4" id="appointmentTabs" role="tablist">
                            <li class="nav-item col-md-2" role="presentation">
                                <button class="nav-link active" id="all-tab" data-bs-toggle="tab" data-bs-target="#all"
                                    type="button">
                                    <i class="fas fa-list"></i><span class="tab-text"> All Appointments</span>
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="followup-tab" data-bs-toggle="tab" data-bs-target="#followup"
                                    type="button">
                                    <i class="fas fa-calendar-plus"></i><span class="tab-text"> Follow-up</span>
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="approved-tab" data-bs-toggle="tab" data-bs-target="#approved"
                                    type="button">
                                    <i class="fas fa-thumbs-up"></i><span class="tab-text"> Approved</span>
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="rejected-tab" data-bs-toggle="tab" data-bs-target="#rejected"
                                    type="button">
                                    <i class="fas fa-times-circle"></i><span class="tab-text"> Rejected</span>
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="completed-tab" data-bs-toggle="tab" data-bs-target="#completed"
                                    type="button">
                                    <i class="fas fa-check-circle"></i><span class="tab-text"> Completed</span>
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="cancelled-tab" data-bs-toggle="tab" data-bs-target="#cancelled"
                                    type="button">
                                    <i class="fas fa-ban"></i><span class="tab-text"> Cancelled</span>
                                </button>
                            </li>
                        </ul>

                        <!-- Filter Options -->
                        <div class="row mb-4 appointment-filters">
                            <!-- Filter Line 1: Search and Date (Mobile/Tablet) -->
                            <div class="filter-line-1 d-lg-none">
                                <div class="col-mobile">
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-search"></i></span>
                                        <input type="text" class="form-control" id="searchInputMobile" placeholder="Search appointments...">
                                    </div>
                                </div>
                                <div class="col-mobile">
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-calendar"></i></span>
                                        <input type="month" class="form-control" id="dateFilterMobile">
                                    </div>
                                </div>
                            </div>

                            <!-- Filter Line 2: Export buttons (Mobile/Tablet) -->
                            <div class="filter-line-2 d-lg-none">
                                <div class="col-mobile">
                                    <div class="btn-group w-100">
                                        <button class="btn btn-primary" id="exportPDFMobile">
                                            <i class="fas fa-file-pdf me-2"></i>Export PDF
                                        </button>
                                        <button class="btn btn-success" id="exportExcelMobile">
                                            <i class="fas fa-file-excel me-2"></i>Export Excel
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <!-- Desktop Layout (Original) -->
                            <div class="col-md-4 d-none d-lg-block">
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-search"></i></span>
                                    <input type="text" class="form-control" id="searchInput" placeholder="Search appointments...">
                                </div>
                            </div>
                            <div class="col-md-4 d-none d-lg-block">
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-calendar"></i></span>
                                    <input type="month" class="form-control" id="dateFilter">
                                </div>
                            </div>
                            <div class="col-md-4 d-none d-lg-block">
                                <div class="btn-group w-100">
                                    <button class="btn btn-primary" id="exportPDF">
                                        <i class="fas fa-file-pdf me-2"></i>Export PDF
                                    </button>
                                    <button class="btn btn-success" id="exportExcel">
                                        <i class="fas fa-file-excel me-2"></i>Export Excel
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Enhanced Export Filters Modal -->
                        <div class="modal fade" id="exportFiltersModal" tabindex="-1" aria-labelledby="exportFiltersModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-lg modal-dialog-scrollable">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="exportFiltersModalLabel"><i class="fas fa-filter me-2"></i>Export Filters</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <!-- Date Range Filters -->
                                        <div class="row g-3 mb-4">
                                            <div class="col-md-3">
                                                <label for="exportStartDate" class="form-label">Start Date</label>
                                                <input type="date" class="form-control" id="exportStartDate">
                                            </div>
                                            <div class="col-md-3">
                                                <label for="exportEndDate" class="form-label">End Date</label>
                                                <input type="date" class="form-control" id="exportEndDate">
                                            </div>
                                            <div class="col-md-6 d-flex align-items-end">
                                                <small class="text-muted">
                                                    <i class="fas fa-info-circle me-1"></i>
                                                    Leave dates empty to export all appointments from the selected status tab.
                                                </small>
                                            </div>
                                        </div>

                                        <!-- Additional Filters -->
                                        <div class="row g-3 mb-2">
                                            <div class="col-md-6">
                                                <label for="exportCounselorFilter" class="form-label">Counselor</label>
                                                <select class="form-select" id="exportCounselorFilter">
                                                    <option value="">All Counselors</option>
                                                </select>
                                            </div>
                                            <div class="col-md-6">
                                                <label for="exportStudentFilter" class="form-label">Student</label>
                                                <select class="form-select" id="exportStudentFilter">
                                                    <option value="">All Students</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="row g-3">
                                            <div class="col-md-6">
                                                <label for="exportCourseFilter" class="form-label">Course</label>
                                                <select class="form-select" id="exportCourseFilter">
                                                    <option value="">All Courses</option>
                                                    <option value="BSIT">BSIT</option>
                                                    <option value="BSABE">BSABE</option>
                                                    <option value="BSEnE">BSEnE</option>
                                                    <option value="BSHM">BSHM</option>
                                                    <option value="BFPT">BFPT</option>
                                                    <option value="BSA">BSA</option>
                                                    <option value="BTHM">BTHM</option>
                                                    <option value="BSSW">BSSW</option>
                                                    <option value="BSAF">BSAF</option>
                                                    <option value="BTLED">BTLED</option>
                                                    <option value="DAT-BAT">DAT-BAT</option>
                                                </select>
                                            </div>
                                            <div class="col-md-6">
                                                <label for="exportYearLevelFilter" class="form-label">Year Level</label>
                                                <select class="form-select" id="exportYearLevelFilter">
                                                    <option value="">All Year Levels</option>
                                                    <option value="I">I</option>
                                                    <option value="II">II</option>
                                                    <option value="III">III</option>
                                                    <option value="IV">IV</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button class="btn btn-outline-secondary" id="clearAllFilters">
                                            <i class="fas fa-times me-1"></i>Clear All
                                        </button>
                                        <button class="btn btn-outline-primary" id="clearDateRange">
                                            <i class="fas fa-calendar-times me-1"></i>Clear Dates
                                        </button>
                                        <button class="btn btn-primary" id="applyFilters">
                                            <i class="fas fa-check me-1"></i>Apply Filters & Export
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Tab Content with Scrollable Container -->
                        <div class="tab-content" id="appointmentTabContent">
                            <!-- Loading Spinner -->
                            <div class="loading-spinner" style="display: none;">
                                <div class="d-flex justify-content-center align-items-center">
                                    <div class="spinner-border text-primary" role="status">
                                        <span class="visually-hidden">Loading...</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Empty State Message -->
                            <div class="empty-state alert alert-info text-center" style="display: none;">
                                <i class="fas fa-info-circle me-2"></i>
                                No appointments found.
                            </div>

                            <!-- All Appointments Tab -->
                            <div class="tab-pane fade show active" id="all" role="tabpanel">
                                <div class="table-responsive" style="max-height: 500px; overflow-y: auto; overflow-x: auto;">
                                    <table class="table table-hover mb-0" style="min-width: 1250px;">
                                        <thead class="table-light sticky-top">
                                            <tr>
                                                <th>User ID</th>
                                                <th>Full Name</th>
                                                <th>Date</th>
                                                <th>Time</th>
                                                <th>Method Type</th>
                                                <th>Consultation Type</th>
                                                <th>Session Type</th>
                                                <th>Purpose</th>
                                                <th>Counselor</th>
                                                <th>Status</th>
                                                <th style="width: 60%;">Reason for Status</th>
                                            </tr>
                                        </thead>
                                        <tbody id="allAppointmentsTable">
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <!-- Approved Appointments Tab -->
                            <div class="tab-pane fade" id="approved" role="tabpanel">
                                <div class="table-responsive" style="max-height: 500px; overflow-y: auto; overflow-x: auto;">
                                    <table class="table table-hover mb-0" style="min-width: 1250px;">
                                        <thead class="table-light sticky-top">
                                            <tr>
                                                <th>User ID</th>
                                                <th>Full Name</th>
                                                <th>Date</th>
                                                <th>Time</th>
                                                <th>Method Type</th>
                                                <th>Consultation Type</th>
                                                <th>Session Type</th>
                                                <th>Purpose</th>
                                                <th>Counselor</th>
                                                <th>Status</th>
                                            </tr>
                                        </thead>
                                        <tbody id="approvedAppointmentsTable">
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <!-- Rejected Appointments Tab -->
                            <div class="tab-pane fade" id="rejected" role="tabpanel">
                                <div class="table-responsive" style="max-height: 500px; overflow-y: auto; overflow-x: auto;">
                                    <table class="table table-hover mb-0" style="min-width: 1250px;">
                                        <thead class="table-light sticky-top">
                                            <tr>
                                                <th>User ID</th>
                                                <th>Full Name</th>
                                                <th>Date</th>
                                                <th>Time</th>
                                                <th>Method Type</th>
                                                <th>Consultation Type</th>
                                                <th>Session Type</th>
                                                <th>Purpose</th>
                                                <th>Counselor</th>
                                                <th>Status</th>
                                                <th style="width: 60%;">Reason for Status</th>
                                            </tr>
                                        </thead>
                                        <tbody id="rejectedAppointmentsTable">
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <!-- Completed Appointments Tab -->
                            <div class="tab-pane fade" id="completed" role="tabpanel">
                                <div class="table-responsive" style="max-height: 500px; overflow-y: auto; overflow-x: auto;">
                                    <table class="table table-hover mb-0" style="min-width: 1250px;">
                                        <thead class="table-light sticky-top">
                                            <tr>
                                                <th>User ID</th>
                                                <th>Full Name</th>
                                                <th>Date</th>
                                                <th>Time</th>
                                                <th>Method Type</th>
                                                <th>Consultation Type</th>
                                                <th>Session Type</th>
                                                <th>Purpose</th>
                                                <th>Counselor</th>
                                                <th>Status</th>
                                            </tr>
                                        </thead>
                                        <tbody id="completedAppointmentsTable">
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <!-- Cancelled Appointments Tab -->
                            <div class="tab-pane fade" id="cancelled" role="tabpanel">
                                <div class="table-responsive" style="max-height: 500px; overflow-y: auto; overflow-x: auto;">
                                    <table class="table table-hover mb-0" style="min-width: 1250px;">
                                        <thead class="table-light sticky-top">
                                            <tr>
                                                <th>User ID</th>
                                                <th>Full Name</th>
                                                <th>Date</th>
                                                <th>Time</th>
                                                <th>Method Type</th>
                                                <th>Consultation Type</th>
                                                <th>Session Type</th>
                                                <th>Purpose</th>
                                                <th>Counselor</th>
                                                <th>Status</th>
                                                <th style="width: 60%;">Reason for Status</th>
                                            </tr>
                                        </thead>
                                        <tbody id="cancelledAppointmentsTable">
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <!-- Follow-up Appointments Tab -->
                            <div class="tab-pane fade" id="followup" role="tabpanel">
                                <div class="table-responsive" style="max-height: 500px; overflow-y: auto; overflow-x: auto;">
                                    <table class="table table-hover mb-0" style="min-width: 1250px;">
                                        <thead class="table-light sticky-top">
                                            <tr>
                                                <th>User ID</th>
                                                <th>Full Name</th>
                                                <th>Date</th>
                                                <th>Time</th>
                                                <th>Method Type</th>
                                                <th>Consultation Type</th>
                                                <th>Session Type</th>
                                                <th>Purpose</th>
                                                <th>Counselor</th>
                                                <th>Status</th>
                                            </tr>
                                        </thead>
                                        <tbody id="followUpAppointmentsTable">
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


        </div>


    </div>

    <!-- Quotes Management Modal -->
    <div class="modal fade" id="quotesManagementModal" tabindex="-1" aria-labelledby="quotesManagementModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-xl modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header" style="background: linear-gradient(135deg, #060E57, #0A1875); color: white;">
                    <h5 class="modal-title" id="quotesManagementModalLabel">
                        <i class="fas fa-quote-left me-2"></i>Manage Quotes
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <!-- Navigation Tabs -->
                    <ul class="nav nav-tabs mb-4" id="quoteTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="pending-tab" data-bs-toggle="tab" data-bs-target="#pending-quotes" type="button" role="tab">
                                <i class="fas fa-clock me-1"></i>Pending
                                <span class="badge bg-warning ms-2" id="pending-count">0</span>
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="approved-tab" data-bs-toggle="tab" data-bs-target="#approved-quotes" type="button" role="tab">
                                <i class="fas fa-check-circle me-1"></i>Approved
                                <span class="badge bg-success ms-2" id="approved-count">0</span>
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="rejected-tab" data-bs-toggle="tab" data-bs-target="#rejected-quotes" type="button" role="tab">
                                <i class="fas fa-times-circle me-1"></i>Rejected
                                <span class="badge bg-danger ms-2" id="rejected-count">0</span>
                            </button>
                        </li>
                    </ul>

                    <!-- Tab Content -->
                    <div class="tab-content" id="quoteTabContent">
                        <!-- Pending Quotes Tab -->
                        <div class="tab-pane fade show active" id="pending-quotes" role="tabpanel">
                            <div id="pendingQuotesList" class="d-flex flex-column gap-3">
                                <div class="text-center py-4">
                                    <i class="fas fa-spinner fa-spin fa-2x text-primary"></i>
                                    <p class="mt-2 text-muted">Loading quotes...</p>
                                </div>
                            </div>
                        </div>

                        <!-- Approved Quotes Tab -->
                        <div class="tab-pane fade" id="approved-quotes" role="tabpanel">
                            <div id="approvedQuotesList" class="d-flex flex-column gap-3">
                                <div class="text-center py-4">
                                    <i class="fas fa-spinner fa-spin fa-2x text-primary"></i>
                                    <p class="mt-2 text-muted">Loading quotes...</p>
                                </div>
                            </div>
                        </div>

                        <!-- Rejected Quotes Tab -->
                        <div class="tab-pane fade" id="rejected-quotes" role="tabpanel">
                            <div id="rejectedQuotesList" class="d-flex flex-column gap-3">
                                <div class="text-center py-4">
                                    <i class="fas fa-spinner fa-spin fa-2x text-primary"></i>
                                    <p class="mt-2 text-muted">Loading quotes...</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-2"></i>Close
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Rejection Reason Modal -->
    <div class="modal fade" id="rejectionReasonModal" tabindex="-1" aria-labelledby="rejectionReasonModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="rejectionReasonModalLabel">
                        <i class="fas fa-times-circle me-2 text-danger"></i>Reject Quote
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p class="text-muted mb-3">Please provide a reason for rejecting this quote:</p>
                    <form id="rejectionReasonForm">
                        <div class="mb-3">
                            <label for="rejectionReason" class="form-label">Rejection Reason <span class="text-danger">*</span></label>
                            <textarea
                                class="form-control"
                                id="rejectionReason"
                                name="rejection_reason"
                                rows="4"
                                maxlength="500"
                                placeholder="Enter the reason for rejection..."
                                required></textarea>
                            <div class="form-text">This reason will be visible to the counselor who submitted the quote.</div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" id="confirmRejectionBtn">
                        <i class="fas fa-times-circle me-2"></i>Reject Quote
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Shared Confirmation Modal (used for quote approvals and other confirms) -->
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

    <footer>
        <div class="footer-content">
            <div class="copyright">
                <b>© 2025 Counselign Team. All rights reserved.</b>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.28/jspdf.plugin.autotable.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        window.BASE_URL = "<?= base_url() ?>";
    </script>
    <script src="<?= base_url('js/admin/admin_drawer.js') ?>"></script>
    <script src="<?= base_url('js/admin/admin_dashboard.js') ?>"></script>
    <script src="<?= base_url('js/admin/profile_sync.js') ?>"></script>
    <script src="<?= base_url('js/admin/view_all_appointments.js') ?>"></script>
    <script src="<?= base_url('js/modals/student_dashboard_modals.js') ?>"></script>
    <script src="<?= base_url('js/admin/quotes_management.js') ?>"></script>
    <script src="<?= base_url('js/admin/logout.js') ?>" defer></script>
    <script src="<?= base_url('js/utils/secureLogger.js') ?>"></script>
</body>

</html>