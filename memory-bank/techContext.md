# Tech Context

## Stack
- Flutter (Dart SDK ^3.9.2)
- Packages: animations, lottie, simple_animations, http, shared_preferences, provider, logger, cupertino_icons, fl_chart, open_file, font_awesome_flutter, intl
- Dev: flutter_test, flutter_lints

## Build/Run
- Targets: Android, iOS, Web, Desktop
- Assets: `Photos/`, `Photos/MISC/` declared in `pubspec.yaml`
- Entry: `lib/main.dart`, routes in `lib/routes.dart`

## API Configuration
- `lib/api/config.dart` exposes environment URLs:
  - Web/Desktop: `localhostUrl`
  - Android: `emulatorUrl` (change to `deviceUrl` for physical device)
  - iOS: `deviceUrl`
  - Production: `productionUrl`
- `defaultHeaders`, `connectTimeout`, `receiveTimeout` defined.

## Data Persistence
- `shared_preferences` for simple key/value storage and PDS reminder session tracking
- `utils/session.dart` manages session-related logic (see file for details)

## Student Schedule Appointment Consent System
- **Consent Accordion**: `ConsentAccordion` (`lib/studentscreen/widgets/consent_accordion.dart`)
- **Acknowledgment Section**: `AcknowledgmentSection` (`lib/studentscreen/widgets/acknowledgment_section.dart`)
- **State Management**: `ScheduleAppointmentViewModel` with consent validation logic
- **Features**:
  - Expandable accordion with counseling informed consent form content
  - Required checkboxes for consent acceptance with validation
  - Legal terms and conditions display with proper formatting
  - Dimensions of confidentiality section with exemptions
  - Form validation integration preventing submission without consent
  - Responsive design with mobile and desktop layouts
  - Error handling and validation messages
  - Consent data submission to backend API
  - Form reset functionality including consent checkboxes
  - **Enhanced Visual Design**: Animated dropdown arrow, dynamic gradient colors, hint text, responsive borders and shadows
- **Integration**: Integrated into `ScheduleAppointmentScreen` with proper form validation
- **Styling**: Matches backend MVC design with gradient headers and proper spacing

