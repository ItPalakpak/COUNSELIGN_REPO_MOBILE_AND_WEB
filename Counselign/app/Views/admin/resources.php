<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resource Management - Counselign</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="icon" href="<?= base_url('Photos/counselign.ico') ?>" type="image/x-icon">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<?= base_url('css/admin/header.css') ?>">
    <link rel="stylesheet" href="<?= base_url('css/admin/resources.css') ?>">
    <link rel="stylesheet" href="<?= base_url('css/admin/admin_dashboard.css') ?>">

</head>
<body>
    <!-- Header -->
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
                                <li class="nav-item"><a class="nav-link" href="<?= base_url('admin/dashboard') ?>"><i class="fas fa-home"></i> Home</a></li>
                                <li class="nav-item"><a class="nav-link" onclick="confirmLogout()"><i class="fas fa-sign-out-alt"></i> Log Out</a></li>
                            </ul>
                        </div>
                    </nav>
                </div>
            </div>
        </div>
    </header>

    <!-- Mobile Drawer -->
    <div class="admin-navbar-drawer d-lg-none" id="adminNavbarDrawer">
        <div class="drawer-header d-flex justify-content-between align-items-center p-3 text-white" style="background-color: #060E57;">
            <h5 class="m-0">Menu</h5>
            <button class="btn-close btn-close-white" id="adminNavbarDrawerClose" aria-label="Close"></button>
        </div>
        <ul class="navbar-nav nav-links p-3">
            <li class="nav-item"><a class="nav-link" href="<?= base_url('admin/dashboard') ?>"><i class="fas fa-home"></i> Home</a></li>
            <li class="nav-item"><a class="nav-link" onclick="confirmLogout()"><i class="fas fa-sign-out-alt"></i> Log Out</a></li>
        </ul>
    </div>
    <div class="admin-navbar-overlay d-lg-none" id="adminNavbarOverlay"></div>

    <!-- Main Content -->
    <div class="container py-4">
        <!-- Page Header -->
        <div class="page-header">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-2"><i class="fas fa-folder-open me-2"></i>Resource Management</h2>
                    <p class="mb-0 opacity-75">Manage educational resources and helpful links</p>
                </div>
                <button class="btn btn-light" id="addResourceBtn">
                    <i class="fas fa-plus me-2"></i>Add Resource
                </button>
            </div>
        </div>

        <!-- Filters -->
        <div class="filter-section">
            <div class="row g-3">
                <div class="col-md-3">
                    <input type="text" class="form-control" id="searchInput" placeholder="Search resources...">
                </div>
                <div class="col-md-2">
                    <select class="form-select" id="typeFilter">
                        <option value="">All Types</option>
                        <option value="file">Files</option>
                        <option value="link">Links</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <select class="form-select" id="categoryFilter">
                        <option value="">All Categories</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <select class="form-select" id="visibilityFilter">
                        <option value="">All Visibility</option>
                        <option value="all">All Users</option>
                        <option value="students">Students Only</option>
                        <option value="counselors">Counselors Only</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <select class="form-select" id="statusFilter">
                        <option value="">All Status</option>
                        <option value="1">Active</option>
                        <option value="0">Inactive</option>
                    </select>
                </div>
                <div class="col-md-1">
                    <button class="btn btn-secondary w-100" id="clearFiltersBtn" title="Clear Filters">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            </div>
        </div>

        <!-- Resources List -->
        <div id="resourcesList">
            <div class="text-center py-5">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Add/Edit Resource Modal -->
    <div class="modal fade" id="resourceModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="resourceModalLabel">Add Resource</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="resourceForm" enctype="multipart/form-data">
                    <div class="modal-body">
                        <input type="hidden" id="resourceId" name="resource_id">
                        
                        <div class="mb-3">
                            <label class="form-label">Resource Type <span class="text-danger">*</span></label>
                            <div class="btn-group w-100" role="group">
                                <input type="radio" class="btn-check" name="resource_type" id="typeFile" value="file" checked>
                                <label class="btn btn-outline-primary" for="typeFile">
                                    <i class="fas fa-file me-2"></i>File Upload
                                </label>
                                <input type="radio" class="btn-check" name="resource_type" id="typeLink" value="link">
                                <label class="btn btn-outline-primary" for="typeLink">
                                    <i class="fas fa-link me-2"></i>External Link
                                </label>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="title" class="form-label">Title <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="title" name="title" required maxlength="255">
                        </div>

                        <div class="mb-3">
                            <label for="description" class="form-label">Description</label>
                            <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                        </div>

                        <!-- File Upload Section -->
                        <div class="mb-3" id="fileSection">
                            <label for="file" class="form-label">File <span class="text-danger">*</span></label>
                            <input type="file" class="form-control" id="file" name="file">
                            <small class="form-text text-muted">Max size: 50MB. Supported formats: PDF, DOC, DOCX, XLS, XLSX, PPT, PPTX, MP4, JPG, PNG</small>
                            <div id="currentFile" class="mt-2" style="display:none;">
                                <small class="text-muted">Current file: <span id="currentFileName"></span></small>
                            </div>
                        </div>

                        <!-- Link Section -->
                        <div class="mb-3" id="linkSection" style="display:none;">
                            <label for="external_url" class="form-label">URL <span class="text-danger">*</span></label>
                            <input type="url" class="form-control" id="external_url" name="external_url" placeholder="https://example.com">
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="category" class="form-label">Category</label>
                                    <input type="text" class="form-control" id="category" name="category" list="categoryList" placeholder="e.g., Mental Health, Career">
                                    <datalist id="categoryList"></datalist>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="visibility" class="form-label">Visibility</label>
                                    <select class="form-select" id="visibility" name="visibility">
                                        <option value="all">All Users</option>
                                        <option value="students">Students Only</option>
                                        <option value="counselors">Counselors Only</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="tags" class="form-label">Tags</label>
                            <input type="text" class="form-control" id="tags" name="tags" placeholder="Separate tags with commas">
                            <small class="form-text text-muted">e.g., anxiety, stress management, career planning</small>
                        </div>

                        <div class="form-check mb-3">
                            <input class="form-check-input" type="checkbox" id="is_active" name="is_active" checked>
                            <label class="form-check-label" for="is_active">
                                Active (visible to users)
                            </label>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary" id="saveResourceBtn">
                            <i class="fas fa-save me-2"></i>Save Resource
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Preview Modal -->
    <div class="modal fade" id="previewModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="previewModalTitle">Resource Preview</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="previewModalBody" style="min-height: 400px;">
                    <!-- Preview content will be loaded here -->
                </div>
            </div>
        </div>
    </div>

    <!-- ====== ADDED: Alert Modal ====== -->
    <div class="modal fade" id="alertModal" tabindex="-1" aria-labelledby="alertModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title d-flex align-items-center" id="alertModalLabel">
                        <span id="alertIcon" class="me-2">
                            <i class="fas fa-info-circle text-primary"></i>
                        </span>
                        <span>Information</span>
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body pt-2">
                    <p id="alertMessageContent" class="mb-0"></p>
                </div>
                <div class="modal-footer border-0 pt-0">
                    <button type="button" class="btn btn-primary" data-bs-dismiss="modal">OK</button>
                </div>
            </div>
        </div>
    </div>

    <!-- ====== ADDED: Confirmation Modal ====== -->
    <div class="modal fade" id="confirmationModal" tabindex="-1" aria-labelledby="confirmationModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title" id="confirmationModalLabel">
                        <i class="fas fa-question-circle text-warning me-2"></i>
                        Confirm Action
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body pt-2">
                    <p id="confirmationMessageContent" class="mb-0"></p>
                </div>
                <div class="modal-footer border-0 pt-0">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="confirmationConfirmBtn">Confirm</button>
                </div>
            </div>
        </div>
    </div>

    <!-- ====== ADDED: Notice Modal (optional but good to have) ====== -->
    <div class="modal fade" id="noticeModal" tabindex="-1" aria-labelledby="noticeModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title d-flex align-items-center" id="noticeModalLabel">
                        <span id="noticeIcon" class="me-2">
                            <i class="fas fa-bell text-warning"></i>
                        </span>
                        <span>Notice</span>
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body pt-2">
                    <p id="noticeMessageContent" class="mb-0"></p>
                </div>
                <div class="modal-footer border-0 pt-0">
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>window.BASE_URL = "<?= base_url() ?>";</script>
    <script src="<?= base_url('js/admin/admin_drawer.js') ?>"></script>
    <script src="<?= base_url('js/modals/student_dashboard_modals.js') ?>"></script>
    <script src="<?= base_url('js/admin/resources_management.js') ?>"></script>
    <script src="<?= base_url('js/admin/logout.js') ?>" defer></script>
    <script src="<?= base_url('js/utils/secureLogger.js') ?>"></script>
</body>
</html>