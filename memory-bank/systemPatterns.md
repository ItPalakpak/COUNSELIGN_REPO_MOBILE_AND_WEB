# System Patterns

## Architecture
- Flutter client app with route-based navigation (`lib/routes.dart`), MaterialApp in `lib/main.dart`.
- Integrates with a PHP CodeIgniter backend (separate MVC project) via HTTP.

## Navigation
- Named routes via `AppRoutes` with `initialRoute` set to `landing` (`'/'`).
- Helper methods for transitions (`navigateToServices`, `navigateToDashboard`, `safePop`, `showSnackBar`).
- Counselor appointments management routes:
  - `AppRoutes.counselorAppointments` → `CounselorAppointmentsScreen`
  - `AppRoutes.counselorAppointmentsViewAll` → `CounselorAppointmentsScreen`

## State Management
- `provider` listed; screens and state files exist per feature directories.
- `shared_preferences` for lightweight persistence.

## Networking
- `http` package used.
- `ApiConfig.currentBaseUrl` selects environment (web/Android/iOS/desktop) with default headers and timeouts.
- Student API endpoints:
  - GET `student/get-counselor-schedules` → Returns counselor availability data organized by weekday (Monday-Friday only)

## Theming
- Seeded `ColorScheme` and global font family (`Roboto`).

## Modules (by directory)
- `lib/landingscreen` → entry/marketing+dialogs with modern drawer navigation.
  - Modern drawer: `frontend/drawer.dart` with gradient background, animated navigation items, responsive design.
- `lib/studentscreen` → student dashboards, appointments, profile, announcements.
  - Dashboard: `student_dashboard.dart` with PDS reminder modal (`pds_reminder_modal.dart`) that shows 20-second auto-close timer with dismiss/update buttons on initial login.
  - Schedule Appointment: `schedule_appointment_screen.dart` with consent accordion (`consent_accordion.dart`) and acknowledgment section (`acknowledgment_section.dart`) for legal consent requirements.
  - Appointments: `my_appointments_screen.dart` with card-based UI using `AppointmentCard` widget.
  - Models: `counselor_schedule.dart` for counselor schedule data with weekday organization.
- `lib/adminscreen` → admin dashboard and widgets.
- `lib/counselorscreen` → counselor dashboard with messages/appointments cards, announcements, appointments, follow-up sessions, profile, messages screen with conversation list and chat interface, reports screen with comprehensive appointment analytics.
  - Profile management: `counselor_profile_screen.dart`, `state/counselor_profile_viewmodel.dart`, `models/counselor_profile.dart`, `models/counselor_availability.dart` with comprehensive profile management including account settings, personal information updates, password changes, profile picture uploads, and availability management with time range functionality.
  - Appointments management: `counselor_appointments_screen.dart`, `state/counselor_appointments_viewmodel.dart`, `models/appointment.dart`.
  - Scheduled appointments: `counselor_scheduled_appointments_screen.dart`, `state/counselor_scheduled_appointments_viewmodel.dart`, `models/scheduled_appointment.dart`, `models/counselor_schedule.dart`.
  - Follow-up sessions: `counselor_follow_up_sessions_screen.dart`, `state/counselor_follow_up_sessions_viewmodel.dart`, `models/completed_appointment.dart`, `models/follow_up_session.dart`, `models/counselor_availability.dart` with enhanced features: follow-up count badges, pending warning indicators, separate pending section, proper sorting.
  - Reports system: `counselor_reports_screen.dart`, `state/counselor_reports_viewmodel.dart`, `models/appointment_report.dart` with comprehensive appointment analytics including statistics dashboard, data visualization (line charts for trends, pie charts for status distribution), tab-based filtering, search and date filtering, PDF export with advanced filtering, responsive appointment cards for mobile display.
  - Widgets: `appointments_table.dart`, `weekly_schedule.dart`, `mini_calendar.dart`, `cancellation_reason_dialog.dart`, `appointment_report_card.dart`, `export_filters_dialog.dart`.
- `lib/servicesscreen` → services display and navigation.
- `lib/utils/session.dart` → session utilities.

## Platform Targets
- Android, iOS, Web, Desktop (Windows/macOS/Linux configured by Flutter scaffolding).

## Coding Patterns/Rules from Recent Fixes
- Keyboard input: prefer `KeyboardListener` with `onKeyEvent` returning `KeyEventResult`; use `KeyDownEvent` checks.
- Token inputs: use `TextField` with centered text, explicit `TextStyle(color: Colors.black)`, `contentPadding` minimized, and fixed cell height for clarity.
- Colors: use `Color.withValues(alpha: ...)` instead of `withOpacity`.
- QR codes (qr_flutter): avoid deprecated `color`/`foregroundColor`/`emptyColor`. Use `eyeStyle` and `dataModuleStyle` for module/eye colors and keep `gapless: false` with padding for quiet zone.
- Async context safety: after awaits or delays, always gate UI interactions with `if (context.mounted)` before calling navigation/snackbar/dialog APIs.
- Logging: use `debugPrint`; avoid `print` in production.
 - Layout overflow prevention: wrap tall page bodies in `SingleChildScrollView` or use `CustomScrollView` where dynamic lists/sections can exceed viewport, e.g., student `AnnouncementsScreen` main content.
 - Layout in scroll views: Do not place `Expanded`/`Flexible` inside `Column` when the column is inside a `SingleChildScrollView`. Instead, make inner lists non-scrollable (`shrinkWrap: true`, `NeverScrollableScrollPhysics`) and let the outer scroll view scroll.