## Student Dashboard PDS Reminder
- **Widget**: `PdsReminderModal` (`lib/studentscreen/widgets/pds_reminder_modal.dart`)
- **State Management**: `StudentDashboardViewModel` with session-based display logic
- **Features**: 
  - 20-second auto-close timer with visual countdown and progress bar
  - Dismiss button to close modal and mark as shown in session
  - Update Now button that navigates to profile page
  - Session-based display logic using SharedPreferences to show only on initial login
  - Responsive design with gradient header styling matching backend MVC (#060E57, #0A1875)
  - Smooth animations with scale and opacity transitions
  - Proper cleanup of timers and animation controllers
- **Integration**: Integrated into `StudentDashboard` screen with proper state management
- **Session Tracking**: Uses SharedPreferences key 'pdsReminderShown' to track if reminder has been displayed

## Counselor Profile Management
- Models: `CounselorProfile`, `CounselorDetails`, `CounselorAvailabilitySlot`, `TimeRange`, `AvailabilityData`
- ViewModel: `CounselorProfileViewModel`
- Screen: `CounselorProfileScreen`
- API Endpoints:
  - `GET /counselor/profile/get` — get counselor profile and personal information
  - `POST /counselor/profile/update` — update username and email (form-encoded)
  - `POST /counselor/profile/counselor-info` — update personal information (form-encoded)
  - `POST /update-password` — change password with current/new/confirm validation (form-encoded)
  - `POST /counselor/profile/picture` — upload profile picture (multipart form)
  - `GET /counselor/profile/availability` — get counselor availability schedule
  - `POST /counselor/profile/availability` — update availability with time ranges (JSON)
- Features: Profile picture upload with image picker, password change with validation, personal information updates with dropdowns, availability management with time range merging and overlap detection, responsive design for mobile/tablet/desktop, comprehensive error handling and loading states
- Dependencies: `image_picker: ^1.0.7` for profile picture upload functionality

## Counselor Messaging System
- **Models**: `Conversation` and `CounselorMessage` in `lib/counselorscreen/models/`
- **API Endpoints**:
  - `/counselor/message/operations?action=get_conversations` - Load conversation list
  - `/counselor/message/operations?action=get_messages&user_id={id}` - Load messages for specific user
  - `/counselor/message/operations?action=send_message` - Send message (POST with receiver_id and message)
  - `/counselor/message/operations?action=mark_read&user_id={id}` - Mark messages as read (POST)
- **Features**: Real-time conversation list, message history, send/receive messages, unread count tracking, search functionality
- **UI**: Responsive sidebar with conversation list, chat area with message bubbles, mobile-friendly navigation

## Counselor Appointments Management
- Models: `CounselorAppointment`
- ViewModel: `CounselorAppointmentsViewModel`
- Screen: `CounselorAppointmentsScreen`
- API Endpoints:
  - `GET /counselor/appointments` — list all (pending default filter applied client-side)
  - `POST /counselor/appointments/updateAppointmentStatus` with `appointment_id`, `status`, optional `rejection_reason`
- Features: search by name/ID/purpose, status filter (Pending/Approved/Rejected/Completed/Cancelled/All), approve/reject with reason modal, cancel with reason

## Counselor Scheduled Appointments
- Models: `CounselorScheduledAppointment`, `CounselorSchedule`
- ViewModel: `CounselorScheduledAppointmentsViewModel`
- Screen: `CounselorScheduledAppointmentsScreen`
- Widgets: `AppointmentsTable`, `WeeklySchedule`, `MiniCalendar`, `CancellationReasonDialog`
- API Endpoints:
  - `GET /counselor/appointments/scheduled/get` — get approved appointments only
  - `GET /counselor/appointments/schedule` — get counselor availability schedule
  - `POST /counselor/appointments/updateAppointmentStatus` with `appointment_id`, `status`, optional `rejection_reason`
- Features: two-column layout (appointments table + sidebar), weekly schedule display, mini calendar with appointment highlighting, mark complete/cancel actions with reason modal, responsive design for mobile/tablet/desktop

## Counselor Follow-up Sessions
- Models: `CompletedAppointment`, `FollowUpSession`, `CounselorAvailability`
- ViewModel: `CounselorFollowUpSessionsViewModel`
- Screen: `CounselorFollowUpSessionsScreen`
- API Endpoints:
  - `GET /counselor/follow-up/completed-appointments` — get completed appointments for counselor (query: `search` - optional)
  - `GET /counselor/follow-up/sessions` — get follow-up sessions for parent appointment (query: `parent_appointment_id`)
  - `GET /counselor/follow-up/availability` — get counselor availability for specific date (query: `date`)
  - `POST /counselor/follow-up/create` — create new follow-up session
  - `POST /counselor/follow-up/complete` — mark follow-up session as completed (form: `id`)
  - `POST /counselor/follow-up/cancel` — cancel follow-up session with reason (form: `id`, `reason`)
- Features: completed appointments display with search, follow-up sessions modal with button state management, create follow-up modal with date/time selection and counselor availability, cancel follow-up modal with reason input, mark complete functionality, responsive design for mobile/tablet/desktop, button state logic: "Create New Follow-up" only active when no follow-up sessions exist, "Create Next Follow-up" only active when previous session is completed or cancelled
- Enhanced Features: follow-up count badges with blue gradient styling showing total follow-up sessions, pending warning indicators with orange gradient styling for appointments with pending follow-ups, separate pending appointments section above search bar with orange gradient background, proper sorting with pending appointments displayed first then by date/time (matching backend orderBy logic), appointment separation between pending and regular appointments, enhanced visual hierarchy with gradient badges and proper indicators

## Counselor Reports System
- Models: `AppointmentReport`, `AppointmentReportItem`, `WeekRange`, `WeekInfo`, `DayInfo`, `ChartData`, `AppointmentPieChartData`, `ExportFilters`, `TimeRange`, `AppointmentStatus`
- ViewModel: `CounselorReportsViewModel`
- Screen: `CounselorReportsScreen`
- Widgets: `AppointmentReportCard`, `ExportFiltersDialog`
- API Endpoints:
  - `GET /counselor/appointments/get_all_appointments` — get comprehensive appointment data with statistics and trend data (query: `timeRange` - daily/weekly/monthly)
- Features: statistics dashboard with appointment counts (completed, approved, rejected, pending, cancelled), data visualization using fl_chart (horizontally scrollable line charts with dynamic width calculation for appointment trends, pie charts for status distribution), tab-based filtering system for appointment status (All, Approved, Rejected, Completed, Cancelled), search and date filtering functionality with debounced search (300ms delay), PDF export functionality with advanced filtering options (date range, student, course, year level), responsive appointment cards for mobile display instead of tables, time range selection (daily, weekly, monthly reports) with proper type-safe JSON parsing for weekInfo (Map<String, dynamic> to WeekInfo model), comprehensive error handling and loading states, proper state management with ChangeNotifierProvider, enhanced line chart visibility with thicker lines (4px) and prominent dots with white stroke borders, responsive layout with LayoutBuilder (mobile breakpoint: 600px, line chart full width, pie chart and legend side-by-side on mobile)
- Chart Configuration: Line chart uses SingleChildScrollView with dynamic width (labels.length * 60.0) for horizontal scrolling, proper label padding and alignment for readability
- Data Visualization: Line charts showing appointment trends over time with different colored lines for each status, pie charts displaying status distribution with color-coded sections and legends, responsive chart sizing for mobile/tablet/desktop screens
- Export Functionality: PDF export with custom header including logo and counselor name, comprehensive table with all appointment details, filter summary in footer, proper page formatting with page numbers and generation timestamp, advanced filtering options for date range, student selection, course and year level filtering
- Mobile Optimization: Responsive appointment cards instead of tables for better mobile experience, proper touch targets and spacing, optimized layout for different screen sizes, card-based design with status badges and icons

## Linting
- `flutter_lints` v5 enabled via `analysis_options.yaml`

## Deprecation Notes
- Flutter 3.27+: `Color.withOpacity` deprecated → use `withValues(alpha: ...)` to avoid precision loss.
- qr_flutter: use `QrEyeStyle`/`QrDataModuleStyle` for styling instead of `color`/`foregroundColor`/`emptyColor`.
- Raw keyboard APIs deprecated in favor of `KeyboardListener`/`KeyEvent`.
 - Async context safety: For `State.context` across async gaps, guard with `if (!mounted) return;` on the `State` before using it. For other `BuildContext` references, prefer `if (context.mounted)` checks where available before navigation/snackbars/dialogs.