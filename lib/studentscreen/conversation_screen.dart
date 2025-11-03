import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/app_header.dart';
import 'state/student_dashboard_viewmodel.dart';
import 'models/counselor.dart';
import 'utils/image_url_helper.dart';
import 'widgets/navigation_drawer.dart';

class ConversationScreen extends StatelessWidget {
  const ConversationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Counselor? initialCounselor =
        ModalRoute.of(context)?.settings.arguments as Counselor?;
    return ChangeNotifierProvider(
      create: (context) {
        final viewModel = StudentDashboardViewModel();
        viewModel.initialize();
        if (initialCounselor != null) {
          viewModel.selectCounselor(initialCounselor);
        }
        return viewModel;
      },
      child: const _ConversationContent(),
    );
  }
}

class _ConversationContent extends StatelessWidget {
  const _ConversationContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentDashboardViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF0F4F8),
          appBar: AppHeader(onMenu: viewModel.toggleDrawer),
          body: Stack(
            children: [
              Column(
                children: [
                  _buildHeader(context, viewModel),
                  Expanded(child: _buildMessagesArea(context, viewModel)),
                  _buildInputArea(context, viewModel),
                ],
              ),
              if (viewModel.isDrawerOpen)
                GestureDetector(
                  onTap: viewModel.closeDrawer,
                  child: Container(
                    color: Colors.black.withAlpha(128),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              StudentNavigationDrawer(
                isOpen: viewModel.isDrawerOpen,
                onClose: viewModel.closeDrawer,
                onNavigateToAnnouncements: () =>
                    viewModel.navigateToAnnouncements(context),
                onNavigateToScheduleAppointment: () =>
                    viewModel.navigateToScheduleAppointment(context),
                onNavigateToMyAppointments: () =>
                    viewModel.navigateToMyAppointments(context),
                onNavigateToProfile: () => viewModel.navigateToProfile(context),
                onLogout: () => viewModel.logout(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    StudentDashboardViewModel viewModel,
  ) {
    final counselor = viewModel.selectedCounselor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE6E8EF), width: 1)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                Navigator.of(
                  context,
                ).pushReplacementNamed('/student/counselor-selection');
              }
            },
          ),
          if (counselor != null)
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE4E6EB), width: 2),
              ),
              child: ClipOval(child: _buildCounselorProfileImage(counselor)),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  counselor != null ? counselor.displayName : 'Conversation',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF003366),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (counselor != null)
                  Row(
                    children: [
                      Icon(
                        counselor.onlineStatus.statusIcon,
                        size: 8,
                        color: counselor.onlineStatus.statusColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        counselor.onlineStatus.text,
                        style: TextStyle(
                          fontSize: 12,
                          color: counselor.onlineStatus.statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesArea(
    BuildContext context,
    StudentDashboardViewModel viewModel,
  ) {
    return Container(
      color: const Color(0xFFF8FAFD),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color(0xFF060E57).withAlpha((0.05 * 255).round()),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF060E57).withAlpha((0.08 * 255).round()),
                width: 1,
              ),
            ),
            child: const Text(
              'Your conversation is private and confidential',
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: viewModel.counselorMessages.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        viewModel.selectedCounselor != null
                            ? 'Start a conversation with ${viewModel.selectedCounselor!.displayName}'
                            : 'Select a counselor to start messaging',
                        style: const TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: viewModel.chatScrollController,
                    itemCount: viewModel.counselorMessages.length,
                    itemBuilder: (context, index) {
                      final message = viewModel.counselorMessages[index];
                      return _MessageBubble(
                        text: message.messageText,
                        createdAt: viewModel.formatMessageTime(
                          message.createdAt,
                        ),
                        isSent: message.isSent,
                        senderName: message.senderName,
                        senderProfilePicture: message.senderProfilePicture,
                      );
                    },
                  ),
          ),
          if (viewModel.isTyping)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha((0.04 * 255).round()),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [_Dot(), _Dot(), _Dot()],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInputArea(
    BuildContext context,
    StudentDashboardViewModel viewModel,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.black.withAlpha((0.06 * 255).round()),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: viewModel.messageController,
              decoration: const InputDecoration(
                hintText: 'Type your message here...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              minLines: 1,
              textAlign: TextAlign.left,
              onSubmitted: (_) => viewModel.sendMessage(context),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF060E57),
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: const Color(
                    0xFF060E57,
                  ).withAlpha((0.08 * 255).round()),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: viewModel.isSendingMessage
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.send, color: Colors.white, size: 18),
              onPressed: viewModel.isSendingMessage
                  ? null
                  : () => viewModel.sendMessage(context),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounselorProfileImage(Counselor counselor) {
    final imageUrl = ImageUrlHelper.getProfileImageUrl(
      counselor.profileImageUrl,
    );
    if (imageUrl == 'Photos/profile.png') {
      return Image.asset(
        'Photos/profile.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.person, color: Colors.white, size: 20);
        },
      );
    }
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.person, color: Colors.white, size: 20);
      },
    );
  }
}

class _MessageBubble extends StatefulWidget {
  final String text;
  final String createdAt;
  final bool isSent;
  final String? senderName;
  final String? senderProfilePicture;

  const _MessageBubble({
    required this.text,
    required this.createdAt,
    required this.isSent,
    required this.senderName,
    required this.senderProfilePicture,
  });

  @override
  State<_MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<_MessageBubble> {
  bool _showTimestamp = false;

  @override
  Widget build(BuildContext context) {
    final alignment = widget.isSent
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    final margin = widget.isSent
        ? const EdgeInsets.only(right: 10, left: 10, bottom: 8)
        : const EdgeInsets.only(right: 10, left: 10, bottom: 8);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _showTimestamp = !_showTimestamp;
        });
      },
      child: Container(
        margin: margin,
        child: Column(
          crossAxisAlignment: alignment,
          children: [
            if (!widget.isSent && widget.senderName != null)
              Container(
                margin: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.senderProfilePicture != null)
                      Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFE4E6EB),
                            width: 1,
                          ),
                        ),
                        child: ClipOval(
                          child: _buildSenderImage(widget.senderProfilePicture!),
                        ),
                      ),
                    Text(
                      widget.senderName!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: widget.isSent ? const Color(0xFF060E57) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: widget.isSent
                      ? const Radius.circular(18)
                      : const Radius.circular(4),
                  bottomRight: widget.isSent
                      ? const Radius.circular(4)
                      : const Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.06 * 255).round()),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                widget.text,
                style: TextStyle(
                  color: widget.isSent ? Colors.white : const Color(0xFF1A1A1A),
                  fontSize: 14,
                  height: 1.4,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: _showTimestamp
                  ? Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        widget.createdAt,
                        style: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: widget.isSent ? TextAlign.right : TextAlign.left,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSenderImage(String profilePicture) {
    final imageUrl = ImageUrlHelper.getProfileImageUrl(profilePicture);
    if (imageUrl == 'Photos/profile.png') {
      return Image.asset(
        'Photos/profile.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.person, color: Color(0xFF64748B), size: 12);
        },
      );
    }
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.person, color: Color(0xFF64748B), size: 12);
      },
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: const BoxDecoration(
        color: Color(0xFF060E57),
        shape: BoxShape.circle,
      ),
    );
  }
}